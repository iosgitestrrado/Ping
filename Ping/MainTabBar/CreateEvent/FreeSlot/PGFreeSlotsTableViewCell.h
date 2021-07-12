//
//  PGFreeSlotsTableViewCell.h
//  Ping
//
//  Created by Monish M S on 06/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBChatAvatarView.h"


@interface PGFreeSlotsTableViewCell : UITableViewCell<DBChatAvatarViewDataSource>
{
    NSArray *stringArray;
}

@property (weak, nonatomic) IBOutlet UIImageView *freeProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *freeTimeLAbel;
@property (weak, nonatomic) IBOutlet UILabel *freeDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapImg;
@property (weak, nonatomic) IBOutlet UIButton *pointBtn;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet DBChatAvatarView *vwAvatarView;
@property (weak, nonatomic) IBOutlet UIView *memberOverCount;
@property (weak, nonatomic) IBOutlet UILabel *memberOverCountLbl;
- (void)setCreateMeetingByCall:(NSArray *)chat;
@end
