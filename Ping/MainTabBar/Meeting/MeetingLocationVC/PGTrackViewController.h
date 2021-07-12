//
//  PGTrackViewController.h
//  Ping
//
//  Created by Monish M S on 27/11/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PGTrackViewController : UIViewController <CLLocationManagerDelegate>

@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,strong) NSString *locNavString;
@property(nonatomic,strong) NSString *loclatString;
@property(nonatomic,strong) NSString *loclonString;
@end
