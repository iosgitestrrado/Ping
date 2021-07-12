//
//  ChatlistTableViewCell.h
//  Ping
//
//  Created by Monish M S on 19/03/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBChatAvatarView.h"
@interface ChatlistTableViewCell : UITableViewCell<DBChatAvatarViewDataSource>{
    NSArray *stringArray;
}
@property (nonatomic, strong) IBOutlet UILabel *chatUserName;
@property (nonatomic, strong) IBOutlet UILabel *chatCount;
@property (nonatomic, strong) IBOutlet UIImageView *chatImage;
@property (weak, nonatomic) IBOutlet DBChatAvatarView *vwAvatarView;
@property (weak, nonatomic) IBOutlet UIView *memberOverCount;
@property (weak, nonatomic) IBOutlet UILabel *memberOverCountLbl;
- (void)setChatByCall:(NSArray *)chat;
@end
