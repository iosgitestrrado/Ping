//
//  PGFriendsViewController.h
//  Ping
//
//  Created by Monish M S on 11/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGProfileTableViewController.h"
#import "NotificationViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIBarButtonItem+Badge.h"
#import "MPCoachMarks.h"

@interface PGFriendsViewController : UIViewController{
    
    NSInteger indexpath;
}
@property (weak, nonatomic) IBOutlet UISearchBar *addFriendsSearch;



@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;
@end
