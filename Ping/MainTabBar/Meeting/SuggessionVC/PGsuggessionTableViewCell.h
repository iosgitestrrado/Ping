//
//  PGsuggessionTableViewCell.h
//  Ping
//
//  Created by Monish M S on 05/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGsuggessionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *suggestPic;
@property (weak, nonatomic) IBOutlet UILabel *suggestLabel;
@property (weak, nonatomic) IBOutlet UIButton *suggestAcceptButton;
@property (weak, nonatomic) IBOutlet UIButton *suggestRejectButton;

@property (weak, nonatomic) IBOutlet UIStackView *hiddenstack;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraint;
@end
