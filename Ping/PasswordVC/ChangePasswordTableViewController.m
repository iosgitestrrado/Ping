//
//  ChangePasswordTableViewController.m
//  Ping
//
//  Created by Monish M S on 21/03/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "ChangePasswordTableViewController.h"


@interface ChangePasswordTableViewController ()

@end

@implementation ChangePasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       self.title = @"Change Password";
    
    NSString *urlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"];
    NSURL *url = [NSURL URLWithString:urlString];
//    [self.profilePicImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserProfile"] options:SDWebImageRefreshCached];
 
    [self.profilePicImgView sd_setImageWithURL:url
                    placeholderImage:nil
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (error) {
                                   
                                   self.profilePicImgView.image = [UIImage imageNamed:@"UserProfile"];
                               }
                           }];
    
    
    
    
    
    
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"fname"],[[NSUserDefaults standardUserDefaults] objectForKey:@"lname"]];
    self.nameLabel.text = fullName;
    self.statusLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"ping_status"];
    
    [self HEIGHTCHANGE:[[NSUserDefaults standardUserDefaults] objectForKey:@"ping_status"]];
    
    
    UITapGestureRecognizer *singleLogTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleLogTap:)];
    [self.view addGestureRecognizer:singleLogTap];
}



- (void)handleSingleLogTap:(UITapGestureRecognizer *)recognizer
{
    [self.oldPasswordTxtField resignFirstResponder];
     [self.passwordTxtField resignFirstResponder];
     [self.confirmPasswordTxtField resignFirstResponder];
}
-(void)HEIGHTCHANGE:(NSString *)str{
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:str
                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.frame.size.width-40, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    
    CGFloat labelHeight = size.height;
    
    
    if (labelHeight>20) {
        CGRect newFrame = CGRectMake( _noChatimageView.frame.origin.x, _noChatimageView.frame.origin.y, _noChatimageView.frame.size.width, 200 + labelHeight);
        
      //  self.noChatimageView.frame = newFrame;
    }else{
        
        CGRect newFrame = CGRectMake( _noChatimageView.frame.origin.x, _noChatimageView.frame.origin.y, _noChatimageView.frame.size.width, 210);
        
       // self.noChatimageView.frame = newFrame;
    }
    
    [self.tableView reloadData];
}


- (IBAction)changePasswordAction:(id)sender
{
    @try {
        
        if ([self validateSignUpData]) {
           
                [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
                
                NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                
                [params setObject:_passwordTxtField.text forKey:@"password"];
                [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
            
            
                
                
            [PGProfile changePasswordWithUserID:params withCompletionBlock:^(bool success, id result, NSError *error)
             {
                 if (success)
                 {
                   
                         
                         [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                         
                         
                         
                         
                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Password changed successfully." preferredStyle:UIAlertControllerStyleAlert];
                         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * action)
                                              {
                                                  [self dismmissView];
                                                
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
       
        
        
        
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"NSException login page-------%@",exception);
    } @finally {
        
    }
    
    
    
}


-(void)dismmissView{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:_passwordTxtField.text forKey:@"Password"];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (BOOL)validateSignUpData
{
    BOOL flag=YES;
    
    NSString *message=@"";
    
    if ([self.oldPasswordTxtField.text length]==0)
    {
        message = @"Please enter old password";
        flag = NO;
    }
    else if ( [self.passwordTxtField.text length]==0)
    {
        message = @"Please enter new password";
        flag = NO;
    }
    else if([self.confirmPasswordTxtField.text length]==0)
    {
        message = @"Please enter confirm password";
        flag = NO;
    }
    else if(![self.oldPasswordTxtField.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Password"]])
    {
        message = @"Please enter a valid oldpassword";
        flag = NO;
    }
    else if(self.confirmPasswordTxtField.text != self.passwordTxtField.text)
    {
        message = @"Password are not same";
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
