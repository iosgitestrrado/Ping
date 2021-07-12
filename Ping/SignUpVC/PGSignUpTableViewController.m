//
//  PGSignUpTableViewController.m
//  Ping
//
//  Created by Monish M S on 08/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGSignUpTableViewController.h"
#import "CountryListViewController.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import "PGUser.h"
#import "PGVerificationTableViewController.h"
#define MAX_LENGTH 35
#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_."

@interface PGSignUpTableViewController () <UITextFieldDelegate,UIAlertViewDelegate>
{
    PGUser *newUser;
    CLLocation *currentLocation;
    CLLocationCoordinate2D coordinate;
    NSString *currentLatitude,*titleString, *currentLongitude;
}
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *signFields;
@property (strong, nonatomic) NSArray *dataRows;
@end

@implementation PGSignUpTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBg"]];
    [self parseJSON];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [RightButton setImage:[UIImage imageNamed:@"iconEyesClose"] forState:UIControlStateNormal];
    
    [RightButton setImage:[UIImage imageNamed:@"iconEyesOpen"] forState:UIControlStateSelected];
    [checkbox setImage:[UIImage imageNamed:@"notselectedcheckbox"] forState:UIControlStateNormal];
    
    [checkbox setImage:[UIImage imageNamed:@"selectedcheckbox"] forState:UIControlStateSelected];
    
    
//    [checkbox setImage:[UIImage imageNamed:@"notselectedcheckbox"]
//                        forState:UIControlStateNormal];
//    [checkbox setBackgroundImage:[UIImage imageNamed:@"selectedcheckbox"]
//                        forState:UIControlStateSelected];
   
    
    
    
    
    
    
    
    
    
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSLog(@"countryCode: %@", countryCode);
    int i = 0;
    for (NSDictionary *item in _dataRows){
        
        
        
        if ([[item objectForKey:@"code"] isEqualToString:countryCode])
        {
            ((UITextField*)[_signFields objectAtIndex:3]).text  = [item objectForKey:@"dial_code"];
            ((UITextField*)[_signFields objectAtIndex:2]).text  = [item objectForKey:@"name"];
            
        }
        i++;
    }
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    
}



-(IBAction)CheckButtonAction:(id)sender
{
    
    if (checkbox.selected)
    {
        
        checkbox.selected = NO;
        
       
    }
    else
    {
        
        checkbox.selected = YES;
     
    }
}





-(IBAction)PrivacyButton:(id)sender
{
    

    
    
    
    
    PrivactTermsViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivactTermsViewController"];
    profileVC.passString = @"Privacy Policy";
    [self.navigationController pushViewController:profileVC animated:true];
}
-(IBAction)termsButton:(id)sender
{
    
    
    
    
    
    
    PrivactTermsViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivactTermsViewController"];
      profileVC.passString = @"Terms & Conditions";
    [self.navigationController pushViewController:profileVC animated:true];
}


-(IBAction)RightButton:(id)sender
{
    
    if (RightButton.selected)
    {
        
        RightButton.selected = NO;
        
        ((UITextField*)[_signFields objectAtIndex:6]).secureTextEntry = YES;
        
        
        if (((UITextField*)[_signFields objectAtIndex:6]).isFirstResponder) {
            [((UITextField*)[_signFields objectAtIndex:6]) resignFirstResponder];
            [((UITextField*)[_signFields objectAtIndex:6]) becomeFirstResponder];
        }
    }
    else
    {
        
        RightButton.selected = YES;
        
        ((UITextField*)[_signFields objectAtIndex:6]).secureTextEntry = NO;
        
        if (((UITextField*)[_signFields objectAtIndex:6]).isFirstResponder) {
            [((UITextField*)[_signFields objectAtIndex:6]) resignFirstResponder];
            [((UITextField*)[_signFields objectAtIndex:6]) becomeFirstResponder];
            
        }
        
    }
}


- (void)parseJSON {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    _dataRows = (NSArray *)parsedObject;
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    UIAlertView * alert;
      [self.navigationController setNavigationBarHidden:true];


    if ([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                              delegate:self
                                     cancelButtonTitle:@"Settings"
                                     otherButtonTitles:@"Cancel", nil];
            [alert show];
        }else{
            [self.locationManager startUpdatingLocation];
        }
    }else{
        
        alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled!"
                                           message:@"Location Based Services are required however, we promise to keep your location private!"
                                          delegate:self
                                 cancelButtonTitle:@"Settings"
                                 otherButtonTitles:@"Cancel", nil];
        
        
        
        [alert show];
    }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0)
    {
        
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }
    
}
#pragma mark - Location Manager

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
    coordinate = newLocation.coordinate;
    
    currentLatitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    currentLongitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
}


-(IBAction)countrySingleLogTap:(UIButton *)gesture
{
    CountryListViewController *cv = [[CountryListViewController alloc] initWithNibName:@"CountryListViewController" delegate:self];
    [self presentViewController:cv animated:YES completion:NULL];
}




- (IBAction)signupAction:(id)sender
{
    if ([self validateSignUpData])
    {
        NSString  *newToken = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceTokenRegister"] description];
        newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
        
        NSString *mobileString;
        mobileString = [[_signFields[3] text]  stringByAppendingString:[_signFields[4] text]];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        
        
        
        
        [params setObject:[_signFields[5] text] forKey:@"email"];
        [params setObject:mobileString forKey:@"number"];
        
        
        newUser = [[PGUser alloc]init];
        
        [newUser registerUserWithDetails:params WithCompletion:^(BOOL success, id result, NSError *error)
         {
             if (success)
             {
                 
                 if (currentLatitude == nil) {
                     currentLatitude = @"";
                     currentLongitude = @"";
                 }
                 
                 
                 
                 
                 [params setObject:[_signFields[0] text] forKey:@"fname"];
                 [params setObject:[_signFields[1] text] forKey:@"lname"];
                 [params setObject:[_signFields[6] text] forKey:@"password"];
                 [params setObject:currentLatitude forKey:@"latitude"];
                 [params setObject:currentLongitude forKey:@"longitude"];
                 [params setObject:[_signFields[2] text] forKey:@"country"];
                 
                 
                 
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 PGVerificationTableViewController *verificationTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PGVerificationTableViewController"];
                 verificationTableVC.passDict = params;
                 [self.navigationController pushViewController:verificationTableVC animated:true];
             }
             else
             {
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                            handler:nil];
                 [alertController addAction:ok];
                 [self presentViewController:alertController animated:YES completion:nil];
             }
         }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}



- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        cell = (UITableViewCell *) textField.superview.superview;
        
    } else {
        // Load resources for iOS 7 or later
        cell = (UITableViewCell *) textField.superview.superview.superview;
        // TextField -> UITableVieCellContentView -> (in iOS 7!)ScrollView -> Cell!
    }
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}



-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        CGPoint buttonPosition = [textField convertPoint:CGPointZero
                                                  toView: self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
    }
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= MAX_LENGTH;
}

- (void)didSelectCountry:(NSDictionary *)country
{
  
    [_signFields[2] setText:[country valueForKey:@"name"]];
    [_signFields[3] setText:[country valueForKey:@"dial_code"]];
}

- (BOOL)validateEmailWithString:(NSString*)emailString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

- (BOOL)validationMobileNumber:(NSString*)number
{
    if  ([number length]<6)
    {
        return NO;
    }
    else if ([number length]<10)
    {
        return YES;
    }
    NSString *numberRegEx = @"[0-9]{12}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return YES;
    else
        return YES;
}
- (BOOL)validatecountrycode:(NSString *)number
{
    if ([[number substringToIndex:1] isEqualToString:@"+"])
        return YES;
    else
        return NO;
}

- (BOOL)validateSignUpData
{
    BOOL flag=YES;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *message=@"";
    NSString *filtered = [[[_signFields[0] text] componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    NSString *filtered1 = [[[_signFields[1] text] componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if ([[_signFields[0] text] length] == 0)
    {
        message = @"Please enter a valid first name";
        flag = NO;
    }
    
    
    else if(![[_signFields[0] text] isEqualToString:filtered] )
    {
        message = @"Please enter a valid first name";
        flag = NO;
    }
    else if([[_signFields[1] text] length] == 0)
    {
        message = @"Please enter a valid last name";
        flag = NO;
    }
    else if(![[_signFields[1] text] isEqualToString:filtered1] )
    {
        message = @"Please enter a valid last name";
        flag = NO;
    }
    
    else if ([[_signFields[3] text] length] == 0||[self validatecountrycode:[_signFields[3] text]] == NO)
    {
        message=@"Please enter a vaild country code";
        flag=NO;
    }
    else if ([[_signFields[4] text] length] == 0||[self validationMobileNumber:[_signFields[4] text]] == NO)
    {
        message=@"Please enter a vaild mobile number";
        flag=NO;
    }
    else if ([[_signFields[5] text] length] == 0 || ![self validateEmailWithString:[_signFields[5] text]])
    {
        message=@"Please input a valid email";
        flag=NO;
    }
    
    else if ([[_signFields[6] text] length] == 0)
    {
        message=@"Please input a valid password";
        flag=NO;
    }
    else if ( currentLatitude == nil ||currentLongitude == nil )
    {
        message=@"Location Based Services are required however, we promise to keep your location private!";
        flag=NO;
        
    }
    else if (![checkbox.currentImage isEqual:[UIImage imageNamed:@"selectedcheckbox"]])
    {
        message=@"Please read and agree to our privacy policy. Terms & Conditions apply.";
        flag=NO;
        
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


@end
