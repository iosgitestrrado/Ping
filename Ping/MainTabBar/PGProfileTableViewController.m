//
//  PGProfileTableViewController.m
//  Ping
//
//  Created by Monish M S on 02/01/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "PGProfileTableViewController.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import "PGUser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PGEditProfileTableViewController.h"
#import "DemoMessagesViewController.h"
#import "ReportViewController.h"





@interface PGProfileTableViewController ()
{
    NSMutableArray *arrayProfile;
}
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editButtonHeight;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextField *mailField;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@property (weak, nonatomic) IBOutlet UIStackView *pingStack;



@end

@implementation PGProfileTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    if (_passString.count>0) {
        self.title = @" Friend's Profile";
        
        UIImage *image = [UIImage imageNamed:@"white_flag"];
        
        btnProfile = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnProfile setFrame:CGRectMake(0, 0, 30, 30)];
        [btnProfile addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnProfile setBackgroundImage:image forState:UIControlStateNormal];
        
        UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:btnProfile];
        self.navigationItem.rightBarButtonItem = navLeftButton;
        
         if ([[NSString stringWithFormat:@"%@",[_passString objectForKey:@"reported"]] isEqualToString:@"1"]) {
        UIImage *image = [UIImage imageNamed:@"red_flag"];
        [btnProfile setBackgroundImage:image forState:UIControlStateNormal];
         }
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"ping+"]) {



            _pingStack.hidden = NO;
            if ([[NSString stringWithFormat:@"%@",[_passString objectForKey:@"is_friend"]] isEqualToString:@"0"]) {

                [_addFriendButton setImage:[UIImage imageNamed:@"add_f"] forState:UIControlStateNormal];
            }else{

                 if ([[NSString stringWithFormat:@"%@",[_passString objectForKey:@"blocked"]] isEqualToString:@"1"]) {
               _ChatView.hidden = TRUE;
                     blocked= YES;
                      [_addFriendButton setImage:[UIImage imageNamed:@"f"] forState:UIControlStateNormal];
                 }else{
                     [_addFriendButton setImage:[UIImage imageNamed:@"ref"] forState:UIControlStateNormal];
                     blocked= false;
                _ChatView.hidden = false;
                 }



            }
            _editButtonHeight.constant= 30;
        } else {
            _pingStack.hidden = YES;
            _editButtonHeight.constant= 0;
        }
        _editButton.hidden = YES;
        
         btnProfile.hidden = false;
    }else{
        self.title = @"Profile";
        _editButton.hidden = NO;
        _editButtonHeight.constant= 30;
        _pingStack.hidden = YES;
         btnProfile.hidden = true;
    }
  
    arrayProfile = [NSMutableArray new];
}


- (IBAction)reportAction:(id)sender
{
    
    [self performSegueWithIdentifier:@"showReport" sender:self];
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showReport"]){
      ReportViewController *vc = [segue destinationViewController];
        vc.passString = _passString;
        vc.delegate = self;
        
        
        
    }
    
}






-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = true;
    
    
    if (_passString.count>0) {
        NSString *urlString = [_passString valueForKey:@"avthar"];
        NSURL *url = [NSURL URLWithString:urlString];
        [self.profilePicImgView sd_setImageWithURL:url
                                  placeholderImage:nil
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             if (error) {
                                                 
                                                 self.profilePicImgView.image = [UIImage imageNamed:@"UserProfile"];
                                             }
                                         }];
        
        
      //  [self.profilePicImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserProfile"] options:SDWebImageRefreshCached];
        [self.numberField setText:[_passString valueForKey:@"number"]];
        [self.mailField setText:[_passString valueForKey:@"email"]];
        NSString *fullName = [NSString stringWithFormat:@"%@",[_passString valueForKey:@"name"]];
        self.nameLabel.text = fullName;
        self.statusLabel.text = [_passString valueForKey:@"ping_status"];
        
        [self HEIGHTCHANGE:[_passString valueForKey:@"ping_status"]];

    }else{
        NSString *urlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"];
        NSURL *url = [NSURL URLWithString:urlString];
        
        [self.profilePicImgView sd_setImageWithURL:url
                                  placeholderImage:nil
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             if (error) {
                                                 
                                                 self.profilePicImgView.image = [UIImage imageNamed:@"UserProfile"];
                                             }
                                         }];
        
        
        
        
       // [self.profilePicImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserProfile"] options:SDWebImageRefreshCached];
        [self.numberField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"number"]];
        [self.mailField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]];
        NSString *fullName = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"fname"],[[NSUserDefaults standardUserDefaults] objectForKey:@"lname"]];
        self.nameLabel.text = fullName;
        self.statusLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"ping_status"];
        
        [self HEIGHTCHANGE:[[NSUserDefaults standardUserDefaults] objectForKey:@"ping_status"]];
    }
    
    
}

-(void)HEIGHTCHANGE:(NSString *)str{
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:str
                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.frame.size.width-40, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    
    CGFloat labelHeight = size.height;
    
    
    if (labelHeight>20) {
        
        if (labelHeight>60) {
            CGRect newFrame = CGRectMake( _noChatimageView.frame.origin.x, _noChatimageView.frame.origin.y, _noChatimageView.frame.size.width, 200 + 60);
            
            self.noChatimageView.frame = newFrame;
        }else{
        CGRect newFrame = CGRectMake( _noChatimageView.frame.origin.x, _noChatimageView.frame.origin.y, _noChatimageView.frame.size.width, 200 + labelHeight);
        
        self.noChatimageView.frame = newFrame;
    }
    }else{
        
        CGRect newFrame = CGRectMake( _noChatimageView.frame.origin.x, _noChatimageView.frame.origin.y, _noChatimageView.frame.size.width, 210);
        
        self.noChatimageView.frame = newFrame;
    }
    
    [self.tableView reloadData];
}


- (IBAction)editAction:(id)sender
{
    PGEditProfileTableViewController *editProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PGEditProfileTableViewController"];
    //editProfileVC.arrayProileDetails = arrayProfile;
    [self.navigationController pushViewController:editProfileVC animated:true];
}

- (IBAction)chatAction:(id)sender
{
    DemoMessagesViewController *vc = [DemoMessagesViewController messagesViewController];
    
vc.chatIdVc = [NSString stringWithFormat:@"%@",[_passString valueForKey:@"chat_id"]];
    
    
    vc.titleName = [NSString stringWithFormat:@"%@",[_passString valueForKey:@"name"]];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)addFriendAction:(id)sender
{
    if ([[NSString stringWithFormat:@"%@",[_passString objectForKey:@"is_friend"]] isEqualToString:@"0"]) {
        
        
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
        
        NSMutableArray *arrayAddFriends = [NSMutableArray new];
        
        
        
        
        NSDictionary* dictNum = @{@"number": [_passString valueForKey:@"number"]};
        [arrayAddFriends addObject:dictNum];
        
        
        NSError *error;
        NSData *jsonDataAddFriends = [NSJSONSerialization dataWithJSONObject:arrayAddFriends
                                                                     options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonStringAddFriends = [[NSString alloc] initWithData:jsonDataAddFriends encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
        [params setObject:jsonStringAddFriends forKey:@"friends"];
        
        [PGFriends addFriendsWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
         {
            
             
             if (success)
             {
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Friends Requested Successfully." preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                dispatch_async(dispatch_get_main_queue(), ^(void)
                                                                               {
                                                                                   
                                                                               });
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
        
        if (!blocked) {
        
        
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Block User"
                                     message:@"Are you sure you want to Block this user?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                        [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
                                        
                                      
                                        
                                        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                                        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
                                        [params setObject:[_passString valueForKey:@"number"] forKey:@"friendNumber"];
                                        
                                        [PGFriends blockFriendsWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
                                         {
                                             
                                             
                                             if (success)
                                             {
                                                 
                                                 
                                                 _ChatView.hidden = TRUE;
                                                 [_addFriendButton setImage:[UIImage imageNamed:@"f"] forState:UIControlStateNormal];
                                                 blocked = TRUE;
                                                 [self.tableView reloadData];
                                                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                                                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Friend Blocked Successfully." preferredStyle:UIAlertControllerStyleAlert];
                                                 UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                                                dispatch_async(dispatch_get_main_queue(), ^(void)
                                                                                                               {
                                                                                                               
                                                                                                               });
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
                                        
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"NO"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                    
                                       
                                       
                                   }];
        
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        }else{
            
            
            
           
                
                
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"Unblock User"
                                             message:@"Are you sure you want to Unblock this user?"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                //Add Buttons
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"Yes"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                
                                                [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
                                                
                                                
                                                
                                                NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                                                [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
                                                [params setObject:[_passString valueForKey:@"number"] forKey:@"friendNumber"];
                                                
                                                [PGFriends unBlockFriendsWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
                                                 {
                                                     
                                                     
                                                     if (success)
                                                     {
                                                         
                                                         [_addFriendButton setImage:[UIImage imageNamed:@"ref"] forState:UIControlStateNormal];
                                                         
                                                         _ChatView.hidden = false;
                                                         blocked = false;
                                                         [self.tableView reloadData];
                                                         [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Friend Unblocked Successfully." preferredStyle:UIAlertControllerStyleAlert];
                                                         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                                                                        dispatch_async(dispatch_get_main_queue(), ^(void)
                                                                                                                       {
                                                                                                                  
                                                                                                                       });
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
                                                
                                                
                                            }];
                
                UIAlertAction* noButton = [UIAlertAction
                                           actionWithTitle:@"NO"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {
                                               
                                               
                                               
                                               
                                           }];
                
                
                [alert addAction:yesButton];
                [alert addAction:noButton];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
       
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section      {
    if (_passString.count>0) {
        
         if (!blocked) {        return 2;
             
         }else{
             return 0;
             
         }
        
        
    }
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_passString.count>0) {
        return 60;}
    
    return 60;
    
    
}


- (IBAction)signOutAction:(id)sender
{
    
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"PING"
                                 message:@"Are you sure you want to Sign Out?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"YES"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self SignOUT];
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    

    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
   
    
    
    
    
}

- (void)childViewControllerFlagChange{
    
    UIImage *image = [UIImage imageNamed:@"red_flag"];
      [btnProfile setBackgroundImage:image forState:UIControlStateNormal];
    
}









-(void)SignOUT {
    
    
    
    
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    
    
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    
    [param setObject:@"0" forKey:@"is_online"];
    
    
    [[PGServiceManager sharedManager] postDataFromService:@"user/online" withParameters:param withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         
         
     }];
    
    
    
    
    
    
    
    
    
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    
    [PGUser logOutUserWithDetails:params WithCompletion:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             
             if([[NSUserDefaults standardUserDefaults] boolForKey:@"ping+"]) {
                 [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
                     NSLog(@"error = %@", error.localizedDescription);
                 }];
             }
             NSString *str =   [[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"];
             
             
             
             
             
             
             
             NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
             NSDictionary * dict = [defs dictionaryRepresentation];
             for (id key in dict) {
                 [defs removeObjectForKey:key];
             }
             [defs synchronize];
             
             NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
             [defaults setValue:str forKey:@"device_token"];
             
             UINavigationController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainLogNav"];
             [UIApplication sharedApplication].keyWindow.rootViewController = homeVC;
             
         }
         else
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
         }
     }];
    
    
    
}

@end
