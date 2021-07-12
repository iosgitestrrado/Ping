//
//  PGFreeSlotsTableViewController.m
//  Ping
//
//  Created by Monish M S on 06/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGFreeSlotsTableViewController.h"
#import "PGFreeSlotsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PGFreeSlotsTableViewController ()
{
    NSMutableArray *freeSlotArray;
}
@end

@implementation PGFreeSlotsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    freeSlotArray = [NSMutableArray new];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(freeSlotNotification:) name:@"freeSlotInfo" object:nil];
}

-(void)freeSlotNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"freeSlotInfo"])
    {
        NSDictionary* userInfo = notification.userInfo;
        freeSlotArray = (NSMutableArray *)userInfo[@"arrayPassFree"];
        //  NSLog (@"Successfully received test notification! %@", arrayPassEvents);
        [self setDetails];
    }
}

-(void)setDetails
{
    if (!freeSlotArray || !freeSlotArray.count)
    {
        
    }
    else
    {
        int heightTotal = 80 * (int)freeSlotArray.count;
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:heightTotal] forKey:@"totalHeightFree"];
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"freeHeightInfo" object:self userInfo:userInfo];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return freeSlotArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGFreeSlotsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FreeSlotCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[PGFreeSlotsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FreeSlotCell"];
    }
    
    int start,end;
    NSString *startAmPm, *endAmPm;
    NSString *startStr = [[freeSlotArray valueForKey:@"start_time"] objectAtIndex:indexPath.row];
    NSString *endStr = [[freeSlotArray valueForKey:@"end_time"] objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    NSDate *dateStart = [dateFormatter dateFromString:startStr];
    NSDate *dateEnd = [dateFormatter dateFromString:endStr];
    
    dateFormatter.dateFormat = @"h.mma";
    NSString *startDateString = [dateFormatter stringFromDate:dateStart];
    NSString *endDateString = [dateFormatter stringFromDate:dateEnd];
    
    if ([[[freeSlotArray valueForKey:@"meeting_title"]objectAtIndex:indexPath.row] isEqualToString:@"meeting"])
    {
        if ([[[freeSlotArray valueForKey:@"location"]objectAtIndex:indexPath.row] isEqualToString:@""])
        {
            [cell.mapImg setHidden:true];
            [cell.pointBtn setHidden:true];
            
        }else{
            
            [cell.mapImg setHidden:false];
            [cell.pointBtn setHidden:false];}
    }
    else
    {
        [cell.mapImg setHidden:true];
        [cell.pointBtn setHidden:true];
    }
    start = [[[freeSlotArray valueForKey:@"start_time"] objectAtIndex:indexPath.row] intValue];
    end   = [[[freeSlotArray valueForKey:@"end_time"] objectAtIndex:indexPath.row] intValue];
    
    if (start >= 12)
    {
        startAmPm = [NSString stringWithFormat:@"%@",startDateString];
    }
    else
    {
        startAmPm = [NSString stringWithFormat:@"%@",startDateString];
    }
    
    if (end >= 12)
    {
        endAmPm = [NSString stringWithFormat:@"%@",endDateString];
    }
    else
    {
        endAmPm = [NSString stringWithFormat:@"%@",endDateString];
    }
    if ([[[freeSlotArray valueForKey:@"description"] objectAtIndex:indexPath.row] isEqualToString:@""])
    {
        cell.freeDescLabel.text = @"# description";
        
        cell.freeDescLabel.text = @"";
    }
    else
    {
        cell.freeDescLabel.text = [[freeSlotArray valueForKey:@"description"] objectAtIndex:indexPath.row];
    }
//    NSString *urlString = [[freeSlotArray valueForKey:@"avthar"] objectAtIndex:indexPath.row];
//    NSURL *url = [NSURL URLWithString:urlString];
//    [cell.freeProfilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
    
    cell.memberOverCount.hidden = YES;
    cell.vwAvatarView.hidden = YES;
    cell.freeProfilePic.hidden = YES;
    
    if([[NSString stringWithFormat:@"%@",[freeSlotArray valueForKey:@"group_flag"] ] isEqualToString:@"0"]){
        
        cell.freeProfilePic.hidden = NO;
        
        NSString *urlString = [[freeSlotArray valueForKey:@"avthar"] objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:urlString];
      //  [cell.freeProfilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
        
        [cell.freeProfilePic sd_setImageWithURL:url
                               placeholderImage:nil
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          if (error) {
                                              
                                              cell.freeProfilePic.image = [UIImage imageNamed:@"UserProfile"];
                                          }
                                      }];
        
    }else{
        
        
        
        
        
        NSArray *arr = [[freeSlotArray valueForKey:@"mambers"] objectAtIndex:indexPath.row];
        if (arr.count>1) {
            
            cell.vwAvatarView.hidden = NO;
            
            
            [cell setCreateMeetingByCall:arr];
        }else{
            
            NSString *urlString = [[freeSlotArray valueForKey:@"avthar"] objectAtIndex:indexPath.row];
            NSURL *url = [NSURL URLWithString:urlString];
            
            cell.freeProfilePic.hidden = NO;
           // [cell.freeProfilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
            
            
            [cell.freeProfilePic sd_setImageWithURL:url
                                          placeholderImage:nil
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                     if (error) {
                                                         
                                                         cell.freeProfilePic.image = [UIImage imageNamed:@"UserProfile"];
                                                     }
                                                 }];
            
            
            
        }
        
    }
    
    
    
    
    
    cell.freeTimeLAbel.text = [[NSString stringWithFormat:@"%@ to %@",startAmPm,endAmPm]lowercaseString];
    
    if ([[[freeSlotArray valueForKey:@"meeting_type"]objectAtIndex:indexPath.row] isEqualToString:@"free_slot"])
    {
        
        cell.colorView.backgroundColor = [UIColor colorWithRed:254.0f/255.0f
                                              green:231.0f/255.0f
                                               blue:229.0f/255.0f
                                              alpha:1.0f];
    }else{
        
        cell.colorView.backgroundColor =  [UIColor colorWithRed:230.0f/255.0f
                                                          green:242.0f/255.0f
                                                           blue:255.0f/255.0f
                                                          alpha:1.0f];
        
        
    }
    
    return cell;
}






-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if ([[[freeSlotArray valueForKey:@"meeting_type"]objectAtIndex:indexPath.row] isEqualToString:@"free_slot"])
    {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"datetimeEventAction" object:self userInfo:[freeSlotArray objectAtIndex:indexPath.row]];
        
        
        
        
    }
 
}







@end
