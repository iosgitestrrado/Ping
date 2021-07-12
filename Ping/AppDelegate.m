//
//  AppDelegate.m
//  Ping
//
//  Created by Monish M S on 25/11/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "AppDelegate.h"
#import "PGUser.h"
#import <UserNotifications/UserNotifications.h>
#import "PGEvent.h"
@import GoogleMaps;



// define macro
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@import GooglePlaces;

@interface AppDelegate () <UIApplicationDelegate,UNUserNotificationCenterDelegate>
{
    BOOL reloadIos;
    NSTimer *t;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [Fabric with:@[[Crashlytics class]]];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [IQKeyboardManager sharedManager].enable =YES;
    [GMSServices provideAPIKey:@"AIzaSyD35aTeUbgkvx2FFgraRUTSYhNGhUr6PjA"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyD35aTeUbgkvx2FFgraRUTSYhNGhUr6PjA"];
    [GIDSignIn sharedInstance].clientID = @"32322554715-bnavsac0ea5flugj76ec1e3sns511kfu.apps.googleusercontent.com";
    UINavigationBar.appearance.barTintColor = [UIColor colorWithRed:85.0/255.0 green:82./255.0 blue:93.0/255.0 alpha:1.0];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HOMETUTORIAL"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CHATTUTORIAL"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PINGOUTTUTORIAL"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NEARMETUTORIAL"];
    UINavigationBar.appearance.tintColor = [UIColor whiteColor];
    UISearchBar.appearance.barStyle = UIBarStyleDefault;
    
    //    [[UINavigationBar appearance] setTitleTextAttributes:
    //     [NSDictionary dictionaryWithObjectsAndKeys:
    //      [UIColor whiteColor], NSForegroundColorAttributeName,
    //      [UIFont fontWithName:@"Lato-Bold" size:18.0], NSFontAttributeName,nil]];
    reloadIos = false;
    _badgeValue =@"0";
    _chatPage = false;
    
    
    [self.window makeKeyAndVisible];
    
    
    
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [self recallNotifications];
        
    }
    else
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if( !error )
             {
                 
                 [self recallNotifications];
                 
                 
                 // required to get the app to do anything at all about push notifications
                 NSLog( @"Push registration success." );
             }
             else
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
             }
         }];
    }
    
    
    if (launchOptions != nil) {
        // Launched from push notification
        NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        NSDictionary *pushDict1 =[notification objectForKey:@"aps" ];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:pushDict1 forKey:@"apnsdata"];
        
    }else{
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"apnsdata"];
        
        
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}



-(void)online:(BOOL)status{
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] != nil) {
        
        
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        
        
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
        if (status) {
            [params setObject:@"1" forKey:@"is_online"];
        }else{
            [params setObject:@"0" forKey:@"is_online"];
        }
        
        
        
        [params setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"] forKey:@"accessToken"];
        
        
        
        
        [[PGServiceManager sharedManager] postDataFromService:@"user/online" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
         {
             NSLog(@"%@",result);
             
             
             
             
             if (success) {
                 
                 
                 
                 NSString *version =     [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
                 
                 NSString *versionfrom =  [NSString stringWithFormat:@"Version %@",[result valueForKey:@"version"]];
                 
                 NSString *p_plusfrom =  [NSString stringWithFormat:@"%@",[result valueForKey:@"p_plus"]];
                 NSString *ap_dev_status =  [NSString stringWithFormat:@"%@",[result valueForKey:@"ap_test_success"]];
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 if ([p_plusfrom isEqualToString:@"1"]) {
                     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ping+"];
                     
                     
                 }else{
                     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ping+"];
                 }
                 
                 
                 
                 if ([ap_dev_status isEqualToString:@"1"]) {
                     
                     
                     
                     
                     if (![version isEqualToString:versionfrom]) {
                         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Update Available"
                                                                                        message:@"A new version of Ping is available. Please update"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                         
                         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                               handler:^(UIAlertAction * action) {
                                                                                   
                                                                                   
                                                                                   
                                                                                   NSString *iTunesLink = @"itms://itunes.apple.com/us/app/ping-beta-socially-productive/id1413652722?ls=1&mt=8";
                                                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                                                                                   
                                                                                   
                                                                                   
                                                                                   
                                                                                   
                                                                                   
                                                                               }];
                         
                         [alert addAction:defaultAction];
                         
                         UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
                         while (topController.presentedViewController) {
                             topController = topController.presentedViewController;
                         }
                         
                         
                         
                         
                         
                         [topController presentViewController:alert animated:YES completion:nil];
                     }
                 }
                 
                 
                 
             }
         }];
        
        
        
    }
}





-(void)recallNotifications{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    });
    
}


-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void
                                                                                                                               (^)(UIBackgroundFetchResult))completionHandler
{
    // iOS 10 will handle notifications through other methods
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO( @"10.0" ) )
    {
        NSLog( @"iOS version >= 10. Let NotificationCenter handle this one." );
        // set a member variable to tell the new delegate that this is background
        return;
    }
    NSLog( @"HANDLE PUSH, didReceiveRemoteNotification: %@", userInfo );
    
    // custom code to handle notification content
    
    if( [UIApplication sharedApplication].applicationState == UIApplicationStateInactive )
    {
        NSLog( @"INACTIVE" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
    else if( [UIApplication sharedApplication].applicationState == UIApplicationStateBackground )
    {
        NSLog( @"BACKGROUND" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
    else
    {
        NSLog( @"FOREGROUND" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {
        
        
        
        
    }];
}




- (void)extractedBack:(NSDictionary *)pushDict {
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    [nc postNotificationName:@"badgeAction" object:self userInfo:nil];
    [nc postNotificationName:@"pushAction" object:self userInfo:pushDict];
    [nc postNotificationName:@"notificationReloaded" object:self userInfo:nil];
    
    
}


- (void)extracted:(NSDictionary *)pushDict {
    
    _updateNeeded  =  @"";
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"badgeAction" object:self userInfo:pushDict];
    if ([[pushDict objectForKey:@"type"] isEqualToString:@"chat"]){
        [nc postNotificationName:@"tabbarCount" object:self userInfo:nil];
    }
    
    else{
        if ([[pushDict objectForKey:@"type"] isEqualToString:@"pingme"]){
            
        }else{
            [nc postNotificationName:@"notificationReloaded" object:self userInfo:nil];
            
        }
    }
    
    NSString *strNotify = @"Ping Notification";
    
    UIImage *imageNotify = [UIImage imageNamed:@"PingMe"];
    
    if ([[pushDict objectForKey:@"type"] isEqualToString:@"request_friend"]) {
        strNotify = @"Friend Request";
        
        imageNotify = [UIImage imageNamed:@"friendrequest"];
        
        
        
        
    }
    
    else if ([[pushDict objectForKey:@"type"] isEqualToString:@"accept_friend"]) {
        strNotify = @"Accept Friend";
        
        imageNotify = [UIImage imageNamed:@"friendrequest"];
        
        
        
        
    }
    
    else if ([[pushDict objectForKey:@"type"] isEqualToString:@"meeting"])
    {
        
        strNotify = @"Meeting";
        
        imageNotify = [UIImage imageNamed:@"meeting"];
        
        
    }
    else if ([[pushDict objectForKey:@"type"] isEqualToString:@"delete meeting"])
    {
        
        strNotify = @"Delete Meeting";
        
        imageNotify = [UIImage imageNamed:@"meeting"];
        
        
    }
    
    
    
    
    
    else if ([[pushDict objectForKey:@"type"] isEqualToString:@"pingme"])
    {
        
        strNotify = @"Ping Me";
        
        imageNotify = [UIImage imageNamed:@"ping-mepush"];
        
        
    }
    else if ([[pushDict objectForKey:@"type"] isEqualToString:@"remind"])
    {
        
        strNotify = @"Reminder Event";
        
        imageNotify = [UIImage imageNamed:@"alarm-clock"];
        
        
    }
    else if ([[pushDict objectForKey:@"type"] isEqualToString:@"sugg_push"])
    {
        
        strNotify = @"Suggestive Push";
        
        imageNotify = [UIImage imageNamed:@"sugg_pushOn"];
        
        
    }
    
    else if ([[pushDict objectForKey:@"type"] isEqualToString:@"sugg_location"])
    {
        
        strNotify = @"Suggestive Location";
        
        imageNotify = [UIImage imageNamed:@"location-on-map"];
        
        
    }
    else if ([[pushDict objectForKey:@"type"] isEqualToString:@"chat"])
    {
        
        strNotify = @"Chat Message";
        
        imageNotify = [UIImage imageNamed:@"chatpush"];
        
        
    }
    else if ([[pushDict objectForKey:@"type"] isEqualToString:@"track"])
    {
        
        strNotify = @"Follow Friend";
        
        imageNotify = [UIImage imageNamed:@"push-pin-guide"];
        
        
    }
    
    
    ISMessages* alert = [ISMessages cardAlertWithTitle:strNotify
                                               message:[pushDict objectForKey:@"alert"]
                                             iconImage:imageNotify
                                              duration:3.f
                                           hideOnSwipe:NO
                                             hideOnTap:YES
                                             alertType:ISAlertTypeCustom
                                         alertPosition:ISAlertPositionTop];
    
    alert.titleLabelFont = [UIFont fontWithName:@"Lato-Regular" size:16.0];
    alert.titleLabelTextColor = [UIColor blackColor];
    
    alert.messageLabelFont = [UIFont fontWithName:@"Lato-Regular" size:14.0];
    alert.messageLabelTextColor = [UIColor grayColor];
    
    alert.alertViewBackgroundColor =[UIColor whiteColor];
    
    [alert show:^{
        [nc postNotificationName:@"pushAction" object:self userInfo:pushDict];
        
    } didHide:nil];
    
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSDictionary *pushDict =[notification.request.content.userInfo objectForKey:@"aps" ];
    if ([[pushDict objectForKey:@"type"] isEqualToString:@"chat"])
    {
        _badgeValue = @"";
    }else{
        _badgeValue = [NSString stringWithFormat:@"%@",[pushDict objectForKey:@"badge"]];    }
    
    if (_chatPage) {
        
        if ([[pushDict objectForKey:@"type"] isEqualToString:@"chat"])
        {
            NSDictionary* key = [pushDict objectForKey:@"detail"];
            
            
            
            if ([_chatIdOnfire isEqualToString:[key objectForKey:@"chat_id"]])
            {
                
                NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                [nc postNotificationName:@"chatonfireAction" object:self userInfo:pushDict];
            }else{
                
                
                [self extracted:pushDict];
                
            }
            
            
        }else{
            
            [self extracted:pushDict];
        }
        
        
    }else{
        
        [self extracted:pushDict];
        
        
    }
    
    
    
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    
    NSDictionary *pushDict =[response.notification.request.content.userInfo objectForKey:@"aps" ];
    
    _badgeValue = [NSString stringWithFormat:@"%@",[pushDict objectForKey:@"badge"]];
    
    if (_chatPage) {
        if ([[pushDict objectForKey:@"type"] isEqualToString:@"chat"])
        {
            
            
            
            
            NSDictionary* key = [pushDict objectForKey:@"detail"];
            
            
            
            if ([_chatIdOnfire isEqualToString:[key objectForKey:@"chat_id"]])
            {
                
                NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                [nc postNotificationName:@"chatonfireAction" object:self userInfo:pushDict];
            }else{
                [self extractedBack:pushDict];
                
            }
            
            
            
            
        }else{
            
            [self extractedBack:pushDict];
            
            
        }
    }else{
        
        [self extractedBack:pushDict];
        
        
    }
    
    
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *absoluteToken=[token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:absoluteToken forKey:@"device_token"];
    NSLog(@"%@",[defaults objectForKey:@"device_token"]);
    [defaults synchronize];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    reloadIos = false;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] != nil) {
        [self online:NO];
        [t invalidate];
        t = nil;
    }
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
    
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] != nil) {
        [self online:YES];
        [self fetchEventsIos];
        
        if (t == nil) {
            [self updateUserLocation];
            
            t = [NSTimer scheduledTimerWithTimeInterval: 300
                                                 target: self
                                               selector:@selector(updateUserLocation)
                                               userInfo: nil repeats:YES];
        }
        
        
        
    }
    
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
-(void) updateUserLocation{
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] != nil) {
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            
            
            
            CLLocationManager *locationManager = [[CLLocationManager alloc] init];
            locationManager.distanceFilter = kCLDistanceFilterNone;
            //locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
            [locationManager startUpdatingLocation];
            locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation;
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
            NSString* latString = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
            NSString* longString = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
            NSLog(@"latString-------%@",latString);
            NSLog(@"longString-------%@",longString);
            [params setObject:latString  forKey:@"latitude"];
            [params setObject:longString forKey:@"longitude"];
            [params setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"] forKey:@"accessToken"];
            [PGUser updateUserLocation:params withCompletionBlock:^(bool success, id result, NSError *error){
                
                if (success) {
                
                
                
                NSString *login_status =  [NSString stringWithFormat:@"%@",[result valueForKey:@"is_login"]];
                
                if ([login_status isEqualToString:@"0"]) {
                    
                    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ping+"]) {
                        [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
                            NSLog(@"error = %@", error.localizedDescription);
                        }];
                    }
                    NSString *str =   [[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"];
                    
                    
                    
                    
                    
                    
                    
                    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
                    NSDictionary * dict = [defs dictionaryRepresentation];
                    for (id key in dict) {
                        [defs removeObjectForKey:key];
                    }
                    [defs synchronize];
                    
                    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                    [defaults setValue:str forKey:@"device_token"];
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                             bundle: nil];
                    UINavigationController *homeVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainLogNav"];
                    [UIApplication sharedApplication].keyWindow.rootViewController = homeVC;
                    
                    
                }
                }
                
            }];
            
            
        });
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DateValueChange"];
    
}

-(void) fetchEventsIos{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] != nil) {
        
        EKEventStore *store = [[EKEventStore alloc] init];
        
        
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        
        if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)])
        {
            
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
             {
                 if ( granted )
                 {
                     NSLog(@"User has granted permission!");
                     // Create the start date components
                     NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
                     oneDayAgoComponents.day = -1;
                     NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                                   toDate:[NSDate date]
                                                                  options:0];
                     
                     
                     NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
                     oneYearFromNowComponents.year = 1;
                     NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                                        toDate:[NSDate date]
                                                                       options:0];
                     
                     // Create the predicate from the event store's instance method
                     NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                                             endDate:oneYearFromNow
                                                                           calendars:[store calendarsForEntityType:EKEntityTypeEvent]];
                     
                     NSArray *events = [store eventsMatchingPredicate:predicate];
                     
                     
                     
                     NSMutableArray *tempdata = [NSMutableArray new];
                     
                     
                     
                     for (EKEvent *eventdata in events) {
                         
                         
                         if (![[NSString stringWithFormat:@"%@", eventdata.title] containsString:@"birthday"]) {
                             
                             
                             
                             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                             [dateFormatter setDateFormat:@"HH:mm"];
                             NSString *formattedStratDateString = [dateFormatter stringFromDate:eventdata.startDate];
                             NSString *formattedEndDateString = [dateFormatter stringFromDate:eventdata.endDate];
                             [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                             NSString *formattedDateString = [dateFormatter stringFromDate:eventdata.startDate];
                             
                             if ([formattedStratDateString isEqualToString:@"00:00"]&&[formattedEndDateString isEqualToString:@"23:59"]) {
                                 NSDictionary* dictNum = @{@"title":[NSString stringWithFormat:@"%@", eventdata.title] ,@"location": [NSString stringWithFormat:@"%@",eventdata.location],@"date": formattedDateString,@"startTime": formattedStratDateString,@"endTime": formattedEndDateString,@"fullEvent": @"1"};
                                 
                                 [tempdata addObject:dictNum];
                             }else{
                                 NSDictionary* dictNum = @{@"title":[NSString stringWithFormat:@"%@", eventdata.title] ,@"location": [NSString stringWithFormat:@"%@",eventdata.location],@"date": formattedDateString,@"startTime": formattedStratDateString,@"endTime": formattedEndDateString,@"fullEvent": @"0"};
                                 [tempdata addObject:dictNum];
                                 
                             }
                             
                             
                             
                         }
                     }
                     
                     
                     NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                     [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
                     
                     NSArray *array = [[NSArray alloc] initWithArray:tempdata];
                     
                     
                     
                     NSData *jsonDataFriendsAdd = [NSJSONSerialization dataWithJSONObject:array
                                                                                  options:NSJSONWritingPrettyPrinted error:&error];
                     NSString *jsonStringFriendsAdd = [[NSString alloc] initWithData:jsonDataFriendsAdd encoding:NSUTF8StringEncoding];
                     
                     
                     [params setObject:jsonStringFriendsAdd forKey:@"events"];
                     
                     
                     [PGEvent fetchIosEventWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
                      {
                          
                      }];
                 }
                 
                 else
                 {
                     NSLog(@"User has not granted permission!");
                 }
             }];
        }
    }
}


@end
