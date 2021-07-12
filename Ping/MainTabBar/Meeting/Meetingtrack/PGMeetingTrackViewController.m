//
//  PGMeetingTrackViewController.m
//  Ping
//
//  Created by Monish M S on 19/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGMeetingTrackViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "PGUser.h"
#import "PGEvent.h"



@interface PGMeetingTrackViewController () <GMSMapViewDelegate>
{
    //GMSMapView *googleMap;
    CLLocation *currentLocation;
    CLLocationCoordinate2D coordinate,pinCoordinate;
    GMSCameraPosition *cameraGeo;
    MKMapView * mapView;
    GMSMarker *marker ;
    BOOL callTrack;
    NSString* latStringDesc ;
    NSString* longStringDesc;
    NSString* locStringDesc;
    NSTimer *t;
    
    
    
}

@end

@implementation PGMeetingTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tabBarController.tabBar.hidden = true;
    
    
    
    self.title = @"Follow";
    googleMapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    callTrack =  true;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [locationManager startUpdatingLocation];
    locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [locationManager startUpdatingLocation];
    mutableMeeting = [[NSMutableArray alloc]init];
    
    [self permissioncallGps];
}

-(void)permissioncallGps{
    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        
        [self updateUserLocation];
        
        [self showMeetingDetails];
        
        t =   [NSTimer scheduledTimerWithTimeInterval:30.0
                                               target:self
                                             selector:@selector(showMeetingDetails)
                                             userInfo:nil
                                              repeats:YES];
        
        
        
        
    } else {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"PING"
                                     message:@"GPS function is off. Please turn on the GPS function"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                        
                                        [self.navigationController popViewControllerAnimated:YES];
                                        
                                        
                                        
                                    }];
        
        
        
        [alert addAction:yesButton];
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}





-(void)viewDidDisappear:(BOOL)animated{
    
    
    [t invalidate];
    t = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showMeetingDetails{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    
    NSString *meetingID = [defaults objectForKey:@"MeetingID"];
    NSString *meetingdate = [defaults objectForKey:@"TrackDate"];
    
    
    
    
    
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:meetingID forKey:@"meetingId"];
    [params setObject:meetingdate forKey:@"date"];
    
    
    
    NSLog(@"params---------%@",params);
    //user_id, meetingId, friendNumber
    //[params setObject:[NSString stringWithFormat:@"%ld", selectedButton.tag] forKey:@"trackId"];
    [PGEvent trackFriend:params withCompletionBlock:^(bool success, id result, NSError *error){
        //    NSLog(@"id 96321 ---------- %@",[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]]]);
        
        
        if (success) {
            // NSLog(@"id 101 ---------- %@",result);
            dataDictionary = [NSMutableDictionary dictionary];
            dataDictionary = [result valueForKey:@"data"];
            latStringDesc = [dataDictionary objectForKey:@"locLatitude"];
            longStringDesc = [dataDictionary objectForKey:@"locLongitude"];
            
            locStringDesc = [dataDictionary objectForKey:@"location"];
            
            
            mutableMeeting = [NSMutableArray array];
            
            mutableMeeting = [[dataDictionary valueForKey:@"friendDetails"]mutableCopy];
            
            NSDictionary* dictNum = @{@"avthar":[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"]] ,@"latitude":[NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude],@"longitude":[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude]};
            
            [mutableMeeting addObject:dictNum];
            
            
            
            if (callTrack) {
                [self showMeetingDesc];
            }
            [self performSelector:@selector(showMeetingFriend) withObject:nil afterDelay:0.25];
            
            
        }
        
    }];
    
    
    
    [self performSelector:@selector(updateUserLocation) withObject:nil afterDelay:45.0];
    
    
    
    
    
}
-(void)showMeetingDesc{
    
    callTrack = false;
    float latFloat=[latStringDesc floatValue];
    float longFloat=[longStringDesc floatValue];
    
    pinCoordinate.latitude = latFloat;
    pinCoordinate.longitude = longFloat;
    cameraGeo = [GMSCameraPosition cameraWithLatitude:latFloat longitude:longFloat zoom:16];
    googleMapView.delegate = self;
    [googleMapView setCamera:cameraGeo];
    [googleMapView setMyLocationEnabled:NO];
    [googleMapView setTrafficEnabled:YES];
    venueLocation = [[CLLocation alloc] initWithLatitude:latFloat longitude:longFloat];
    
}
-(void)showMeetingFriend{
    [googleMapView clear];
    [locationManager startUpdatingLocation];
    marker = [GMSMarker markerWithPosition:pinCoordinate];
    marker.layer.cornerRadius = 5.0;
    marker.layer.masksToBounds = YES;
    marker.title = locStringDesc;
    marker.map = googleMapView;
    
    
    
    for (int i=0; i<[mutableMeeting count] ;i++) {
        
        
        
        
        
        NSMutableDictionary * testDictionary = [[NSMutableDictionary alloc]init];
        testDictionary = [mutableMeeting objectAtIndex:i];
        NSString*   latString1 = [NSString stringWithFormat:@"%@", [testDictionary valueForKey:@"latitude"]];
        NSString* longString1 = [NSString stringWithFormat:@"%@", [testDictionary valueForKey:@"longitude"]];
        float latFloat1=[latString1 floatValue];
        float longFloat1=[longString1 floatValue];
        userLocation = [[CLLocation alloc] initWithLatitude:latFloat1 longitude:longFloat1];
        NSURL *url = [NSURL URLWithString:[testDictionary valueForKey:@"avthar"]];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
        GMSMarker *  marker3 = [[GMSMarker alloc] init];
        marker3.position = [[[CLLocation alloc]initWithLatitude:latFloat1 longitude:longFloat1] coordinate];
        marker3.layer.cornerRadius = 5.0;
        marker3.layer.masksToBounds = YES;
        marker3.groundAnchor = CGPointMake(0.5, 0.5);
        marker3.icon = [self roundedRectImageFromImage:[UIImage imageWithData:imageData] size:CGSizeMake(30.0f, 30.0f) withCornerRadius:30.0];
        marker3.map = googleMapView;
        
        
        
        
        [self fetchPolylineWithOrigin:venueLocation destination:userLocation completionHandler:^(GMSPolyline *polyline)
         {
             if(polyline)
                 polyline.map = googleMapView;
             NSLog(@"963 strTime ---------------- %@",strTime);
             marker3.title = strTime;
             polyline.strokeColor = [UIColor blueColor];
             polyline.strokeWidth = 5.f;
             marker3.map = googleMapView;
             [googleMapView setSelectedMarker:marker3];
             
         }];
        
        
        
    }
    
    [self updateUserLocation];
    
    
}
- (void)fetchPolylineWithOrigin:(CLLocation *)origin destination:(CLLocation *)destination completionHandler:(void (^)(GMSPolyline *))completionHandler
{
    NSString *originString = [NSString stringWithFormat:@"%f,%f", origin.coordinate.latitude, origin.coordinate.longitude];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.coordinate.latitude, destination.coordinate.longitude];
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving", directionsAPI, originString, destinationString];
    NSLog(@"directionsUrlString ----- %@",directionsUrlString);
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    
    
    
    NSURLSessionDataTask *fetchDirectionsTask = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler:
                                                 ^(NSData *data, NSURLResponse *response, NSError *error)
                                                 {
                                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                     id tjson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                     if(error)
                                                     {
                                                         if(completionHandler)
                                                             completionHandler(nil);
                                                         return;
                                                     }
                                                     
                                                     NSArray *routesArray = [json objectForKey:@"routes"];
                                                     
                                                     GMSPolyline *polyline = nil;
                                                     if ([routesArray count] > 0)
                                                     {
                                                         
                                                         routeDict = [routesArray objectAtIndex:0];
                                                         
                                                         NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                                                         NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                                                         GMSPath *path = [GMSPath pathFromEncodedPath:points];
                                                         polyline = [GMSPolyline polylineWithPath:path];
                                                         // NSMutableArray *arrLeg=[[arrDistance objectAtIndex:0]objectForKey:@"legs"];
                                                         //NSLog(@"%@",[NSString stringWithFormat:@"Estimated Time %@",[[dictleg   objectForKey:@"duration"] objectForKey:@"text"]]);
                                                         NSLog(@"tjson legs ----------------- %@",tjson);
                                                         NSLog(@"json legs 0123 ----------------- %@",[routeDict objectForKey:@"legs"]);
                                                         
                                                         NSMutableArray *arrLeg=[[routesArray objectAtIndex:0]objectForKey:@"legs"];
                                                         NSMutableDictionary *dictleg=[arrLeg objectAtIndex:0];
                                                         
                                                         dictionaryData = [NSMutableDictionary dictionary];
                                                         dictionaryData = dictleg;
                                                         strTime = [NSString stringWithFormat:@"%@", [[dictleg   objectForKey:@"duration"] objectForKey:@"text"]];
                                                         NSLog(@"strTime ------%@",strTime);
                                                         NSLog(@"dictleg 0123 ----------------- %@",[[dictleg   objectForKey:@"duration"] objectForKey:@"text"]);
                                                         
                                                         
                                                     }
                                                     
                                                     // run completionHandler on main thread
                                                     dispatch_sync(dispatch_get_main_queue(), ^{
                                                         if(completionHandler)
                                                             completionHandler(polyline);
                                                     });
                                                 }];
    
    
    
    [fetchDirectionsTask resume];
}
- (void)drawDashedLineOnMapBetweenOrigin:(CLLocation *)originLocation destination:(CLLocation *)destinationLocation {
    //[googleMapView clear];
    
    CGFloat distance = [originLocation distanceFromLocation:destinationLocation];
    //if (distance < kMinimalDistance) return;
    
    // works for segmentLength 22 at zoom level 16; to have different length,
    // calculate the new lengthFactor as 1/(24^2 * newLength)
    CGFloat lengthFactor = 2.7093020352450285e-09;
    CGFloat zoomFactor = pow(2, googleMapView.camera.zoom + 8);
    CGFloat segmentLength = 1.f / (lengthFactor * zoomFactor);
    CGFloat dashes = floor(distance / segmentLength);
    CGFloat dashLatitudeStep = (destinationLocation.coordinate.latitude - originLocation.coordinate.latitude) / dashes;
    CGFloat dashLongitudeStep = (destinationLocation.coordinate.longitude - originLocation.coordinate.longitude) / dashes;
    
    CLLocationCoordinate2D (^offsetCoord)(CLLocationCoordinate2D coord, CGFloat latOffset, CGFloat lngOffset) =
    ^CLLocationCoordinate2D(CLLocationCoordinate2D coord, CGFloat latOffset, CGFloat lngOffset) {
        return (CLLocationCoordinate2D) { .latitude = coord.latitude + latOffset,
            .longitude = coord.longitude + lngOffset };
    };
    
    GMSMutablePath *path = GMSMutablePath.path;
    NSMutableArray *spans = NSMutableArray.array;
    CLLocation *currentLocation = originLocation;
    [path addCoordinate:currentLocation.coordinate];
    
    while ([currentLocation distanceFromLocation:destinationLocation] > segmentLength) {
        CLLocationCoordinate2D dashEnd = offsetCoord(currentLocation.coordinate, dashLatitudeStep, dashLongitudeStep);
        [path addCoordinate:dashEnd];
        [spans addObject:[GMSStyleSpan spanWithColor:UIColor.blueColor]];
        
        CLLocationCoordinate2D newLocationCoord = offsetCoord(dashEnd, dashLatitudeStep / 2.f, dashLongitudeStep / 2.f);
        [path addCoordinate:newLocationCoord];
        [spans addObject:[GMSStyleSpan spanWithColor:UIColor.clearColor]];
        
        currentLocation = [[CLLocation alloc] initWithLatitude:newLocationCoord.latitude
                                                     longitude:newLocationCoord.longitude];
    }
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = googleMapView;
    polyline.spans = spans;
    polyline.strokeWidth = 4;
}
- (MKOverlayRenderer *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    return circleView;
}




#pragma mark - update user location
-(void) updateUserLocation{
    //http://elviserp.in/ping/user/userLocation/
    //    API params : user_id, latitude, longitude
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    //locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    NSString* latString = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    NSString* longString = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
    
    [params setObject:latString  forKey:@"latitude"];
    [params setObject:longString forKey:@"longitude"];
    NSLog(@"params 963 -------%@",params);
    [PGUser updateUserLocation:params withCompletionBlock:^(bool success, id result, NSError *error){
        
    }];
    
    
}



- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // Update your marker on your map using location.coordinate.latitude
        //and location.coordinate.longitude);
    }
    //    //Geocoder Code
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CGFloat zoom = googleMapView.camera.zoom;
             cameraGeo = [GMSCameraPosition cameraWithLatitude:pinCoordinate.latitude longitude:pinCoordinate.longitude zoom:zoom];
             googleMapView.camera = cameraGeo;
             
             [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coordinate completionHandler:
              ^(GMSReverseGeocodeResponse *response, NSError *error)
              {
                  NSLog(@"Address: %@", response.firstResult);
                  /* Address = [[response.firstResult valueForKey:@"lines"] objectAtIndex:0];
                   
                   [CATransaction begin];
                   [CATransaction setAnimationDuration:2.0];
                   markerMain.position = coordinate;
                   [CATransaction commit];
                   // markerMain = [GMSMarker markerWithPosition:coordinate];
                   markerMain.map = googleMap;
                   NSURL *url = [NSURL URLWithString:[[PIUser currentUser]image_url]];
                   NSData *data = [NSData dataWithContentsOfURL:url];
                   markerMain.icon = [UIImage imageWithData:data scale:20.0];
                   // [markerMain setAppearAnimation:kGMSMarkerAnimationPop];
                   NSLog(@"Address %@",Address);
                   markerMain.title = Address;*/
              }];
             
             
         }
         else
         {
             
         }
     }];
}




-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
    
    
}




-(UIImage*)roundedRectImageFromImage:(UIImage *)image
                                size:(CGSize)imageSize
                    withCornerRadius:(float)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);   //  <= notice 0.0 as third scale parameter. It is important cause default draw scale ≠ 1.0. Try 1.0 - it will draw an ugly image..
    CGRect bounds=(CGRect){CGPointZero,imageSize};
    [[UIBezierPath bezierPathWithRoundedRect:bounds
                                cornerRadius:cornerRadius] addClip];
    [image drawInRect:bounds];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}



@end
