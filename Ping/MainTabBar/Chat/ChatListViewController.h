//
//  ChatListViewController.h
//  Ping
//
//  Created by Monish M S on 19/03/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGProfileTableViewController.h"
#import "DemoMessagesViewController.h"
#import "NotificationViewController.h"
@interface ChatListViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIView *noChatimageView;
@property (weak, nonatomic) IBOutlet UITableView *chatsTableVIew;
@end
