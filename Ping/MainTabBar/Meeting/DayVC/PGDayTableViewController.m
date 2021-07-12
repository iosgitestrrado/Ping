//
//  PGDayTableViewController.m
//  Ping
//
//  Created by Monish M S on 04/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGDayTableViewController.h"
#import "PGDayTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PGUser.h"
#import "PGEvent.h"
#import <FVCustomAlertView/FVCustomAlertView.h>

@interface PGDayTableViewController ()
{
    NSMutableArray *arrayDayPass, *arrayMeeting, *arrayTime, *arrayEventBlock;
    NSString *expandInfoString;
    UIToolbar *toolBarStart, *toolBarEnd;
    UIButton *cancelButton;
}
@end

@implementation PGDayTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(receiveTestNotification:) name:@"eventInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(expandInfoNotification:) name:@"expandInfo" object:nil];
  
}

-(void) receiveTestNotification:(NSNotification*)notification
{
    arrayDayPass = [NSMutableArray new];
   
    if ([notification.name isEqualToString:@"eventInfo"])
    {
        NSDictionary* userInfo = notification.userInfo;
        arrayDayPass = (NSMutableArray *)userInfo[@"arrayPass"];
        expandInfoString = userInfo[@"expandStr"];
     //   NSLog (@"Successfully received test notification! %@", arrayDayPass);
        [self tableShow];
    }
}

-(void) expandInfoNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"expandInfo"])
    {
        NSDictionary* userInfo = notification.userInfo;
        expandInfoString = userInfo[@"expandStr"];
    //    NSLog (@"Successfully received test notification! %@", expandInfoString);
        [self tableShow];
    }
}

-(void)tableShow
{
    arrayMeeting = [NSMutableArray new];
    
    
    int heightTotal = 80 * (int)arrayDayPass.count;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:heightTotal] forKey:@"totalHeight"];
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"heightInfo" object:self userInfo:userInfo];
   
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

      return arrayDayPass.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[PGDayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DayCell"];
    }
    // Configure the cell...
//    if ([expandInfoString isEqualToString:@"expanded"])
//    {
        int start,end;
        NSString *startAmPm, *endAmPm;
        NSString *startStr = [[arrayDayPass valueForKey:@"start_time"] objectAtIndex:indexPath.row];
        NSString *endStr = [[arrayDayPass valueForKey:@"end_time"] objectAtIndex:indexPath.row];
    
//        start = [[[arrayDayPass valueForKey:@"start_time"] objectAtIndex:indexPath.row] intValue];
//        end   = [[[arrayDayPass valueForKey:@"end_time"] objectAtIndex:indexPath.row] intValue];

        if ([[[arrayDayPass valueForKey:@"meeting_title"]objectAtIndex:indexPath.row] isEqualToString:@"meeting"])
        {
            if ([[[arrayDayPass valueForKey:@"location"]objectAtIndex:indexPath.row] isEqualToString:@""])
            {
                [cell.mapImg setHidden:true];
                [cell.mapPointerBtn setHidden:true];
                
            }else{
            
            [cell.mapImg setHidden:false];
                [cell.mapPointerBtn setHidden:false];}
        }
        else
        {
            [cell.mapImg setHidden:true];
            [cell.mapPointerBtn setHidden:true];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        NSDate *dateStart = [dateFormatter dateFromString:startStr];
        NSDate *dateEnd = [dateFormatter dateFromString:endStr];
        
        dateFormatter.dateFormat = @"h.mma";
        NSString *startDateString = [dateFormatter stringFromDate:dateStart];
        NSString *endDateString = [dateFormatter stringFromDate:dateEnd];
        
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
        if ([[[arrayDayPass valueForKey:@"description"] objectAtIndex:indexPath.row] isEqualToString:@""])
        {
            cell.descriptionLabel.text = @"# description";
            cell.descriptionLabel.text = @"";
        }
        else
        {
            cell.descriptionLabel.text = [[arrayDayPass valueForKey:@"description"] objectAtIndex:indexPath.row];
        }
    
        cell.timeLabel.text = [[NSString stringWithFormat:@"%@ to %@",startAmPm,endAmPm]lowercaseString];
    
    
    
 
    cell.vwAvatarView.hidden = YES;
    cell.profilePicImg.hidden = YES;
    cell.memberOverCount.hidden = YES;
    if([[NSString stringWithFormat:@"%@",[arrayDayPass valueForKey:@"group_flag"] ] isEqualToString:@"0"]){
    
         cell.profilePicImg.hidden = NO;
       
        NSString *urlString = [[arrayDayPass valueForKey:@"avthar"] objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:urlString];
       // [cell.profilePicImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
        [cell.profilePicImg sd_setImageWithURL:url
                              placeholderImage:nil
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         if (error) {
                                             
                                             cell.profilePicImg.image = [UIImage imageNamed:@"UserProfile"];
                                         }
                                     }];
    
    
    }else{
    
    
    
    
    
    NSArray *arr = [[arrayDayPass valueForKey:@"mambers"] objectAtIndex:indexPath.row];
    if (arr.count>1) {
        
        cell.vwAvatarView.hidden = NO;
        
        
        cell.profilePicImg.hidden = YES;
        [cell setMeetingByCall:arr];
    }else{
        
        NSString *urlString = [[arrayDayPass valueForKey:@"avthar"] objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:urlString];
        cell.vwAvatarView.hidden = YES;
        
        cell.profilePicImg.hidden = NO;
        
        [cell.profilePicImg sd_setImageWithURL:url
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      if (error) {
                                          
                                          cell.profilePicImg.image = [UIImage imageNamed:@"UserProfile"];
                                      }
                                  }];
        
       // [cell.profilePicImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
        
    }
    
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if ([[[arrayDayPass valueForKey:@"meeting_type"]objectAtIndex:indexPath.row] isEqualToString:@"ios_event"]||[[[arrayDayPass valueForKey:@"meeting_type"]objectAtIndex:indexPath.row] isEqualToString:@"self_event"]||[[[arrayDayPass valueForKey:@"meeting_type"]objectAtIndex:indexPath.row] isEqualToString:@"single_event"]||[[[arrayDayPass valueForKey:@"meeting_type"]objectAtIndex:indexPath.row] isEqualToString:@"group_event"]||[[[arrayDayPass valueForKey:@"meeting_type"]objectAtIndex:indexPath.row] isEqualToString:@"ping_meeting"]||[[[arrayDayPass valueForKey:@"meeting_type"]objectAtIndex:indexPath.row] isEqualToString:@"google_event"])
    {
        
        NSDictionary* userInfo = @{@"mainArrayPass": [arrayDayPass objectAtIndex:indexPath.row]};
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"mainArrayEventInfo" object:self userInfo:userInfo];
    }
    
 
    
    
//        }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (self.tableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[arrayDayPass valueForKey:@"meeting_type"]objectAtIndex:indexPath.row] isEqualToString:@"free_slot"])
    {
        
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *formattedDateString = [outputFormatter stringFromDate:[NSDate date]];
        NSString *checkDateString = [NSString stringWithFormat:@"%@ %@",[[arrayDayPass valueForKey:@"start_date"]objectAtIndex:indexPath.row] ,[[arrayDayPass valueForKey:@"end_time"]objectAtIndex:indexPath.row]];
        
        NSDate *dateCurrent = [outputFormatter dateFromString:formattedDateString];
        NSDate *checkDate = [outputFormatter dateFromString:checkDateString];
        
        NSDate *tomorrow1 = [NSDate dateWithTimeInterval:-(15*60) sinceDate:checkDate];
        NSComparisonResult result;
        
        
        result = [dateCurrent compare:tomorrow1];
        
        if(result==NSOrderedAscending)
        {
        
        
        UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Block" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            arrayEventBlock =  [[arrayDayPass objectAtIndex:indexPath.row]mutableCopy];
            
            
            
            
                [self blockTimeView];
            }];
        editAction.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:136.0/255.0 blue:184.0/255.0 alpha:1.0];
        
        return @[editAction];
            
            
            
        }else{
            [self.tableView setEditing:false];
            return nil;
            
            
        }
    }else  if ([[[arrayDayPass valueForKey:@"meeting_type"]objectAtIndex:indexPath.row] isEqualToString:@"block_event"])
    {
        
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *formattedDateString = [outputFormatter stringFromDate:[NSDate date]];
        NSString *checkDateString = [NSString stringWithFormat:@"%@ %@",[[arrayDayPass valueForKey:@"start_date"]objectAtIndex:indexPath.row] ,[[arrayDayPass valueForKey:@"end_time"]objectAtIndex:indexPath.row]];
        
        NSDate *dateCurrent = [outputFormatter dateFromString:formattedDateString];
        NSDate *checkDate = [outputFormatter dateFromString:checkDateString];
        
        NSDate *tomorrow1 = [NSDate dateWithTimeInterval:-(15*60) sinceDate:checkDate];
        NSComparisonResult result;
        
        
        result = [dateCurrent compare:tomorrow1];
        
        if(result==NSOrderedAscending)
        {
        
        
        
        
        UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Unblock" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            arrayEventBlock =  [[arrayDayPass objectAtIndex:indexPath.row]mutableCopy];
            [self uncallBlock];
            
        }];
        editAction.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:136.0/255.0 blue:184.0/255.0 alpha:1.0];
        
        return @[editAction];
            
        }else{
            [self.tableView setEditing:false];
            return nil;
            
            
        }
    }
    else
    {
        [self.tableView setEditing:false];
        return nil;
    }
}

-(void)blockTimeView
{
    myBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.bounds.size.height)];
    [myBackView setBackgroundColor:[UIColor blackColor]];
    [myBackView setAlpha:0.5];
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = myBackView.bounds;
    [myBackView addSubview:visualEffectView];
    
    myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.bounds.size.height)];
    [myView setBackgroundColor:[UIColor clearColor]];

    
  UIView *  myView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, (self.navigationController.view.bounds.size.height-50)/2)];
    [myView1 setBackgroundColor:[UIColor clearColor]];
    
    UIView *  myView2 = [[UIView alloc] initWithFrame:CGRectMake(0, (self.navigationController.view.bounds.size.height-50)/2, self.navigationController.view.frame.size.width, (self.navigationController.view.bounds.size.height-50)/2)];
    [myView2 setBackgroundColor:[UIColor clearColor]];
    
    
    UIView *  myView3 = [[UIView alloc] initWithFrame:CGRectMake(30, myView1.frame.size.height-160, self.navigationController.view.frame.size.width-60, 130)];
    [myView3 setBackgroundColor:[UIColor whiteColor]];
    UIView *  myView4 = [[UIView alloc] initWithFrame:CGRectMake(30, 20, self.navigationController.view.frame.size.width-60, 130)];
    [myView4 setBackgroundColor:[UIColor whiteColor]];
    
    myView3.layer.cornerRadius = 5;
    myView3.layer.masksToBounds = true;
    myView4.layer.cornerRadius = 5;
    myView4.layer.masksToBounds = true;
    
     [myView addSubview:myView1];
     [myView addSubview:myView2];
    [myView1 addSubview:myView3];
    [myView2 addSubview:myView4];
    
   
    
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, myView3.frame.size.width, 35)];
    fromLabel.text = @"Start Time";
    fromLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16.0];
    fromLabel.backgroundColor = [UIColor colorWithRed:85.0/255.0 green:82./255.0 blue:93.0/255.0 alpha:1.0];;
    fromLabel.textColor = [UIColor colorWithRed:254.0/255.0 green:194./255.0 blue:22.0/255.0 alpha:1.0];;
    fromLabel.textAlignment = NSTextAlignmentCenter;
    [myView3 addSubview:fromLabel];
    
    UILabel *toLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, myView4.frame.size.width, 35)];
    toLabel.text = @"End Time";
    toLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16.0];
    toLabel.backgroundColor = [UIColor colorWithRed:85.0/255.0 green:82./255.0 blue:93.0/255.0 alpha:1.0];;
    toLabel.textColor = [UIColor colorWithRed:254.0/255.0 green:194./255.0 blue:22.0/255.0 alpha:1.0];;
    toLabel.textAlignment = NSTextAlignmentCenter;
    [myView4 addSubview:toLabel];
    
    
    
    
    
    
    
    
   
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSDate *dateT = [dateFormatter dateFromString:[arrayEventBlock valueForKey:@"start_time"]];
    NSDate *dateS = [dateFormatter dateFromString:[arrayEventBlock valueForKey:@"end_time"]];
    
    
    
    
    
    
    myPickerViewStart = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,35, myView3.frame.size.width, 95)];
    myPickerViewStart.datePickerMode = UIDatePickerModeTime;
    [myPickerViewStart setMinimumDate:dateT];
    
    [myPickerViewStart setMaximumDate:dateS];
    
    [myPickerViewStart setDate:dateT];
    myPickerViewStart.minuteInterval=15;
    
    
    
    
    
    [myPickerViewStart setBackgroundColor:[UIColor whiteColor]];
    [myView3 addSubview:myPickerViewStart];
 
    
    
    
    
    myPickerViewEnd = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,35, myView4.frame.size.width, 95)];
   myPickerViewEnd.datePickerMode = UIDatePickerModeTime;
    
    [myPickerViewEnd setMinimumDate:dateT];
    [myPickerViewEnd setMaximumDate:dateS];
    [myPickerViewEnd setDate:dateS];
    
    [myPickerViewEnd setBackgroundColor:[UIColor whiteColor]];
     myPickerViewEnd.minuteInterval=15;
    
    
    [myView4 addSubview:myPickerViewEnd];
  
    
    UIView *  myView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 35,  myView3.frame.size.width, 32)];
    [myView5 setBackgroundColor:[UIColor whiteColor]];
    UIView *  myView6 =[[UIView alloc] initWithFrame:CGRectMake(0, 98,  myView3.frame.size.width, 32)];
    [myView6 setBackgroundColor:[UIColor whiteColor]];
    myView5.userInteractionEnabled = NO;
    myView6.userInteractionEnabled = NO;
    [myView3 addSubview:myView5];
    [myView3 addSubview:myView6];
    UIView *  myView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 35,  myView4.frame.size.width, 32)];
    [myView7 setBackgroundColor:[UIColor whiteColor]];
    UIView *  myView8 = [[UIView alloc] initWithFrame:CGRectMake(0, 98,  myView4.frame.size.width, 32)];
    [myView8 setBackgroundColor:[UIColor whiteColor]];
    
    
    [myView4 addSubview:myView7];

    [myView4 addSubview:myView8];
    myView7.userInteractionEnabled = NO;
    myView8.userInteractionEnabled = NO;
    
    UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake((myView5.frame.size.width/2)-21,0,32,32)];
    dot.image=[UIImage imageNamed:@"arrow_up"];
    
    [myView5 addSubview:dot];
    UIImageView *dot1 =[[UIImageView alloc] initWithFrame:CGRectMake((myView6.frame.size.width/2)-21,0,32,32)];
    dot1.image=[UIImage imageNamed:@"arrow_down"];
    
    [myView6 addSubview:dot1];
    
    
    UIImageView *dot2 =[[UIImageView alloc] initWithFrame:CGRectMake((myView7.frame.size.width/2)-21,0,32,32)];
    dot2.image=[UIImage imageNamed:@"arrow_up"];
    
    [myView7 addSubview:dot2];
    UIImageView *dot3 =[[UIImageView alloc] initWithFrame:CGRectMake((myView8.frame.size.width/2)-21,0,32,32)];
    dot3.image=[UIImage imageNamed:@"arrow_down"];
    
    [myView8 addSubview:dot3];
    
    
    
    
    
    
    UIImageView *dot4 =[[UIImageView alloc] initWithFrame:CGRectMake((myView5.frame.size.width/2)-82,0,32,32)];
    dot4.image=[UIImage imageNamed:@"arrow_up"];
    
    [myView5 addSubview:dot4];
    UIImageView *dot5 =[[UIImageView alloc] initWithFrame:CGRectMake((myView6.frame.size.width/2)-82,0,32,32)];
    dot5.image=[UIImage imageNamed:@"arrow_down"];
    
    [myView6 addSubview:dot5];
    

    UIImageView *dot6 =[[UIImageView alloc] initWithFrame:CGRectMake((myView7.frame.size.width/2)+40,0,32,32)];
    dot6.image=[UIImage imageNamed:@"arrow_up"];

    [myView5 addSubview:dot6];
    UIImageView *dot7 =[[UIImageView alloc] initWithFrame:CGRectMake((myView8.frame.size.width/2)+40,0,32,32)];
    dot7.image=[UIImage imageNamed:@"arrow_down"];

    [myView6 addSubview:dot7];


    UIImageView *dot8 =[[UIImageView alloc] initWithFrame:CGRectMake((myView5.frame.size.width/2)-82,0,32,32)];
    dot8.image=[UIImage imageNamed:@"arrow_up"];

    [myView7 addSubview:dot8];
    UIImageView *dot9 =[[UIImageView alloc] initWithFrame:CGRectMake((myView6.frame.size.width/2)-82,0,32,32)];
    dot9.image=[UIImage imageNamed:@"arrow_down"];

    [myView8 addSubview:dot9];


    UIImageView *dot10 =[[UIImageView alloc] initWithFrame:CGRectMake((myView7.frame.size.width/2)+40,0,32,32)];
    dot10.image=[UIImage imageNamed:@"arrow_up"];

    [myView7 addSubview:dot10];
    UIImageView *dot11 =[[UIImageView alloc] initWithFrame:CGRectMake((myView8.frame.size.width/2)+40,0,32,32)];
    dot11.image=[UIImage imageNamed:@"arrow_down"];

    [myView8 addSubview:dot11];
    
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50 , [UIScreen mainScreen].bounds.size.width/2-1, 50)];
    [cancelButton setBackgroundColor:[UIColor colorWithRed:72.0/255.0 green:70.0/255.0 blue:84.0/255.0 alpha:1.0]];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16.0]];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:cancelButton];
    
   OKButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [OKButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2+1, [UIScreen mainScreen].bounds.size.height-50 , [UIScreen mainScreen].bounds.size.width/2-1, 50)];
    [OKButton setBackgroundColor:[UIColor colorWithRed:72.0/255.0 green:70.0/255.0 blue:84.0/255.0 alpha:1.0]];
    [OKButton.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16.0]];
    [OKButton setTitle:@"OK" forState:UIControlStateNormal];
    [OKButton setTitleColor:[UIColor colorWithRed:254.0/255.0 green:194./255.0 blue:22.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [OKButton addTarget:self action:@selector(okViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:OKButton];
    myView10  = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-1,  [UIScreen mainScreen].bounds.size.height-50,  2, 50)];
    [myView10 setBackgroundColor:[UIColor whiteColor]];
    
       [[UIApplication sharedApplication].keyWindow addSubview:myView10];
    [self.navigationController.view addSubview:myBackView];
    [self.navigationController.view addSubview:myView];
}

- (IBAction)cancelButtonAction:(id)sender
{
    [myView setHidden:true];
    [myBackView setHidden:true];
  [cancelButton removeFromSuperview];
     [OKButton removeFromSuperview];
    [myView10 removeFromSuperview];
}

- (IBAction)dismissViewAction:(id)sender
{
    [myView setHidden:true];
    [myBackView setHidden:true];
    [cancelButton removeFromSuperview];
    [OKButton removeFromSuperview];
    [myView10 removeFromSuperview];
}





- (IBAction)okViewAction:(id)sender
{
    
    [self callBlock];
    [myView setHidden:true];
    [myBackView setHidden:true];
    [cancelButton removeFromSuperview];
    [OKButton removeFromSuperview];
    [myView10 removeFromSuperview];
}



-(void)callBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
    NSString *dateString1 = [outputFormatter stringFromDate:myPickerViewStart.date];
    NSString *dateString2 = [outputFormatter stringFromDate:myPickerViewEnd.date];
    
    
    
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[arrayEventBlock valueForKey:@"start_date"] forKey:@"startDate"];
    [params setObject:[arrayEventBlock valueForKey:@"end_date"] forKey:@"endDate"];
    [params setObject:dateString1 forKey:@"startTime"];
    [params setObject:dateString2 forKey:@"endTime"];
  
    
    
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *formattedDateString = [outputFormatter stringFromDate:[NSDate date]];
    NSString *checkDateString = [NSString stringWithFormat:@"%@ %@",[arrayEventBlock valueForKey:@"start_date"],dateString1];
    
    
      NSDate *dateCurrent = [outputFormatter dateFromString:formattedDateString];
   NSDate *checkDate = [outputFormatter dateFromString:checkDateString];
    
    
    NSComparisonResult result;
   
    
    result = [dateCurrent compare:checkDate];
    
    if(result==NSOrderedAscending)
       {
           
           [params setObject:@"0" forKey:@"repeatEvent"];
           [params setObject:@"" forKey:@"everyday"];
           
           [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
           
           [PGEvent callBlockWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
            {
                if (success)
                {
                    [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                    
                    [self cancelButtonAction:nil];
                    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                    [nc postNotificationName:@"reloaddataDate" object:self userInfo:nil];
                    
                }
                else
                {
                    [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                    [self cancelButtonAction:nil];
                }
            }];
           
       }
  
    else
       {
           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"This selection occurs in the past. Please try again." preferredStyle:UIAlertControllerStyleAlert];
           UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                      handler:nil];
           [alertController addAction:ok];
           [self presentViewController:alertController animated:YES completion:nil];
       }
    
    
    
    
    
   
}

-(void)uncallBlock
{
    
    
  
    
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[arrayEventBlock valueForKey:@"meeting_id"] forKey:@"meetingId"];
 
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    [PGEvent callUnBlockWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         if (success)
         {
             
             NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
             [nc postNotificationName:@"reloaddataDate" object:self userInfo:nil];
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             
         }
         else
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             
         }
     }];
}


@end
