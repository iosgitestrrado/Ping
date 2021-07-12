//
//  PGDayTableViewCell.m
//  Ping
//
//  Created by Monish M S on 04/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGDayTableViewCell.h"

@implementation PGDayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.memberOverCount.hidden = YES;
    self.memberOverCountLbl.text = @"";
    self.vwAvatarView.chatAvatarDataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.vwAvatarView reset];
}

- (void)setMeetingByCall:(NSArray *)chat {
    stringArray = chat;
    self.memberOverCount.hidden = YES;
    if (stringArray.count>4) {
        
        self.memberOverCount.hidden = NO;
        
        
        self.memberOverCountLbl.text = [NSString stringWithFormat:@"+ %lu",stringArray.count-4];
    }
    
    [self.vwAvatarView reloadAvatars];
}
#pragma mark - DBChatAvatarViewDataSource

- (NSInteger)numberOfUsersInChatAvatarView:(DBChatAvatarView *)chatAvatarView {
    return stringArray.count;
}


- (NSString *)imageForAvatarAtIndex:(NSInteger)avatarIndex inChatAvatarView:(DBChatAvatarView *)chatAvatarView {
    
    
    
    
    return  [stringArray[avatarIndex] objectForKey:@"avthar"] ;
}
@end
