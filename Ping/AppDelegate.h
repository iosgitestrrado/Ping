//
//  AppDelegate.h
//  Ping
//
//  Created by Monish M S on 25/11/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGServiceManager.h"
#import "IQKeyboardManager.h"
#import <EventKitUI/EventKitUI.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "ISMessages.h"
#import <CoreLocation/CoreLocation.h>
@import GooglePlaces;



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) NSInteger starttimeApp;
@property (assign, nonatomic) NSInteger endtimeApp;
@property (assign, nonatomic) NSInteger indexValue;
@property (assign, nonatomic) NSString * chatIdOnfire;
@property (assign, nonatomic) NSString * badgeValue;
@property (assign, nonatomic) NSString * updateNeeded;

@property (assign, nonatomic) BOOL chatPage;



@end

