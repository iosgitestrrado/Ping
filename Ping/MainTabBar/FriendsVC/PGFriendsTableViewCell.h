//
//  PGFriendsTableViewCell.h
//  Ping
//
//  Created by Monish M S on 12/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGFriendsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *friendImgView;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet UIButton *friendBtn;

@end
