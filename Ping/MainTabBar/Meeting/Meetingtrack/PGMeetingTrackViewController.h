//
//  PGMeetingTrackViewController.h
//  Ping
//
//  Created by Monish M S on 19/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapViewAnnotation.h"
#import <SDWebImage/UIImageView+WebCache.h>
@import GoogleMaps;




@interface PGMeetingTrackViewController : UIViewController<CLLocationManagerDelegate>{
    

    CLLocationManager *locationManager;
    //IBOutlet UIView *googleMapView;
  
    IBOutlet GMSMapView *googleMapView;
    
   NSMutableArray * mutablePingFriends;
  
    
    CLLocation *userLocation,*venueLocation,*CrrentuserLocation;
    
    
    NSMutableDictionary * dictionaryData;
    NSDictionary *routeDict;
    NSString * strTime;
    NSMutableArray *mutableMeeting;
    NSMutableDictionary * dataDictionary;
  
}

- (UIImage *)roundedRectImageFromImage :(UIImage *)image
                                  size :(CGSize)imageSize
                      withCornerRadius :(float)cornerRadius;

@end
