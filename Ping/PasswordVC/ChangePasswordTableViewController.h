//
//  ChangePasswordTableViewController.h
//  Ping
//
//  Created by Monish M S on 21/03/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FVCustomAlertView/FVCustomAlertView.h>
#import "PGProfile.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ChangePasswordTableViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UIView *noChatimageView;
@property (weak, nonatomic) IBOutlet UITextField * oldPasswordTxtField;
@property (weak, nonatomic) IBOutlet UITextField * passwordTxtField;
@property (weak, nonatomic) IBOutlet UITextField * confirmPasswordTxtField;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
