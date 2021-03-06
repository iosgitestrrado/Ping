//
//  DBChatAvatarView.h
//
//  Copyright (c) 2015 Diana Belogrivaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>


@class DBChatAvatarView;

typedef NS_ENUM(NSInteger, DBChatAvatarState) {
    DBChatAvatarStateNone,
    DBChatAvatarStateOffline,
    DBChatAvatarStateOnline
};
  
@protocol DBChatAvatarViewDataSource <NSObject>

- (NSInteger)numberOfUsersInChatAvatarView:(DBChatAvatarView *)chatAvatarView;
- (DBChatAvatarState)stateForAvatarAtIndex:(NSInteger)avatarIndex inChatAvatarView:(DBChatAvatarView *)chatAvatarView;
- (NSString *)imageForAvatarAtIndex:(NSInteger)avatarIndex inChatAvatarView:(DBChatAvatarView *)chatAvatarView;

@end

@interface DBChatAvatarView : UIView

@property (weak, nonatomic) id <DBChatAvatarViewDataSource> chatAvatarDataSource;

- (void)reloadAvatars;
- (void)reset;

@end
