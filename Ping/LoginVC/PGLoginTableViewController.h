//
//  PGLoginTableViewController.h
//  Ping
//
//  Created by Monish M S on 25/11/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGForgotPasswordTableViewController.h"
#import "AppDelegate.h"


@interface PGLoginTableViewController : UITableViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    
 UIPickerView *categoryPickerView;
}

@property (nonatomic, retain) UIPickerView *categoryPickerView;

@end
