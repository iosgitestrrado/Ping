//
//  NotificationTableViewCell.h
//  Ping
//
//  Created by Softnotions Technologies Pvt Ltd on 2/7/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *notificationHead;
@property (strong, nonatomic) IBOutlet UILabel *notificationDate;
@property (strong, nonatomic) IBOutlet UILabel *notificationDetails;
@property (strong, nonatomic) IBOutlet UIImageView *notificationImage;

@end
