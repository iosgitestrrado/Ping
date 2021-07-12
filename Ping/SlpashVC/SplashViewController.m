//
//  SplashViewController.m
//  Ping
//
//  Created by Monish M S on 13/06/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ping+"]) {
    UIImage *overlayImage = [UIImage imageNamed:@"SplashScreen"];

        [self.ImageView setImage:overlayImage];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
      [super viewWillAppear:animated];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ping+"]) {
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self passFuctionality];
        });


    } else {
        [self passFuctionality];
    }
    
    
    
    
}




-(void) passFuctionality {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetails"] != nil)
    {
        NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserDetails"];
        NSDictionary *dictLog = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [PGUser setValueInObject:dictLog];
        
        if ([[[PGUser currentUser] active] isEqualToString:@"1"])
        {
          [self performSegueWithIdentifier:@"homeIdSegue" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"loginIdSegue" sender:self];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"loginIdSegue" sender:self];
    }
    
    
}


@end
