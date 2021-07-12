//
//  PGPingOutMeetingTableViewCell.m
//  Ping
//
//  Created by Monish M S on 04/01/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "PGPingOutMeetingTableViewCell.h"

@implementation PGPingOutMeetingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.memberOverCount.hidden = YES;
     self.memberOverCountLbl.hidden = YES;
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

- (void)setMeetingPingoutByCall:(NSArray *)chat {
    stringArray = chat;
    self.memberOverCountLbl.hidden = YES;
    self.memberOverCount.hidden = YES;
    
    
    if (stringArray.count>4) {
        
        self.memberOverCount.hidden = NO;
        self.memberOverCountLbl.hidden = NO;
        
        self.memberOverCountLbl.text = [NSString stringWithFormat:@"+ %lu",stringArray.count-4];
    }else{
        self.memberOverCountLbl.hidden = YES;
        self.memberOverCount.hidden = YES;
    }
    
    [self.vwAvatarView reloadAvatars];
}
#pragma mark - DBChatAvatarViewDataSource

- (NSInteger)numberOfUsersInChatAvatarView:(DBChatAvatarView *)chatAvatarView {
    return stringArray.count;
}


- (NSString *)imageForAvatarAtIndex:(NSInteger)avatarIndex inChatAvatarView:(DBChatAvatarView *)chatAvatarView {
    
    
    
    
     return  stringArray[avatarIndex]  ;
}

@end
