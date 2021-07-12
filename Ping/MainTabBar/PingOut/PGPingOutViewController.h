//
//  PGPingOutViewController.h
//  Ping
//
//  Created by Monish M S on 04/01/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>
#import "NotificationViewController.h"
#import "UIBarButtonItem+Badge.h"
#import "PGPingOutMeetingTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MPCoachMarks.h"


@interface PGPingOutViewController : UIViewController <JTCalendarDelegate>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;
@end
