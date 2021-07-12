//
//  PGProfileTableViewController.h
//  Ping
//
//  Created by Monish M S on 02/01/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGServiceManager.h"
#import "PGFriends.h"

#import "ReportViewController.h"

@interface PGProfileTableViewController : UITableViewController<ChildViewControllerDelegate>
{
    
    IBOutlet UIButton *btnProfile;
    BOOL blocked;
}
@property (weak, nonatomic) NSDictionary * passString;
@property (nonatomic, strong) IBOutlet UIView *noChatimageView;

@property (nonatomic, strong) IBOutlet UIView *ChatView;


@end
