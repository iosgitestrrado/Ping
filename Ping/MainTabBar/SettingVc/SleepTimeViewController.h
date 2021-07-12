//
//  SleepTimeViewController.h
//  Ping
//
//  Created by Monish M S on 25/06/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGUser.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import "AppDelegate.h"


@interface SleepTimeViewController : UIViewController
{
    
    
    IBOutlet UIDatePicker *myPickerViewStart;
    IBOutlet UIView *blurView;
    PGUser *newUser;
    IBOutlet UIDatePicker *myPickerViewEnd;
    NSDate *dateStart;
    NSDate *dateEnd;
}


@end
