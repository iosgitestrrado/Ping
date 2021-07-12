//
//  NotificationViewController.m
//  Ping
//
//  Created by Softnotions Technologies Pvt Ltd on 2/7/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "NotificationViewController.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NotificationTableViewCell.h"

@interface NotificationViewController ()
{
    NSMutableArray *arrayChatsList;
     AppDelegate *appDelegate;
}

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.badgeValue = @"0";
    self.tabBarController.tabBar.hidden = true;
    arrayChatsList    = [[NSMutableArray alloc]init];
   self.title = @"Notifications";
    _chatsTableVIew.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
    UIBarButtonItem *chkmanuaaly = [[UIBarButtonItem alloc]initWithTitle:@"Clear All" style:UIBarButtonItemStylePlain target:self action:@selector(clearAll:)];
    self.navigationItem.rightBarButtonItem=chkmanuaaly;
    
    [[NSNotificationCenter defaultCenter]
    addObserver:self selector:@selector(receiveTestNotification:) name:@"notificationReloaded" object:nil];
}

-(IBAction)clearAll:(id)sender
{
    if (arrayChatsList.count>0) {
    
   
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
  
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    [PGNotification notificationListClear:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     
     {
         
         
         if (success)
         {
             NSLog(@"success 321 -------------------");
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
             
                 [arrayChatsList removeAllObjects];
                 
                 [_chatsTableVIew reloadData ];
                
             }
         }
        
     }];
    [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
    
}

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchChatList];
    
    self.tabBarController.tabBar.hidden= YES;
    
   
}

-(void) receiveTestNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"notificationReloaded"])
    {
      
         [self fetchChatList];
    }
}



-(void)fetchChatList
{

    
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
        NSLog(@"params 123 -------------------%@",params);
      
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
        
        [PGNotification notificationList:params withCompletionBlock:^(BOOL success, id result, NSError *error)
         
         {
         
     
             if (success)
             {
                 NSLog(@"success 321 -------------------");
                 if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
                 {
                     //completionBlock(YES,result,nil);
                     //[testArray addObject:[result valueForKey:@"data"]];
                     arrayChatsList = [[result valueForKey:@"data"]mutableCopy];
                     
                     [_chatsTableVIew reloadData ];
                     
                     if (arrayChatsList.count>0){
                         NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                         [self.chatsTableVIew scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                     }
                     
                     
                     
                   
                 }
                 else
                 {
                     
                 }
             }
             else
             {
                
             }
         }];
        [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
        
    }

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (arrayChatsList.count>0) {
        
        
        CGRect newFrame = CGRectMake( tableView.frame.origin.x, tableView.frame.origin.y, 0, 0);
        
        self.noChatimageView.frame = newFrame;
        _noChatimageView.hidden = YES;
        tableView.scrollEnabled = YES;
        return arrayChatsList.count;
        
        
        
    }
    else{
        
        
        
        
        tableView.scrollEnabled = NO;
        
        
        
        
        
        self.noChatimageView.frame = tableView.frame;
        _noChatimageView.hidden = false;
        
        
        
        
        
        
        return 0 ;
        
    }
    
    
    
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotificationCell"];
    }
    
    cell.notificationHead.text =[[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] capitalizedString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *datefrom = [dateFormatter dateFromString:[[arrayChatsList valueForKey:@"notify_on"] objectAtIndex:indexPath.row]];
    
    
    
    
    [dateFormatter setDateFormat:@"dd MMM yyyy h.mma"];
    NSString *str = [dateFormatter stringFromDate:datefrom];
    
     cell.notificationDate.text =[str lowercaseString] ;
  
  NSString *abc = [[arrayChatsList valueForKey:@"message"] objectAtIndex:indexPath.row];
    
    abc = [NSString stringWithFormat:@"%@%@",[[abc substringToIndex:1] uppercaseString],[abc substringFromIndex:1] ];
    
    
    
    cell.notificationDetails.text = abc  ;
    cell.notificationImage.image = [UIImage imageNamed:@"update"];
    
    
    
    if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] isEqualToString:@"accept friend"]) {
        
        
        cell.notificationImage.image = [UIImage imageNamed:@"fri"];
        
        
        
        
    }
    
   else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] containsString:@"friend"]) {
        
        
          cell.notificationImage.image = [UIImage imageNamed:@"friendrequest"];
        
        
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] isEqualToString:@"pingme"])
    {
        
     
        
          cell.notificationImage.image = [UIImage imageNamed:@"ping-mepush"];
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] isEqualToString:@"view remind"])
    {
        
        cell.notificationHead.text = @"View Reminder";
        
        cell.notificationImage.image = [UIImage imageNamed:@"reminder"];
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] containsString:@"remind"])
    {
        
      cell.notificationHead.text = @"Reminder";
        
          cell.notificationImage.image = [UIImage imageNamed:@"alarm-clock"];
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] isEqualToString:@"suggest push"])
    {
        
    
        
          cell.notificationImage.image = [UIImage imageNamed:@"sugg_pushOn"];
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] isEqualToString:@"accept push"])
    {
        
        
        
        cell.notificationImage.image = [UIImage imageNamed:@"swap"];
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] isEqualToString:@"suggest location"])
    {
        
        cell.notificationImage.image = [UIImage imageNamed:@"location-on-map"];
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] containsString:@"location"])
    {
    
          cell.notificationImage.image = [UIImage imageNamed:@"accept_location"];
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] isEqualToString:@"accept track"])
    {
        
         cell.notificationHead.text = @"Accept Follow";
        cell.notificationImage.image = [UIImage imageNamed:@"accept_track"];
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] containsString:@"track"])
    {
        
         cell.notificationHead.text = @"Follow Request";
         cell.notificationImage.image = [UIImage imageNamed:@"push-pin-guide"];
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] containsString:@"priority"])
    {
        
        
        
        cell.notificationImage.image = [UIImage imageNamed:@"priority"];
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] isEqualToString:@"push meeting"])
    {
        
        
        
        cell.notificationImage.image = [UIImage imageNamed:@"push"];
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] isEqualToString:@"swap meeting"])
    {
        
        
        
        cell.notificationImage.image = [UIImage imageNamed:@"meetingswap"];
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] isEqualToString:@"reshedule meeting"])
    {
        
        
        
        cell.notificationImage.image = [UIImage imageNamed:@"reshedule"];
        
        
    }
  
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] isEqualToString:@"delete meeting"])
    {
        
        
        
        cell.notificationImage.image = [UIImage imageNamed:@"delete"];
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] isEqualToString:@"edit meeting"])
    {
        
        
        
        cell.notificationImage.image = [UIImage imageNamed:@"edit"];
        
        
    }
    
    
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] containsString:@"meeting"])
    {
        
        
        cell.notificationImage.image = [UIImage imageNamed:@"meeting"];
        
        
    }
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    
    
    if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] containsString:@"friend"]) {
        
        
       self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        
         [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] isEqualToString:@"pingme"])
    {
        
        
        
      self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:3];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if ([[[arrayChatsList valueForKey:@"notify_type"] objectAtIndex:indexPath.row] containsString:@"delete meeting"])
    {
    }
    else{
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSDate * strdateon =   [format dateFromString:[[arrayChatsList valueForKey:@"event_date"] objectAtIndex:indexPath.row]];
        
        if (strdateon==nil) {
            
            
            [format setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            
            
            NSDate * strdateon =   [format dateFromString:[[arrayChatsList valueForKey:@"event_date"] objectAtIndex:indexPath.row]];
            
            
            
            
            [format setDateFormat:@"yyyy-MM-dd"];
            NSString * strdateonSTR =   [format stringFromDate:strdateon];
            strdateon =   [format dateFromString:strdateonSTR];
            
            if (strdateon==nil){
                
                strdateonSTR =   [format stringFromDate:[NSDate date]];
                strdateon =   [format dateFromString:strdateonSTR];
                
                
                
            }
            
        }
        
        
        
        [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
        [[NSUserDefaults standardUserDefaults]setObject:[[arrayChatsList valueForKey:@"meeting_id"] objectAtIndex:indexPath.row] forKey:@"DateeventmeetingId"];
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
   
}


@end
