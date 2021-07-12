//
//  PGSignUpTableViewController.h
//  Ping
//
//  Created by Monish M S on 08/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PrivactTermsViewController.h"

@interface PGSignUpTableViewController : UITableViewController <CLLocationManagerDelegate>
{
       IBOutlet UIButton *RightButton;
       IBOutlet UIButton *checkbox;
}
@property (nonatomic,retain) CLLocationManager *locationManager;

@end
