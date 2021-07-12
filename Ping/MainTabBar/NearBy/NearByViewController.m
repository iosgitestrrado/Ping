//
//  NearByViewController.m
//  Ping
//
//  Created by Softnotions Technologies Pvt Ltd on 2/5/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "NearByViewController.h"
#import "PGUser.h"
#import "AppDelegate.h"
#import "LNBRippleEffect.h"


@interface NearByViewController ()<GMSMapViewDelegate>
{
    //GMSMapView *googleMap;
    CLLocation *currentLocation;
    CLLocationCoordinate2D coordinate,pinCoordinate;
    GMSCameraPosition *cameraGeo;
    MKMapView * mapView;
    GMSMarker *marker ;
    GMSCircle *geoFenceCircle;
    NSString  *radiusPassString;
    int radiusVal;
    
    LNBRippleEffect *rippleEffect;
    AppDelegate *appDelegate;
    UIButton *button1;
    
}
@property (weak, nonatomic) IBOutlet UIButton *notifyBtn;

@end

@implementation NearByViewController








-(void)viewWillAppear:(BOOL)animated{
    
    
    
    
    //      ---title
    //
    //
    //     / decline buttons
    
    
    
    
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(profileViewAction:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 34, 34)];
    button.layer.cornerRadius = 17;
    button.layer.masksToBounds = YES;
    [self updateUserLocation];
    UIImageView *picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"] == nil)
    {
        picImageView.layer.cornerRadius = 17;
        picImageView.layer.masksToBounds = YES;
        picImageView.image = [UIImage imageNamed:@"UserProfile"];
    }
    else
    {
        picImageView.layer.cornerRadius = 17;
        picImageView.layer.masksToBounds = YES;
        NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"]];
        [picImageView sd_setImageWithURL:url
                        placeholderImage:nil
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   if (error) {
                                       
                                       picImageView.image = [UIImage imageNamed:@"UserProfile"];
                                   }
                               }];
        
        //[picImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserProfile"] options:SDWebImageRefreshCached];
    }
    [button addSubview:picImageView];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    UIImage *img;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ping+"]) {
        img = [UIImage imageNamed:@"pingHomeList"];
    }else{
        
        img = [UIImage imageNamed:@"PingMe"];
        
    }
    
    
    [btnPing setImage:img forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem.badgeValue = appDelegate.badgeValue;
    appDelegate.indexValue = 4;
    self.navigationItem.rightBarButtonItem.badgeBGColor =  [UIColor colorWithRed:203.0/255.0 green:84.0/255.0 blue:124.0/255.0 alpha:1.0];
    
    
    
    self.tabBarController.tabBar.hidden = false;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(passLocationtargetAction:)
                                                 name:@"passLocationtarget"
                                               object:nil];
    
    [btnPing setHidden:NO];
    [self.viewSlider setHidden:NO];
    
    
    
    
    
    [self permissioncallGps];
    
    
    
    
    
    
    
    
    
}







-(void)permissioncallLocation{
    
    
    //   if (allowLocation) {
    
    [self permissioncallGps];
    
    //    }else{
    //
    //
    //
    //
    //
    //
    //
    //    UIAlertController * alert = [UIAlertController
    //                                 alertControllerWithTitle:@"Allow “Ping” to access your location"
    //                                 message:@"PING displays friends within a specified kilometer and find out where you are."
    //                                 preferredStyle:UIAlertControllerStyleAlert];
    //
    //    //Add Buttons
    //
    //    UIAlertAction* yesButton = [UIAlertAction
    //                                actionWithTitle:@"Accept"
    //                                style:UIAlertActionStyleDefault
    //                                handler:^(UIAlertAction * action) {
    //                                    allowLocation  = YES;
    //                                    [self permissioncallGps];
    //
    //
    //                                }];
    //
    //    UIAlertAction* noButton = [UIAlertAction
    //                               actionWithTitle:@"Decline"
    //                               style:UIAlertActionStyleDefault
    //                               handler:^(UIAlertAction * action) {
    //
    //                                   [self.tabBarController setSelectedIndex:2];
    //
    //
    //                               }];
    //
    //
    //    [alert addAction:yesButton];
    //    [alert addAction:noButton];
    //
    //    [self presentViewController:alert animated:YES completion:nil];
    //
    //     // [self permissioncallGps];
    //    }
    
    
    
}

-(void)permissioncallpingPlus{
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"ping+"]) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"PING"
                                     message:@"This feature requires you to upgrade to Ping Plus (Coming Soon)"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"UPGRADE"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                        
                                        [self performSegueWithIdentifier:@"upgradeSegue" sender:self];
                                        
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"CANCEL"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [self performSelector:@selector(setupNearMe) withObject:nil afterDelay:1.0];
                                   }];
        
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        [self performSelector:@selector(setupNearMe) withObject:nil afterDelay:3.0];
        
    }
    
    
    
    
    
}

-(void)permissioncallGps{
    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        
        [self performSelector:@selector(setupNearMe) withObject:nil afterDelay:0.25];
        
        
        
        
    } else {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"PING"
                                     message:@"GPS function is off. Please turn on the GPS function"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                        
                                        [self.tabBarController setSelectedIndex:2];
                                        
                                        
                                        
                                    }];
        
        
        
        [alert addAction:yesButton];
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}






-(void)setupNearMe{
    [googleMapView clear];
    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
    CLLocationCoordinate2D pinCoordinate;
    pinCoordinate.latitude = locationManager.location.coordinate.latitude;
    pinCoordinate.longitude = locationManager.location.coordinate.longitude;
    myAnnotation.coordinate = pinCoordinate;
    [mapView addAnnotation:myAnnotation];
    radiusPassString=[[NSNumber numberWithFloat:slider.value] stringValue];
    geoFenceCircle.radius = [radiusPassString intValue] * 1000; // Meters
    geoFenceCircle.position = pinCoordinate; // Some CLLocationCoordinate2D position
    geoFenceCircle.fillColor = [UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:0.1];
    geoFenceCircle.strokeWidth = 1;
    geoFenceCircle.strokeColor = [UIColor redColor];
    geoFenceCircle.map = googleMapView; // Add it to the map
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"]]];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    iconView.layer.cornerRadius = 5.0;
    iconView.layer.masksToBounds = YES;
    
    GMSMarker *marker = [GMSMarker markerWithPosition:pinCoordinate];
    marker.icon = [self roundedRectImageFromImage:[UIImage imageWithData:imageData] size:CGSizeMake(30.0f, 30.0f) withCornerRadius:30.0];
    marker.layer.cornerRadius = 5.0;
    marker.layer.masksToBounds = YES;
    marker.map = googleMapView;
    
    [self listPingFriends];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"NEARMETUTORIAL"]) {
        
        [self showTutorial];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIImage *image = [UIImage imageNamed:@"notification"];
    
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(0, 0, 34, 34)];
    [button1 addTarget:self action:@selector(notificationViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setBackgroundImage:image forState:UIControlStateNormal];
    
    // Make BarButton Item
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = navLeftButton;
    
    
    [btnPing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnPing setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    allowLocation  = NO;
    
    currentUser = 0;
    // Do any additional setup after loading the view.
    geoFenceCircle = [[GMSCircle alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    //locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    
    
    //googleMapView
    cameraGeo = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude zoom:16];
    
    googleMapView.delegate = self;
    
    
    googleMapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    
    
    [googleMapView animateToCameraPosition: cameraGeo];
    
    [googleMapView setMyLocationEnabled:YES];
    [locationManager startUpdatingLocation];
    // [googleMapView setMinZoom:10 maxZoom:26];
    
    slider.value = 0.0;
    lblSliderDistance.text = [NSString stringWithFormat:@"%.0f km", slider.value];
    slider.userInteractionEnabled = true;
    // Build a circle for the GMSMapView
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(NearmeNotification:) name:@"nearmeAction" object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(badgeNotification:) name:@"badgeAction" object:nil];
}

-(void) showTutorial{
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect coachmark = CGRectMake(self.view.frame.size.width-89,self.view.frame.size.height- 74,72,72);
        
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height == 812){
            coachmark = CGRectMake(self.view.frame.size.width- 91,self.view.frame.size.height-86,76,76);
        }
        
        NSArray *coachMarks = @[
                                @{
                                    @"rect": [NSValue valueWithCGRect:coachmark],
                                    @"caption": @"You can send pingme notifications to your near users.",
                                    @"shape": [NSNumber numberWithInteger:SHAPE_CIRCLE],
                                    @"position":[NSNumber numberWithInteger:LABEL_POSITION_TOP],
                                    @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_CENTER],
                                    @"showArrow":[NSNumber numberWithBool:NO]
                                    }
                                ];
        
        MPCoachMarks *coachMarksView = [[MPCoachMarks alloc] initWithFrame:self.navigationController.view.bounds coachMarks:coachMarks];
        [self.navigationController.view addSubview:coachMarksView];
        [coachMarksView start];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NEARMETUTORIAL"];
        
        
        
        
    }
    
    
    
    
}


-(void)NearmeNotification:(NSNotification*)notification
{
    
    NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
    
    UIViewController * controllerTest = [controllers lastObject];
    
    if([controllerTest isKindOfClass:[NearByViewController class]]){
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    
    
    
    
    [self listPingFriends];
}



-(void)badgeNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"badgeAction"])
    {
        self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor colorWithRed:203.0/255.0 green:84.0/255.0 blue:124.0/255.0 alpha:1.0];
        self.navigationItem.rightBarButtonItem.badgeValue = appDelegate.badgeValue;
        
        
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:-M_PI/18];
        animation.toValue = [NSNumber numberWithFloat: M_PI/18];
        animation.duration = 0.2;
        animation.repeatCount = 5;
        [animation setAutoreverses:YES];
        [button1.layer addAnimation:animation forKey:@"SpinAnimation"];
        // [self listPingFriends];
    }
    
}
- (IBAction)notificationViewAction:(id)sender
{
    
    NotificationViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    [self.navigationController pushViewController:profileVC animated:true];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) updateUserLocation{
    
    [locationManager startUpdatingLocation];
    
    
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

#pragma mark - List of ping friend arround current user
-(void) listPingFriends{
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    radiusVal = lblSliderDistance.text.intValue;
    NSString *radiusString = [NSString stringWithFormat:@"%d",radiusVal];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:radiusString forKey:@"distance"];
    
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ping+"]) {
        [params setObject:@"1" forKey:@"user"];
    } else {
        [params setObject:@"0" forKey:@"user"];
    }
    
    NSLog(@"params 222 -------------------%@",params);
    [PGMeetingAction listfriends:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         
         
         self.tabBarController.tabBar.userInteractionEnabled = YES;
         if (success)
         {
             mutablePingFriends = [NSMutableArray array];
             mutablePingFriends =[result valueForKey:@"data"];
             [self repeatfriendsResult];
         }
         [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
     }];
    
    
}
-(void)repeatfriendsResult{
    [googleMapView clear];
    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
    CLLocationCoordinate2D pinCoordinate;
    pinCoordinate.latitude = locationManager.location.coordinate.latitude;
    pinCoordinate.longitude = locationManager.location.coordinate.longitude;
    myAnnotation.coordinate = pinCoordinate;
    [mapView addAnnotation:myAnnotation];
    radiusPassString=[[NSNumber numberWithFloat:slider.value] stringValue];
    geoFenceCircle.radius = [radiusPassString intValue] * 1000; // Meters
    geoFenceCircle.position = pinCoordinate; // Some CLLocationCoordinate2D position
    geoFenceCircle.fillColor = [UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:0.1];
    geoFenceCircle.strokeWidth = 1;
    geoFenceCircle.strokeColor = [UIColor redColor];
    geoFenceCircle.map = googleMapView; // Add it to the map
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"]]];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    iconView.layer.cornerRadius = 5.0;
    iconView.layer.masksToBounds = YES;
    
    GMSMarker *marker = [GMSMarker markerWithPosition:pinCoordinate];
    marker.icon = [self roundedRectImageFromImage:[UIImage imageWithData:imageData] size:CGSizeMake(30.0f, 30.0f) withCornerRadius:30.0];
    marker.layer.cornerRadius = 5.0;
    marker.layer.masksToBounds = YES;
    marker.map = googleMapView;
    
    for (int i=0; i<[mutablePingFriends count];i++) {
        NSDictionary * testDictionary = [[NSDictionary alloc]init];
        testDictionary = [mutablePingFriends objectAtIndex:i];
        
        NSURL *url = [NSURL URLWithString:[[mutablePingFriends valueForKey:@"avthar"]objectAtIndex:i]];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
        
        CLLocationCoordinate2D pCoordinate;
        CLLocationCoordinate2D pinCoordinate;
        pinCoordinate.latitude = locationManager.location.coordinate.latitude;
        pinCoordinate.longitude = locationManager.location.coordinate.longitude;
        //76.867400
        //8.558567
        
        NSString* latString = [NSString stringWithFormat:@"%@", [[mutablePingFriends objectAtIndex:i] valueForKey:@"latitude"]];
        NSString* longString = [NSString stringWithFormat:@"%@", [[mutablePingFriends objectAtIndex:i] valueForKey:@"longitude"]];
        
        
        float latFloat=[latString floatValue];
        float longFloat=[longString floatValue];
        pCoordinate.latitude = latFloat;
        pCoordinate.longitude = longFloat;
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = [[[CLLocation alloc]initWithLatitude:latFloat longitude:longFloat] coordinate];
        marker.title =  [[mutablePingFriends objectAtIndex:i] valueForKey:@"name"];
        
        
        
        
        
        NSNumber *someNumber = [NSNumber numberWithInteger:1];
        NSInteger value =[[[mutablePingFriends objectAtIndex:i] valueForKey:@"is_online"]integerValue];
        
        
        NSNumber *someNumber1 = [NSNumber numberWithInteger:value];
        
        if (![someNumber1 isEqual:someNumber]) {
            
            marker.icon = [self roundedRectImageFromImage:[UIImage imageWithData:imageData] size:CGSizeMake(30.0f, 30.0f) withCornerRadius:30.0];
            
            
            
        }else{
            
            UIImage *image1 = [UIImage imageNamed:@"ClusterAnnotation"];
            UIImage *image2 =  [self roundedRectImageFromImage:[UIImage imageWithData:imageData] size:CGSizeMake(27.0f,27.0f) withCornerRadius:27.0];
            
            CGSize size = CGSizeMake(33, 40);
            
            UIGraphicsBeginImageContext(size);
            
            [image1 drawInRect:CGRectMake(0,0,size.width, size.height)];
            [image2 drawInRect:CGRectMake(3,3,27, 27)];
            
            UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, finalImage.size.width, finalImage.size.height)];
            imageView.image = finalImage;
            
            
            marker.icon = finalImage;
            
        }
        
        marker.layer.cornerRadius = 5.0;
        marker.layer.masksToBounds = YES;
        
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = googleMapView;
        
    }
    
}








-(void)mapView:(GMSMapView *)mapView
didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
    NSLog(@"%@",marker);
    
    
    for (id item in mutablePingFriends)
    {
        NSDictionary *dict = item;
        
        if ([marker.title isEqualToString:[dict valueForKey:@"name"]])
        {
            [self profileViewActionmarker:dict];
            break;
        }
    }
    
    
}

- (void)profileViewActionmarker:(NSDictionary *)senderString
{
    
    PGProfileTableViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PGProfileTableViewController"];
    profileVC.passString = senderString;
    [self.navigationController pushViewController:profileVC animated:true];
    
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
                  
              }];
             // Build a circle for the GMSMapView
             
             geoFenceCircle.radius = [radiusPassString intValue] * 1000; // Meters
             geoFenceCircle.position = coordinate; // Some CLLocationCoordinate2D position
             geoFenceCircle.fillColor = [UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:0.1];
             geoFenceCircle.strokeWidth = 1;
             geoFenceCircle.strokeColor = [UIColor redColor];
             geoFenceCircle.map = googleMapView; // Add it to the map
             
         }
         else
         {
             
         }
     }];
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
    
    
}



- (IBAction)sliderAction:(id)sender {
    lblSliderDistance.text = [NSString stringWithFormat:@"%.0f km", slider.value];
    //geoFenceCircle = [[GMSCircle alloc] init];
    // Build a circle for the GMSMapView
    NSLog(@"sliderAction");
    //[self listPingFriends];
    
    
}


- (IBAction)sliderTouchUpInside:(id)sender {
    NSLog(@"sliderTouchUpInside");
    radiusVal = lblSliderDistance.text.intValue;
    
    
    NSArray *array = @[ @1.87f, @1.40f, @1.20f,@1.03f, @0.85f, @0.745f,@0.66f, @0.6f, @0.55f,@0.505f ,@0.47f  ];
    // cameraGeo.setz = 24 - (radiusVal*1.1);
    
    float y = [array[radiusVal] floatValue];
    
    
    cameraGeo = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude zoom:(16 - (radiusVal* y))];
    [googleMapView setCamera:cameraGeo];
    
    [self listPingFriends];
    NSString *radiusString = [NSString stringWithFormat:@"%d",radiusVal];
    NSDictionary* userInfo = @{@"radiusLoc": radiusString};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"passLocationtarget" object:nil userInfo:userInfo];
}

- (IBAction)pingMeAction:(id)sender {
    
    
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Pingme" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Ping Friends" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
        
        
        [self Pingfrinds];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Ping All" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
        
        
        
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"ping+"]) {
            
            [self PingAlls];
            
        }else{
            [self segueAction];
        }
        
    }]];
    
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    
    
}


-(void)segueAction{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"PING"
                                 message:@" Upgrade to 'ping +' to Pingme users near you"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"UPGRADE"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                    
                                    [self performSegueWithIdentifier:@"upgradeSegue" sender:self];
                                    
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"CANCEL"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)PingAlls{
    
    
    
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"PING"
                                 message:@"Check out who’s nearby?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"YES"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    //[self clearAllData];
                                    
                                    rippleEffect = [[LNBRippleEffect alloc]initWithImage:nil Frame:CGRectMake(self.view.frame.size.width-120, self.view.frame.size.height-120, 200, 200) Color:[UIColor colorWithRed:(28.0/255.0) green:(212.0/255.0) blue:(255.0/255.0) alpha:0] Target:nil ID:self];
                                    [rippleEffect setRippleColor:[UIColor colorWithRed:203.0/255.0 green:84.0/255.0 blue:124.0/255.0 alpha:1.0]];
                                    [rippleEffect setRippleTrailColor:[UIColor colorWithRed:203.0/255.0 green:84.0/255.0 blue:124.0/255.0 alpha:0.5]];
                                    [self.view addSubview:rippleEffect];
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    radiusVal = lblSliderDistance.text.intValue;
                                    NSString *radiusString = [NSString stringWithFormat:@"%d",radiusVal];
                                    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                                    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
                                    [params setObject:radiusString forKey:@"distance"];
                                    [params setObject:@"1" forKey:@"user"];
                                    
                                    
                                    // [PGMeetingAction listfriends:params withCompletionBlock:^(bool success, id result, NSError *error)
                                    [PGNotification sendPingNotification:params withCompletionBlock:^(bool success, id result, NSError *error){
                                        if (success) {
                                            
                                            
                                            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerCalled) userInfo:nil repeats:NO];
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                        }
                                        else {
                                            
                                            [rippleEffect removeFromSuperview];
                                            NSLog(@"pingMeAction 222 -------------------%@",error.localizedDescription);
                                        }
                                    }];
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}




-(void)Pingfrinds{
    
    
    
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"PING"
                                 message:@"Check out who’s nearby?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"YES"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    //[self clearAllData];
                                    
                                    rippleEffect = [[LNBRippleEffect alloc]initWithImage:nil Frame:CGRectMake(self.view.frame.size.width-120, self.view.frame.size.height-120, 200, 200) Color:[UIColor colorWithRed:(28.0/255.0) green:(212.0/255.0) blue:(255.0/255.0) alpha:0] Target:nil ID:self];
                                    [rippleEffect setRippleColor:[UIColor colorWithRed:203.0/255.0 green:84.0/255.0 blue:124.0/255.0 alpha:1.0]];
                                    [rippleEffect setRippleTrailColor:[UIColor colorWithRed:203.0/255.0 green:84.0/255.0 blue:124.0/255.0 alpha:0.5]];
                                    [self.view addSubview:rippleEffect];
                                    
                                    radiusVal = lblSliderDistance.text.intValue;
                                    NSString *radiusString = [NSString stringWithFormat:@"%d",radiusVal];
                                    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                                    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
                                    [params setObject:radiusString forKey:@"distance"];
                                    [params setObject:@"0" forKey:@"user"];
                                    
                                    // [PGMeetingAction listfriends:params withCompletionBlock:^(bool success, id result, NSError *error)
                                    [PGNotification sendPingNotification:params withCompletionBlock:^(bool success, id result, NSError *error){
                                        if (success) {
                                            
                                            
                                            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerCalled) userInfo:nil repeats:NO];
                                            
                                            
                                        }
                                        else {
                                            
                                            
                                            [rippleEffect removeFromSuperview];
                                            NSLog(@"pingMeAction 222 -------------------%@",error.localizedDescription);
                                        }
                                    }];
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)timerCalled
{
    
    
    
    [rippleEffect removeFromSuperview];
    //    UIAlertController * alert = [UIAlertController
    //                                 alertControllerWithTitle:@"Ping"
    //                                 message:@"Ping Me sent successfully"
    //                                 preferredStyle:UIAlertControllerStyleAlert];
    //    //Add Buttons
    //
    //    UIAlertAction* yesButton = [UIAlertAction
    //                                actionWithTitle:@"Ok"
    //                                style:UIAlertActionStyleDefault
    //                                handler:^(UIAlertAction * action) {
    //                                    //Handle your yes please button action here
    //
    //
    //                                }];
    //
    //
    //
    //    //Add your buttons to alert controller
    //
    //    [alert addAction:yesButton];
    //
    //
    //    [self presentViewController:alert animated:YES completion:nil];
    
    
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

- (IBAction)profileViewAction:(id)sender
{
    
    PGProfileTableViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PGProfileTableViewController"];
    profileVC.passString = nil;
    [self.navigationController pushViewController:profileVC animated:true];
    
}

- (void)passLocationtargetAction:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"passLocationtarget"])
    {
        NSDictionary* userInfo = notification.userInfo;
        radiusPassString = (NSString *)userInfo[@"radiusLoc"];
        geoFenceCircle.radius = [radiusPassString intValue] * 1000;
        
    }
}

@end
