//
//  CreateEventViewController.h
//  Ping
//
//  Created by Monish M S on 17/04/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>



@interface CreateEventViewController : UIViewController <JTCalendarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
   

    
     IBOutlet UIDatePicker *myPickerViewStart;
     IBOutlet UIView *myView;
    IBOutlet UIView *blurView;
    NSString *passString;
    
     IBOutlet UIDatePicker *myPickerViewEnd;
    NSDate *dateStart;
    NSDate *dateEnd;
}



@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet UICollectionView *FriendsCollectionView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet UIButton *monthButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *friendContentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *friendsearchHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freeslotHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalHeight;
@property (weak, nonatomic) IBOutlet UILabel * selecttime ;

@property (weak, nonatomic) IBOutlet UIScrollView * mainscroll ;
@property (nonatomic, retain) NSDate * curDate;
@property (nonatomic, retain) NSDateFormatter * formatter;

@property (weak, nonatomic) IBOutlet UISearchBar *addFriendsSearch;

@property (weak, nonatomic) IBOutlet UIButton *arrowButton;


@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UILabel *nofriendsLbl;

@end
