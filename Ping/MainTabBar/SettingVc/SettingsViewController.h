//
//  SettingsViewController.h
//  Ping
//
//  Created by Monish M S on 08/06/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGUser.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
@import GoogleSignIn;
#import <GTLRCalendar.h>


@interface SettingsViewController : UITableViewController <GIDSignInDelegate, GIDSignInUIDelegate>
{
    PGUser *newUser;
    NSMutableArray *tempdata;
    
}

@property (nonatomic, strong) GTLRCalendarService *service;

@end
