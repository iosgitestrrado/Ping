//
//  MovingEventViewController.h
//  Ping
//
//  Created by Monish M S on 13/03/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWeekViewDecoratorFactory.h"


@interface MovingEventViewController : UIViewController<MSWeekViewDelegate, MSWeekViewDragableDelegate,MSWeekViewNewEventDelegate, MSWeekViewInfiniteDelegate,UIPopoverPresentationControllerDelegate,EKEventEditViewDelegate>{
    
    NSArray* unavailableHours;
    BOOL unidate;
      NSMutableArray* eventslist;
    
}
@property (strong,nonatomic) NSMutableArray *arrayPassEventFree;
@property (strong,nonatomic) NSMutableDictionary *arrayPassEventMain;
@property (weak, nonatomic) IBOutlet MSWeekView *weekView;
@property (strong, nonatomic) MSWeekView *decoratedWeekView;
@property (strong,nonatomic) NSDate *passdate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@end
