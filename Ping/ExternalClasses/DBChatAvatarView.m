//
//  DBChatAvatarView.m
//
//  Copyright (c) 2015 Diana Belogrivaya. All rights reserved.
//

#import "DBChatAvatarView.h"


static const NSInteger kMaxVisibleAvatar = 4;

@interface DBChatAvatarView ()

@property (assign, nonatomic) NSInteger totalCount;


@property (strong, nonatomic) NSArray *avatarViews;

@end

@implementation DBChatAvatarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    self.backgroundColor = [UIColor clearColor];
    
    self.avatarViews = @[];
    for (int i = 0; i < 4; i++) {
        UIImageView *avatarView = [[UIImageView alloc] init];
        avatarView.contentMode = UIViewContentModeScaleAspectFill;
        [avatarView setClipsToBounds:YES];
        [self addSubview:avatarView];
        self.avatarViews = [self.avatarViews arrayByAddingObject:avatarView];
    }
    
    
    [self reset];
}

- (void)reset {
    self.totalCount = 0;
    
    for (UIImageView *avatarView in self.avatarViews) {
        [avatarView isHidden];
    }
    
  
}
   
- (void)reloadAvatars {
    [self reset];
    
    NSInteger usersCount = [self.chatAvatarDataSource numberOfUsersInChatAvatarView:self];
    self.totalCount = MIN(kMaxVisibleAvatar, usersCount);
    
    if (self.totalCount > 0) {
        CGFloat width = 0;
        
        CGFloat width1 = 0;
        CGSize size = self.frame.size;
         self.layer.masksToBounds = true;
        self.layer.cornerRadius = self.frame.size.height/2;
        
      
        
        if (self.totalCount == 2) {
             width = floorf(size.width);
             CGFloat kPadding = 1.f;
            
            [self updateAvatarViewAtIndex:0 withFrame:CGRectMake(0, 0, width/2 - kPadding, width)];
            [self updateAvatarViewAtIndex:1 withFrame:CGRectMake(width/2 + kPadding, 0, width/2 - kPadding, width)];
            return;
        }
        
      else if (self.totalCount == 3) {
           
             CGFloat kPadding = 1.f;
              width = floorf(size.width * 0.5) - kPadding * 2;
           
           width1 = floorf(size.width);
           [self updateAvatarViewAtIndex:0 withFrame:CGRectMake(0, 0, width1/2 - kPadding, width1)];
      
            
            [self updateAvatarViewAtIndex:1 withFrame:CGRectMake((size.width - width), kPadding, width, width)];
            [self updateAvatarViewAtIndex:2 withFrame:CGRectMake((size.width - width), (size.height - width), width, width)];
            
            
            
            return;
        }
        
          
        
        CGFloat kPadding = 1.f;
        width = floorf(size.width * 0.5) - kPadding * 2;
        
        
        [self updateAvatarViewAtIndex:0 withFrame:CGRectMake(kPadding, kPadding, width, width)];
        
        [self updateAvatarViewAtIndex:1 withFrame:CGRectMake(kPadding, (size.height - width), width, width)];
        
            [self updateAvatarViewAtIndex:2 withFrame:CGRectMake((size.width - width), kPadding, width, width)];
        [self updateAvatarViewAtIndex:3 withFrame:CGRectMake((size.width - width), (size.height - width), width, width)];
        
        
        
        
        
    }
}


- (void)updateAvatarViewAtIndex:(NSInteger)index withFrame:(CGRect)frame {
    UIImageView *avatarView = self.avatarViews[index];
    avatarView.hidden = NO;
   
    [self bringSubviewToFront:avatarView];
    
    avatarView.frame = frame;
    NSURL *url = [NSURL URLWithString:[self.chatAvatarDataSource imageForAvatarAtIndex:index inChatAvatarView:self]];
   // [avatarView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserProfile"] options:SDWebImageRefreshCached];
    [avatarView sd_setImageWithURL:url
                              placeholderImage:nil
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         if (error) {
                                             
                                             avatarView.image = [UIImage imageNamed:@"UserProfile"];
                                         }
                                     }];
    
    
}

@end
