//
//  PGDayTableViewController.h
//  Ping
//
//  Created by Monish M S on 04/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGDayTableViewController : UITableViewController
{
    UIButton *pickerButton;
    UIDatePicker *myPickerViewStart, *myPickerViewEnd;
    
    NSMutableArray *array_from;
    UILabel *fromButton;
    
    UIButton *doneButton ;
    UIButton *backButton ;
    UIView *  myView10;
    UIButton *OKButton;
 
 UIView *myView,*myBackView;

    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ContentViewHeight;
@end
