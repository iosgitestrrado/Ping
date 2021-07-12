//
//  PGForgotPasswordTableViewController.h
//  Ping
//
//  Created by Monish M S on 12/03/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGUser.h"
#import <FVCustomAlertView/FVCustomAlertView.h>

@interface PGForgotPasswordTableViewController : UITableViewController{
     PGUser *newUser;
}
@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@end
