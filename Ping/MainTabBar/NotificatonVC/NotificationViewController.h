//
//  NotificationViewController.h
//  Ping
//
//  Created by Softnotions Technologies Pvt Ltd on 2/7/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGNotification.h"
#import "AppDelegate.h"

@interface NotificationViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIView *noChatimageView;
@property (weak, nonatomic) IBOutlet UITableView *chatsTableVIew;
@end
