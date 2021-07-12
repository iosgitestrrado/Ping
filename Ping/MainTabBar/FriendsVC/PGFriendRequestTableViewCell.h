//
//  PGFriendRequestTableViewCell.h
//  Ping
//
//  Created by Monish M S on 13/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGFriendRequestTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *requestImgView;
@property (weak, nonatomic) IBOutlet UILabel *requestLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;

@end
