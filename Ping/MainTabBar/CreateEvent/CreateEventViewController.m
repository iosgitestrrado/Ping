//
//  CreateEventViewController.m
//  Ping
//
//  Created by Monish M S on 17/04/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "CreateEventViewController.h"
#import "PGNewEvent.h"
#import "PGUser.h"
#import "PGFriends.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import "PGFreeFriendsCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CreateeventConfirmViewController.h"


@interface CreateEventViewController ()
{
    
    BOOL isDateSelected,isSearchStarted;
    
    BOOL isTimeSelected;
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    NSString *startTimeSlots,*endTimeSlots;
    NSDate *_dateSelected;
    NSMutableArray *arrayFreeSlots, *freeFriendsArray, *selectedFriendsArray,*newFilteredArray,*sortedArray,*duplicateArray;
}
@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    freeFriendsArray = [[NSMutableArray alloc]init];
    isDateSelected = false;
    [self addDoneToolBarToKeyboard:self.addFriendsSearch];
    isSearchStarted = false;
    isTimeSelected = false;
    self.title = @"New Event";
    selectedFriendsArray = [[NSMutableArray alloc]init];
    self.tabBarController.tabBar.hidden = true;
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_curDate];
      _freeslotHeight.constant = 0;
    _dateSelected       = _curDate;
    [self weekMode];
    [self fetchFriendsList];
    [self setupNewEvent];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(freeHeightNotification:) name:@"freeHeightInfo" object:nil];
    [self.FriendsCollectionView setAllowsMultipleSelection:YES];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(datetimeEventNotification:) name:@"datetimeEventAction" object:nil];
    
    [self fetchFreeSlots];
    
    UIBarButtonItem *chkmanuaaly = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(moveToConfirm:)];
    self.navigationItem.rightBarButtonItem=chkmanuaaly;
    
    [_monthButton bringSubviewToFront:self.view];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"BackArrow"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(popNavigationController:) forControlEvents:UIControlEventTouchUpInside];
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _clearButton.hidden = YES;
    visualEffectView.frame = blurView.bounds;
    [blurView addSubview:visualEffectView];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
}

- (void)popNavigationController:(id)sender
{
    
    if (isTimeSelected) {
        [self cancelButtonAction:nil];
    }
    else{
        
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

-(void)addDoneToolBarToKeyboard:(UISearchBar *)textView
{
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.FriendsCollectionView.frame.size.width, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
                         nil];
    [doneToolbar sizeToFit];
    textView.inputAccessoryView = doneToolbar;
}

-(void)doneButtonClickedDismissKeyboard
{
    [self.addFriendsSearch resignFirstResponder];
    if (self.addFriendsSearch.text.length == 0)
    {
        isSearchStarted = false;
        freeFriendsArray = [duplicateArray mutableCopy];
        
        NSArray *tmpArray = [NSArray arrayWithArray:freeFriendsArray];
        NSArray *tmpArray1 = [NSArray arrayWithArray:selectedFriendsArray];
        
        for (id item in tmpArray)
        {
            NSDictionary *dict = item;
            for (id itemStop in tmpArray1)
            {
                
                NSDictionary *dict1 = itemStop;
                
                if(  [[dict valueForKey:@"number"]isEqualToString:[dict1 valueForKey:@"number"]])
                {
                    
                    if (freeFriendsArray.count>0) {
                        
                        [freeFriendsArray removeObject:dict];
                        
                        
                        
                        
                        
                    }
                    
                }
            }
            
        }
        
        [self  nofriends];
        
        [self.FriendsCollectionView reloadData];
    }
}

-(void)nofriends{
    if (selectedFriendsArray.count+freeFriendsArray.count>0)
    {
        _nofriendsLbl.hidden= YES;
        
    }
    else{
        _nofriendsLbl.hidden= NO;
    }
    
}



-(void)freeHeightNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"freeHeightInfo"])
    {
        int pass = [[[notification userInfo] valueForKey:@"totalHeightFree"] intValue];
        
        _freeslotHeight.constant = pass;
        
        
        _totalHeight.constant = pass+_friendContentViewHeight.constant+200+self.calendarContentViewHeight.constant; ;
        
    }
}

#pragma mark - UISearchBar Delegates

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    isSearchStarted = true;
    return true;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length >0 )
    {
        [self updateSearchResults:searchText];
    }
    else
    {
        freeFriendsArray = duplicateArray.mutableCopy;
        
        NSArray *tmpArray = [NSArray arrayWithArray:freeFriendsArray];
        NSArray *tmpArray1 = [NSArray arrayWithArray:selectedFriendsArray];
        
        for (id item in tmpArray)
        {
            NSDictionary *dict = item;
            for (id itemStop in tmpArray1)
            {
                
                NSDictionary *dict1 = itemStop;
                
                if(  [[dict valueForKey:@"number"]isEqualToString:[dict1 valueForKey:@"number"]])
                {
                    
                    if (freeFriendsArray.count>0) {
                        
                        [freeFriendsArray removeObject:dict];
                        
                        
                        
                        
                        
                    }
                    
                }
            }
            
        }
        [self  nofriends];
        [self.FriendsCollectionView reloadData];
    }
}

- (void)updateSearchResults:(NSString *)string
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name contains[c] %@", string];
    if (duplicateArray == nil || [duplicateArray count] == 0)
    {
        return;
    }
    NSArray *filteredArr = [duplicateArray filteredArrayUsingPredicate:pred];
    [freeFriendsArray removeAllObjects];
    freeFriendsArray = filteredArr.mutableCopy;
    NSArray *tmpArray = [NSArray arrayWithArray:freeFriendsArray];
    NSArray *tmpArray1 = [NSArray arrayWithArray:selectedFriendsArray];
    
    for (id item in tmpArray)
    {
        NSDictionary *dict = item;
        for (id itemStop in tmpArray1)
        {
            
            NSDictionary *dict1 = itemStop;
            
            if(  [[dict valueForKey:@"number"]isEqualToString:[dict1 valueForKey:@"number"]])
            {
                
                if (freeFriendsArray.count>0) {
                    
                    [freeFriendsArray removeObject:dict];
                    
                    
                    
                    
                    
                }
                
            }
        }
        
    }
    
    [self  nofriends];
    [self.FriendsCollectionView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}






-(void)datetimeEventNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"datetimeEventAction"])
    {
        
        
        
        NSString *startStr =[NSString stringWithFormat:@"%@ %@", [notification.userInfo objectForKey:@"start_date"],[notification.userInfo objectForKey:@"start_time"]] ;
        
        NSString *endStr =[NSString stringWithFormat:@"%@ %@", [notification.userInfo objectForKey:@"start_date"],[notification.userInfo objectForKey:@"end_time"]] ;
      
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        dateStart = [dateFormatter dateFromString:startStr];
        dateEnd = [dateFormatter dateFromString:endStr];
        [dateFormatter setDateFormat:@"hh:mm a"];
        
        startTimeSlots=[dateFormatter stringFromDate:dateStart];
        endTimeSlots=[dateFormatter stringFromDate:dateEnd];
        
        [dateFormatter setDateFormat:@"h.mma"];
        
        passString = [NSString stringWithFormat:@"%@ to %@",[dateFormatter stringFromDate:dateStart],[dateFormatter stringFromDate:dateEnd]];
        
        self.selecttime.text = [passString lowercaseString] ;
        
        _clearButton.hidden = NO;
        
      
        [self.mainscroll setContentOffset:CGPointMake(self.mainscroll.contentOffset.x, 0)
                                 animated:YES];
        
     //   [self fetchFriendsListSlots];
        [self blockTimeView];
        
    }
    
    
}
- (IBAction)changetimePicker:(id)sender {
    [self blockTimeView];
    
}


-(void)blockTimeView
{
    
   
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * dateStart1 = [dateFormatter stringFromDate:dateStart];
    NSString *  dateEnd1 = [dateFormatter stringFromDate:dateEnd];
    
    
    
    
    
    
    
    
    // [dateFormatter setDateFormat:@"HH:mm"];
    
    NSDate *dateT = [dateFormatter dateFromString:dateStart1];
    NSDate *dateS = [dateFormatter dateFromString:dateEnd1];
    
   
      [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString * dateStartAM = [dateFormatter stringFromDate:dateStart];
    NSString *  dateEndAM = [dateFormatter stringFromDate:dateEnd];
    
    
     NSString *code = [dateStartAM substringFromIndex: [dateStartAM length] - 2];
    NSString *code1 = [dateEndAM substringFromIndex: [dateEndAM length] - 2];
    
    
    if (dateS != nil  && dateT != nil) {
       
        myView.hidden = false;
        [self.navigationController setNavigationBarHidden:YES];
        isTimeSelected = true;
    
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(15*60) sinceDate:dateT];
    NSDate *tomorrow1 = [NSDate dateWithTimeInterval:-(15*60) sinceDate:dateS];
    NSDate *tomorrow2 = [NSDate dateWithTimeInterval:(60*60) sinceDate:dateT];
    
    
    myPickerViewStart.datePickerMode = UIDatePickerModeTime;
    [myPickerViewStart setMinimumDate:dateT];
    
    [myPickerViewStart setMaximumDate:tomorrow1];
    
    [myPickerViewStart setDate:dateT];
    myPickerViewStart.minuteInterval=15;
    
    
    
    
    [myPickerViewStart setBackgroundColor:[UIColor whiteColor]];
    
    [myPickerViewStart addTarget:self action:@selector(pickerChanged:)               forControlEvents:UIControlEventValueChanged];

    
    
    
    
    myPickerViewEnd.datePickerMode = UIDatePickerModeTime;
    
    [myPickerViewEnd setMinimumDate:tomorrow];
    [myPickerViewEnd setMaximumDate:dateS];
    
    
    NSComparisonResult result;
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    
    result = [tomorrow2 compare:dateS]; // comparing two dates
    
    if(result==NSOrderedAscending)
       [myPickerViewEnd setDate:tomorrow2];
    else{
        
            [myPickerViewEnd setDate:dateS];
        
        if ([code1 isEqualToString:@"AM"]&&[code isEqualToString:@"PM"]) {
            [myPickerViewEnd setDate:tomorrow2];
        }
       

    }
    
    [myPickerViewEnd setBackgroundColor:[UIColor whiteColor]];
    myPickerViewEnd.minuteInterval=15;
    
    
    }
    
    
    
    
}


- (void)pickerChanged:(id)sender
{
   
    
       NSDate *tomorrow2 = [NSDate dateWithTimeInterval:(60*60) sinceDate:[sender date]];
    
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
     [dateFormatter setDateFormat:@"hh:mm a"];
    NSString * dateStartAM = [dateFormatter stringFromDate:dateStart];
    NSString *  dateEndAM = [dateFormatter stringFromDate:dateEnd];
    NSString *code = [dateStartAM substringFromIndex: [dateStartAM length] - 2];
    NSString *code1 = [dateEndAM substringFromIndex: [dateEndAM length] - 2];
    
    NSComparisonResult result;
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    
    result = [tomorrow2 compare:myPickerViewEnd.maximumDate]; // comparing two dates
    
    if(result==NSOrderedAscending)
        [myPickerViewEnd setDate:tomorrow2];
    else
        
    {
        
        
        [myPickerViewEnd setDate:myPickerViewEnd.maximumDate];
        if ([code1 isEqualToString:@"AM"]&&[code isEqualToString:@"PM"]) {
            [myPickerViewEnd setDate:tomorrow2];
        }
    }
    
    
    
    
}
- (IBAction)cancelButtonAction:(id)sender
{
    
    isTimeSelected = false;
    self.selecttime.text = @"";
    _clearButton.hidden = YES;
    if (selectedFriendsArray.count>0) {
        
    }else{
        [self fetchFriendsList];}
    [self.navigationController setNavigationBarHidden:NO];

        
        myView.hidden = true;
 
    
    
    
    
    
}


- (IBAction)clearButtonAction:(id)sender
{
    self.selecttime.text = @"";
    _clearButton.hidden = YES;
    if (selectedFriendsArray.count>0) {
        
    }else{
        [self fetchFriendsList];}
}




- (IBAction)okButtonAction:(id)sender
{
    
    isTimeSelected = false;
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
    
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *startStr =[dateFormatter stringFromDate: myPickerViewStart.date] ;
    
    NSString *endStr =[dateFormatter stringFromDate: myPickerViewEnd.date] ;
    
    
    dateStart = [dateFormatter dateFromString:startStr];
    dateEnd = [dateFormatter dateFromString:endStr];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    startTimeSlots=[dateFormatter stringFromDate:dateStart];
    endTimeSlots=[dateFormatter stringFromDate:dateEnd];
    
    [dateFormatter setDateFormat:@"h.mma"];
    
    passString = [NSString stringWithFormat:@"%@ to %@",[dateFormatter stringFromDate:dateStart],[dateFormatter stringFromDate:dateEnd]];
    int startTime   = [self minutesSinceMidnight:[dateFormatter dateFromString:startTimeSlots]];
    int endTime  = [self minutesSinceMidnight:[dateFormatter dateFromString:endTimeSlots]];
    
    
    
    if (startTime >= endTime)
    {
        
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"This selection occurs in the past. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        
        
        
        
    }
    else {
        self.selecttime.text = [passString lowercaseString];
        _clearButton.hidden = NO;
        [self fetchFriendsListSlots];
        
        
        myView.hidden = true;
    }
    
    
    
    
    
    
    
    
    
}

-(int) minutesSinceMidnight:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    return 60 * (int)[components hour] + (int)[components minute];
}




- (IBAction)moveToConfirm:(id)sender {
    
    
    if(![self.selecttime.text isEqualToString:@""]){
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMM yyyy"];
        
        NSString *myString = [dateFormat stringFromDate:_curDate];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *myString1 = [dateFormat stringFromDate:_curDate];
        
          NSString  *stringCheck = [NSString stringWithFormat:@"%@ %@",myString,startTimeSlots];
        
        
        
        dateFormat.dateFormat = @"dd MMM yyyy hh:mm a";
        NSDate *dateStart = [dateFormat dateFromString:stringCheck];
        
        NSComparisonResult result;
        NSDate *today = [NSDate date];
        
        result = [today compare:dateStart];
        
        if(result==NSOrderedAscending)
            NSLog(@"today is less");
        else if(result==NSOrderedDescending)
            NSLog(@"newDate is less");
        else
            NSLog(@"Both dates are same");
        
        if(result==NSOrderedDescending)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"We are unable to create an event in the past. Please check and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:nil];
            [alertController addAction:ok];
            
            
            
            
            
            
            
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }else{
            
        
        CreateeventConfirmViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateeventConfirmViewController"];
        profileVC.selectDate =[NSString stringWithFormat:@"%@ %@",myString, self.selecttime.text];
        profileVC.curDate = myString1;
        profileVC.starttimeDate = startTimeSlots;
        profileVC.endTimeDate = endTimeSlots;
        
        
        profileVC.selectFriendsArray= selectedFriendsArray;
        [self.navigationController pushViewController:profileVC animated:true];
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Please select an available time slot to create a Ping." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alertController addAction:ok];
        
        
        
        
        
        
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
}
-(void)fetchFreeSlots
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSDictionary *dateDict = @{@"date":[_formatter stringFromDate:_curDate]};
    NSMutableArray *dateArray = [NSMutableArray new];
    [dateArray addObject:dateDict];
    
    NSMutableArray *arraySelectedFriends = [NSMutableArray new];
    
    
    NSArray* tmpArray = [selectedFriendsArray copy];
    
    for (id item in tmpArray)
    {
        NSDictionary *dict = item;
        
        NSDictionary *dictNumber = @{@"number":[dict valueForKey:@"number"]};
        [arraySelectedFriends addObject:dictNumber];
    }
    NSError *error;
    NSData *jsonDataFriends = [NSJSONSerialization dataWithJSONObject:arraySelectedFriends
                                                              options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStringFriends = [[NSString alloc] initWithData:jsonDataFriends encoding:NSUTF8StringEncoding];
    
    NSData *jsonDataDate = [NSJSONSerialization dataWithJSONObject:dateArray
                                                           options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStringDate = [[NSString alloc] initWithData:jsonDataDate encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:jsonStringDate forKey:@"date"];
    
    if (!arraySelectedFriends || !arraySelectedFriends.count)
    {
        [params setObject:@"" forKey:@"friends"];
    }
    else
    {
        [params setObject:jsonStringFriends forKey:@"friends"];
    }
    
    [PGNewEvent fetchFreeSlotsWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         if (success)
         {
             arrayFreeSlots = [result valueForKey:@"data"];
             NSDictionary* userInfo = @{@"arrayPassFree": arrayFreeSlots};
             NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
             [nc postNotificationName:@"freeSlotInfo" object:self userInfo:userInfo];
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
         }
         else
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
//             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:@"Fetching Freeslots Failed"preferredStyle:UIAlertControllerStyleAlert];
//
//             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//             [alert addAction:yesButton];
//
//             [self presentViewController:alert animated:YES completion:nil];
         }
     }];
}
-(void)setupNewEvent{
    _friendContentViewHeight.constant = 60;
  
    _friendsearchHeight.constant = 0;
    _addFriendsSearch.hidden = YES;
}

- (IBAction)searchSetup:(id)sender {
    
    
    
    //    _freeslotHeight.constant = pass;
    //
    //
    //    _totalHeight.constant = pass+_friendContentViewHeight.constant+290;
    
    
    
    
    
    
    if(_friendContentViewHeight.constant == 60)
    {
        
        [_arrowButton setBackgroundImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
        
           if (freeFriendsArray.count == 0) {
               [_arrowButton setBackgroundImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
               [self setupNewEvent];
               _friendContentViewHeight.constant == 60;
           }
        
       else if (freeFriendsArray.count>6) {
            _friendContentViewHeight.constant = 180;
           _friendsearchHeight.constant = 56;
           _addFriendsSearch.hidden = NO;
            
            
            
        }else{
            
            _friendContentViewHeight.constant = 120;
            
            _friendsearchHeight.constant = 56;
            _addFriendsSearch.hidden = NO;
            
            
        }
        
        
        
        
    }else{
        
        [_arrowButton setBackgroundImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        _friendContentViewHeight.constant = 60;
        
        _friendsearchHeight.constant = 0;
        _addFriendsSearch.hidden = YES;
    }
    
    _totalHeight.constant = _freeslotHeight.constant+_friendContentViewHeight.constant+200+self.calendarContentViewHeight.constant;;
    
    
}



-(void)weekMode
{
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    CGFloat newHeight = 0.0;
    CGFloat containerHeight = 0.0;
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 736)
        {
            newHeight = 220;
            containerHeight = 365;
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 667)
        {
            newHeight = 220;
            containerHeight = 275;
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            newHeight = 190;
            containerHeight = 205;
        }
        else
        {
            newHeight = 160;
            containerHeight = 265;
        }
    }
    else
    {
        //[ipad]
    }
    
    if(_calendarManager.settings.weekModeEnabled)
    {
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            if ([[UIScreen mainScreen] bounds].size.height == 736)
            {
                newHeight = 45.;
                containerHeight = 525.;
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 667)
            {
                newHeight = 45.;
                containerHeight = 435.;
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                newHeight = 45.;
                containerHeight = 335.;
            }
            else
            {
                newHeight = 45.;
                containerHeight = 425.;
            }
        }
        else
        {
            //[ipad]
        }
    }
    
    self.calendarContentViewHeight.constant = newHeight;
    [self.view layoutIfNeeded];
}
#pragma mark - Buttons callback
- (IBAction)ChangeModeprogm
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
    
    
    self.calendarContentViewHeight.constant = newHeight;
    _totalHeight.constant = _freeslotHeight.constant+_friendContentViewHeight.constant+200+self.calendarContentViewHeight.constant;
    [self.view layoutIfNeeded];
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    //    // Today
    //    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date])
    //    {
    //        dayView.circleView.hidden = NO;
    //        dayView.circleView.backgroundColor = [UIColor colorWithRed:203.0/255.0 green:84.0/255.0 blue:124.0/255.0 alpha:1.0];
    //        dayView.dotView.backgroundColor = [UIColor clearColor];
    //        dayView.textLabel.textColor = [UIColor whiteColor];
    //    }
    //    // Selected date
    //    else
    
    
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
    
    
    dayView.dotView.hidden = YES;
    
}
- (IBAction)didGoTodayTouch
{
    self.selecttime.text = @"";
    _clearButton.hidden = YES;
    _dateSelected    = _todayDate;
     _curDate = _todayDate;
    [_calendarManager setDate:_todayDate];
   [_calendarManager reload];
    
    
     [self fetchFreeSlots];
}











- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    
    NSComparisonResult result;
   NSDate *today = [NSDate date];
    self.selecttime.text = @"";
     _clearButton.hidden = YES;
       result = [today compare:dayView.date];
    
    if(result==NSOrderedAscending)
        NSLog(@"today is less");
    else if(result==NSOrderedDescending)
        NSLog(@"newDate is less");
    else
        NSLog(@"Both dates are same");
    
 // comparing two dates
    
    
    NSDateFormatter *dateFormatter=[NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDate = [dateFormatter stringFromDate:today];
    NSString *serverDate = [dateFormatter stringFromDate:dayView.date];
    

    
    
    
    
    
    
    
    if(result==NSOrderedDescending)
    {
        
        if ([currentDate isEqualToString:serverDate]) {
            
            
            
            
            _dateSelected = dayView.date;
            isDateSelected = true;
            [_calendarManager setDate:_dateSelected];
            // Animation for the circleView
            dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
            [UIView transitionWithView:dayView
                              duration:.3
                               options:0
                            animations:^{
                                dayView.circleView.transform = CGAffineTransformIdentity;
                                [_calendarManager reload];
                            } completion:nil];
            
            
            if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
                if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
                    [_calendarContentView loadNextPageWithAnimation];
                }
                else{
                    [_calendarContentView loadPreviousPageWithAnimation];
                }
            }
            
            // Don't change page in week mode because block the selection of days in first and last weeks of the month
            if(_calendarManager.settings.weekModeEnabled)
            {
                NSLog(@"%@",_dateSelected);
                _curDate = _dateSelected;
                [self fetchFreeSlots];
                return;
            }else{
                [self ChangeModeprogm];
                NSLog(@"%@",_dateSelected);
                _curDate = _dateSelected;
                [self fetchFreeSlots];
                return;
                
                
            }
            
            
        }
        else{
        
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:@"Please select a future date" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancelButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        }
        
    }else{
    
    
    
    
    _dateSelected = dayView.date;
    isDateSelected = true;
     [_calendarManager setDate:_dateSelected];
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled)
    {
        NSLog(@"%@",_dateSelected);
        _curDate = _dateSelected;
        [self fetchFreeSlots];
        return;
    }else{
          [self ChangeModeprogm];
        NSLog(@"%@",_dateSelected);
        _curDate = _dateSelected;
        [self fetchFreeSlots];
        return;
        
        
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
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-1];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:12];
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

-(void)fetchFriendsListSlots
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSDictionary *dateDict = @{@"date":[_formatter stringFromDate:_curDate]};
    NSMutableArray *dateArray = [NSMutableArray new];
    [dateArray addObject:dateDict];
    
    
    
    
    NSError *error;
    
    
    NSData *jsonDataDate = [NSJSONSerialization dataWithJSONObject:dateArray
                                                           options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStringDate = [[NSString alloc] initWithData:jsonDataDate encoding:NSUTF8StringEncoding];
    
    
    
    NSDateFormatter *dateFormatterStart = [[NSDateFormatter alloc] init];
    dateFormatterStart.dateFormat = @"hh:mm a";
    NSDate *dateStart = [dateFormatterStart dateFromString:startTimeSlots];
    dateFormatterStart.dateFormat = @"HH:mm:ss";
    NSString *starTime24 = [dateFormatterStart stringFromDate:dateStart];
    
    NSDateFormatter *dateFormatterEnd = [[NSDateFormatter alloc] init];
    dateFormatterEnd.dateFormat = @"hh:mm a";
    NSDate *dateEnd = [dateFormatterEnd dateFromString:endTimeSlots];
    dateFormatterEnd.dateFormat = @"HH:mm:ss";
    NSString *endTime24 = [dateFormatterEnd stringFromDate:dateEnd];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:jsonStringDate forKey:@"date"];
    [params setObject:starTime24 forKey:@"startTime"];
    [params setObject:endTime24 forKey:@"endTime"];
    
    [PGFriends friendsListWithSlots:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             freeFriendsArray = [[result valueForKey:@"data"]mutableCopy];
             
             NSArray *tmpArray = [NSArray arrayWithArray:freeFriendsArray];
             NSArray *tmpArray1 = [NSArray arrayWithArray:selectedFriendsArray];
             
             for (id item in tmpArray)
             {
                 NSDictionary *dict = item;
                 for (id itemStop in tmpArray1)
                 {
                     
                     NSDictionary *dict1 = itemStop;
                     
                     if(  [[dict valueForKey:@"number"]isEqualToString:[dict1 valueForKey:@"number"]])
                     {
                         
                         if (freeFriendsArray.count>0) {
                             
                             [freeFriendsArray removeObject:dict];
                             
                             
                             
                             
                             
                         }
                         
                     }
                 }
                 
             }
             
             
             
             duplicateArray = [[result valueForKey:@"data"]mutableCopy];
             
             [self  nofriends];
             [self.FriendsCollectionView reloadData];
         }
         else
         {
     [self  nofriends];
             
             
             
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
//             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:@"Fetching Friends Failed"preferredStyle:UIAlertControllerStyleAlert];
//
//             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//             [alert addAction:yesButton];
//
//             [self presentViewController:alert animated:YES completion:nil];
         }
     }];
}

-(void)fetchFriendsList
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    
    [PGFriends friendsListWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             freeFriendsArray = [[result valueForKey:@"data"]mutableCopy];
             
             duplicateArray = [[result valueForKey:@"data"]mutableCopy];
             
             [self  nofriends];
             [self.FriendsCollectionView reloadData];
         }
         else
         {
             
             [self  nofriends];
             
             
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
//             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:@"Fetching Friends Failed"preferredStyle:UIAlertControllerStyleAlert];
//
//             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//             [alert addAction:yesButton];
//
//             [self presentViewController:alert animated:YES completion:nil];
         }
     }];
}

#pragma mark - CollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (selectedFriendsArray.count+freeFriendsArray.count>0)
    {
        
        
        
        return selectedFriendsArray.count+freeFriendsArray.count;
        
    }
    else
    {
        
        
        
        return 0;    }
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FreeFriendsCollectionCell";
    
    PGFreeFriendsCollectionViewCell *freeCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (selectedFriendsArray.count>indexPath.row) {
        freeCell.freeProfilePic.layer.borderColor = [UIColor colorWithRed:254.0/255.0 green:194.0/255.0 blue:22.0/255.0 alpha:1.0].CGColor;
        freeCell.freeProfilePic.layer.borderWidth = 3.0f;
        freeCell.freeProfilePic.alpha = 0.5f;
        NSString *urlString = [[selectedFriendsArray valueForKey:@"avthar"] objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:urlString];
       // [freeCell.freeProfilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
        
        
        [freeCell.freeProfilePic sd_setImageWithURL:url
                                   placeholderImage:nil
                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                              if (error) {
                                                  
                                                  freeCell.freeProfilePic.image = [UIImage imageNamed:@"UserProfile"];
                                              }
                                          }];
        
        
        
        
        freeCell.freeFriendsLabel.text = [[selectedFriendsArray valueForKey:@"fname"] objectAtIndex:indexPath.row];
        
    } else {
        freeCell.freeProfilePic.layer.borderColor = nil;
        freeCell.freeProfilePic.layer.borderWidth = 0.0f;
        freeCell.freeProfilePic.alpha = 1.0f;
        
        NSString *urlString = [[freeFriendsArray valueForKey:@"avthar"] objectAtIndex:indexPath.row-selectedFriendsArray.count];
        NSURL *url = [NSURL URLWithString:urlString];
      //  [freeCell.freeProfilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
        
        
        [freeCell.freeProfilePic sd_setImageWithURL:url
                                   placeholderImage:nil
                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                              if (error) {
                                                  
                                                  freeCell.freeProfilePic.image = [UIImage imageNamed:@"UserProfile"];
                                              }
                                          }];
        
        
        
        freeCell.freeFriendsLabel.text = [[freeFriendsArray valueForKey:@"fname"] objectAtIndex:indexPath.row-selectedFriendsArray.count];
        
        
        
    }
    return freeCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    
    
    if (selectedFriendsArray.count>indexPath.row) {
        
        
        
        
        
        NSArray *tmpArray = [NSArray arrayWithArray:selectedFriendsArray];
        
        NSString *checkString =    [[tmpArray valueForKey:@"number"] objectAtIndex:indexPath.row];
        
        NSLog(@"pass Select%@",checkString);
        
        for (id item in tmpArray)
        {
            
            
            
            NSDictionary *dict = item;
            if ([checkString isEqualToString:[dict valueForKey:@"number"]])
            {
                
                [freeFriendsArray addObject:dict];
                
               
                
                
                if (selectedFriendsArray.count>0) {
                    
                    [selectedFriendsArray removeObject:dict];
                    
                }
                
                
                [self fetchFreeSlots];
            }
        }
        
        
        
        
        
    }else{
        
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"ping+"]) {


            NSArray *tmpArray = [NSArray arrayWithArray:freeFriendsArray];
            NSString *checkString =    [[tmpArray valueForKey:@"number"] objectAtIndex:indexPath.row-selectedFriendsArray.count];

            NSLog(@"Unselect%@",checkString);



            for (id item in tmpArray)
            {



                NSDictionary *dict = item;
                if ([checkString isEqualToString:[dict valueForKey:@"number"]])
                {

                    [selectedFriendsArray addObject:dict];
                    if (freeFriendsArray.count>0) {

                    [freeFriendsArray removeObject:dict];





                    }
                    [self fetchFreeSlots];
                }
            }


        }else{

       
        
        
        
        
        
        
        if (selectedFriendsArray.count < 8) {
            NSArray *tmpArray = [NSArray arrayWithArray:freeFriendsArray];
            NSString *checkString =    [[tmpArray valueForKey:@"number"] objectAtIndex:indexPath.row-selectedFriendsArray.count];
            
            NSLog(@"Unselect%@",checkString);
            
            
            
            for (id item in tmpArray)
            {
                
                
                
                NSDictionary *dict = item;
                if ([checkString isEqualToString:[dict valueForKey:@"number"]])
                {
                    
                    [selectedFriendsArray addObject:dict];
                    
                    if (freeFriendsArray.count>0) {
                        
                        [freeFriendsArray removeObject:dict];
                        
                    }
                    [self fetchFreeSlots];
                }
            }
            
            
        }else{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"This feature requires you to upgrade to Ping Plus (Coming Soon)" preferredStyle:UIAlertControllerStyleAlert];
         
            
         //   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Only a maximum of 9 members can be selected for a ping..." preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {


[self performSegueWithIdentifier:@"upgradeSegueEvent" sender:self];










                                                       }];
            [alertController addAction:ok];
            UIAlertAction* ok1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                        handler:nil];
            [alertController addAction:ok1];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        
        
                }
    
        
        
        
    }
    [collectionView reloadData];
}





@end
