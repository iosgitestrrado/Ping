//
//  CreateeventConfirmViewController.h
//  Ping
//
//  Created by Monish M S on 17/04/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNRadioButtonGroup.h"
#import "NKColorSwitch.h"
#import <CoreLocation/CoreLocation.h>

@interface CreateeventConfirmViewController : UITableViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate, CLLocationManagerDelegate,UICollectionViewDelegateFlowLayout>

{
      NSString *strEvery;
    NSString *pickerSelect;
    
     NSString *locLatString, *locLangString;
    NSMutableArray *years;
    NSMutableArray *monthsArray;
      NSMutableArray *yearsArray;
    NSDateComponents * currentDateComponents;
    UIDatePicker *datePicker;
    UIDatePicker *datePicker1;
    UIPickerView * myPickerView ;
    CLLocationManager *locationManager;
    CLLocation        *currentLocation;
    double CURRENT_LATITUDE;
    double CURRENT_LONGITUDE ;  
    NSString *CURRENT_ADDRESS;
    
    NSString *lat;
    NSString *lon;
}
@property (nonatomic, strong) TNRadioButtonGroup *everyGroup;
@property (nonatomic, strong) IBOutlet NKColorSwitch *nkColorSwitch;
@property (nonatomic, strong) IBOutlet NKColorSwitch *nkColorSwitch2;
@property (weak, nonatomic) IBOutlet UICollectionView *FriendsCollectionView;
@property (nonatomic, strong )NSString *selectDate;
@property (nonatomic, strong )NSMutableArray *selectFriendsArray;
@property (weak, nonatomic) IBOutlet UITextField *whereField;
@property (weak, nonatomic) IBOutlet UITextField *descField;
@property (weak, nonatomic) IBOutlet UITextField *endDateDayField;
@property (weak, nonatomic) IBOutlet UITextField *endDateWeekField;
@property (weak, nonatomic) IBOutlet UITextField *endDateMonthField;
@property (weak, nonatomic) IBOutlet UITextField *endDateYearField;
@property (weak, nonatomic) IBOutlet UIView *everyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FriendsContentViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UILabel *DateCreateField;
@property (nonatomic, retain) NSString * curDate;
@property (nonatomic, retain) NSString * starttimeDate;
@property (nonatomic, retain) NSString * endTimeDate;

- (void)getCurrentLocation;

@end
