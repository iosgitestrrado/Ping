//
//  PGEditProfileTableViewController.m
//  Ping
//
//  Created by Monish M S on 03/01/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "PGEditProfileTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PGUser.h"
#import <FVCustomAlertView/FVCustomAlertView.h>

@interface PGEditProfileTableViewController () <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *picker ;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *editProfileImgView;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *editFields;

@end

@implementation PGEditProfileTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Edit Profile";}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *urlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.editProfileImgView sd_setImageWithURL:url
                              placeholderImage:nil
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         if (error) {
                                             
                                             self.editProfileImgView.image = [UIImage imageNamed:@"UserProfile"];
                                         }
                                     }];
    
    
    
    
    
  //  [self.editProfileImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserProfile"] options:SDWebImageRefreshCached];
    [self.editFields[0] setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"fname"]];
    [self.editFields[1] setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"lname"]];
    [self.editFields[2] setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"ping_status"]];
    [self.editFields[3] setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"number"]];
    [self.editFields[4] setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.editFields[2]) {
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 100;
        
    }
    return YES;
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editProfileImgAction:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"PING" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
      
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Open Camera" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
        }
        else
        {
            picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose from gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        
        
        
        [self presentViewController:picker animated:YES completion:NULL];
    }]];
    
    
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    int value = (int)self.tabBarController.selectedIndex;
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:value+1 forKey:@"HighScore"];
    [picker dismissViewControllerAnimated:false completion:^(){
        //  NSLog(@"selected index %lu",self.tabBarController.selectedIndex);
    }];
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.2);
    NSDictionary *parameters = @{@"user_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]};
    
    [PGUser updateProfilePicWithDetails:parameters imageData:imageData WithCompletion:^(BOOL success, id result, NSError *error)
     {
         //self.editProfileImgView.image = chosenImage;
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             self.editProfileImgView.image = chosenImage;
             
         }
         else
         {
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                        handler:nil];
             [alertController addAction:ok];
             [self presentViewController:alertController animated:YES completion:nil];
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
         }
     }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    NSLog(@"selected index %lu",self.tabBarController.selectedIndex);
    
    
    int value = (int)self.tabBarController.selectedIndex;
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:value+1 forKey:@"HighScore"];
    
    
    
    [picker dismissViewControllerAnimated:false completion:^(){
        
        
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGFloat screenHeight = screenRect.size.height - 274;
    
    
    
    
    
    return screenHeight/6;
    
    
}





- (IBAction)updateAction:(id)sender
{
    if ([self validateSignUpData])
    {
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        
        [params setObject:[self.editFields[0] text] forKey:@"fname"];
        [params setObject:[self.editFields[1] text] forKey:@"lname"];
        [params setObject:[self.editFields[2] text] forKey:@"ping_status"];
        [params setObject:[self.editFields[4] text] forKey:@"email"];
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
        
        [PGUser updateProfileWithDetails:params WithCompletion:^(BOOL success, id result, NSError *error)
         {
             if (success)
             {
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Profile updated successfully." preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action){
                                                                //Do Some action here
                                                                [self.navigationController popViewControllerAnimated:false];
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
    }
}

- (BOOL)validateSignUpData
{
    BOOL flag=YES;
    
    NSString *message=@"";
    
    if ([[self.editFields[0] text] length] == 0)
    {
        message = @"Please enter a valid first name";
        flag = NO;
    }
    else if([[self.editFields[1] text] length] == 0)
    {
        message = @"Please enter a valid last name";
        flag = NO;
    }
    
    else if ([[self.editFields[4] text] length] == 0 || ![self validateEmailWithString:[self.editFields[4] text]])
    {
        message=@"Please input a valid email";
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

- (BOOL)validateEmailWithString:(NSString*)emailString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

@end
