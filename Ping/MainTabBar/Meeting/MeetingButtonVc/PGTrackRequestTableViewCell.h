//
//  PGTrackRequestTableViewCell.h
//  Ping
//
//  Created by Softnotions Technologies Pvt Ltd on 2/12/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGTrackRequestTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *suggestPic;
@property (weak, nonatomic) IBOutlet UILabel *suggestLabel;
@property (weak, nonatomic) IBOutlet UIButton *suggestAcceptButton;
@property (weak, nonatomic) IBOutlet UIButton *suggestRejectButton;
@end
