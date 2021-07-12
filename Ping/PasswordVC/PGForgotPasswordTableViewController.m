//
//  PGForgotPasswordTableViewController.m
//  Ping
//
//  Created by Monish M S on 12/03/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "PGForgotPasswordTableViewController.h"

@interface PGForgotPasswordTableViewController ()

@end

@implementation PGForgotPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBg"]];

    
    UITapGestureRecognizer *singleLogTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleLogTap:)];
    [self.view addGestureRecognizer:singleLogTap];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void)handleSingleLogTap:(UITapGestureRecognizer *)recognizer
{
    [self.emailTxtField resignFirstResponder];
    
}

- (IBAction)Back
{
    [self.navigationController popViewControllerAnimated  :YES]; 
}

- (IBAction)loginAction:(id)sender
{
    @try {
        
        if (_emailTxtField.text.length>0) {
            if ([self validateEmailWithString:_emailTxtField.text])
            {
                 [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
                
                NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                
                [params setObject:_emailTxtField.text forKey:@"email"];
              
              
                newUser = [[PGUser alloc]init];
                
                
              [newUser forgotPasswordWithemail:params withCompletionBlock:^(BOOL success, id result, NSError *error)
                
                
              
                 {
                     if (success)
                     {
                         
                          [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                         
                         
                         
                         
                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] preferredStyle:UIAlertControllerStyleAlert];
                         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * action)
                         {
                           [self.navigationController popViewControllerAnimated:YES];
                         }];
                         [alertController addAction:ok];
                         [self presentViewController:alertController animated:YES completion:nil];
                         
                        
                         
                         
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
                
                
                
                
                
                
                
                
                
                
                
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Please enter a valid email address." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Please enter your email." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        
        
        
       
            
    } @catch (NSException *exception) {
        NSLog(@"NSException login page-------%@",exception);
    } @finally {
        
    }
    
    
    
}
- (BOOL)validateEmailWithString:(NSString*)emailString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}
            




@end
