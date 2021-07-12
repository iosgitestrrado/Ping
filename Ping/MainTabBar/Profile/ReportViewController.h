//
//  ReportViewController.h
//  Ping
//
//  Created by Monish M S on 16/08/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPDropMenu.h"
#import "PGFriends.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
@protocol ChildViewControllerDelegate <NSObject>

- (void)childViewControllerFlagChange;

@end

@interface ReportViewController : UIViewController<UITextViewDelegate>{
    BOOL    isStatusBarHidden;
    NSString *reportType;
}
@property (nonatomic, weak) IBOutlet KPDropMenu *drop;
@property (nonatomic, weak) IBOutlet UITextView *comments;
@property (nonatomic, weak) IBOutlet UIView *commentView;
@property (weak, nonatomic) NSDictionary * passString;
@property (nonatomic, weak) id<ChildViewControllerDelegate> delegate;
@end

