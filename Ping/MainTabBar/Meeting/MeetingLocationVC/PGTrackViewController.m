//
//  PGTrackViewController.m
//  Ping
//
//  Created by Monish M S on 27/11/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGTrackViewController.h"
#import <GoogleMaps/GoogleMaps.h>


@interface PGTrackViewController () <GMSMapViewDelegate>
{
    GMSMapView *mapView;
    BOOL _firstLocationUpdate;
    GMSMarker *marker;
    NSString *locatedAt, *latString, *longString;
    
    CGFloat  lat_float;
    CGFloat  lon_float;
}

@end

@implementation PGTrackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Location";
    
    lat_float = [_loclatString floatValue];
    lon_float = [_loclonString floatValue];
    
    self.tabBarController.tabBar.hidden = true;
    
    
    [self permissioncallGps];
    
}
-(void)permissioncallGps{
    
    //    if([CLLocationManager locationServicesEnabled] &&
    //       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat_float
                                                            longitude:lon_float
                                                                 zoom:15];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.delegate = nil;
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat_float,lon_float);
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.title = _locNavString;
    marker.map = mapView;
    self.view = mapView;
    [mapView setSelectedMarker:marker];
    
    
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView.myLocationEnabled = YES;
    });
    
    //    } else {
    //
    //        UIAlertController * alert = [UIAlertController
    //                                     alertControllerWithTitle:@"PING"
    //                                     message:@"GPS function is off. Please turn on the GPS function"
    //                                     preferredStyle:UIAlertControllerStyleAlert];
    //
    //
    //        UIAlertAction* yesButton = [UIAlertAction
    //                                    actionWithTitle:@"OK"
    //                                    style:UIAlertActionStyleDefault
    //                                    handler:^(UIAlertAction * action) {
    //
    //
    //                                        [self.navigationController popViewControllerAnimated:YES];
    //
    //
    //
    //                                    }];
    //
    //
    //
    //        [alert addAction:yesButton];
    //
    //
    //        [self presentViewController:alert animated:YES completion:nil];
    //    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
