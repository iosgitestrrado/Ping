//
//  PGPingOutMeetingTableViewCell.h
//  Ping
//
//  Created by Monish M S on 04/01/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBChatAvatarView.h"
@interface PGPingOutMeetingTableViewCell : UITableViewCell<DBChatAvatarViewDataSource>
{
    NSArray *stringArray;
}

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBboBtn;
@property (weak, nonatomic) IBOutlet DBChatAvatarView *vwAvatarView;
@property (weak, nonatomic) IBOutlet UIView *memberOverCount;
@property (weak, nonatomic) IBOutlet UILabel *memberOverCountLbl;
- (void)setMeetingPingoutByCall:(NSArray *)chat;
@end
