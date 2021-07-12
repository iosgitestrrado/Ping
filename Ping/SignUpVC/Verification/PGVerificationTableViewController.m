//
//  PGVerificationTableViewController.m
//  Ping
//
//  Created by Monish M S on 11/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGVerificationTableViewController.h"
#import "PGUser.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import "PGAddFriendsViewController.h"

@interface PGVerificationTableViewController ()
{
    PGUser *newUser;
   
}
@property (weak, nonatomic) IBOutlet UITextField *codeField;

@end

@implementation PGVerificationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBg"]];
    

    UITapGestureRecognizer *singleLogTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleLogTap:)];
    [self.view addGestureRecognizer:singleLogTap];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true];

}

- (void)handleSingleLogTap:(UITapGestureRecognizer *)recognizer
{
    [self.codeField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}


- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)goAction:(id)sender
{
  //
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    [self.view setUserInteractionEnabled:false];
   NSMutableDictionary *params = [[NSMutableDictionary alloc]init];

   [params setObject:self.codeField.text forKey:@"otp"];
 

    [params setObject:[_passDict objectForKey:@"number"] forKey:@"number"];
    [params setObject:[_passDict objectForKey:@"email"] forKey:@"email"];
    [params setObject:[_passDict objectForKey:@"fname"] forKey:@"fname"];
    [params setObject:[_passDict objectForKey:@"lname"] forKey:@"lname"];
    [params setObject:[_passDict objectForKey:@"password"] forKey:@"password"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"] forKey:@"deviceToken"];
    [params setObject:[_passDict objectForKey:@"latitude"] forKey:@"latitude"];
    [params setObject:[_passDict objectForKey:@"longitude"] forKey:@"longitude"];
    [params setObject:@"" forKey:@"avthar"];
    [params setObject:[_passDict objectForKey:@"country"] forKey:@"country"];
    
    
    
    
   newUser = [[PGUser alloc]init];
   [newUser verificationWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
   {
       if (success)
       {
          [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
           
            [[NSUserDefaults standardUserDefaults] setObject:[_passDict objectForKey:@"password"] forKey:@"Password"];
           
           NSDictionary *dict123 = [[result valueForKey:@"sleepingTime"] mutableCopy];
           NSDictionary *userDes = [result valueForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:[userDes objectForKey:@"accessToken"]  forKey:@"accessToken"];
           
           if (dict123!=nil) {
               
               
               
               
               
               [[NSUserDefaults standardUserDefaults] setObject:[dict123 objectForKey:@"sleepStart"] forKey:@"sleepStart"];
               [[NSUserDefaults standardUserDefaults] setObject:[dict123 objectForKey:@"sleepEnd"] forKey:@"sleepEnd"];
           }else{
               
               
               
               
               
               [[NSUserDefaults standardUserDefaults] setObject:@"22:00" forKey:@"sleepStart"];
               [[NSUserDefaults standardUserDefaults] setObject:@"08:00" forKey:@"sleepEnd"];
           }
           
           [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"HOMETUTORIAL"];
           [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"CHATTUTORIAL"];
           [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"PINGOUTTUTORIAL"];
           [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"NEARMETUTORIAL"];
           
           
           
           
           PGAddFriendsViewController *addFriendsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PGAddFriendsViewController"];
           
            addFriendsVC.otp = @"otp";
           [self.navigationController pushViewController:addFriendsVC animated:true];
       }
       else
       {
           [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
           UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self.view setUserInteractionEnabled:true];
                                                      }];
           [alertController addAction:ok];
           [self presentViewController:alertController animated:YES completion:nil];
       }
   }];
}

@end
