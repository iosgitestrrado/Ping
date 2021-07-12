//
//  MSEventCell.h
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSEvent.h"

#import "DBChatAvatarView.h"


typedef NS_ENUM(NSUInteger,MKCalendarEventColor) { // add more colors what you need
    MKCalendarEventColorBlue, // Default
    MKCalendarEventColorRed,
    MKCalendarEventColorGreen,
    MKCalendarEventColorPink,
    MKCalendarEventColorGrey,
     MKCalendarEventColorYellow, MKCalendarEventColorOrange
};

@class MSEvent;

@interface MSEventCell : UICollectionViewCell<DBChatAvatarViewDataSource>{
    NSArray *stringArray;
}

@property (nonatomic, strong) MSEvent *event;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *location;
@property (nonatomic, strong) UIView *memberOverCount;
@property (nonatomic, strong) UILabel *memberOverCountLbl;
@property (nonatomic, strong)  DBChatAvatarView *vwAvatarView;



@property (nonatomic, strong) UIImageView *userImageView;

- (void)updateColors;

- (NSDictionary *)titleAttributesHighlighted:(BOOL)highlighted;
- (NSDictionary *)subtitleAttributesHighlighted:(BOOL)highlighted;
- (UIColor *)backgroundColorHighlighted:(BOOL)selected;
- (UIColor *)textColorHighlighted:(BOOL)selected;


@end
