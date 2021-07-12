//
//  PGPingOutViewController.m
//  Ping
//
//  Created by Monish M S on 04/01/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "PGPingOutViewController.h"
#import "PGUser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PGProfileTableViewController.h"
#import "PGEvent.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import "AppDelegate.h"

@interface PGPingOutViewController ()
{
    NSMutableDictionary *_eventsByDate;
    BOOL isDateSelected;
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    NSMutableArray *arrayEventsPingOut;
    NSDate *_dateSelected;

     UIButton *button1;
    AppDelegate *appDelegate;
    
    NSMutableArray *arrayToPush;
    
    
    
}
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightComnst;
@property (weak, nonatomic) IBOutlet UIView *pingAlertView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertHeightConst;
@property (weak, nonatomic) IBOutlet UIImageView *pingOutImgView;
@property (weak, nonatomic) IBOutlet UILabel *pingoutTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *undoPingOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *notifyBtn;






@end

@implementation PGPingOutViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    isDateSelected = false;
 appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIImage *image = [UIImage imageNamed:@"notification"];
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(0, 0, 34, 34)];
    [button1 addTarget:self action:@selector(notificationViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setBackgroundImage:image forState:UIControlStateNormal];
    
    // Make BarButton Item
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = navLeftButton;
    
    arrayToPush = [[NSMutableArray alloc]init];
    _mainViewHeight.constant = 0;
    [self.mainView setHidden:true];
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
   [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    _dateSelected       = _todayDate;
    [self weekMode];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(badgeNotification:) name:@"badgeAction" object:nil];
    
    
}
-(void)badgeNotification:(NSNotification*)notification
{
    
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor colorWithRed:203.0/255.0 green:84.0/255.0 blue:124.0/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem.badgeValue = appDelegate.badgeValue;
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:-M_PI/18];
    animation.toValue = [NSNumber numberWithFloat: M_PI/18];
    animation.duration = 0.2;
    animation.repeatCount = 5;
    [animation setAutoreverses:YES];
    [button1.layer addAnimation:animation forKey:@"SpinAnimation"];
}

-(void) showTutorial{
    
    
    CGRect coachmark = CGRectMake(self.view.frame.size.width-79,self.view.frame.size.height- 124,64,64);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PINGOUTTUTORIAL"];
    
    
    NSArray *coachMarks = @[
                            @{
                                @"rect": [NSValue valueWithCGRect:coachmark],
                                @"caption": @"You can put marks over images",
                                @"shape": [NSNumber numberWithInteger:SHAPE_CIRCLE],
                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_LEFT_BOTTOM],
                                @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_RIGHT],
                                @"showArrow":[NSNumber numberWithBool:YES]
                                }
                            ];
    
    MPCoachMarks *coachMarksView = [[MPCoachMarks alloc] initWithFrame:self.navigationController.view.bounds coachMarks:coachMarks];
    [self.navigationController.view addSubview:coachMarksView];
    [coachMarksView start];
    
}








-(void)viewWillAppear:(BOOL)animated{
   
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden= NO;
    
    [_calendarContentView setUserInteractionEnabled:true];
  //  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(profileViewAction:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 34, 34)];
    button.layer.cornerRadius = 17;
    button.layer.masksToBounds = YES;
    UIImageView *picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"] == nil)
    {
        picImageView.layer.cornerRadius = 17;
        picImageView.layer.masksToBounds = YES;
        picImageView.image = [UIImage imageNamed:@"UserProfile"];
    }
    else
    {
        picImageView.layer.cornerRadius = 17;
        picImageView.layer.masksToBounds = YES;
        
        NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"]];
        
        [picImageView sd_setImageWithURL:url
                        placeholderImage:nil
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   if (error) {
                                       
                                       picImageView.image = [UIImage imageNamed:@"UserProfile"];
                                   }
                               }];
        
       // [picImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserProfile"] options:SDWebImageRefreshCached];
    }
    [button addSubview:picImageView];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
   
   self.navigationItem.rightBarButtonItem.badgeValue = appDelegate.badgeValue;
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor colorWithRed:203.0/255.0 green:84.0/255.0 blue:124.0/255.0 alpha:1.0];
    [self fetchPingOutDatas];
    appDelegate.indexValue = 1;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"PINGOUTTUTORIAL"]) {
        
       // [self showTutorial];
    }
    
}

-(void)fetchPingOutDatas
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString* finalDateString;
    if (isDateSelected == true)
    {
        finalDateString  = [format stringFromDate:[[NSUserDefaults standardUserDefaults]valueForKey:@"pingOutDateValueChange"]];
        NSLog(@"%@",finalDateString);
    }
    else
    {
        finalDateString  = [format stringFromDate:_todayDate];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:finalDateString forKey:@"date"];
    
    [PGEvent pingoutListWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         self.tabBarController.tabBar.userInteractionEnabled = YES;
      
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
            
             arrayEventsPingOut = [result valueForKey:@"data"];
             
             
             if([[NSString stringWithFormat:@"%@",[result valueForKey:@"is_pingout"]] isEqualToString:@"1"])
             {
                 [self.pingAlertView setHidden:false];
                 [self.undoPingOutBtn setHidden:false];
                 [self.mainView setHidden:true];
                 self.pingOutImgView.image = [UIImage imageNamed:@"PingoutBarIcon"];
                 _mainViewHeight.constant = 0;
                 [_mainTable reloadData];
                 self.pingoutTextLabel.text = @"There will be no Pings scheduled today.";
             }
             else{
                 
             
             
             if (!arrayEventsPingOut || !arrayEventsPingOut.count)
             {
                 [self.pingAlertView setHidden:false];
                 [self.undoPingOutBtn setHidden:true];
                 _mainViewHeight.constant = 0;
                 [self.mainView setHidden:true];
                 self.pingOutImgView.image = [UIImage imageNamed:@"OopsIcon"];
                 self.pingoutTextLabel.text = @"There are no Pings scheduled today.";
             }
             
             else
             {
                 [self.pingAlertView setHidden:true];
                 [self.undoPingOutBtn setHidden:true];
                 [self.mainView setHidden:false];
                 _mainViewHeight.constant = (arrayEventsPingOut.count * 60) + 70;
                 [_mainTable reloadData];
                 [arrayToPush removeAllObjects ];
                 arrayToPush = [arrayEventsPingOut mutableCopy];
                 
                 
               
             }
             }
         }
         else
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:cancelButton];
             
             [self presentViewController:alert animated:YES completion:nil];
         }
     }];
}



- (IBAction)notificationViewAction:(id)sender
{
    
    NotificationViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    [self.navigationController pushViewController:profileVC animated:true];
    
}

- (IBAction)pingUndoOut:(id)sender
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString* finalDateString;
    if (isDateSelected == true)
    {
        finalDateString  = [format stringFromDate:[[NSUserDefaults standardUserDefaults]valueForKey:@"pingOutDateValueChange"]];
        NSLog(@"%@",finalDateString);
    }
    else
    {
        finalDateString  = [format stringFromDate:_todayDate];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:finalDateString forKey:@"date"];
    
    [PGEvent pingOutoutActionWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             NSDateFormatter *format = [[NSDateFormatter alloc] init];
             [format setDateFormat:@"yyyy-MM-dd"];
             
             NSDate * strdateon =   [format dateFromString:finalDateString];
             
             
             [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
               [self fetchPingOutDatas];
           
         }
         else
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:cancelButton];
             
             [self presentViewController:alert animated:YES completion:nil];
         }
     }];
}

- (IBAction)confirmAction:(id)sender
{
    //    API params : user_id, date, meetingIds
    NSMutableArray *arrayConfirmFinal = [NSMutableArray new];
    
      [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
      NSDateFormatter *format = [[NSDateFormatter alloc] init];
      [format setDateFormat:@"yyyy-MM-dd"];
      NSString* finalDateString;
        if (isDateSelected == true)
        {
            finalDateString  = [format stringFromDate:[[NSUserDefaults standardUserDefaults]valueForKey:@"pingOutDateValueChange"]];
            NSLog(@"%@",finalDateString);
        }
        else
        {
            finalDateString  = [format stringFromDate:_todayDate];
        }
    
        for (id item in arrayToPush)
        {
            NSDictionary *dict = item;
            NSDictionary* dictConfirm = @{@"id": [dict valueForKey:@"meeting_id"]};
            [arrayConfirmFinal addObject:dictConfirm];
        }
    
    
        NSError *error;
        NSData *jsonDataContacts = [NSJSONSerialization dataWithJSONObject:arrayConfirmFinal
                                                               options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonStringContacts = [[NSString alloc] initWithData:jsonDataContacts encoding:NSUTF8StringEncoding];
    
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
        [params setObject:finalDateString forKey:@"date"];
    
    if (arrayToPush.count>0) {
 [params setObject:jsonStringContacts forKey:@"meetingIds"];
    }
    
    
    
    
        [PGEvent pingoutActionWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
         {
             if (success)
             {
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:@"You have cleared all Pings today." preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     
                     NSDateFormatter *format = [[NSDateFormatter alloc] init];
                     [format setDateFormat:@"yyyy-MM-dd"];
                     
                     NSDate * strdateon =   [format dateFromString:finalDateString];
                     
                     
                     [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
                 
                     [self.tabBarController setSelectedIndex:2];
                     
                     
                     
                     
                   //  [self fetchPingOutDatas];
                 }];
                 [alert addAction:cancelButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
             }
             else
             {
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alert addAction:cancelButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
             }
         }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)profileViewAction:(id)sender
{
    
    PGProfileTableViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PGProfileTableViewController"];
    profileVC.passString = nil;
    [self.navigationController pushViewController:profileVC animated:true];
}

-(void)weekMode
{
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    CGFloat newHeight = 0.0;
    CGFloat containerHeight = 0.0;
   
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
                
            case 1136:
                newHeight = 190;
                containerHeight = 205;
                break;
            case 1334:
                newHeight = 220;
                containerHeight = 275;
                break;
            case 1920:
                newHeight = 220;
                containerHeight = 365;
                break;
                
            case 2208:
                newHeight = 220;
                containerHeight = 365;
                
                break;
            case 2436:
                newHeight = 220;
                containerHeight = 365;
                break;
            default:
                newHeight = 190;
                containerHeight = 205;
                break;
        }
    }
    
    if(_calendarManager.settings.weekModeEnabled)
    {
       
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
            
            switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
                    
                case 1136:
                    newHeight = 60.;
                    containerHeight = 335.;
                    break;
                case 1334:
                    newHeight = 60.;
                    containerHeight = 435.;
                    break;
                case 1920:
                    newHeight = 60.;
                    containerHeight = 525.;
                    break;
                    
                case 2208:
                    newHeight = 60.;
                    containerHeight = 525.;
                    
                    break;
                case 2436:
                    newHeight = 60.;
                    containerHeight = 525.;
                    break;
                default:
                    newHeight = 60.;
                    containerHeight = 335.;
                    break;
            }
        }
    }
    
    
      self.alertHeightConst.constant = containerHeight;
    self.containerHeightComnst.constant = containerHeight;
    self.calendarContentViewHeight.constant = newHeight;
    [self.view layoutIfNeeded];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayEventsPingOut.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGPingOutMeetingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PingoutCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[PGPingOutMeetingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PingoutCell"];
    }
    
    int start,end;
    NSString *startAmPm, *endAmPm;
    NSString *startStr = [[arrayEventsPingOut valueForKey:@"start_time"] objectAtIndex:indexPath.row];
    NSString *endStr = [[arrayEventsPingOut valueForKey:@"end_time"] objectAtIndex:indexPath.row];
    
    start = [[[arrayEventsPingOut valueForKey:@"start_time"] objectAtIndex:indexPath.row] intValue];
    end   = [[[arrayEventsPingOut valueForKey:@"end_time"] objectAtIndex:indexPath.row] intValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    NSDate *dateStart = [dateFormatter dateFromString:startStr];
    NSDate *dateEnd = [dateFormatter dateFromString:endStr];
    
     [cell.checkBboBtn setTitle:@"checkbox-checked" forState:UIControlStateNormal];
    [cell.checkBboBtn addTarget:self action:@selector(checkMarkAction:) forControlEvents:UIControlEventTouchUpInside];
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
    if ([[[arrayEventsPingOut valueForKey:@"description"] objectAtIndex:indexPath.row] isEqualToString:@""])
    {
        cell.descLabel.text = @"# description";
        cell.descLabel.text = @"";
    }
    else
    {
        cell.descLabel.text = [[arrayEventsPingOut valueForKey:@"description"] objectAtIndex:indexPath.row];
    }
    //    NSString *urlString = [[arrayPingoutpass valueForKey:@"avthar"] objectAtIndex:indexPath.row];
    //    NSURL *url = [NSURL URLWithString:urlString];
    //    [cell.profilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserProfile"] options:SDWebImageRefreshCached];
    //
    cell.vwAvatarView.hidden = YES;
    cell.profilePic.hidden = YES;
    cell.memberOverCount.hidden = YES;
    
    NSString *str = [NSString stringWithFormat:@"%@",[[arrayEventsPingOut valueForKey:@"meeting_type"] objectAtIndex:indexPath.row]];
    
    
    
    
    
    
    if([str isEqualToString:@"group_event"]){
        
   
        NSArray *arr = [[arrayEventsPingOut valueForKey:@"grAvthar"] objectAtIndex:indexPath.row];
        if (arr.count>1) {
            
            cell.vwAvatarView.hidden = NO;
            
            [cell setMeetingPingoutByCall:arr];
        }else{
            
            NSString *urlString = [[arrayEventsPingOut valueForKey:@"avthar"] objectAtIndex:indexPath.row];
            NSURL *url = [NSURL URLWithString:urlString];
            cell.profilePic.hidden = NO;
            
            [cell.profilePic sd_setImageWithURL:url
                               placeholderImage:nil
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          if (error) {
                                              
                                              cell.profilePic.image = [UIImage imageNamed:@"UserProfile"];
                                          }
                                      }];
            
            
            // [cell.profilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
            
        }
        
        
    }else{
        
        cell.profilePic.hidden = NO;
        
        NSString *urlString = [[arrayEventsPingOut valueForKey:@"avthar"] objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:urlString];
        // [cell.profilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
        
        [cell.profilePic sd_setImageWithURL:url
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      if (error) {
                                          
                                          cell.profilePic.image = [UIImage imageNamed:@"UserProfile"];
                                      }
                                  }];
        
        
        
        
        
        
        
        
        
        
      
        
    }
    cell.timeLabel.text = [[NSString stringWithFormat:@"%@ to %@",startAmPm,endAmPm]lowercaseString];
    
    return cell;
}

- (IBAction)checkMarkAction:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.mainTable];
    NSIndexPath *indexPath = [self.mainTable indexPathForRowAtPoint:buttonPosition];
    PGPingOutMeetingTableViewCell *swipeCell  = [self.mainTable cellForRowAtIndexPath:indexPath];
    
    UIButton *button = (UIButton *)sender;
    if ([sender isSelected])
    {
        [button setTitle:@"checkbox-checked" forState:UIControlStateNormal];
        [sender setSelected: NO];
        for (id item in arrayEventsPingOut)
        {
            NSDictionary *dict = item;
            
            if ([[dict valueForKey:@"description"] isEqualToString: [swipeCell.descLabel text]])
            {
                [arrayToPush addObject: dict];
            }
        }
    }
    else
    {
        [button setTitle:@"checkbox-unchecked" forState:UIControlStateNormal];
        [sender setSelected: YES];
        
        for (id item in arrayEventsPingOut)
        {
            NSDictionary *dict = item;
            
            if ([[dict valueForKey:@"description"] isEqualToString: [swipeCell.descLabel text]])
            {
                
                if (arrayToPush.count>0) {
                
                [arrayToPush removeObject: dict];
                }
            }
        }
    }
}



#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    
  
    isDateSelected = false;
    
    _dateSelected    = _todayDate;
    [_calendarManager setDate:_todayDate];
     [self fetchPingOutDatas];
    
}

- (IBAction)didChangeModeTouch
{
    
    
    
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    self.arrowIcon.image = [UIImage imageNamed:@"UpArrow"];
    CGFloat newHeight = 0.0;
    CGFloat containerHeight = 0.0;
 
    
    
    
    
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
                
            case 1136:
                newHeight = 190;
                containerHeight = 205;
                break;
            case 1334:
                newHeight = 220;
                containerHeight = 275;
                break;
            case 1920:
                newHeight = 220;
                containerHeight = 365;
                break;
                
            case 2208:
                newHeight = 220;
                containerHeight = 365;
                
                break;
            case 2436:
                newHeight = 220;
                containerHeight = 365;
                break;
            default:
                newHeight = 190;
                containerHeight = 205;
                break;
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    if(_calendarManager.settings.weekModeEnabled)
    {
      
        
        
        
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
            
            switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
                    
                case 1136:
                    newHeight = 60.;
                    containerHeight = 335.;
                    break;
                case 1334:
                    newHeight = 60.;
                    containerHeight = 435.;
                    break;
                case 1920:
                    newHeight = 60.;
                    containerHeight = 525.;
                    break;
                    
                case 2208:
                    newHeight = 60.;
                    containerHeight = 525.;
                    
                    break;
                case 2436:
                    newHeight = 60.;
                    containerHeight = 525.;
                    break;
                default:
                    newHeight = 60.;
                    containerHeight = 335.;
                    break;
            }
        }
        
        
        
        
        
        
        
        self.arrowIcon.image = [UIImage imageNamed:@"DownArrowIcon"];
    }
    
    
    self.alertHeightConst.constant = containerHeight;
    self.containerHeightComnst.constant = containerHeight;
    self.calendarContentViewHeight.constant = newHeight;
    [self.view layoutIfNeeded];
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{

    if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithRed:203.0/255.0 green:84.0/255.0 blue:124.0/255.0 alpha:1.0];
        dayView.dotView.backgroundColor = [UIColor clearColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    isDateSelected = true;
  [_calendarManager setDate:_dateSelected];

    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
   
    
   
    
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled)
    {
        NSLog(@"%@",_dateSelected);
        [[NSUserDefaults standardUserDefaults] setValue:_dateSelected forKey:@"pingOutDateValueChange"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self fetchPingOutDatas];
        return;
    }else{
        [self  didChangeModeTouch];
        NSLog(@"%@",_dateSelected);
        [[NSUserDefaults standardUserDefaults] setValue:_dateSelected forKey:@"pingOutDateValueChange"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self fetchPingOutDatas];
        return;
        
    }
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    // Load the previous or next page if touch a day from another month
    
   
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}



@end
