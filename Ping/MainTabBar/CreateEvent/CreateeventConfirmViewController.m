//
//  CreateeventConfirmViewController.m
//  Ping
//
//  Created by Monish M S on 17/04/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "CreateeventConfirmViewController.h"
#import "PGNewEvent.h"
#import "PGUser.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import "PGFreeFriendsCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZMJTipView.h"
@import GooglePlacePicker;
@import GooglePlaces;




@interface CreateeventConfirmViewController ()<ZMJTipViewDelegate>
{
    BOOL  isSetActive;
    BOOL  isSetRepeat;
    ZMJTipView *Zview;
    
    GMSPlacePicker *_placePicker;
    
}
@end

@implementation CreateeventConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Confirm Event";
    isSetActive = false;
    isSetRepeat = false;
    pickerSelect = @"";
    
    
    
    CURRENT_LATITUDE     = 0.0f;
    CURRENT_LONGITUDE    = 0.0f;
    
    [self getCurrentLocation];
    
    
    
    [self.nkColorSwitch setOnTintColor:[UIColor redColor]];
    [self.nkColorSwitch setShape:kNKColorSwitchShapeRectangle];
    [self.nkColorSwitch2 setOnTintColor:[UIColor redColor]];
    [self.nkColorSwitch2 setShape:kNKColorSwitchShapeRectangle];
    [self.nkColorSwitch2 addTarget:self action:@selector(switchPressed:) forControlEvents:UIControlEventValueChanged];
    [self.nkColorSwitch addTarget:self action:@selector(switchPressedset:) forControlEvents:UIControlEventValueChanged];
    
    
    _DateCreateField.text = [_selectDate lowercaseString];
    [self createHorizontalListWithImage];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AddressLoc"];
    // Do any additional setup after loading the view.
    
    //Get Current Year into i2
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
    
    
    //Create Years Array from 1960 to This year
    years = [[NSMutableArray alloc] init];
    for (int i=1; i<=13; i++) {
        [years addObject:[NSString stringWithFormat:@"%d",i2+i]];
    }
    UIPickerView *objPickerView = [UIPickerView new];
    objPickerView.delegate = self;
    objPickerView.dataSource = self;
    objPickerView.showsSelectionIndicator = YES;
    
    
    _endDateYearField.inputView = objPickerView;
    
    yearsArray=[[NSMutableArray alloc]init];
    ZMJPreferences *preferences = [ZMJPreferences new];
    preferences.drawing.backgroundColor = [UIColor colorWithHue:.58 saturation:.1 brightness:1 alpha:1];
    preferences.drawing.foregroundColor = [UIColor darkGrayColor];
    preferences.drawing.textAlignment = NSTextAlignmentCenter;
    
    preferences.animating.dismissTransform = CGAffineTransformMakeTranslation(100, 0);
    preferences.animating.showInitialTransform =CGAffineTransformMakeTranslation(-100, 0);
    preferences.animating.showInitialAlpha = 0;
    preferences.animating.showDuration = 1;
    preferences.animating.dismissDuration = 1;
    
    Zview = [[ZMJTipView alloc] initWithText:@"Ping will notify the user if the other person is having any earlier slot free before and till the meeting time"
                                 preferences:preferences
                                    delegate:self];
    
    
    for (int i=0; i<13; i++)
    {
        [yearsArray addObject:[NSString stringWithFormat:@"%d",i2+i]];
    }
    
    //    UIBarButtonItem *chkmanuaaly = [[UIBarButtonItem alloc]initWithTitle:@"Confirm" style:UIBarButtonItemStylePlain target:self action:@selector(confirmAction:)];
    //    self.navigationItem.rightBarButtonItem=chkmanuaaly;
    
    currentDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    //Array for picker view
    monthsArray=[[NSMutableArray alloc]initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    myPickerView = [UIPickerView new];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    //[myPickerView selectRow:[currentDateComponents month]-1 inComponent:0 animated:YES];
    
    _endDateMonthField.inputView = myPickerView;
    
    
    
    datePicker = [[UIDatePicker alloc]init];
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *formattedDate = [dateFormatter dateFromString:_curDate];
    NSDate *tomorrowSet = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:formattedDate];
    
    
    
    
    
    [datePicker setDate:tomorrowSet];
    
    
    
    [datePicker setMinimumDate:tomorrowSet];
    
    
    
    
    
    
    
    
    
    
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
    [self.endDateWeekField setInputView:datePicker];
    [self.endDateDayField setInputView:datePicker];
    
    
    
    
    [self.endDateDayField setInputView:datePicker];
    
    
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60*7) sinceDate:formattedDate];
    
    datePicker1 = [[UIDatePicker alloc]init];
    [datePicker1 setDate:tomorrow];
    
    [datePicker1 setMinimumDate:tomorrow];
    [datePicker1 setDatePickerMode:UIDatePickerModeDate];
    
    [datePicker1 addTarget:self action:@selector(updateTextField1:) forControlEvents:UIControlEventValueChanged];
    [self.endDateWeekField setInputView:datePicker1];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"BackArrow"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(popNavigationController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
                       {
                           // [self getAddressFromLocation:currentLocation];
                       });
    }
}


- (IBAction)pickPlace:(UIButton *)sender {
    
    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
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
                _whereField.text =[NSString stringWithFormat:@"%@ , %@",place.name,[[place.formattedAddress
                                                                                     componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"]];
            } else {
                
                _whereField.text = @"";
            }
        }];
    } else {
        
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



- (void)popNavigationController:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)confirmAction:(id)sender
{
    if ([self validateNewEvent])
    {
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
        
        NSMutableArray *arraySelectedNumbers = [NSMutableArray new];
        
        for (id item in _selectFriendsArray)
        {
            NSDictionary *dict = item;
            
            NSDictionary *dictNumber = @{@"number":[dict valueForKey:@"number"]};
            [arraySelectedNumbers addObject:dictNumber];
        }
        
        NSDateFormatter *dateFormatterStart = [[NSDateFormatter alloc] init];
        dateFormatterStart.dateFormat = @"hh:mm a";
        NSDate *dateStart = [dateFormatterStart dateFromString:_starttimeDate];
        NSDate *dateEnd = [dateFormatterStart dateFromString:_endTimeDate];
        
        dateFormatterStart.dateFormat = @"HH:mm:ss";
        NSString *starTime24 = [dateFormatterStart stringFromDate:dateStart];
        NSString *endTime24 = [dateFormatterStart stringFromDate:dateEnd];
        
        NSError *error;
        NSData *jsonDataFriends = [NSJSONSerialization dataWithJSONObject:arraySelectedNumbers
                                                                  options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonStringFriends = [[NSString alloc] initWithData:jsonDataFriends encoding:NSUTF8StringEncoding];
        
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
        [params setObject:_curDate forKey:@"startDate"];
        [params setObject:_curDate forKey:@"endDate"];
        
        
        [params setObject:starTime24 forKey:@"startTime"];
        [params setObject:endTime24 forKey:@"endTime"];
        if (!_selectFriendsArray || !_selectFriendsArray.count)
        {
            [params setObject:@"" forKey:@"friends"];
        }
        else
        {
            [params setObject:jsonStringFriends forKey:@"friends"];
        }
        [params setObject:@"" forKey:@"title"];
        [params setObject:self.descField.text forKey:@"description"];
        [params setObject:self.whereField.text forKey:@"location"];
        
        if (_nkColorSwitch.on) {
            [params setObject:@"1" forKey:@"priority"];
        }else{
            [params setObject:@"0" forKey:@"priority"];
        }
        
        if (isSetRepeat) {
            
            [params setObject:@"1" forKey:@"repeatEvent"];
            [params setObject:strEvery forKey:@"everyday"];
            [params setObject:self.endDateDayField.text forKey:@"endDate"];
            
            if ([strEvery isEqualToString:@"every_day"]) {
                [params setObject:[self formatDateString:self.endDateDayField.text] forKey:@"endDate"];
            }else if ([strEvery isEqualToString:@"every_week"]){
                [params setObject:[self formatDateString:self.endDateWeekField.text] forKey:@"endDate"];
            }else if ([strEvery isEqualToString:@"every_month"]){
                
                
                [params setObject:[self formatDateMonthString:self.endDateMonthField.text] forKey:@"endDate"];
            }else if ([strEvery isEqualToString:@"every_year"]){
                
                
                [params setObject:[self formatDateYearString:self.endDateYearField.text] forKey:@"endDate"];
            }
            
            
            
            
            
            
            
            
        }else{
            
            [params setObject:@"0" forKey:@"repeatEvent"];
        }
        
        if (lat == nil || lon == nil)
        {
            [params setObject:@"" forKey:@"latitude"];
            [params setObject:@"" forKey:@"longitude"];
        }
        else
        {
            [params setObject:lat forKey:@"latitude"];
            [params setObject:lon forKey:@"longitude"];
        }
        
        [PGNewEvent newEventWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
         {
             if (success)
             {
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true] ;
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:@"Event Created Successfully"preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     
                     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                     [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                     NSDate *dateT = [dateFormatter dateFromString:_curDate];
                     
                     
                     
                     
                     [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"data"] forKey:@"DateeventmeetingId"];
                     
                     [[NSUserDefaults standardUserDefaults] setValue:dateT forKey:@"DateValueChange"];
                     
                     //                     [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated: true];
                     
                     
                     
                     NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
                     
                     [navigationArray removeLastObject];
                     [navigationArray removeLastObject];
                     
                     self.navigationController.viewControllers = navigationArray;
                     
                     
                     
                 }];
                 [alert addAction:yesButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
             }
             else
             {
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true] ;
                 
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alert addAction:yesButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
             }
         }];
    }
}



- (BOOL)validateNewEvent
{
    BOOL flag=YES;
    
    NSString *message=@"";
    
    
    
    if (isSetRepeat) {
        if ([strEvery isEqualToString:@"every_day"]) {
            if([self.endDateDayField.text isEqualToString:@""])
            {
                message = @"Please select end date of event";
                flag = NO;
            }
        }else if ([strEvery isEqualToString:@"every_week"]){
            if([self.endDateWeekField.text isEqualToString:@""])
            {
                message = @"Please select end date of event";
                flag = NO;
            }
        }else if ([strEvery isEqualToString:@"every_month"]){
            if([self.endDateMonthField.text isEqualToString:@""])
            {
                message = @"Please select end date of event";
                flag = NO;
            }
        }else if ([strEvery isEqualToString:@"every_year"]){
            if([self.endDateYearField.text isEqualToString:@""])
            {
                message = @"Please select end date of event";
                flag = NO;
            }
        }
        
    }
    
    
    
    
    
    
    
    if (!flag)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    return flag;
}



//- (IBAction)locationChangeAction:(id)sender {
//
//
//
//
//
//    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:nil];
//    GMSPlacePickerViewController *placePicker =
//    [[GMSPlacePickerViewController alloc] initWithConfig:config];
//    placePicker.delegate = self;
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
//    _whereField.text = [NSString stringWithFormat:@"%@%@",name,adress];
//    [viewController dismissViewControllerAnimated:YES completion:nil];
//}
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

-(void)updateTextField1:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.endDateWeekField.inputView;
    self.endDateWeekField.text = [self formatDate:picker.date];
}


-(void)updateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.endDateDayField.inputView;
    self.endDateDayField.text = [self formatDate:picker.date];
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

- (NSString *)formatDateString:(NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd-MMMM-yyyy"];
    NSDate *formattedDate = [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formattedDate1 = [dateFormatter stringFromDate:formattedDate];
    
    
    
    
    return formattedDate1;
}

- (NSString *)formatDateMonthString:(NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MMMM yyyy"];
    NSDate *formattedDate = [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formattedDate1 = [dateFormatter stringFromDate:formattedDate];
    
    NSString *formattedDate2 ;
    
    
    if ([_curDate length] > 0) {
        formattedDate2 = [_curDate substringFromIndex: [_curDate length] - 2];
    }
    
    
    
    if ([formattedDate1 length] > 0) {
        formattedDate1 = [formattedDate1 substringToIndex:[formattedDate1 length] - 2];
    }
    
    
    return [NSString stringWithFormat:@"%@%@",formattedDate1,formattedDate2];
}
- (NSString *)formatDateYearString:(NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSString *formattedDate2 ;
    
    if ([_curDate length] > 0) {
        formattedDate2 = [_curDate substringFromIndex: [_curDate length] - 5];
    }
    
    
    
    
    
    
    
    return [NSString stringWithFormat:@"%@-%@",date,formattedDate2];
}








- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)thePickerView {
    
    if ([pickerSelect isEqualToString:@"year"]) {
        return 1;    }
    else if ([pickerSelect isEqualToString:@"month"])
    {
        return 2;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerSelect isEqualToString:@"year"]) {
        return [years count];   }
    else if ([pickerSelect isEqualToString:@"month"])
    {
        NSInteger rowsInComponent;
        if (component==0)
        {
            rowsInComponent=[monthsArray count];
        }
        else
        {
            rowsInComponent=[yearsArray count];
        }
        return rowsInComponent;
    }
    else{
        
        return 0;
        
    }
    
    
    
}
- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [years objectAtIndex:row];
}




- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Lato-Regular" size:16.0];
    
    if ([pickerSelect isEqualToString:@"year"]) {
        label.text = [years objectAtIndex:row];
        
    }
    else if ([pickerSelect isEqualToString:@"month"])
    {
        label.text = component==0?[monthsArray objectAtIndex:row]:[yearsArray objectAtIndex:row];
        
        if (component==0)
        {
            if (row+1<[currentDateComponents month]+1 && [[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]] intValue]==[currentDateComponents year])
            {
                label.textColor = [UIColor grayColor];
            }
        }
        
    }
    return label;
}










- (void)pickerView:(UIPickerView *)thePickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    if ([pickerSelect isEqualToString:@"year"]) {
        _endDateYearField.text=[years objectAtIndex:row];
        
    }
    else if ([pickerSelect isEqualToString:@"month"])
    {
        
        
        
        NSLog(@"[currentDateComponents month]-->%ld<--",(long)[currentDateComponents month]);
        NSLog(@"-->%ld<--",(long)row);
        NSLog(@"row->%@<--",[yearsArray objectAtIndex:row]);
        NSLog(@"-->%@<--",[yearsArray objectAtIndex:[myPickerView selectedRowInComponent:1]]);
        
        
        if (component==1)
        {
            //[myPickerView reloadComponent:0];
            _endDateMonthField.text=[NSString stringWithFormat:@"%@ %@",[monthsArray objectAtIndex:[myPickerView selectedRowInComponent:0]],[yearsArray objectAtIndex:[myPickerView selectedRowInComponent:1]] ];
            
        }else{
            _endDateMonthField.text=[NSString stringWithFormat:@"%@ %@",[monthsArray objectAtIndex:row],[yearsArray objectAtIndex:[myPickerView selectedRowInComponent:1]] ];
            
        }
        if ([myPickerView selectedRowInComponent:0]+1<[currentDateComponents month]+1 && [[yearsArray objectAtIndex:[myPickerView selectedRowInComponent:1]] intValue]==[currentDateComponents year])
        {
            [myPickerView selectRow:[currentDateComponents month] inComponent:0 animated:YES];
            
            _endDateMonthField.text=[NSString stringWithFormat:@"%@ %@",[monthsArray objectAtIndex:[currentDateComponents month]],[yearsArray objectAtIndex:0] ];
        }
        
        
        //         _endDateMonthField.text=[NSString stringWithFormat:@"%@ %@",[monthsArray objectAtIndex:row],[years objectAtIndex:row] ];
        
        
        
    }
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField ==_endDateYearField) {
        
        pickerSelect = @"year";
        
        if ([_endDateYearField.text isEqualToString:@""]) {
            _endDateYearField.text =years[0];
            
        }
    }else if (textField ==_endDateMonthField) {
        
        pickerSelect = @"month";
        if ([_endDateMonthField.text isEqualToString:@""]) {
            
            [myPickerView selectRow:[currentDateComponents month] inComponent:0 animated:YES];
            _endDateMonthField.text =[NSString stringWithFormat:@"%@ %@", monthsArray[[currentDateComponents month]], yearsArray[0]];
        }
    }else if (textField ==_endDateDayField) {
        UIDatePicker *picker = (UIDatePicker*)self.endDateDayField.inputView;
        pickerSelect = @"";
        [self updateTextField:picker];
    }else if (textField ==_endDateWeekField) {
        UIDatePicker *picker = (UIDatePicker*)self.endDateWeekField.inputView;
        pickerSelect = @"";
        [self updateTextField1:picker];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSString *string = [data objectForKey:@"AddressLoc"];
    if(string == nil)
    {
        
    }
    else
    {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"AddressLoc"];
        self.whereField.text = [dict valueForKey:@"locationString"];
        locLatString = [dict valueForKey:@"latLoc"];
        locLangString = [dict valueForKey:@"longLoc"];
    }
    //    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"demoLoc"] != nil){
    //
    //        lat = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"demoLat"]];
    //    lon = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"demoLong"]];
    //    self.whereField.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"demoLoc"]];
    //
    //
    //
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"demoLat"];
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"demoLong"];
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"demoLoc"];
    //    }
    
}



//MARK: ZMJTipViewDelegate
- (void)tipViewDidDimiss:(ZMJTipView *)tipView {
    NSLog(@"%@ did dismiss!", tipView);
    Zview.hidden = YES;
    
}
- (IBAction)buttonAction:(UIButton *)sender {
    
    
    Zview.hidden = NO;
    
    [Zview showAnimated:YES forView:sender withinSuperview:self.view];
    
    
    
}

- (void)createHorizontalListWithImage {
    TNImageRadioButtonData *coldData = [TNImageRadioButtonData new];
    coldData.labelText = @"Every Day";
    coldData.identifier = @"day";
    coldData.selected = YES;
    coldData.unselectedImage = [UIImage imageNamed:@"unchecked"];
    coldData.selectedImage = [UIImage imageNamed:@"checked"];
    
    strEvery = @"every_day";
    _endDateDayField.hidden = false;
    _endDateWeekField.hidden = true;
    _endDateMonthField.hidden = true;
    _endDateYearField.hidden = true;
    _endDateDayField.text = @"";
    _endDateWeekField.text = @"";;
    _endDateMonthField.text = @"";;
    _endDateYearField.text = @"";;
    
    TNImageRadioButtonData *hotData = [TNImageRadioButtonData new];
    hotData.labelText = @"Every Week";
    hotData.identifier = @"week";
    hotData.selected = NO;
    hotData.unselectedImage = [UIImage imageNamed:@"unchecked"];
    hotData.selectedImage = [UIImage imageNamed:@"checked"];
    
    
    
    TNImageRadioButtonData *coldData1 = [TNImageRadioButtonData new];
    coldData1.labelText = @"Every Month";
    coldData1.identifier = @"month";
    coldData1.selected = NO;
    coldData1.unselectedImage = [UIImage imageNamed:@"unchecked"];
    coldData1.selectedImage = [UIImage imageNamed:@"checked"];
    
    TNImageRadioButtonData *hotData1 = [TNImageRadioButtonData new];
    hotData1.labelText = @"Every Year";
    hotData1.identifier = @"year";
    hotData1.selected = NO;
    hotData1.unselectedImage = [UIImage imageNamed:@"unchecked"];
    hotData1.selectedImage = [UIImage imageNamed:@"checked"];
    
    
    
    self.everyGroup = [[TNRadioButtonGroup alloc] initWithRadioButtonData:@[coldData, hotData,coldData1, hotData1] layout:TNRadioButtonGroupLayoutVertical];
    self.everyGroup.identifier = @"Temperature group";
    [self.everyGroup create];
    self.everyGroup.frame = _everyView.frame;
    
    [_everyView addSubview:self.everyGroup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(temperatureGroupUpdated:) name:SELECTED_RADIO_BUTTON_CHANGED object:self.everyGroup];
}
- (void)temperatureGroupUpdated:(NSNotification *)notification {
    NSLog(@"[MainView] Temperature group updated to %@", self.everyGroup.selectedRadioButton.data.identifier);
    _endDateDayField.text = @"";
    _endDateWeekField.text = @"";;
    _endDateMonthField.text = @"";;
    _endDateYearField.text = @"";;
    if([self.everyGroup.selectedRadioButton.data.identifier isEqualToString:@"day"]){
        strEvery = @"every_day";
        _endDateDayField.hidden = false;
        _endDateWeekField.hidden = true;
        _endDateMonthField.hidden = true;
        _endDateYearField.hidden = true;
        
        
        
        
        
    }else if ([self.everyGroup.selectedRadioButton.data.identifier isEqualToString:@"week"])
        
    {
        strEvery = @"every_week";
        
        _endDateDayField.hidden = true;
        _endDateWeekField.hidden = false;
        _endDateMonthField.hidden = true;
        _endDateYearField.hidden = true;
        
        
        
        
        
    }else if ([self.everyGroup.selectedRadioButton.data.identifier isEqualToString:@"month"])
        
    {
        strEvery = @"every_month";
        _endDateDayField.hidden = true;
        _endDateWeekField.hidden = true;
        _endDateMonthField.hidden = false;
        _endDateYearField.hidden = true;
        
        
        
    }else{
        
        strEvery = @"every_year";
        
        _endDateDayField.hidden = true;
        _endDateWeekField.hidden = true;
        _endDateMonthField.hidden = true;
        _endDateYearField.hidden = false;
        
        
    }
    
}

#pragma mark - CollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!_selectFriendsArray || !_selectFriendsArray.count)
    {
        return 0;
    }
    else
    {
        return _selectFriendsArray.count;
    }
}
#pragma mark NKColorSwitch
- (void)switchPressed:(id)sender
{
    NKColorSwitch *nkswitch = (NKColorSwitch *)sender;
    
    
    
    
    if (nkswitch.isOn)
    {
        if (nkswitch.tag == 10) {
            
            [self.tableView beginUpdates];
            isSetRepeat = true;
            
            [self.tableView endUpdates];
            
            
        }
        
        NSLog(@"switchPressed ON");
    }
    else{
        if (nkswitch.tag == 10) {
            [self.tableView beginUpdates];
            isSetRepeat = false;
            
            [self.tableView endUpdates];
            
        }
        NSLog(@"switchPressed OFF");    }
    
}
- (void)switchPressedset:(id)sender
{
    NKColorSwitch *nkswitch = (NKColorSwitch *)sender;
    
    
    
    
    if (nkswitch.isOn)
    {
        if (nkswitch.tag == 11) {
            
            [self.tableView beginUpdates];
            isSetActive = true;
            
            [self.tableView endUpdates];
            
            
        }
        
        NSLog(@"switchPressed ON");
    }
    else{
        if (nkswitch.tag == 11) {
            [self.tableView beginUpdates];
            isSetActive = false;
            
            [self.tableView endUpdates];
            
        }
        NSLog(@"switchPressed OFF");    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FreeFriendsCollectionCell";
    
    PGFreeFriendsCollectionViewCell *freeCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *urlString = [[_selectFriendsArray valueForKey:@"avthar"] objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [freeCell.freeProfilePic sd_setImageWithURL:url
                               placeholderImage:nil
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          if (error) {
                                              
                                              freeCell.freeProfilePic.image = [UIImage imageNamed:@"UserProfile"];
                                          }
                                      }];
    
    // [freeCell.freeProfilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
    freeCell.freeFriendsLabel.text = [[_selectFriendsArray valueForKey:@"fname"] objectAtIndex:indexPath.row];
    return freeCell;
}
- (IBAction)setAction:(id)sender
{
    if ([sender isSelected])
    {
        [self.tableView beginUpdates];
        isSetActive = false;
        //        isSetRepeat = false;
        //        [self.nkColorSwitch setOn:false];
        //        [self.nkColorSwitch2 setOn:false];
        [_setButton setImage:[UIImage imageNamed:@"GroupDown"]  forState:UIControlStateNormal];
        [_setButton.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16.0]];
        [self.tableView endUpdates];
        [sender setSelected: NO];
    }
    else
    {
        [self.tableView beginUpdates];
        isSetActive = true;
        
        [_setButton setImage:[UIImage imageNamed:@"GroupUp"] forState:UIControlStateNormal];
        [_setButton.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16.0]];
        [self.tableView endUpdates];
        [sender setSelected: YES];
    }
}






- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(60, 80);
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            if (_selectFriendsArray.count>0) {
                
                return 100;
                
            }
            
            return 0;
        }
        else if (indexPath.row == 1)
        {
            return 50;
        }
    }
    
    
    
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            return 50;
        }
        else if (indexPath.row == 1)
        {
            return 50;
        }
    }
    else if (indexPath.section == 2)
    {
        
        if (isSetActive != false)
        {
            if (indexPath.row == 0)
            {
                
                return 40;
            }
            else if (indexPath.row == 1 ||indexPath.row == 2 )
            {
                
                return 50;
                
            }
            else if (indexPath.row == 3 )
            {
                if (isSetRepeat) {
                    return 160;
                }
                return 0;
            }
            else if (indexPath.row == 4 )
            {
                
                return 40;
                
            }
            else if (indexPath.row == 5 )
            {
                
                return 20;
                
            }
            
            
            
        }else{
            
            if (indexPath.row == 0)
            {
                
                return 40;
            }
            else if (indexPath.row == 4 )
            {
                
                return 40;
                
            }
            else if (indexPath.row == 5 )
            {
                
                return 20;
                
            }
            return 0;
            
        }
        
        
        
        
    }
    return 0;
}


@end
