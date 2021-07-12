//
//  PGLoginTableViewController.m
//  Ping
//
//  Created by Monish M S on 25/11/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGLoginTableViewController.h"
#import "PGUser.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import "PGVerificationTableViewController.h"
#import "ContactList.h"

@interface PGLoginTableViewController () <UITextFieldDelegate>
{
    PGUser *newUser;
    NSInteger starvalue;
    IBOutlet UIButton *RightButton;
    
}
@property (strong, nonatomic) NSArray *dataRows;
@property (weak, nonatomic) IBOutlet UITextField *codeTxtField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTxtField;
@property (weak, nonatomic) IBOutlet UITextField *paswrdTxtField;

@end

@implementation PGLoginTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self parseJSON];
    [[ContactList sharedContacts] fetchAllContacts];
    [RightButton setImage:[UIImage imageNamed:@"iconEyesClose"] forState:UIControlStateNormal];
    
    [RightButton setImage:[UIImage imageNamed:@"iconEyesOpen"] forState:UIControlStateSelected];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBg"]];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSLog(@"countryCode: %@", countryCode);
    int i = 0;
    for (NSDictionary *item in _dataRows){
        
        
        
        if ([[item objectForKey:@"code"] isEqualToString:countryCode])
        {
            self.codeTxtField.text =[item objectForKey:@"dial_code"];
            starvalue = i;
        }
        i++;
    }
    
    
    
    
    
    
    UITapGestureRecognizer *singleLogTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleLogTap:)];
    [self.view addGestureRecognizer:singleLogTap];
    
    
}

-(IBAction)RightButton:(id)sender
{
    
    if (RightButton.selected)
    {
        
        RightButton.selected = NO;
        
        _paswrdTxtField.secureTextEntry = YES;
        
        
        if (_paswrdTxtField.isFirstResponder) {
            [_paswrdTxtField resignFirstResponder];
            [_paswrdTxtField becomeFirstResponder];
        }
    }
    else
    {
        
        RightButton.selected = YES;
        
        _paswrdTxtField.secureTextEntry = NO;
        
        if (_paswrdTxtField.isFirstResponder) {
            [_paswrdTxtField resignFirstResponder];
            [_paswrdTxtField becomeFirstResponder];
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








- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
    self.codeTxtField.text = [NSString stringWithFormat:@"%@",[[_dataRows objectAtIndex:row]objectForKey:@"dial_code"]];
    starvalue = row;
    
}
// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_dataRows count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [NSString stringWithFormat:@"%@      %@", [[_dataRows objectAtIndex: row]objectForKey:@"dial_code"],[[_dataRows objectAtIndex: row]objectForKey:@"name"]];
    
}

- (IBAction)forgotPasswordAction:(id)sender
{
    
    PGForgotPasswordTableViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PGForgotPasswordTableViewController"];
    [self.navigationController pushViewController:profileVC animated:true];
}

- (IBAction)codeAction:(id)sender
{
    
    
    
    categoryPickerView = [[UIPickerView alloc] init];
    
    [categoryPickerView setDataSource: self];
    [categoryPickerView setDelegate: self];
    categoryPickerView.showsSelectionIndicator = YES;
    
    [self.codeTxtField setInputView:categoryPickerView];
    [self.codeTxtField becomeFirstResponder];
    [categoryPickerView selectRow:starvalue inComponent:0 animated:YES];
    
}

- (void)handleSingleLogTap:(UITapGestureRecognizer *)recognizer
{
    [self.codeTxtField resignFirstResponder];
    [self.mobileTxtField resignFirstResponder];
    [self.paswrdTxtField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (IBAction)loginAction:(id)sender
{
    @try {
        if ([self validateSignUpData])
        {
            [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
            
            NSString *mobile = [self.codeTxtField.text  stringByAppendingString:self.mobileTxtField.text];
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:mobile forKey:@"number"];
            [params setObject:self.paswrdTxtField.text forKey:@"password"];
            [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"] forKey:@"deviceToken"];
            
            newUser = [[PGUser alloc]init];
            
            [newUser loginUserWithDetails:params WithCompletion:^(BOOL success, id result, NSError *error)
             {
                 if (success)
                 {
                     
                     [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                     
                     [[NSUserDefaults standardUserDefaults] setObject:_paswrdTxtField.text forKey:@"Password"];
                     
                     
                     if ([[[PGUser currentUser] active] isEqualToString:@"1"])
                     {
                         
                         
                         
                         [[NSUserDefaults standardUserDefaults]synchronize];
                         
                         dispatch_async(dispatch_get_main_queue(), ^(void)
                                        {
                                            NSDictionary *userDes = [result valueForKey:@"data"];
                                            
                                            
                                            
                                            if ([[NSString stringWithFormat:@"%@",[userDes objectForKey:@"p_plus"]] isEqualToString:@"0"]) {
                                                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ping+"];
                                            }else{
                                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ping+"];
                                                [[UIApplication sharedApplication] setAlternateIconName:@"Icon2" completionHandler:^(NSError * _Nullable error) {
                                                    NSLog(@"error = %@", error.localizedDescription);
                                                }];
                                                
                                            }
                                            
                                            
                                            [[NSUserDefaults standardUserDefaults] setObject:[userDes objectForKey:@"accessToken"] forKey:@"accessToken"];
                                            
                                            NSDictionary *dict123 = [[userDes valueForKey:@"sleepingTime"] mutableCopy];
                                            
                                            
                                            
                                            if (dict123!=nil) {
                                                
                                                
                                                
                                                
                                                
                                                [[NSUserDefaults standardUserDefaults] setObject:[dict123 objectForKey:@"sleepStart"] forKey:@"sleepStart"];
                                                [[NSUserDefaults standardUserDefaults] setObject:[dict123 objectForKey:@"sleepEnd"] forKey:@"sleepEnd"];
                                            }else{
                                                
                                                
                                                
                                                
                                                
                                                [[NSUserDefaults standardUserDefaults] setObject:@"22:00" forKey:@"sleepStart"];
                                                [[NSUserDefaults standardUserDefaults] setObject:@"08:00" forKey:@"sleepEnd"];
                                            }
                                            
                                            
                                            [self performSegueWithIdentifier:@"loginIdSegue" sender:self];
                                            
                                        });
                         
                     }
                     else
                     {
                         dispatch_async(dispatch_get_main_queue(), ^(void)
                                        {
                                            PGVerificationTableViewController *PIVerificationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PGVerificationTableViewController"];
                                            [self.navigationController pushViewController:PIVerificationVC animated:true];
                                        });
                     }
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
    } @catch (NSException *exception) {
        NSLog(@"NSException login page-------%@",exception);
    } @finally {
        
    }
    
}

- (BOOL)validateSignUpData
{
    BOOL flag=YES;
    
    NSString *message=@"";
    
    if ([self.mobileTxtField.text length]==0)
    {
        message = @"Please enter a valid mobile number";
        flag = NO;
    }
    else if ([self.codeTxtField.text length]==1 || [self.codeTxtField.text length]==0)
    {
        message = @"Please enter a valid country code";
        flag = NO;
    }
    else if([self.paswrdTxtField.text length]==0)
    {
        message = @"Please enter a valid password";
        flag = NO;
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
