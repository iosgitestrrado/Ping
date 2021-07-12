//
//  MSEventCell.m
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MSEventCell.h"

#define MAS_SHORTHAND
#import "Masonry.h"
#import "UIColor+HexString.h"
#import "RVCollection.h"
#import "MSDurationChangeIndicator.h"
#import "PGUser.h"
#import <SDWebImage/UIImageView+WebCache.h>



@interface MSEventCell ()
{
    
    UIColor *savecolor;
}
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIView *borderView1;
@property (nonatomic, strong) UIView *borderView2;
@property (nonatomic, strong) UIView *borderView3;


@end

@implementation MSEventCell

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.layer.shouldRasterize = YES;
        
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0.0, 4.0);
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.0;
        
        self.clipsToBounds = YES;
        
        
        
        self.borderView = [UIView new];
        [self.contentView addSubview:self.borderView];
        self.borderView1 = [UIView new];
        [self.contentView addSubview:self.borderView1];
        self.borderView2 = [UIView new];
        [self.contentView addSubview:self.borderView2];
        self.borderView3 = [UIView new];
        [self.contentView addSubview:self.borderView3];
       
      
        
        CGFloat heightimage = 56;
        
        
        _userImageView = [UIImageView new];
     
        [self.contentView addSubview:_userImageView];
     
        self.vwAvatarView = [DBChatAvatarView new];
        
//        self.memberOverCount = [UIView new];
//        self.memberOverCount.backgroundColor = [UIColor clearColor];
//        self.memberOverCount.layer.cornerRadius = heightimage/2;
//        self.memberOverCount.layer.masksToBounds = YES;
//        [self.contentView addSubview:self.memberOverCount];
       
        
        
        
        
        [self.contentView addSubview:self.vwAvatarView ];
        
        
       
        
        
        
//        self.memberOverCountLbl = [UILabel new];
//        self.memberOverCountLbl.textColor = [UIColor whiteColor];
//        self.memberOverCountLbl.textAlignment = NSTextAlignmentCenter;
//        [self.memberOverCount addSubview:self.memberOverCountLbl];
//
//
//
//       UIView *  myView = [UIView new];
//
//        myView.backgroundColor = [UIColor blackColor];
//        myView.alpha = 0.25;
//        [self.memberOverCount addSubview:myView];
        
        
        
        
        
        self.title = [UILabel new];
        self.title.numberOfLines = 0;
        self.title.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.title];
        
        self.location = [UILabel new];
        self.location.numberOfLines = 0;
        self.location.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.location];
        
       // [self updateColors];
        
        CGFloat borderWidth = 2.0;
        CGFloat contentMargin = 2.0;
       
   
        UIEdgeInsets contentPadding = UIEdgeInsetsMake(4.0, (borderWidth + 4.0), 1.0, 4.0);
        
        
        
        
        
        
        [self.borderView makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.height);
            make.width.equalTo(@(borderWidth));
            make.left.equalTo(self.left);
            make.top.equalTo(self.top);
        }];
        
        [self.borderView1 makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.height);
            make.width.equalTo(@(borderWidth));
            make.right.equalTo(self.right);
            make.top.equalTo(self.top);
        }];
        
        [self.borderView2 makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(borderWidth));
            make.width.equalTo(self.width);
            make.left.equalTo(self.left);
            make.bottom.equalTo(self.bottom);
        }];
     
        
        
//
//        [self.topBorderView makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(borderWidth));
//            make.width.equalTo(self.width);
//            make.top.equalTo(self.top);
//            make.left.equalTo(self.left);
//            make.right.equalTo(self.right);
//        }];
//
       
        
        
//        [_userImage makeConstraints:^(MASConstraintMaker *make) {
//            
//        
//          
//            
//            
//            make.top.equalTo(self.top).offset(contentPadding.top);
//            make.left.equalTo(self.left).offset(contentPadding.top);
//            make.height.equalTo(@(contentMargin1));
//            make.width.equalTo(@(contentMargin1));
//        }];
        
        
        [self.userImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(borderWidth));
            make.left.equalTo(@(borderWidth));
            make.width.equalTo(@(heightimage));
            make.height.equalTo(@(heightimage));
        }];
        [self.vwAvatarView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(borderWidth));
            make.left.equalTo(@(borderWidth));
            make.width.equalTo(@(heightimage));
            make.height.equalTo(@(heightimage));
        }];
        
//        [self.memberOverCount makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@(borderWidth));
//            make.left.equalTo(@(borderWidth));
//            make.width.equalTo(@(heightimage));
//            make.height.equalTo(self.height).offset(-4);
//        }];
//
//        [myView makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(0);
//            make.left.equalTo(0);
//            make.width.equalTo(@(heightimage));
//            make.height.equalTo(self.height).offset(-4);
//        }];
//
//
//        [self.memberOverCountLbl makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@(0));
//            make.left.equalTo(@(0));
//            make.width.equalTo(@(heightimage));
//            make.height.equalTo(self.height).offset(-4);
//        }];
//
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(contentPadding.top);
            make.left.equalTo(_vwAvatarView.right).offset(contentPadding.left);
            make.right.equalTo(self.right).offset(-contentPadding.right);
        }];
        
        
        
        [self.location makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.bottom).offset(contentMargin);
            make.left.equalTo(_vwAvatarView.right).offset(contentPadding.left);
            make.right.equalTo(self.right).offset(-contentPadding.right);
            make.bottom.lessThanOrEqualTo(self.bottom).offset(-contentPadding.bottom);
        }];

        
        [self.borderView3 makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(borderWidth));
            make.width.equalTo(self.width);
            make.left.equalTo(self.left);
            make.top.equalTo(self.top);
        }];
       
        
        
        self.userImageView.layer.cornerRadius =28;
        self.userImageView.layer.masksToBounds = YES;
        self.vwAvatarView.layer.cornerRadius = 28;
        self.vwAvatarView.layer.masksToBounds = YES;
   
        self.memberOverCount.hidden = YES;
        self.memberOverCountLbl.text = @"";
        self.vwAvatarView.chatAvatarDataSource = self;
        
    }
    return self;
}
- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.vwAvatarView reset];
}


#pragma mark - UICollectionViewCell
- (void)setSelected:(BOOL)selected
{
   
    
    
    if (selected && (self.selected != selected)) {
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeScale(1.025, 1.025);
            self.layer.shadowOpacity = 0.2;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }];
    } else if (selected) {
        self.layer.shadowOpacity = 0.2;
    } else {
        self.layer.shadowOpacity = 0.0;
    }
    [super setSelected:selected]; // Must be here for animation to fire
    [self updateColors];    
    [self removeIndicators];
}


#pragma mark - MSEventCell
- (void)setEvent:(MSEvent *)event
{
    _event = event;
    self.title.attributedText    = [[NSAttributedString alloc] initWithString:_event.title attributes:[self titleAttributesHighlighted:self.selected]];
    self.location.attributedText = [[NSAttributedString alloc] initWithString:_event.location attributes:[self subtitleAttributesHighlighted:self.selected]];
//    [_userImage reset];
//    _userImage.hidden = YES;
    
    
    
 
   
    
    
    
  
    
    _userImageView.hidden = YES;

    _userImageView.layer.cornerRadius = _userImageView.frame.size.width/2;
    _userImageView.layer.masksToBounds = YES;
    _vwAvatarView.layer.cornerRadius = _userImageView.frame.size.width/2;
    _vwAvatarView.layer.masksToBounds = YES;
    
    
    
    
    
    
    
    
    NSDictionary *dict = [event.eventDict mutableCopy];

    if( dict!= nil){
    
        
        
        
      //  NSLog(@"%@",dict);
        
        
        
        
        
    if ([[dict objectForKey:@"meeting_type"] isEqualToString:@"group_event"])
        {
    stringArray = [[dict objectForKey:@"grAvthar"] mutableCopy];
            
    [self setColorType:MKCalendarEventColorGreen];
            
            
            
            
            
            
            
            if (stringArray.count>1) {
                
   // _userImage.totalEntries = dictArry.count;
          //  _userImage.hidden = NO;
            _userImageView.hidden = YES;
            
//            for (int k =0; k< dictArry.count; k++) {
//            
//            
//            
//    [_userImage addImage:[[dictArry objectAtIndex:k]objectForKey:@"avthar"] withInitials:[[dictArry objectAtIndex:k]objectForKey:@"name"]];
//            }
                self.vwAvatarView.hidden = NO;
    
   // [_userImage updateLayout];
  
            if (stringArray.count>4) {
                
                self.memberOverCount.hidden = NO;
                
                
                self.memberOverCountLbl.text = [NSString stringWithFormat:@"+ %lu",stringArray.count-4];
            }else{
                
                self.memberOverCount.hidden = YES;
            }
            
            [self.vwAvatarView reloadAvatars];
            }else{
                
                
                self.vwAvatarView.hidden = YES;
                _userImageView.hidden = NO;
                self.memberOverCount.hidden = YES;
                
                NSString *urlString =[dict objectForKey:@"avthar"] ;
                NSURL *url = [NSURL URLWithString:urlString];
                
                [_userImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
                
            }
        }
        
    else  if ([[dict objectForKey:@"meeting_type"] isEqualToString:@"single_event"])
    {
        
        self.vwAvatarView.hidden = YES;
        _userImageView.hidden = NO;
         self.memberOverCount.hidden = YES;
        
   
            [self setColorType:MKCalendarEventColorGreen];
       
        
       
        NSString *urlString = [dict objectForKey:@"avthar"] ;
        NSURL *url = [NSURL URLWithString:urlString];
        
        [_userImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
        
        
        
        
    }
    else  if ([[dict objectForKey:@"meeting_type"] isEqualToString:@"ping_meeting"])
    {
        
        
        [self setColorType:MKCalendarEventColorGreen];
        
        self.vwAvatarView.hidden = YES;
        _userImageView.hidden = NO;
        self.memberOverCount.hidden = YES;
      
        
        
        [self setColorType:MKCalendarEventColorGreen];
        
        
        
        NSString *urlString = [dict objectForKey:@"avthar"] ;
        NSURL *url = [NSURL URLWithString:urlString];
        
        [_userImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
        
        
     
      
        
    }
        
        
        
        
        
        
        
    else  if ([[dict objectForKey:@"meeting_type"] isEqualToString:@"self_event"])
    {
        self.vwAvatarView.hidden = YES;
        _userImageView.hidden = NO;
        self.memberOverCount.hidden = YES;
  
        [self setColorType:MKCalendarEventColorGreen];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"] == nil)
        {
            
        
            _userImageView.image = [UIImage imageNamed:@"UserProfile"];
            
            
            
        }
        else
        {
            NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"]];
            [_userImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserProfile"] options:SDWebImageRefreshCached];
            
            
        }
        
        
        
    }
    else  if ([[dict objectForKey:@"meeting_type"] isEqualToString:@"block_event"])
    {
        self.vwAvatarView.hidden = YES;
        _userImageView.hidden = NO;
        self.memberOverCount.hidden = YES;
        
       
       [self setColorType:MKCalendarEventColorGreen];
            
   
         _userImageView.image = [UIImage imageNamed:@"block"];
        
        
    }
    else  if ([[dict objectForKey:@"meeting_type"] isEqualToString:@"ios_event"])
    {
        self.vwAvatarView.hidden = YES;
        _userImageView.hidden = NO;
        self.memberOverCount.hidden = YES;
        
        
        
  [self setColorType:MKCalendarEventColorGreen];
  

_userImageView.image = [UIImage imageNamed:@"ios"];
        
    }
    else  if ([[dict objectForKey:@"meeting_type"] isEqualToString:@"google_event"])
    {
        
        self.vwAvatarView.hidden = YES;
        _userImageView.hidden = NO;
        self.memberOverCount.hidden = YES;
        [self setColorType:MKCalendarEventColorGreen];
       
        
      _userImageView.image = [UIImage imageNamed:@"googleImage"];
        
    }
        if (event.eventSTATUS) {
            [self setColorType:MKCalendarEventColorBlue];
        }
        
        
    }
    
    
    


    
    
    
    
}

#pragma mark - DBChatAvatarViewDataSource

- (NSInteger)numberOfUsersInChatAvatarView:(DBChatAvatarView *)chatAvatarView {
    return stringArray.count;
}


- (NSString *)imageForAvatarAtIndex:(NSInteger)avatarIndex inChatAvatarView:(DBChatAvatarView *)chatAvatarView {
    
    
    
    
   
    return [stringArray objectAtIndex:avatarIndex];
}
- (void)setColorType:(MKCalendarEventColor)type{
 
    
    switch (type) {
        case MKCalendarEventColorRed:
            self.title.textColor = [UIColor blackColor];
            self.location.textColor = [UIColor blackColor];
            self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f
                                                   green:213.0f/255.0f
                                                    blue:210.0f/255.0f
                                                   alpha:1.0f];
            self.borderView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f
                                                              green:138.0f/255.0f
                                                               blue:130.0f/255.0f
                                                              alpha:1.0f];
            
            
            
            
            
            self.borderView1.backgroundColor = [UIColor colorWithRed:255.0f/255.0f
                                                              green:138.0f/255.0f
                                                               blue:130.0f/255.0f
                                                              alpha:1.0f];
            
            self.borderView2.backgroundColor = [UIColor colorWithRed:255.0f/255.0f
                                                              green:138.0f/255.0f
                                                               blue:130.0f/255.0f
                                                              alpha:1.0f];
            
            
            
            
            
            self.borderView3.backgroundColor = [UIColor colorWithRed:255.0f/255.0f
                                                               green:138.0f/255.0f
                                                                blue:130.0f/255.0f
                                                               alpha:1.0f];
            
            
            
            
            break;
        case MKCalendarEventColorGreen:
            self.title.textColor = [UIColor blackColor];
            self.location.textColor = [UIColor blackColor];
            self.backgroundColor = [UIColor colorWithRed:213.0f/255.0f
                                                   green:231.0f/255.0f
                                                    blue:255.0f/255.0f
                                                   alpha:1.0f];
            self.borderView.backgroundColor = [UIColor colorWithRed:91.0f/255.0f
                                                              green:251.0f/255.0f
                                                               blue:255.0f/255.0f
                                                              alpha:1.0f];
            self.borderView1.backgroundColor = [UIColor colorWithRed:91.0f/255.0f
                                                              green:251.0f/255.0f
                                                               blue:255.0f/255.0f
                                                              alpha:1.0f];
            self.borderView2.backgroundColor = [UIColor colorWithRed:91.0f/255.0f
                                                              green:251.0f/255.0f
                                                               blue:255.0f/255.0f
                                                              alpha:1.0f];
            self.borderView3.backgroundColor = [UIColor colorWithRed:91.0f/255.0f
                                                               green:251.0f/255.0f
                                                                blue:255.0f/255.0f
                                                               alpha:1.0f];
            
            break;
        case MKCalendarEventColorBlue:
            self.title.textColor = [UIColor blackColor];
            self.location.textColor = [UIColor blackColor];
            self.backgroundColor = [UIColor colorWithRed:214.0f/255.0f
                                                   green:254.0f/255.0f
                                                    blue:255.0f/255.0f
                                                   alpha:1.0f];
            self.borderView.backgroundColor = [UIColor colorWithRed:124.0f/255.0f
                                                              green:180.0f/255.0f
                                                               blue:255.0f/255.0f
                                                              alpha:1.0f];
            
            self.borderView1.backgroundColor = [UIColor colorWithRed:124.0f/255.0f
                                                              green:180.0f/255.0f
                                                               blue:255.0f/255.0f
                                                              alpha:1.0f];
            
            self.borderView2.backgroundColor = [UIColor colorWithRed:124.0f/255.0f
                                                              green:180.0f/255.0f
                                                               blue:255.0f/255.0f
                                                              alpha:1.0f];
            
            self.borderView3.backgroundColor = [UIColor colorWithRed:124.0f/255.0f
                                                               green:180.0f/255.0f
                                                                blue:255.0f/255.0f
                                                               alpha:1.0f];
            
            break;
        case MKCalendarEventColorPink:
            self.title.textColor = [UIColor blackColor];
            self.location.textColor = [UIColor blackColor];
            self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f
                                                   green:213.0f/255.0f
                                                    blue:247.0f/255.0f
                                                   alpha:1.0f];
            self.borderView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f
                                                              green:174.0f/255.0f
                                                               blue:240.0f/255.0f
                                                              alpha:1.0f];
            
            
            self.borderView1.backgroundColor = [UIColor colorWithRed:255.0f/255.0f
                                                              green:174.0f/255.0f
                                                               blue:240.0f/255.0f
                                                              alpha:1.0f];
            
            self.borderView2.backgroundColor = [UIColor colorWithRed:255.0f/255.0f
                                                              green:174.0f/255.0f
                                                               blue:240.0f/255.0f
                                                              alpha:1.0f];
            
            
            self.borderView3.backgroundColor = [UIColor colorWithRed:255.0f/255.0f
                                                               green:174.0f/255.0f
                                                                blue:240.0f/255.0f
                                                               alpha:1.0f];
            
            break;
        case MKCalendarEventColorGrey:
            self.title.textColor = [UIColor blackColor];
            self.location.textColor = [UIColor blackColor];
       
            
            
            
            self.backgroundColor = [UIColor colorWithRed:218.0f/255.0f
                                                   green:218.0f/255.0f
                                                    blue:218.0f/255.0f
                                                   alpha:1.0f];
            self.borderView.backgroundColor =  [UIColor colorWithRed:200.0f/255.0f
                                                               green:200.0f/255.0f
                                                                blue:200.0f/255.0f
                                                               alpha:1.0f];
            self.borderView1.backgroundColor =  [UIColor colorWithRed:200.0f/255.0f
                                                                green:200.0f/255.0f
                                                                 blue:200.0f/255.0f
                                                                alpha:1.0f];
            self.borderView2.backgroundColor =  [UIColor colorWithRed:200.0f/255.0f
                                                                green:200.0f/255.0f
                                                                 blue:200.0f/255.0f
                                                                alpha:1.0f];
            self.borderView3.backgroundColor = [UIColor colorWithRed:200.0f/255.0f
                                                               green:200.0f/255.0f
                                                                blue:200.0f/255.0f
                                                               alpha:1.0f];
            
            
            
            
            break;
            
        case MKCalendarEventColorOrange:
            self.title.textColor = [UIColor blackColor];
            self.location.textColor = [UIColor blackColor];
            
            self.backgroundColor = [UIColor colorWithRed:251.0f/255.0f
                                                   green:235.0f/255.0f
                                                    blue:210.0f/255.0f
                                                   alpha:1.0f];
            self.borderView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f
                                                              green:188.0f/255.0f
                                                               blue:84.0f/255.0f
                                                              alpha:1.0f];
            
            
            
            self.borderView1.backgroundColor = [UIColor colorWithRed:255.0f/255.0f
                                                              green:188.0f/255.0f
                                                               blue:84.0f/255.0f
                                                              alpha:1.0f];
            
            self.borderView2.backgroundColor = [UIColor colorWithRed:255.0f/255.0f
                                                              green:188.0f/255.0f
                                                               blue:84.0f/255.0f
                                                              alpha:1.0f];
            
            
            
            self.borderView3.backgroundColor = [UIColor colorWithRed:255.0f/255.0f
                                                               green:188.0f/255.0f
                                                                blue:84.0f/255.0f
                                                               alpha:1.0f];
            
            
            break;
            
        case MKCalendarEventColorYellow:
            self.title.textColor = [UIColor blackColor];
            self.location.textColor = [UIColor blackColor];
            
            self.backgroundColor = [UIColor colorWithRed:249.0f/255.0f
                                                   green:251.0f/255.0f
                                                    blue:214.0f/255.0f
                                                   alpha:1.0f];
            self.borderView.backgroundColor = [UIColor colorWithRed:246.0f/255.0f
                                                              green:255.0f/255.0f
                                                               blue:87.0f/255.0f
                                                              alpha:1.0f];
            
            
            
            
            self.borderView1.backgroundColor = [UIColor colorWithRed:246.0f/255.0f
                                                              green:255.0f/255.0f
                                                               blue:87.0f/255.0f
                                                              alpha:1.0f];
            
            
            self.borderView2.backgroundColor = [UIColor colorWithRed:246.0f/255.0f
                                                              green:255.0f/255.0f
                                                               blue:87.0f/255.0f
                                                              alpha:1.0f];
            
            
            
            
            self.borderView3.backgroundColor = [UIColor colorWithRed:246.0f/255.0f
                                                               green:255.0f/255.0f
                                                                blue:87.0f/255.0f
                                                               alpha:1.0f];
            
            
            
            
            
            break;
            
            
            
            
            
            
        default:
            self.title.textColor = [UIColor blackColor];
            self.location.textColor = [UIColor blackColor];
            self.backgroundColor = [UIColor yellowColor];
            self.borderView.backgroundColor = [UIColor cyanColor];
            
             self.borderView1.backgroundColor = [UIColor cyanColor];
            self.borderView2.backgroundColor = [UIColor cyanColor];
            
            self.borderView3.backgroundColor = [UIColor cyanColor];
            
            break;
    }

}







- (void)updateColors
{
    
    savecolor = self.backgroundColor;
    
    
    self.backgroundColor = [self backgroundColorHighlighted:self.selected];
    self.title.textColor             = [self textColorHighlighted:self.selected];
    self.location.textColor          = [self textColorHighlighted:self.selected];
}

-(void)removeIndicators{
    [self.subviews each:^(UIView* subview) {
        if([subview isKindOfClass:MSDurationChangeIndicator.class]){
            [subview removeFromSuperview];
        }
    }];
}

- (NSDictionary *)titleAttributesHighlighted:(BOOL)highlighted
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    return @{
             NSFontAttributeName : [UIFont fontWithName:@"Lato-Regular" size:12.0],
             NSForegroundColorAttributeName : [self textColorHighlighted:highlighted],
             NSParagraphStyleAttributeName : paragraphStyle
             };
}

- (NSDictionary *)subtitleAttributesHighlighted:(BOOL)highlighted
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    return @{
             NSFontAttributeName : [UIFont fontWithName:@"Lato-Regular" size:12.0],
             NSForegroundColorAttributeName : [self textColorHighlighted:highlighted],
             NSParagraphStyleAttributeName : paragraphStyle
             };
}

- (UIColor *)backgroundColorHighlighted:(BOOL)selected
{
    

    
    
    return selected ? [UIColor colorWithHexString:@"35b1f1"] : savecolor;
}

- (UIColor *)textColorHighlighted:(BOOL)selected
{
    return selected ? [UIColor whiteColor] : [UIColor colorWithHexString:@"21729c"];
}


@end
