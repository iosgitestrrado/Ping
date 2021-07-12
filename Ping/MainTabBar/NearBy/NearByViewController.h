//
//  NearByViewController.h
//  Ping
//
//  Created by Softnotions Technologies Pvt Ltd on 2/5/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapViewAnnotation.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PGProfileTableViewController.h"
#import "PGMeetingAction.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import "NotificationViewController.h"
#import "UIBarButtonItem+Badge.h"
#import "MPCoachMarks.h"

@import GoogleMaps;

@interface NearByViewController : UIViewController<CLLocationManagerDelegate>{
   
    IBOutlet UISlider *slider;
    IBOutlet UILabel *lblSliderDistance;
    CLLocationManager *locationManager;
    //IBOutlet UIView *googleMapView;
    
    IBOutlet UIButton *btnPing;
    IBOutlet GMSMapView *googleMapView;
    
    IBOutlet UIImageView *imgProfile;
    IBOutlet UIButton *btnProfile;
    NSMutableArray * mutablePingFriends;
    NSMutableArray * notificationArray;
    
    CLLocation *userLocation,*venueLocation;
    BOOL allowLocation;
    GMSMarker *marker1;
    NSMutableDictionary * dictionaryData;
    NSDictionary *routeDict;
    NSString * strTime;
    NSMutableArray *mutableMeeting;
    NSMutableDictionary * dataDictionary;
    int currentUser;
}
@property (strong, nonatomic) IBOutlet UIView *viewSlider;

- (IBAction)sliderAction:(id)sender;

- (IBAction)sliderTouchUpInside:(id)sender;
- (IBAction)pingMeAction:(id)sender;
- (UIImage *)roundedRectImageFromImage :(UIImage *)image
                                  size :(CGSize)imageSize
                      withCornerRadius :(float)cornerRadius;

@end
