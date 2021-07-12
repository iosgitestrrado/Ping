
//
//  PGMeetingViewController.m
//  Ping
//
//  Created by Monish M S on 25/11/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGMeetingViewController.h"
#import "PGEvent.h"
#import "PGUser.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "PGEditFriendsCollectionViewCell.h"
#import "PGEditAddFriendsCollectionViewCell.h"
#import "PGNewEvent.h"
#import "PGProfileTableViewController.h"
#import "NotificationViewController.h"
#import "AppDelegate.h"




@interface PGMeetingViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableDictionary *_eventsByDate;
    
    NSMutableDictionary *notificationDict;
    BOOL locId;
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    NSDate *_dateSelected;
    NSMutableArray *arrayEvents, *arrayMainMeeting, *memberArray,*editFriendArray, *arrayFreeFriends, *selectededitFriendsArray;
    BOOL isDateSelected;
    NSString *expandInfoStringView;
    NSString *latLocView, *longLocView;
    AppDelegate *appDelegate;
    
    UIButton *button1;
}

@property (weak, nonatomic) IBOutlet UIButton *monthButton;
@property (weak, nonatomic) IBOutlet UIView *tableContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;
@property (weak, nonatomic) IBOutlet UIView *viewAlert;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewAlertHeight;
@property (weak, nonatomic) IBOutlet UITextField *editDescField;
@property (weak, nonatomic) IBOutlet UITextField *editLocationField;
@property (weak, nonatomic) IBOutlet UICollectionView *editFriendCollectionView;
@property (weak, nonatomic) IBOutlet UIView *editContentView;
@property (weak, nonatomic) IBOutlet UIView *editbackView;

@property (weak, nonatomic) IBOutlet UIView *meetingTrackView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileBarButtonItem;
@property (weak, nonatomic) IBOutlet UIImageView *oopsImagView;
@property (weak, nonatomic) IBOutlet UILabel *alertTextLabel;

@end

@implementation PGMeetingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    CURRENT_LATITUDE     = 0.0f;
    CURRENT_LONGITUDE    = 0.0f;
    
    
    [self getCurrentLocation];
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sleepStart"]!=nil) {
        
        
        
        NSString *strStack =[[NSUserDefaults standardUserDefaults] objectForKey:@"sleepStart"];
        NSString *strend =[[NSUserDefaults standardUserDefaults] objectForKey:@"sleepEnd"];
        
        strStack = [strStack substringToIndex:2];
        strend = [strend substringToIndex:2];
        
        int value = [strStack intValue];
        
        int value1 = [strend intValue];
        
        appDelegate.starttimeApp =value;
        appDelegate.endtimeApp = value1;
        
        
    }else{
        appDelegate.starttimeApp =8;
        appDelegate.endtimeApp = 22;
        
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@"22:00" forKey:@"sleepStart"];
        [[NSUserDefaults standardUserDefaults] setObject:@"08:00" forKey:@"sleepEnd"];
    }
    
    
    
    
    
    isDateSelected = false;
    locId= false;
    arrayEvents = [NSMutableArray new];
    arrayMainMeeting = [NSMutableArray new];
    memberArray  = [NSMutableArray new];
    editFriendArray = [NSMutableArray new];
    
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    [self createMinAndMaxDate];
    
    UIImage *image = [UIImage imageNamed:@"notification"];
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(0, 0, 34, 34)];
    [button1 addTarget:self action:@selector(notificationViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setBackgroundImage:image forState:UIControlStateNormal];
    
    // Make BarButton Item
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = navLeftButton;
    self.editDescField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"DateValueChange"] == nil)
    {
        
        
        [_calendarManager setDate:_todayDate];
        _dateSelected       = _todayDate;
        
    }
    else
    {
        _dateSelected = [[NSUserDefaults standardUserDefaults]valueForKey:@"DateValueChange"];
        
        
        if (_dateSelected == nil) {
            
            
            
            
            [_calendarManager setDate:_todayDate];
        }else{
            
            
            
            
            
            [_calendarManager setDate:_dateSelected];
            
            
        }
        
        
        
        
        
    }
    [_calendarManager reload];
    
    [self weekMode];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"DateeventmeetingId"] == nil)
    {
        
      //  [self fetchEvents:@""];
    }
    
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(dateEventNotification:) name:@"CalldateEventAction" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(dateEventPushNotification:) name:@"PushdateEventAction" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(dateEventRemiderNotification:) name:@"dateEventRemiderAction" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(dateEventtrackNotification:) name:@"dateEventTrackAction" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(dateEventSuggPushNotification:) name:@"dateEventSuggPushAction" object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(dateEventSuggLOcNotification:) name:@"dateEventSuggLocAction" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(dateEventpriorityNotification:) name:@"dateEventpriorityAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expandInfoNotification:) name:@"expandInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editViewNotification:) name:@"editViewInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editLocationNotification:) name:@"editLocationInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteEditNotification:) name:@"deleteViewInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainArrayChangeEventNotification:) name:@"mainArrayChangeEventInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remindTrackEventInfoNotification:) name:@"remindTrackEventInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(reloaddataDate:) name:@"reloaddataDate" object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(EventTrackNotification:) name:@"reloaddataDateMeetingID" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(badgeNotification:) name:@"badgeAction" object:nil];
}






//- (IBAction)locationChangeAction:(id)sender {
//
//    [self.editLocationField endEditing:true];
//    [self.editDescField endEditing:true];
//
//
//
//    NSLog(@"%@",  arrayMainMeeting);
//
//
//
//    NSString *   tempLat = [arrayMainMeeting valueForKey:@"latitude"];
//
//    NSString *   tempLong = [arrayMainMeeting valueForKey:@"longitude"];
//
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(tempLat.doubleValue, tempLong.doubleValue);
//    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
//                                                                  center.longitude + 0.001);
//    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
//                                                                  center.longitude - 0.001);
//    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
//                                                                         coordinate:southWest];
//
//
//
//
//
//    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
//    GMSPlacePickerViewController *placePicker =
//    [[GMSPlacePickerViewController alloc] initWithConfig:config];
//    placePicker.delegate = self;
//
//
//    [self presentViewController:placePicker animated:YES completion:nil];
//
//
//    //  [self performSegueWithIdentifier:@"maploading" sender:self];
//}
////- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
////    /* Cancel button color  */
////navigationController.navigationBar.tintColor = [UIColor redColor];
////    /* Status bar color */
////    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
////}
//// To receive the results from the place picker 'self' will need to conform to
//// GMSPlacePickerViewControllerDelegate and implement this code.
//- (void)placePicker:(GMSPlacePickerViewController *)viewController didPickPlace:(GMSPlace *)place {
//    // Dismiss the place picker, as it cannot dismiss itself.
//
//
//    NSLog(@"Place name %@", place.name);
//    NSLog(@"Place address %@", place.formattedAddress);
//    NSLog(@"Place attributions %@", place.attributions.string);
//
//    NSString *name = place.name;
//    NSString *adress = place.formattedAddress;
//    [[place.formattedAddress componentsSeparatedByString:@", "]
//     componentsJoinedByString:@"\n"];
//
//    NSLog(@"%@",place);
//    lat=[NSString stringWithFormat:@"%f",place.coordinate.latitude];
//    lon=[NSString stringWithFormat:@"%f",place.coordinate.longitude];
//
//
//
//
//    _editLocationField.text = [NSString stringWithFormat:@"%@%@",name,adress];
//    [viewController dismissViewControllerAnimated:YES completion:nil];
//}
//
//
//- (void)placePickerDidCancel:(GMSPlacePickerViewController *)viewController {
//    // Dismiss the place picker, as it cannot dismiss itself.
//
//    NSLog(@"No place selected");
//
//    [viewController dismissViewControllerAnimated:YES completion:nil];
//
//
//}

- (void)getCurrentLocation
{
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //NSLog(@"didUpdateToLocation: %@",[locations lastObject]);
    currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        CURRENT_LATITUDE    =   currentLocation.coordinate.latitude;
        CURRENT_LONGITUDE   =   currentLocation.coordinate.longitude;
    }
}

- (IBAction)selectAddressAction:(id)sender {
    [self.editLocationField endEditing:true];
    [self.editDescField endEditing:true];
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        
        [self pickPlace];
    }
    else {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"PING"
                                     message:@"GPS function is off. Please turn on the GPS function"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                        
                                        
                                        
                                        
                                        
                                    }];
        
        
        
        [alert addAction:yesButton];
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


- (void)pickPlace {
    
    CLLocationCoordinate2D center;
    
    
    if (   [[arrayMainMeeting valueForKey:@"location"] isEqualToString:@""])
        
    {
        center = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    }else{
        
        NSString *   tempLat = [arrayMainMeeting valueForKey:@"latitude"];
        
        NSString *   tempLong = [arrayMainMeeting valueForKey:@"longitude"];
        
        
        center = CLLocationCoordinate2DMake([tempLat floatValue], [tempLong floatValue  ]);
        
        
        
    }
    
    
    
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
                                                                  center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
                                                                  center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            
            
            
            lat=[NSString stringWithFormat:@"%f",place.coordinate.latitude];
            lon=[NSString stringWithFormat:@"%f",place.coordinate.longitude];
            _editLocationField.text =[NSString stringWithFormat:@"%@ , %@",place.name,[[place.formattedAddress
                                                                                        componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"]];
        } else {
            
            _editLocationField.text = @"";
        }
    }];
}






-(void)badgeNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"badgeAction"])
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
        
        NSDictionary *Dict2 = notification.userInfo;
        NSDictionary *Dict =[Dict2 objectForKey:@"detail"];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        
        
        NSDate * strdateon =   [format dateFromString:[Dict objectForKey:@"date"]];
        
        if ([strdateon isKindOfClass: [NSDate class]]) {
            
            
            NSString * strdateonOFF =   [format stringFromDate:_calendarManager.date];
            
            NSDate * strdateonCHECK =   [format dateFromString:strdateonOFF];
            
            if ([strdateon isEqualToDate:strdateonCHECK]) {
                
                
                
                [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
                
                
                if (arrayMainMeeting.count>0) {
                    
                    if ([[Dict2 objectForKey:@"type"] isEqualToString:@"delete meeting"])
                    {
                        
                        
                    }else{
                        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[arrayMainMeeting valueForKey:@"meeting_id"] ] forKey:@"DateeventmeetingId"];
                    }
                    
                    
                    
                }
                
                
                [self fetchEvents:@"remind"];
                
                
                
            }
            
            
        }
        
        
        
        
    }
    
}

-(void)dateEventNotification:(NSNotification*)notification
{
    locId =false;
    
    
    [self fetchEvents:@""];
    
    
    
    
    
    
    
    
}
-(void)dateEventRemiderNotification:(NSNotification*)notification
{
    NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
    
    UIViewController * controllerTest = [controllers lastObject];
    
    if([controllerTest isKindOfClass:[PGMeetingViewController class]]){
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    
    
    NSLog(@"this is the variable value: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DateeventmeetingId"]);
    [self fetchEvents:@"remind"];
}

-(void)dateEventtrackNotification:(NSNotification*)notification
{
    NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
    
    UIViewController * controllerTest = [controllers lastObject];
    
    if([controllerTest isKindOfClass:[PGMeetingViewController class]]){
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    
    
    NSLog(@"this is the variable value: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DateeventmeetingId"]);
    [self fetchEvents:@"remind"];
}

-(void)dateEventSuggPushNotification:(NSNotification*)notification
{
    NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
    
    UIViewController * controllerTest = [controllers lastObject];
    
    if([controllerTest isKindOfClass:[PGMeetingViewController class]]){
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    
    
    NSLog(@"this is the variable value: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DateeventmeetingId"]);
    [self fetchEvents:@"remind"];
}

-(void)dateEventSuggLOcNotification:(NSNotification*)notification
{
    NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
    
    UIViewController * controllerTest = [controllers lastObject];
    
    if([controllerTest isKindOfClass:[PGMeetingViewController class]]){
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    
    
    NSLog(@"this is the variable value: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DateeventmeetingId"]);
    [self fetchEvents:@"remind"];
}


-(void)dateEventpriorityNotification:(NSNotification*)notification
{
    NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
    
    UIViewController * controllerTest = [controllers lastObject];
    
    if([controllerTest isKindOfClass:[PGMeetingViewController class]]){
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    
    
    NSLog(@"this is the variable value: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DateeventmeetingId"]);
    [self fetchEvents:@"remind"];
}



-(void)dateEventPushNotification:(NSNotification*)notification
{
    
    NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
    
    UIViewController * controllerTest = [controllers lastObject];
    
    if([controllerTest isKindOfClass:[PGMeetingViewController class]]){
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    
    NSLog(@"this is the variable value: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DateeventmeetingId"]);
    [self fetchEvents:@"remind"];
}
-(void)EventTrackNotification:(NSNotification*)notification
{
    
    NSLog(@"this is the variable value: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DateeventmeetingId"]);
    
    if (arrayMainMeeting.count>0) {
        if ([[NSString stringWithFormat:@"%@",[arrayMainMeeting valueForKey:@"meeting_id"] ] isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"DateeventmeetingId"]] ){
        [self fetchEventsMeeting:[NSString stringWithFormat:@"%@",[arrayMainMeeting valueForKey:@"meeting_id"] ] passing:@"str" passingdate:[arrayMainMeeting valueForKey:@"start_date"]];
        
        }
        
        
    }else{
            NSLog(@"this is the variable valuecvdsvsdvderswfvdfrsv dfsv vdfrfvdsd: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DateeventmeetingId"]);
            [self fetchEventsMeeting:[[NSUserDefaults standardUserDefaults]objectForKey:@"DateeventmeetingId"] passing:@"str"];
        }
    
}






-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
     _todayDate = [NSDate date];
    
    
    
    
    
    
    
    [_calendarContentView setUserInteractionEnabled:true];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(profileViewAction:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 34, 34)];
    button.layer.cornerRadius = 17;
    button.layer.masksToBounds = YES;
    //    button.layer.borderColor = [UIColor whiteColor].CGColor;
    //    button.layer.borderWidth = 1.0f;
    
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
    
    UIImage *img;
    
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ping+"]) {
        img = [UIImage imageNamed:@"ping+Home"];
    }else{
        
        img = [UIImage imageNamed:@"PiIcon"];
        
    }
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:img];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;
    
    self.navigationItem.rightBarButtonItem.badgeValue = appDelegate.badgeValue;
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor colorWithRed:203.0/255.0 green:84.0/255.0 blue:124.0/255.0 alpha:1.0];
    appDelegate.indexValue = 3;
    
    
    locId =false;
    
    if (_dateSelected) {
        
        [_calendarManager setDate:_dateSelected];
        
    }else{
        
        [_calendarManager setDate:_todayDate];
        
    }
    
    
    self.tabBarController.tabBar.hidden = false;
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"DateValueChange"] == nil)
    {
        
        if (arrayMainMeeting.count>0) {
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            
            NSDate * strdateon =   [format dateFromString:[arrayMainMeeting valueForKey:@"start_date"] ];
            
            if ([strdateon isKindOfClass: [NSDate class]]) {
                
                
                
                [[NSUserDefaults standardUserDefaults] setObject:strdateon forKey:@"DateValueChange"];
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[arrayMainMeeting valueForKey:@"meeting_id"] ] forKey:@"DateeventmeetingId"];
                
                
                
                
                _dateSelected = strdateon;
                [_calendarManager setDate:_dateSelected];
                
                locId = true;
                [self fetchEvents:@"remind"];
                [_calendarManager reload];
                
            }
        }else{
            
            _dateSelected = _todayDate;
            [_calendarManager setDate:_dateSelected];
            locId = true;
            [self fetchEvents:@"remind"];
            [_calendarManager reload];
            
        }
        
        
        
        
        
        
        
    }
    else
    {
        
        _dateSelected = [[NSUserDefaults standardUserDefaults]valueForKey:@"DateValueChange"];
        if (_dateSelected == nil) {
            
            
            
            
            [_calendarManager setDate:_todayDate];
        }else{
            
            
            
            
            
            [_calendarManager setDate:_dateSelected];
            
            
        }
        locId =false;
        [self fetchEvents:@"remind"];
        
        
    }
    [_calendarManager reload];
    
    NSLog(@"%@",_calendarManager.date);
}
-(void)reloaddataDate:(NSNotification*)notification
{
    
    
    if ([notification.name isEqualToString:@"reloaddataDate"])
    {
        [self fetchEvents:@""];
    }
}



-(void) expandInfoNotification:(NSNotification*)notification
{
    //    if ([notification.name isEqualToString:@"expandInfo"])
    //    {
    //        NSDictionary* userInfo = notification.userInfo;
    //        expandInfoStringView = userInfo[@"expandStr"];
    //
    //        if ([expandInfoStringView isEqualToString:@"expanded"])
    //        {
    //            [self.viewAlert setHidden:true];
    //        }
    //        else
    //        {
    //            if (!arrayMainMeeting || !arrayMainMeeting.count)
    //            {
    //                [self.viewAlert setHidden:false];
    //            }
    //            else
    //            {
    //                [self.viewAlert setHidden:true];
    //            }
    //        }
    //    }
}
-(void) remindTrackEventInfoNotification:(NSNotification*)notification
{
    
    notificationDict =  [[NSMutableDictionary alloc  ]init];
    
    if ([notification.name isEqualToString:@"remindTrackEventInfo"])
    {
        
        
        notificationDict = [notification.userInfo mutableCopy];
        locId= false;
        
        
        
#pragma please add date
        //[[NSUserDefaults standardUserDefaults]valueForKey:@"DateValueChange"];
        
        [[NSUserDefaults standardUserDefaults]setObject:[notificationDict objectForKey:@"meeting_id"]  forKey:@"DateeventmeetingId"];
        
        [self fetchEvents:@""];
    }
}

-(void) mainArrayChangeEventNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"mainArrayChangeEventInfo"])
    {
        NSDictionary* userInfoMeet = notification.userInfo;
        arrayMainMeeting = (NSMutableArray *)userInfoMeet[@"mainArrayPassChange"];
        NSDictionary* userInfo = @{@"arrayPass": arrayEvents,@"expandStr": @"notExpand",@"arrayMainEvent":arrayMainMeeting};
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"eventInfo" object:self userInfo:userInfo];
        //  NSLog (@"Successfully received test notification! %@", arrayPassEvents);
    }
}

-(void) editViewNotification:(NSNotification*)notification
{
    
    
    
    
    if ([notification.name isEqualToString:@"editViewInfo"])
    {
        
        [UIView transitionWithView:_editbackView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCurlDown
                        animations:^{
                            _editbackView.hidden = false;
                        }
                        completion:NULL];
        
        [UIView transitionWithView:_editContentView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCurlDown
                        animations:^{
                            _editContentView.hidden = false;
                        }
                        completion:NULL];
        
        self.editDescField.text = [arrayMainMeeting valueForKey:@"description"];
        self.editLocationField.text = [arrayMainMeeting valueForKey:@"location"];
        lat = [arrayMainMeeting valueForKey:@"latitude"];
        lon = [arrayMainMeeting valueForKey:@"longitude"];
        self.editDescField.userInteractionEnabled = true;
        memberArray = [arrayMainMeeting valueForKey:@"mambers"];
        
        if ([[NSString stringWithFormat:@"%@", [arrayMainMeeting valueForKey:@"group_flag"]] isEqualToString:@"1"])
        {
            
            [self.editFriendCollectionView setHidden:false];
            
            self.editDescField.userInteractionEnabled = false;
            [self.editFriendCollectionView reloadData];
            
            if ([[NSString stringWithFormat:@"%@", [arrayMainMeeting valueForKey:@"created_by"]] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]])
            {
                self.editDescField.userInteractionEnabled = true;
                // [self.editFriendCollectionView setHidden:false];
                //            [self.editFriendCollectionView reloadData];
                
            }
            
            
        }
        else
        {
            self.editDescField.userInteractionEnabled = true;
            
            [self.editFriendCollectionView setHidden:true];
        }
        
        
        
        
    }
}

-(void) editLocationNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"editLocationInfo"])
    {
        NSDictionary* userInfo = notification.userInfo;
        NSString *stringLocView = userInfo[@"locationString"];
        
        if ([stringLocView isEqualToString:@"cancelLoc"] )
        {
            [self.meetingTrackView setHidden:true];
        }
        else
        {
            self.editLocationField.text = stringLocView;
            lat = userInfo[@"latLoc"];
            lon  = userInfo[@"longLoc"];
            [self.meetingTrackView setHidden:true];
        }
    }
}

-(void) deleteEditNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"deleteViewInfo"])
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:@"Do you want to remove this Ping?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancelButton];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //http://elviserp.in/ping/meeting/deleteMeeting/
            // API params : user_id, meetingId
            [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
            [params setObject:[arrayMainMeeting valueForKey:@"meeting_id"] forKey:@"meetingId"];
            
            [PGEvent deleteMeetingWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
             {
                 if (success)
                 {
                     [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                     
                     locId =false;
                     
                     if (_dateSelected) {
                         
                         [[NSUserDefaults standardUserDefaults] setValue:_dateSelected forKey:@"DateValueChange"];
                         
                     }else{
                         [[NSUserDefaults standardUserDefaults] setValue:_todayDate forKey:@"DateValueChange"];
                     }
                     
                     
                     [self fetchEvents:@""];
                 }
                 else
                 {
                     [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                     UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                     [alert addAction:yesButton];
                     
                     [self presentViewController:alert animated:YES completion:nil];
                 }
             }];
        }];
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)editCloseAction:(id)sender
{
    [self.editDescField resignFirstResponder];
    [self.editLocationField resignFirstResponder];
    
    
    [UIView transitionWithView:_editbackView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        _editbackView.hidden = true;
                    }
                    completion:NULL];
    
    [UIView transitionWithView:_editContentView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        _editContentView.hidden = true;
                    }
                    completion:NULL];
    [self.editFriendCollectionView reloadData];
}

- (IBAction)doneAction:(id)sender
{
    
    
    [self.view endEditing:YES];
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Meeting Updated"
                                 message:@"Are you sure?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                    
                                    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
                                    
                                    NSMutableArray *arrayEditSelectedNumbers = [NSMutableArray new];
                                    NSMutableArray *arrayAddSelectedNumbers = [NSMutableArray new];
                                    
                                    for (id item in editFriendArray)
                                    {
                                        NSDictionary *dict = item;
                                        
                                        NSDictionary *dictNumber = @{@"number":[dict valueForKey:@"number"]};
                                        [arrayEditSelectedNumbers addObject:dictNumber];
                                    }
                                    
                                    NSError *error;
                                    NSData *jsonDataFriends = [NSJSONSerialization dataWithJSONObject:arrayEditSelectedNumbers
                                                                                              options:NSJSONWritingPrettyPrinted error:&error];
                                    NSString *jsonStringFriends = [[NSString alloc] initWithData:jsonDataFriends encoding:NSUTF8StringEncoding];
                                    
                                    
                                    for (id item in selectededitFriendsArray)
                                    {
                                        NSDictionary *dict = item;
                                        
                                        NSDictionary *dictNumber = @{@"number":[dict valueForKey:@"number"]};
                                        [arrayAddSelectedNumbers addObject:dictNumber];
                                    }
                                    
                                    NSData *jsonDataFriendsAdd = [NSJSONSerialization dataWithJSONObject:arrayAddSelectedNumbers
                                                                                                 options:NSJSONWritingPrettyPrinted error:&error];
                                    NSString *jsonStringFriendsAdd = [[NSString alloc] initWithData:jsonDataFriendsAdd encoding:NSUTF8StringEncoding];
                                    
                                    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                                    
                                    
                                    
                                    
                                    
                                    
                                    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
                                    [params setObject:[arrayMainMeeting valueForKey:@"meeting_id"] forKey:@"meetingId"];
                                    [params setObject:self.editDescField.text forKey:@"description"];
                                    [params setObject:self.editLocationField.text forKey:@"location"];
                                    [params setObject:lat forKey:@"latitude"];
                                    [params setObject:lon forKey:@"longitude"];
                                    
                                    if (!arrayAddSelectedNumbers || !arrayAddSelectedNumbers.count)
                                    {
                                        [params setObject:@"" forKey:@"addFriends"];
                                    }
                                    else
                                    {
                                        [params setObject:jsonStringFriendsAdd forKey:@"addFriends"];
                                    }
                                    
                                    if (!arrayEditSelectedNumbers || !arrayEditSelectedNumbers.count)
                                    {
                                        [params setObject:@"" forKey:@"removeFriends"];
                                    }
                                    else
                                    {
                                        [params setObject:jsonStringFriends forKey:@"removeFriends"];
                                    }
                                    
                                    [PGEvent editMeetingWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
                                     {
                                         if (success)
                                         {
                                             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                                             [selectededitFriendsArray removeAllObjects];
                                             [self.editFriendCollectionView reloadData];
                                             [editFriendArray removeAllObjects];
                                             
                                             
                                             
                                             [[NSUserDefaults standardUserDefaults]setObject:[arrayMainMeeting valueForKey:@"meeting_id"]  forKey:@"DateeventmeetingId"];
                                             
                                             if (_dateSelected) {
                                                 
                                                 [[NSUserDefaults standardUserDefaults] setValue:_dateSelected forKey:@"DateValueChange"];
                                                 
                                             }else{
                                                 [[NSUserDefaults standardUserDefaults] setValue:_todayDate forKey:@"DateValueChange"];
                                             }
                                             locId = true;
                                             
                                             [self fetchEvents:@""];
                                         }
                                         else
                                         {
                                             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                                             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                             
                                             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                             [alert addAction:yesButton];
                                             
                                             [self presentViewController:alert animated:YES completion:nil];
                                         }
                                     }];
                                    
                                    
                                    [self editCloseAction:nil];
                                    
                                    
                                    
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self editCloseAction:nil];
                               }];
    
    
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
    
    
    
    
}


// API params : user_id, meetingId, description, location, addFriends, removeFriends
//  addFriends | removeFriends format : [{"number":"+918973732721"},{"number":"+918973732721"}]
/*
 NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
 [params setObject:[[PGUser currentUser] accessToken] forKey:@"user_id"];
 [params setObject:[arrayPassMainEvent valueForKey:@"meeting_id"] forKey:@"meetingId"];
 [params setObject:[arrayPassMainEvent valueForKey:@"start_date"] forKey:@"date"];
 
 [PGEvent pushSwapWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
 {
 if (success)
 {
 
 }
 else
 {
 
 }
 }];
 */

-(void)fetchEventsMeeting:(NSString *)meetingId passing:(NSString *)functinality
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    
    if (meetingId==nil) {
        meetingId = @"";
    }
    
    
    [params setObject:meetingId forKey:@"meetingId"];
    
    
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DateeventmeetingId"];
    [PGEvent eventDetailsByMeetingId:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         
         
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             arrayMainMeeting = [result valueForKey:@"data"];
             // [self.viewAlert setHidden:true];
             
             
             
             
             
             if ([functinality isEqualToString:@""]) {
                 NSDictionary* userInfo = @{@"arrayPass": arrayEvents,@"expandStr": @"notExpand",@"arrayMainEvent":arrayMainMeeting};
                 NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                 [nc postNotificationName:@"eventInfo" object:self userInfo:userInfo];
             }else{
                 
                 NSDictionary* userInfo = @{@"arrayPass": arrayEvents,@"expandStr": @"notExpand",@"arrayMainEvent":arrayMainMeeting,@"functinality":functinality};
                 NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                 [nc postNotificationName:@"eventInfo" object:self userInfo:userInfo];
                 
             }
             if (!locId) {
                 locId = false;
                 NSDictionary* userInfo = @{@"ViewString": @"NeedView"};
                 NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                 [nc postNotificationName:@"ViewExpandInfo" object:self userInfo:userInfo];
             }
             
             
         }
         else
         {
             
             
             NSMutableDictionary* dictionary = @{}.mutableCopy;
             
             NSDictionary* userInfo = @{@"arrayPass": arrayEvents,@"expandStr": @"notExpand",@"arrayMainEvent":dictionary};
             
             NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
             [nc postNotificationName:@"eventInfo" object:self userInfo:userInfo];
             
             
             
             
             
             if (result) {
                 
                 NSString* categoryName =@"";
                 if ([result isKindOfClass:[NSString class]]) {
                     categoryName = [NSString stringWithFormat:@"%@",result];
                 }else{
                     categoryName = [NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]];
                 }
                 
                 
                 if (categoryName == nil || categoryName == (id)[NSNull null]) {
                     categoryName = @"Error in Action";
                 }
                 
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:[NSString stringWithFormat:@"%@",categoryName] preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
                 [alert addAction:cancelButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
                 
                 
                 
                 
             }else{
                 
                 
                 
                 
                 
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
                 [alert addAction:cancelButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
                 
             }
         }
     }];
}

-(void)fetchEventsMeeting:(NSString *)meetingId passing:(NSString *)functinality passingdate:(NSString *)datetopass
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    
    if (meetingId==nil) {
        meetingId = @"";
    }
    
    
    [params setObject:meetingId forKey:@"meetingId"];
    [params setObject:datetopass forKey:@"date"];
    
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DateeventmeetingId"];
    [PGEvent eventDetailsByMeetingId:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         
         
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             arrayMainMeeting = [result valueForKey:@"data"];
             // [self.viewAlert setHidden:true];
             
             
             
             
             
             if ([functinality isEqualToString:@""]) {
                 NSDictionary* userInfo = @{@"arrayPass": arrayEvents,@"expandStr": @"notExpand",@"arrayMainEvent":arrayMainMeeting};
                 NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                 [nc postNotificationName:@"eventInfo" object:self userInfo:userInfo];
             }else{
                 
                 NSDictionary* userInfo = @{@"arrayPass": arrayEvents,@"expandStr": @"notExpand",@"arrayMainEvent":arrayMainMeeting,@"functinality":functinality};
                 NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                 [nc postNotificationName:@"eventInfo" object:self userInfo:userInfo];
                 
             }
             if (!locId) {
                 locId = false;
                 NSDictionary* userInfo = @{@"ViewString": @"NeedView"};
                 NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                 [nc postNotificationName:@"ViewExpandInfo" object:self userInfo:userInfo];
             }
             
             
         }
         else
         {
             
             
             NSMutableDictionary* dictionary = @{}.mutableCopy;
             
             NSDictionary* userInfo = @{@"arrayPass": arrayEvents,@"expandStr": @"notExpand",@"arrayMainEvent":dictionary};
             
             NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
             [nc postNotificationName:@"eventInfo" object:self userInfo:userInfo];
             
             
             
             
             
             if (result) {
                 
                 NSString* categoryName =@"";
                 if ([result isKindOfClass:[NSString class]]) {
                     categoryName = [NSString stringWithFormat:@"%@",result];
                 }else{
                     categoryName = [NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]];
                 }
                 
                 
                 if (categoryName == nil || categoryName == (id)[NSNull null]) {
                     categoryName = @"Error in Action";
                 }
                 
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:[NSString stringWithFormat:@"%@",categoryName] preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
                 [alert addAction:cancelButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
                 
                 
                 
                 
             }else{
                 
                 
                 
                 
                 
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
                 [alert addAction:cancelButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
                 
             }
         }
     }];
}









-(void)fetchEvents :(NSString *) str
{
    
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"DateValueChange"] == nil)
    {
        
        
    }
    else
    {
        _dateSelected = [[NSUserDefaults standardUserDefaults]valueForKey:@"DateValueChange"];
        
        
        
        
        
        
        if (_dateSelected == nil) {
            isDateSelected = false;
            
            
            
            
        }else{
            
            isDateSelected = true;
            
            
            
            
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString* finalDateString;
    
    
    
    if (isDateSelected == true)
    {
        
        finalDateString  = [format stringFromDate:_dateSelected];
        [_calendarManager setDate:_dateSelected];
        NSLog(@"%@",finalDateString);
        
    }
    else
    {
        finalDateString  = [format stringFromDate:_todayDate];
        [_calendarManager setDate:_todayDate];
        
    }
    
    if (![finalDateString isKindOfClass:[NSString class]]) {
        finalDateString  = [format stringFromDate:_todayDate];
        [_calendarManager setDate:_todayDate];
        
        
    }
    [_calendarManager reload];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:finalDateString forKey:@"date"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DateValueChange"];
    
    [PGEvent fetchEventWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             
             arrayEvents = [result valueForKey:@"data"];
             
             NSLog(@"this is the variable value: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DateeventmeetingId"]);
             
             
             
             if ([[NSUserDefaults standardUserDefaults]valueForKey:@"DateeventmeetingId"] == nil)
             {
                 arrayMainMeeting = [result valueForKey:@"mainEvent"];
             }
             else
             {
                 
                 NSLog(@"this is the variable value: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DateeventmeetingId"]);
                 
                 
                 
                 
                 
                 
                 [self fetchEventsMeeting:[[NSUserDefaults standardUserDefaults]objectForKey:@"DateeventmeetingId"] passing:str passingdate:finalDateString];
                 
                 
             }
             
             
             
             if ( arrayMainMeeting.count>0)
             {
                 
                 
                 NSDictionary* userInfo = @{@"arrayPass": arrayEvents,@"expandStr": @"notExpand",@"arrayMainEvent":arrayMainMeeting};
                 NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                 [nc postNotificationName:@"eventInfo" object:self userInfo:userInfo];
                 
                 
             }
             else
             {
                 NSMutableDictionary* dictionary = @{}.mutableCopy;
                 
                 NSDictionary* userInfo = @{@"arrayPass": arrayEvents,@"expandStr": @"notExpand",@"arrayMainEvent":dictionary};
                 
                 NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                 [nc postNotificationName:@"eventInfo" object:self userInfo:userInfo];
                 
             }
         }
         else
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:cancelButton];
             
             [self presentViewController:alert animated:YES completion:nil];
         }
     }];
    
    
    
    
    
    
    
    
}
#pragma mark - Textfield Delegate


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return true;
}

- (IBAction)locAction:(id)sender
{
    [self.editLocationField endEditing:true];
    [self.editDescField endEditing:true];
    [self.meetingTrackView setHidden:false];
}


- (IBAction)createEvent:(id)sender
{
    
    
    
    
    if (_dateSelected) {
        
        NSComparisonResult result;
        
        
        result = [_todayDate compare:_dateSelected];
        
        if(result==NSOrderedAscending)
            NSLog(@"today is less");
        else if(result==NSOrderedDescending)
            NSLog(@"newDate is less");
        else
            NSLog(@"Both dates are same");
        
        if(result==NSOrderedDescending)
        {
            CreateEventViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateEventViewController"];
            profileVC.curDate = _todayDate;
            [self.navigationController pushViewController:profileVC animated:true];
            
        }else{
            
            
            
            CreateEventViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateEventViewController"];
            profileVC.curDate = _dateSelected;
            [self.navigationController pushViewController:profileVC animated:true];
            
        }
    }else{
        CreateEventViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateEventViewController"];
        profileVC.curDate = _todayDate;
        [self.navigationController pushViewController:profileVC animated:true];
    }
}
#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
     _todayDate = [NSDate date];
    _dateSelected    = _todayDate;
    [_calendarManager setDate:_todayDate];
    
    locId =false;
    
    NSDictionary* userInfo = @{@"ViewString": @"NoNeedView"};
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"ViewExpandInfo" object:self userInfo:userInfo];
     [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DateeventmeetingId"];
    
    [self fetchEvents:@""];
}

- (IBAction)didChangeModeTouch
{
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    self.arrowIcon.image = [UIImage imageNamed:@"UpArrow"];
    CGFloat newHeight = 0.0;
    CGFloat containerHeight = 0.0;
    if (!arrayMainMeeting || !arrayMainMeeting.count)
    {
        //[self.viewAlert setHidden:false];
        NSDictionary* userInfo = @{@"ViewString": @"NoNeedView"};
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"ViewExpandInfo" object:self userInfo:userInfo];
    }
    else
    {
        //  [self.viewAlert setHidden:true];
    }
    
    
    
    
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
        if (!arrayMainMeeting || !arrayMainMeeting.count)
        {
            //  [self.viewAlert setHidden:false];
            NSDictionary* userInfo = @{@"ViewString": @"NeedView"};
            NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"ViewExpandInfo" object:self userInfo:userInfo];
        }
        else
        {
            //  [self.viewAlert setHidden:true];
        }
        
        
        
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
    self.containerViewHeight.constant = containerHeight;
    self.calendarContentViewHeight.constant = newHeight;
    [self.view layoutIfNeeded];
}

-(void)weekMode
{
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    CGFloat newHeight = 0.0;
    CGFloat containerHeight = 0.0;
    if (!arrayMainMeeting || !arrayMainMeeting.count)
    {
        // [self.viewAlert setHidden:false];
        NSDictionary* userInfo1 = @{@"ViewString": @"NoNeedView"};
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"ViewExpandInfo" object:self userInfo:userInfo1];
    }
    else
    {
        //[self.viewAlert setHidden:true];
    }
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
        if (!arrayMainMeeting || !arrayMainMeeting.count)
        {
            // [self.viewAlert setHidden:false];
            NSDictionary* userInfo = @{@"ViewString": @"NoNeedView"};
            NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"ViewExpandInfo" object:self userInfo:userInfo];
        }
        else
        {
            // [self.viewAlert setHidden:true];
        }
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
    self.containerViewHeight.constant = containerHeight;
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
     [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DateeventmeetingId"];
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    
    
    if(_calendarManager.settings.weekModeEnabled){
        
        NSLog(@"%@",_dateSelected);
        [[NSUserDefaults standardUserDefaults] setValue:_dateSelected forKey:@"DateValueChange"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_calendarManager setDate:_dateSelected];
        locId =false;
        
        NSDictionary* userInfo = @{@"ViewString": @"NoNeedView"};
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"ViewExpandInfo" object:self userInfo:userInfo];
        
        [self fetchEvents:@""];
        return;
    }
    
    
    else {
        NSLog(@"%@",_dateSelected);
        [[NSUserDefaults standardUserDefaults] setValue:_dateSelected forKey:@"DateValueChange"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_calendarManager setDate:_dateSelected];
        locId =false;
        
        NSDictionary* userInfo = @{@"ViewString": @"NoNeedView"};
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"ViewExpandInfo" object:self userInfo:userInfo];
        
        [self didChangeModeTouch];
        
        [self fetchEvents:@""];
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
    
}

- (IBAction)profileViewAction:(id)sender
{
    
    PGProfileTableViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PGProfileTableViewController"];
    profileVC.passString = nil;
    [self.navigationController pushViewController:profileVC animated:true];
    
}
- (IBAction)notificationViewAction:(id)sender
{
    
    NotificationViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    [self.navigationController pushViewController:profileVC animated:true];
    
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
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-12];
    
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


#pragma mark - CollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return memberArray.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EditFriendCell";
    
    PGEditFriendsCollectionViewCell *freeCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *urlString = [[memberArray valueForKey:@"avthar"] objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:urlString];
    //  [freeCell.editFriendImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
    
    [freeCell.editFriendImgView sd_setImageWithURL:url
                                  placeholderImage:nil
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             if (error) {
                                                 
                                                 freeCell.editFriendImgView.image = [UIImage imageNamed:@"UserProfile"];
                                             }
                                         }];
    freeCell.editFriendImgView.layer.borderColor = nil;
    freeCell.editFriendImgView.layer.borderWidth = 0.0f;
    freeCell.editFriendImgView.alpha = 1.0f;
    freeCell.editFriendNameLabel.text = [[memberArray valueForKey:@"fname"] objectAtIndex:indexPath.row];
    return freeCell;
    
}

@end

