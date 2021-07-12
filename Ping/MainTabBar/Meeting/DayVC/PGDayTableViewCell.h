//
//  PGDayTableViewCell.h
//  Ping
//
//  Created by Monish M S on 04/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBChatAvatarView.h"
@interface PGDayTableViewCell : UITableViewCell<DBChatAvatarViewDataSource>
{
    NSArray *stringArray;
}

@property (weak, nonatomic) IBOutlet UIImageView *profilePicImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapImg;
@property (weak, nonatomic) IBOutlet UIButton *mapPointerBtn;
@property (weak, nonatomic) IBOutlet DBChatAvatarView *vwAvatarView;
@property (weak, nonatomic) IBOutlet UIView *memberOverCount;
@property (weak, nonatomic) IBOutlet UILabel *memberOverCountLbl;
- (void)setMeetingByCall:(NSArray *)chat;
@end
