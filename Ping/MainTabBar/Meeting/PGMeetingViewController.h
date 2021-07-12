//
//  PGMeetingViewController.h
//  Ping
//
//  Created by Monish M S on 25/11/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>
#import "CreateEventViewController.h"
#import "PGFriends.h"
#import "UIBarButtonItem+Badge.h"

#import <CoreLocation/CoreLocation.h>
@import GooglePlacePicker;


@interface PGMeetingViewController : UIViewController <JTCalendarDelegate,CLLocationManagerDelegate>{
    NSString *lat;
    NSString *lon;
    GMSPlacePicker *_placePicker;
    CLLocationManager *locationManager;
    CLLocation        *currentLocation;
    double CURRENT_LATITUDE;
    double CURRENT_LONGITUDE ;
    NSString *CURRENT_ADDRESS;
    

}


@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet UIButton *notifyBtn;
@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;

@end
