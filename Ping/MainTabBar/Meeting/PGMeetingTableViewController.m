//
//  PGMeetingTableViewController.m
//  Ping
//
//  Created by Monish M S on 27/11/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGMeetingTableViewController.h"
#import "PGTrackViewController.h"
#import "CAPopUpViewController.h"
#import "PGMeetingCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PGEvent.h"
#import "PGMeetingAction.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import "DBChatAvatarView.h"
#import "MovingEventViewController.h"
#import "PGMeetingTrackViewController.h"

@interface PGMeetingTableViewController ()<UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,CAAnimationDelegate,DBChatAvatarViewDataSource>
{
    NSArray *arrayImg;
    BOOL isdropDown, isMainDown, isViewDown;
    NSMutableArray *arrayPassEvents, *arrayPassMainEvent, *arraymembermeeting, *arrayPushSwapMain,*pushSwapMutArray;
    int rowHeight, suggestRowHeight;
    NSInteger arrayCount;
    NSDate *time1;
    NSString *stTime;
    NSDate *time2;
    NSString *enTime;
    NSString *curDate;
    NSString *stDate;
    NSDate *strDte;
    NSDate *toDate;
    BOOL ackknowledgement;
    NSArray *strtrack;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *mapImgView;
@property (weak, nonatomic) IBOutlet UIView *meetingMainView;
@property (weak, nonatomic) IBOutlet UIView *meetingMainViewlocation;
@property (weak, nonatomic) IBOutlet UICollectionView *meetingCollectionView;
@property (weak, nonatomic) IBOutlet UIView *suggestionVIew;
@property (weak, nonatomic) IBOutlet UIView *upDownView;
@property (weak, nonatomic) IBOutlet UIButton *upDownButton;
@property (weak, nonatomic) IBOutlet UIImageView *upDownImage;

@property (weak, nonatomic) IBOutlet UIView *memberOverCount;
@property (weak, nonatomic) IBOutlet UILabel *memberOverCountLbl;



@property (weak, nonatomic) IBOutlet DBChatAvatarView *vwAvatarView;


@property (weak, nonatomic) IBOutlet UIView *collectionDupView;
@property (weak, nonatomic) IBOutlet UIButton *locateButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerRowHeight;
@property (weak, nonatomic) IBOutlet UIButton *expanButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicMain;
@property (weak, nonatomic) IBOutlet UILabel *descLabelMAin;
@property (weak, nonatomic) IBOutlet UILabel *dayLabelMain;
@property (weak, nonatomic) IBOutlet UILabel *timeLabelMain;
@property (weak, nonatomic) IBOutlet UILabel *meetingTitile;
@property (weak, nonatomic) IBOutlet UIButton *reminfBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *trackBtn;
@property (weak, nonatomic) IBOutlet UIView *editDeleteView;
@property (weak, nonatomic) IBOutlet UIView *pushSwapView;


@property (weak, nonatomic) IBOutlet UIView *maineventHiddenVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationWidth;



@property (nonatomic, weak) IBOutlet UITableView *mainTableView;
@property (nonatomic) BOOL useCustomCells;

@end

@implementation PGMeetingTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrayPassEvents = [NSMutableArray new];
    arrayPassMainEvent = [NSMutableArray new];
    arraymembermeeting = [NSMutableArray new];
    
    // [self.meetingMainView.layer setCornerRadius:5.0f];
    isdropDown= false;
    isMainDown = false;
    isViewDown = true;
    ackknowledgement =  false;
    self.vwAvatarView.chatAvatarDataSource = self;
    
    rowHeight = 0;
    suggestRowHeight = 0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    [tapGesture setNumberOfTapsRequired:1.0];
    [self.mapImgView addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer *recognizerRight;
    recognizerRight.delegate = self;
    
    recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.meetingMainView addGestureRecognizer:recognizerRight];
    
    UISwipeGestureRecognizer *recognizerLeft;
    recognizerLeft.delegate=self;
    recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.meetingMainView addGestureRecognizer:recognizerLeft];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(eventInfoNotification:) name:@"eventInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(heightInfoNotification:) name:@"heightInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(suggestHeightInfoNotification:) name:@"suggestHeightInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(mainArrayEventInfoNotification:) name:@"mainArrayEventInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(mainArraySugggesionInfoNotification:) name:@"firefromsuggession" object:nil];
    [_upDownImage setImage:[UIImage imageNamed:@"GroupDown"]];
    
    
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(viewExpandInfoNotification:) name:@"ViewExpandInfo" object:nil];
    
    arrayImg = @[@"ChatIcon",@"ChatIcon",@"ChatIcon",@"ChatIcon"];
}

-(void)swipeRight: (UISwipeGestureRecognizer *)swipe
{
    
    
    
    if ([[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"ios_event"]||[[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"google_event"])
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"This event was created externally. Please select a ping and try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        
        
        
    }else{
        
        NSDate *today = [NSDate date];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSString *todayString = [format stringFromDate:today];
        
        NSDate *todayDate = [format dateFromString:todayString];
        
        
        NSDate *newDate = [format dateFromString:[NSString stringWithFormat:@"%@ %@",[arrayPassMainEvent valueForKey:@"start_date"],[arrayPassMainEvent valueForKey:@"start_time"]]];
        NSComparisonResult result;
        
        
        result = [todayDate compare:newDate];
        
        if(result!=NSOrderedDescending)
            
        {
            
            if ([[NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"repeat_event"]] isEqualToString:@"1"] )
                
            {
                
                if (self.meetingMainView.frame.origin.x == -60)
                {
                    [UIView animateWithDuration:0.33f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                                     animations:^{
                                         [self.meetingMainView setFrame:self.meetingMainView.frame];
                                         [self.meetingMainView setFrame:CGRectMake(16, self.meetingMainView.frame.origin.y, self.meetingMainView.frame.size.width, self.meetingMainView.frame.size.height)];
                                     }
                                     completion:^(BOOL finished)
                     {
                         // do whatever post processing you want (such as resetting what is "current" and what is "next")
                     }];
                }else{
                    
                    
                    
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Unable to push or swap a recurring ping." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                               handler:nil];
                    [alertController addAction:ok];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                
            }else{
                
                
                
                
                
                
                if (self.meetingMainView.frame.origin.x == -60)
                {
                    [UIView animateWithDuration:0.33f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                                     animations:^{
                                         [self.meetingMainView setFrame:self.meetingMainView.frame];
                                         [self.meetingMainView setFrame:CGRectMake(16, self.meetingMainView.frame.origin.y, self.meetingMainView.frame.size.width, self.meetingMainView.frame.size.height)];
                                     }
                                     completion:^(BOOL finished)
                     {
                         // do whatever post processing you want (such as resetting what is "current" and what is "next")
                     }];
                }
                else
                {
                    [UIView animateWithDuration:0.33f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                                     animations:^{
                                         [self.meetingMainView setFrame:self.meetingMainView.frame];
                                         [self.meetingMainView setFrame:CGRectMake(80, self.meetingMainView.frame.origin.y, self.meetingMainView.frame.size.width, self.meetingMainView.frame.size.height)];
                                     }
                                     completion:^(BOOL finished)
                     {
                         // do whatever post processing you want (such as resetting what is "current" and what is "next")
                     }];
                }
                
                
            }
        }else{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING COMPLETED" message:@"This event was created by an external application. Please select a ping and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            
            
        }
        
    }
}

-(void)swipeLeft: (UISwipeGestureRecognizer *)swipe
{
    NSDate *today = [NSDate date];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *todayString = [format stringFromDate:today];
    
    NSDate *todayDate = [format dateFromString:todayString];
    
    
    NSDate *newDate = [format dateFromString:[NSString stringWithFormat:@"%@ %@",[arrayPassMainEvent valueForKey:@"start_date"],[arrayPassMainEvent valueForKey:@"start_time"]]];
    NSComparisonResult result;
    
    
    result = [todayDate compare:newDate];
    
    if(result!=NSOrderedDescending)
        
    {
        if ([[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"ios_event"]||[[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"google_event"])
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"This event was created externally. Please select a ping and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            
            
            
            
        }else{
            if (![[NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"repeat_event"]] isEqualToString:@"1"] )
                
            {
                
                if (self.meetingMainView.frame.origin.x == 80)
                {
                    [UIView animateWithDuration:0.33f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                                     animations:^{
                                         [self.meetingMainView setFrame:self.meetingMainView.frame];
                                         [self.meetingMainView setFrame:CGRectMake(16, self.meetingMainView.frame.origin.y, self.meetingMainView.frame.size.width, self.meetingMainView.frame.size.height)];
                                     }
                                     completion:^(BOOL finished)
                     {
                         // do whatever post processing you want (such as resetting what is "current" and what is "next")
                     }];
                }
                else
                {
                    [UIView animateWithDuration:0.33f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                                     animations:^{
                                         [self.meetingMainView setFrame:self.meetingMainView.frame];
                                         [self.meetingMainView setFrame:CGRectMake(-60, self.meetingMainView.frame.origin.y, self.meetingMainView.frame.size.width, self.meetingMainView.frame.size.height)];
                                     }
                                     completion:^(BOOL finished)
                     {
                         // do whatever post processing you want (such as resetting what is "current" and what is "next")
                     }];
                }
                
                
            }else{
                
                if (self.meetingMainView.frame.origin.x == -60)
                {
                    [UIView animateWithDuration:0.33f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                                     animations:^{
                                         [self.meetingMainView setFrame:self.meetingMainView.frame];
                                         [self.meetingMainView setFrame:CGRectMake(16, self.meetingMainView.frame.origin.y, self.meetingMainView.frame.size.width, self.meetingMainView.frame.size.height)];
                                     }
                                     completion:^(BOOL finished)
                     {
                         // do whatever post processing you want (such as resetting what is "current" and what is "next")
                     }];
                }
                else
                {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Unable to edit or delete a recurring ping." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                               handler:nil];
                    [alertController addAction:ok];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                }
            }
            
        }
    }else{
        
        
        
        
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING COMPLETED" message:@"This meeting has occurred in the past and therefore cannot be deleted or edited." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        
        
    }
    
    
    
    
    
    
}



-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        
        
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            
            
            
        }
        else
        {
            
            
            self.reminfBtn.frame = CGRectMake(self.reminfBtn.bounds.origin.x, self.reminfBtn.bounds.origin.y, 40, 40);
            self.chatBtn.frame = CGRectMake(self.chatBtn.bounds.origin.x, self.chatBtn.bounds.origin.y, 40, 40);
            self.trackBtn.frame = CGRectMake(self.trackBtn.bounds.origin.x, self.trackBtn.bounds.origin.y, 40, 40);
            
        }
    }
    else
    {
        //[ipad]
    }
}



-(void)viewExpandInfoNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"ViewExpandInfo"])
    {
        NSDictionary* userInfo = notification.userInfo;
        NSString *expandViewString = userInfo[@"ViewString"];
        if ([expandViewString isEqualToString:@"NeedView"])
        {
            isdropDown = true;
            [_upDownImage setImage:[UIImage imageNamed:@"GroupUp"]];
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }
        else
        {
            isdropDown = false;
            [_upDownImage setImage:[UIImage imageNamed:@"GroupDown"]];
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }
    }
}


-(void)eventInfoNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"eventInfo"])
    {
        NSDictionary* userInfo = notification.userInfo;
        arrayPassEvents = (NSMutableArray *)userInfo[@"arrayPass"];
        arrayPassMainEvent = (NSMutableArray *)userInfo[@"arrayMainEvent"];
        
        if (arrayPassMainEvent.count>0) {
            NSArray *str = [arrayPassMainEvent valueForKey:@"trackRequest"];
            arrayCount = str.count;
            
            NSString *strFunctinality =(NSString *)userInfo[@"functinality"];
            if (strFunctinality) {
                
                
                if (![strFunctinality isEqualToString:@""]) {
                    
                    isdropDown = true;
                    [_upDownImage setImage:[UIImage imageNamed:@"GroupUp"]];
                    [self.tableView beginUpdates];
                    [self.tableView endUpdates];
                    
                }
            }
            
            [self setDetails];
        }else{
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }
        
    }
}



-(void)heightTrackNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"TrackHeightInfo"])
    {
        int pass = [[[notification userInfo] valueForKey:@"totalHeight"] intValue];
        //  NSLog (@"Successfully received test notification! %i", pass);
        rowHeight = pass;
        
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        isdropDown= false;
        
        
        
        //  [self viewDidLayoutSubviews];
    }
}




-(void)heightInfoNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"heightInfo"])
    {
        int pass = [[[notification userInfo] valueForKey:@"totalHeight"] intValue];
        //  NSLog (@"Successfully received test notification! %i", pass);
        rowHeight = pass;
        
        [_upDownImage setImage:[UIImage imageNamed:@"GroupDown"]];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        isdropDown= false;
        
    }
}

-(void)mainArrayEventInfoNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"mainArrayEventInfo"])
    {
        NSDictionary* userInfo = notification.userInfo;
        arrayPassMainEvent = (NSMutableArray *)userInfo[@"mainArrayPass"];
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        [self passMainArrayChange];
        
        
        
    }
}
-(void)mainArraySugggesionInfoNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"firefromsuggession"])
    {
        
        
        arrayCount= arrayCount - 1 ;
        [self.tableView reloadData];
        
    }
}





-(void)passMainArrayChange
{
    NSDictionary* userInfo = @{@"mainArrayPassChange": arrayPassMainEvent};
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"mainArrayChangeEventInfo" object:self userInfo:userInfo];
}

-(void)suggestHeightInfoNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"suggestHeightInfo"])
    {
        int pass = [[[notification userInfo] valueForKey:@"totalHeightSuggest"] intValue];
        //   NSLog (@"Successfully received test notification! %i", pass);
        
        
        
        suggestRowHeight = pass;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        //[self viewDidLayoutSubviews];
    }
}

-(void)setDetails
{
    NSDictionary* userInfo = @{@"total": arrayPassMainEvent};
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"eRXReceived" object:self userInfo:userInfo];
    
    NSMutableArray *arrayMember = [NSMutableArray new];
    
    
    
    arraymembermeeting = [arrayPassMainEvent valueForKey:@"mambers"];
    if (!arraymembermeeting || !arraymembermeeting.count)
    {
        [self.meetingCollectionView reloadData];
        
    }
    else
    {
        [self.meetingCollectionView reloadData];
    }
    // [self.meetingCollectionView reloadData];
    if ([[NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"view_rmd_flag"]] isEqualToString:@"0"])
    {
        ackknowledgement     = false;
        
    }else{
        
        ackknowledgement     = true;
        
    }
    if (arrayPassMainEvent.count>0) {
        
        NSNumber *someNumber = [NSNumber numberWithInteger:1];
        NSInteger value =[[arrayPassMainEvent valueForKey:@"group_flag"]integerValue];
        
        
        NSNumber *someNumber1 = [NSNumber numberWithInteger:value];
        //self.reminfBtn
        
        
        if ([[arrayPassMainEvent valueForKey:@"location"] isEqualToString:@""]) {
            
            _trackBtn.hidden = YES;
            _meetingMainViewlocation.hidden = YES;
            _locationWidth.constant = 0;
            
        }else{
            _meetingMainViewlocation.hidden = NO;
            _locationWidth.constant = 100;
            _trackBtn.hidden = NO;
            
        }
        
        
        
        if (![someNumber1 isEqual:someNumber]) {
            self.reminfBtn.hidden = YES;
            self.chatBtn.hidden = YES;
            self.trackBtn.hidden = YES;
            
            
            
            
            if ([[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"single_event"]||[[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"ping_meeting"]) {
                
                self.reminfBtn.hidden = NO;
                self.chatBtn.hidden = NO;
                self.trackBtn.hidden = NO;
                
                if ([[arrayPassMainEvent valueForKey:@"location"] isEqualToString:@""]) {
                    
                    _trackBtn.hidden = YES;
                    
                    
                }
            }
        }else{
            
            self.reminfBtn.hidden = NO;
            self.chatBtn.hidden = NO;
            self.trackBtn.hidden = NO;
            
            
            
            if ([[arrayPassMainEvent valueForKey:@"location"] isEqualToString:@""]) {
                
                _trackBtn.hidden = YES;
                
                
            }else{
                
                _trackBtn.hidden = NO;
                
            }
            
            if (arraymembermeeting.count>0)
            {
                
                
            }else{
                
                self.reminfBtn.hidden = YES;
                
                self.trackBtn.hidden = YES;
            }
            
            
            
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        NSDate *today = [NSDate date];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSString *todayString = [format stringFromDate:today];
        
        NSDate *todayDate = [format dateFromString:todayString];
        
        
        NSDate *newDate = [format dateFromString:[NSString stringWithFormat:@"%@ %@",[arrayPassMainEvent valueForKey:@"start_date"],[arrayPassMainEvent valueForKey:@"start_time"]]];
        NSComparisonResult result;
        
        
        result = [todayDate compare:newDate];
        
        if(result==NSOrderedDescending)
            
        {
            
            
            self.reminfBtn.hidden = YES;
            
            
            if (!self.trackBtn.hidden){
                
                self.trackBtn.hidden = YES;
                
            }
            
            
            
            
        }
        
        NSDate *newDate1 = [format dateFromString:[NSString stringWithFormat:@"%@ %@",[arrayPassMainEvent valueForKey:@"start_date"],[arrayPassMainEvent valueForKey:@"end_time"]]];
        NSComparisonResult result1;
        
        
        result1 = [todayDate compare:newDate1];
        
        if(result1==NSOrderedDescending)
            
        {
            
            
            
            if ([someNumber1 isEqual:someNumber]) {
                self.chatBtn.hidden = YES;
            }
            
            
            
            
            
        }
        
        
        
        
        
        if ([[NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"chated"]] isEqualToString:@"1"])
        {
            [self.chatBtn setBackgroundImage:[UIImage imageNamed:@"ChatPinkIcon"] forState:UIControlStateNormal];
        }
        else
        {
            [self.chatBtn setBackgroundImage:[UIImage imageNamed:@"ChatIcon"] forState:UIControlStateNormal];
        }
        
        
        if ([[NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"remind_flag"]] isEqualToString:@"1"])
        {
            [self.reminfBtn setBackgroundImage:[UIImage imageNamed:@"RemindPinkIcon"] forState:UIControlStateNormal];
        }
        else
        {
            [self.reminfBtn setBackgroundImage:[UIImage imageNamed:@"RemindIcon"] forState:UIControlStateNormal];
        }
        /*
         if ([[arrayPassMainEvent valueForKey:@"track_flag"] isEqual:someNumber])
         {
         [self.trackBtn setBackgroundImage:[UIImage imageNamed:@"TrackPinkIcon"] forState:UIControlStateNormal];
         }
         else
         {
         [self.trackBtn setBackgroundImage:[UIImage imageNamed:@"TrackIcon"] forState:UIControlStateNormal];
         }
         */
        //trackMeetingFlag
           if ([[NSString stringWithFormat:@"%@", [arrayPassMainEvent valueForKey:@"track_flag"]] isEqualToString:@"1"]||[[NSString stringWithFormat:@"%@", [arrayPassMainEvent valueForKey:@"trackMeetingFlag"]] isEqualToString:@"1"]) {
     
            
            
            
//
//            if (([toDate compare:time1] == NSOrderedDescending) && ([toDate compare:time2] == NSOrderedAscending))
//            {
                [self.trackBtn setBackgroundImage:[UIImage imageNamed:@"TrackPinkIcon"] forState:UIControlStateNormal];
//            }
            
        }
        else
        {
            [self.trackBtn setBackgroundImage:[UIImage imageNamed:@"TrackIcon"] forState:UIControlStateNormal];
        }
        
        if (!arrayPassMainEvent || !arrayPassMainEvent.count)
        {
            [self.upDownView setHidden:true];
            [self.meetingMainView setHidden:true];
            [self.pushSwapView setHidden:true];
            [self.editDeleteView setHidden:true];
        }
        else
        {
            [self.upDownView setHidden:false];
            [self.meetingMainView setHidden:false];
            [self.pushSwapView setHidden:false];
            [self.editDeleteView setHidden:false];
            
            
            
            
            if([[NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"group_flag"] ] isEqualToString:@"0"]){
                
                NSString *urlString = [arrayPassMainEvent valueForKey:@"avthar"];
                
                if ([[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"self_event"]){
                    
                    NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"]];
                    
                    [self.profilePicMain sd_setImageWithURL:url
                                           placeholderImage:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                      if (error) {
                                                          
                                                          self.profilePicMain.image = [UIImage imageNamed:@"UserProfile"];
                                                      }
                                                  }];
                    
                    
                    // [self.profilePicMain sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
                }else{
                    NSURL *url = [NSURL URLWithString:urlString];
                    // [self.profilePicMain sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
                    
                    
                    [self.profilePicMain sd_setImageWithURL:url
                                           placeholderImage:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                      if (error) {
                                                          
                                                          self.profilePicMain.image = [UIImage imageNamed:@"UserProfile"];
                                                      }
                                                  }];
                    
                    
                    
                }
                self.vwAvatarView.hidden = YES;
                _memberOverCount.hidden = true;
                
                _profilePicMain.hidden = NO;
            }else{
                
                
                
                
                ArrImages = [arrayPassMainEvent valueForKey:@"mambers"] ;
                
                
                
                
                
                
                if(ArrImages.count>1)
                {
                    _profilePicMain.hidden = YES;
                    
                    self.vwAvatarView.hidden = NO;
                    
                    
                    if (ArrImages.count>4) {
                        _memberOverCount.hidden = false;
                        _memberOverCountLbl.text = [NSString stringWithFormat:@"+ %lu",ArrImages.count-4];
                    }
                    else{
                        
                        _memberOverCount.hidden = true;
                        
                    }
                    
                    
                    
                    
                    
                    [self.vwAvatarView reset];
                    
                    
                    
                    [self.vwAvatarView reloadAvatars];
                    
                    
                }else{
                    
                    _profilePicMain.hidden = NO;
                    
                    _memberOverCount.hidden = true;
                    if (ArrImages.count == 1){
                        
                        NSURL *url = [NSURL URLWithString:[[ArrImages valueForKey:@"avthar"] objectAtIndex:0]];
                        //[self.profilePicMain sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
                        [self.profilePicMain sd_setImageWithURL:url
                                               placeholderImage:nil
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                          if (error) {
                                                              
                                                              self.profilePicMain.image = [UIImage imageNamed:@"UserProfile"];
                                                          }
                                                      }];
                    }else{
                        
                        
                        NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"]];
                        //[self.profilePicMain sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
                        [self.profilePicMain sd_setImageWithURL:url
                                               placeholderImage:nil
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                          if (error) {
                                                              
                                                              self.profilePicMain.image = [UIImage imageNamed:@"UserProfile"];
                                                          }
                                                      }];
                        
                        
                    }
                    self.vwAvatarView.hidden = YES;
                    
                }
                
            }
            
            
            
            
            
            
            
            
            [self.descLabelMAin setText:[arrayPassMainEvent valueForKey:@"description"]];
            
            arrayMember = [arrayPassMainEvent valueForKey:@"mambers"];
            
            if (!arrayMember || !arrayMember.count)
            {
                
                if ([[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"ios_event"]||[[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"google_event"])
                {
                    
                    
                    if ([[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"ios_event"]){
                        [self.meetingTitile setText:@"iOS CALENDER EVENT"];
                        
                        [self.descLabelMAin setText:[arrayPassMainEvent valueForKey:@"meeting_title"]];
                    }else{
                        
                        [self.meetingTitile setText:@"GOOGLE CALENDER EVENT"];
                        
                        [self.descLabelMAin setText:[arrayPassMainEvent valueForKey:@"meeting_title"]];
                    }
                    
                    
                }else{
                    if ([[arrayPassMainEvent valueForKey:@"group_flag"] isEqualToString:@"1"])
                    {
                        [self.meetingTitile setText:@"GROUPING"];
                    }else{
                        [self.meetingTitile setText:@"SELF EVENT"];
                    }
                }
            }
            else
            {
                if ([[arrayPassMainEvent valueForKey:@"group_flag"] isEqualToString:@"1"])
                {
                    [self.meetingTitile setText:@"GROUPING"];
                }
                else
                {
                    [self.meetingTitile setText:[[[arrayPassMainEvent valueForKeyPath:@"mambers.name"]objectAtIndex:0]uppercaseString]];
                }
            }
            
            NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc] init];
            dateFormatterTime.dateFormat = @"HH:mm";
            
            
            
            
            NSDate *dateStart = [dateFormatterTime dateFromString:[arrayPassMainEvent valueForKey:@"start_time"]];
            
            //dateFormatterTime.dateFormat = @"HH:mm a";
            //     NSString *startDateString = [dateFormatterTime stringFromDate:dateStart];
            NSDate *dateEnd = [dateFormatterTime dateFromString:[arrayPassMainEvent valueForKey: @"end_time"]];
            
            
            // One hour prior to start time
            dateFormatterTime.dateFormat = @"HH:mm";
            NSDate *prevTime = [dateStart dateByAddingTimeInterval:-3600*1];
            
            
            
            stTime = [dateFormatterTime stringFromDate:prevTime];
            enTime = [dateFormatterTime stringFromDate:dateEnd];
            
            time1 = [dateFormatterTime dateFromString:stTime];
            time2 = [dateFormatterTime dateFromString:enTime];
            
            dateFormatterTime.dateFormat = @"h.mma";
            
            NSString *startDateString1 = [[dateFormatterTime stringFromDate:dateStart]lowercaseString];
            NSString *startDateString2 = [[dateFormatterTime stringFromDate:dateEnd]lowercaseString];
            
            
            
            [self.timeLabelMain setText:[NSString stringWithFormat:@"%@ to %@" ,startDateString1,startDateString2]];
            
            NSString *dateString =  [arrayPassMainEvent valueForKey:@"start_date"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSCalendar *cal = [NSCalendar currentCalendar];
            NSDateComponents *components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
            NSDate *today = [cal dateFromComponents:components];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *currentDate = [dateFormatter stringFromDate:today];
            
            strDte = [dateFormatter dateFromString:[arrayPassMainEvent valueForKey:@"start_date"]];
            
            stDate = [dateFormatter stringFromDate:strDte];
            
            
            //Global var
            curDate = currentDate;
            
            if([currentDate isEqualToString:dateString])
            {
                [self.dayLabelMain setText:@"Today"];
            }
            else
            {
                [dateFormatter setDateFormat:@"dd MMM yyyy"];
                
                
                [self.dayLabelMain setText:[dateFormatter stringFromDate:strDte]];
            }
            
            
        }
    }
    
    //[self.tableView setContentOffset:CGPointZero animated:YES];
    [self scrollToTop];
    
    
}




-(void)scrollToTop {
    
    [self.tableView reloadData];
    NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // drop shadow
    CAShapeLayer * maskLayerPushSwap = [CAShapeLayer layer];
    maskLayerPushSwap.path = [UIBezierPath bezierPathWithRoundedRect: self.pushSwapView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10.0, 10.}].CGPath;
    self.pushSwapView.layer.mask = maskLayerPushSwap;
    
    CAShapeLayer * maskLayerDlete = [CAShapeLayer layer];
    maskLayerDlete.path = [UIBezierPath bezierPathWithRoundedRect: self.editDeleteView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10.0, 10.}].CGPath;
    self.editDeleteView.layer.mask = maskLayerDlete;
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.meetingMainView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10.0, 10.}].CGPath;
    self.meetingMainView.layer.mask = maskLayer;
    [self.meetingMainView.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.meetingMainView.layer setShadowOpacity:0.7];
    [self.meetingMainView.layer setShadowRadius:3.0];
    [self.meetingMainView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    self.suggestionVIew.layer.borderColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1.0].CGColor;
    self.suggestionVIew.layer.borderWidth = 1.0;
    
    CAShapeLayer * maskLayerUp = [CAShapeLayer layer];
    maskLayerUp.path = [UIBezierPath bezierPathWithRoundedRect: self.upDownView.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){10.0, 10.}].CGPath;
    self.upDownView.layer.mask = maskLayerUp;
    [self.upDownView.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.upDownView.layer setShadowOpacity:0.7];
    [self.upDownView.layer setShadowRadius:3.0];
    [self.upDownView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    self.meetingCollectionView.layer.borderColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1.0].CGColor;
    self.meetingCollectionView.layer.borderWidth = 1.0;
}

-(void)tapGestureHandler:(UITapGestureRecognizer *)gesture
{
    
    if ([[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"ios_event"]||[[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"google_event"])
    {
    }else{
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *latitude1 = [numberFormatter numberFromString:[arrayPassMainEvent valueForKey:@"latitude"]];
        NSNumber *longitude1 = [numberFormatter numberFromString:[arrayPassMainEvent valueForKey:@"longitude"]];
        
        if (latitude1 != nil && longitude1 != nil)
            
        {
           
            
            if ((latitude1.floatValue > -90.0) && (latitude1.floatValue < 90.0)) {
                
                if ((longitude1.floatValue > -180.0) && (longitude1.floatValue < 180.0)) {

        PGTrackViewController *trackVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PGTrackViewController"];
        
        
        trackVc.locNavString =[arrayPassMainEvent valueForKey:@"location"];
        trackVc.loclatString =[arrayPassMainEvent valueForKey:@"latitude"];
        trackVc.loclonString =[arrayPassMainEvent valueForKey:@"longitude"];
        
        [self.navigationController pushViewController:trackVc animated:true];
                    
                }
            }
        }
    }
}

- (IBAction)expandAction:(id)sender
{
    if ([sender isSelected])
    {
        isMainDown = false;
        [_expanButton setTitle:@"enlarge7" forState:UIControlStateNormal];
        [_expanButton.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16.0]];
        
        NSDictionary* userInfo = @{@"expandStr": @"notExpand"};
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"expandInfo" object:self userInfo:userInfo];
        [sender setSelected: NO];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        
        
        
        
        
        
        
    }
    else
    {
        isMainDown = true;
        [_expanButton setTitle:@"shrink7" forState:UIControlStateNormal];
        [_expanButton.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16.0]];
        
        NSDictionary* userInfo = @{@"expandStr": @"expanded"};
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"expandInfo" object:self userInfo:userInfo];
        [sender setSelected: YES];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}


- (IBAction)updownAction:(id)sender
{
    
    
    
    
    
    
    
    
    
    
    if (isdropDown){
        
        isdropDown = false;
        [_upDownImage setImage:[UIImage imageNamed:@"GroupDown"]];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        
        
        
    }else{
        
        if (!ackknowledgement){
            
            
            
            NSArray *str = [arrayPassMainEvent valueForKey:@"remind_msg"];
            if (str.count>0) {
                
                
                if ([[NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"view_rmd_flag"]] isEqualToString:@"0"])
                {
                    
                    
                    
                    NSString *strString = [str lastObject];
                    
                    if (![strString containsString:@"noticed"]&&![strString containsString:@"You "]) {
                        
                        
                        strString = [strString substringToIndex:4];
                        
                        
                        
                        if (![strString isEqualToString:@"You "]) {
                            [self remindActionAcknowlegment];
                        }
                    }
                }
            }
            
            
            
        }
        
        isdropDown = true;
        [_upDownImage setImage:[UIImage imageNamed:@"GroupUp"]];
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        
    }
    
    
    
    
}

- (IBAction)locateAction:(id)sender
{
    NSString *sendName = [[NSBundle mainBundle] localizedStringForKey:[arrayPassMainEvent valueForKey:@"location"] value:@"" table:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CAPopUpViewController *popup = [[CAPopUpViewController alloc] init];
        popup.itemsArray = @[sendName];
        popup.sourceView = self.locateButton;
        popup.backgroundColor = [UIColor whiteColor];
        popup.backgroundImage = nil;
        popup.itemTitleColor = [UIColor blackColor];
        popup.itemSelectionColor = [UIColor lightGrayColor];
        popup.arrowDirections = UIPopoverArrowDirectionRight;
        popup.arrowColor = [UIColor whiteColor];
        [popup setPopCellBlock:^(CAPopUpViewController *popupVC, UITableViewCell *popupCell, NSInteger row, NSInteger section) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [popupVC dismissViewControllerAnimated:YES completion:^{
                    
                }];
            });
        }];
        [self.navigationController presentViewController:popup animated:YES completion:^{
            
        }];
    });
}

- (IBAction)editAction:(id)sender
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"editViewInfo" object:self userInfo:nil];
}

- (IBAction)deleteAction:(id)sender
{
    
    
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"deleteViewInfo" object:self userInfo:nil];
    
}

- (IBAction)pushAction:(id)sender
{
    [self fetchDataPushSwap];
    
}




- (void)loadDataserver{
    
    
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString* finalDateString;
    
    finalDateString  = [format stringFromDate:[NSDate date]];
    
    [params setObject:finalDateString forKey:@"date"];
    
    [PGEvent pushSwapFullDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             
             MovingEventViewController *calVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MovingEventViewController"];
             calVC.arrayPassEventFree =  [result valueForKey:@"data"];
             calVC.arrayPassEventMain = [arrayPassMainEvent mutableCopy];
             CATransition *transition = [CATransition animation];
             transition.duration = 0.5;
             transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
             transition.type = kCATransitionPush;
             transition.subtype = kCATransitionFromTop;
             transition.delegate = self;
             [self.navigationController.view.layer addAnimation:transition forKey:nil];
             [self.navigationController pushViewController:calVC animated:false];
         }
         else
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:cancelButton];
             
             [self presentViewController:alert animated:YES completion:nil];
         }
     }];
}







-(void)fetchDataPushSwap
{
    
    [self loadDataserver];
    [[NSUserDefaults standardUserDefaults] setValue:arrayPassMainEvent forKey:@"PushMainMeeting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //    [PGEvent pushSwapFreeWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
    //     {
    //         if (success)
    //         {
    //             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
    //             arrayPushSwapMain = [result valueForKey:@"data"];
    //
    //             [pushSwapMutArray addObjectsFromArray:arrayPushSwapMain];
    //             [pushSwapMutArray addObject:arrayPassMainEvent];
    //             [[NSUserDefaults standardUserDefaults] setValue:arrayPassMainEvent forKey:@"PushMainMeeting"];
    //             [[NSUserDefaults standardUserDefaults] synchronize];
    //             [self loadDataserver];
    //         }
    //         else
    //         {
    //             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
    //             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:@"Failed to fetch data of current date" preferredStyle:UIAlertControllerStyleAlert];
    //
    //             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
    //             [alert addAction:cancelButton];
    //
    //             [self presentViewController:alert animated:YES completion:nil];
    //         }
    //     }];
}

- (void)remindActionAcknowlegment
{
    
    ackknowledgement = true;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"meeting_id"] ] forKey:@"meetingId"];
    
    [params setObject:[NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"start_date"] ] forKey:@"date"];
    
    
    
    
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    mutableDictionary = [arrayPassMainEvent mutableCopy];
    
    [PGMeetingAction remindNotifyActionWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         
         
         
     }];
    
}
- (IBAction)remindAction:(id)sender
{
    
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"meeting_id"] ] forKey:@"meetingId"];
    [params setObject:[NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"start_date"] ] forKey:@"date"];
    
    
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    mutableDictionary = [arrayPassMainEvent mutableCopy];
    
    [PGMeetingAction remindActionWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:@"Meeting Reminded Successfully"preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                 [nc postNotificationName:@"remindTrackEventInfo" object:self userInfo:mutableDictionary];
                 UIButton *button = (UIButton *)sender;
                 [button setBackgroundImage:[UIImage imageNamed:@"RemindPinkIcon"] forState:UIControlStateNormal];
             }];
             [alert addAction:cancelButton];
             [self presentViewController:alert animated:YES completion:nil];
         }
         else
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:cancelButton];
             [self presentViewController:alert animated:YES completion:nil];
         }
     }];
}

- (IBAction)chatAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //[button setBackgroundImage:[UIImage imageNamed:@"ChatPinkIcon"] forState:UIControlStateNormal];
    
    
    
    if  ([[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"group_event"]||[[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"single_event"]||[[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"ping_meeting"]) {
        
        
        DemoMessagesViewController *vc = [DemoMessagesViewController messagesViewController];
        
        
        
        vc.chatIdVc = [NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"chat_id"]];
        
        
        
        
        
        if  ([[arrayPassMainEvent valueForKey:@"meeting_type"] isEqualToString:@"group_event"]){
            
            vc.titleName = [NSString stringWithFormat:@"Group %@",[[arrayPassMainEvent valueForKey:@"meeting_title"]capitalizedString]];
        }else{
            
            NSArray  *Arr = [arrayPassMainEvent valueForKey:@"mambers"] ;
            vc.titleName = [NSString stringWithFormat:@"%@ %@",[[Arr valueForKey:@"fname"] objectAtIndex:0],[[Arr valueForKey:@"lname"] objectAtIndex:0]];
            
            
            
        }
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
    
    
    
}

- (IBAction)trackAction:(id)sender
{
    
    if ([[NSString stringWithFormat:@"%@", [arrayPassMainEvent valueForKey:@"track_flag"]] isEqualToString:@"1"]||[[NSString stringWithFormat:@"%@", [arrayPassMainEvent valueForKey:@"trackMeetingFlag"]] isEqualToString:@"1"]) {
        
        [self.trackBtn setBackgroundImage:[UIImage imageNamed:@"TrackPinkIcon"] forState:UIControlStateNormal];
        
        
    }
    
    
    
    
    
    
    
    
    NSLog(@"Flag--------- %@",[arrayPassMainEvent valueForKey:@"trackMeetingFlag"]);
    if ([[NSString stringWithFormat:@"%@", [arrayPassMainEvent valueForKey:@"trackMeetingFlag"]] isEqualToString:@"1"]) {
        
   
        
        NSDate *now = [NSDate date];
        NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
        [dateForm setDateFormat:@"yyyy-MM-dd"];
        NSLog(@"now-------- %@",now);
        NSLog(@"%@",[dateForm stringFromDate:now]);
        if ([[dateForm stringFromDate:now] isEqualToString:[arrayPassMainEvent valueForKey:@"start_date"]]) {
            NSLog(@"same date");
            /***/
            
            [dateForm setDateFormat:@"HH:mm"];
            /*
             "start_date" = "2018-02-16";
             "start_time" = "10:00";
             "end_date" = "2018-02-16";
             "end_time" = "10:30";
             
             */
            
            //current time display
            NSDate *now = [NSDate date];
            NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
            [dateForm setDateFormat:@"HH:mm"];
            NSString *currentTime = [dateForm stringFromDate:now];
            //NSLog(@"currentTime %@", currentTime);
            
            toDate = [dateForm dateFromString:currentTime];
            
            /**/
            //PGMeetingTableViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"NearByViewController"];
            //[self.navigationController pushViewController:newView animated:YES];
            
            //Check start time-1hr < current time < end time
            if (([toDate compare:time1] == NSOrderedDescending) && ([toDate compare:time2] == NSOrderedAscending))
            {
                // Store the data
                
              //  [self.trackBtn setBackgroundImage:[UIImage imageNamed:@"TrackPinkIcon"] forState:UIControlStateNormal];
                NSString *meetingIdCheck =  [NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"meeting_id"] ];
                
                
                NSString *meetingIdCheckDate =  [NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"start_date"] ];
                
                
                
                
                
                if ([meetingIdCheck isKindOfClass:[NSString class]]) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:meetingIdCheck forKey:@"MeetingID"];
                    [defaults synchronize];
                    
                    // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"1" forKey:@"mapValue"];
                    [defaults synchronize];
                    
                    [defaults setObject:meetingIdCheckDate forKey:@"TrackDate"];
                    
                    
                    
                    PGMeetingTrackViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackNewViewController"];
                    [self.navigationController pushViewController:newView animated:YES];
                    
                }
                
                
            } else {
                //[self presentViewController:alert animated:YES completion:nil];
                NSLog(@"Tack end time");
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PERMISSION REQUEST SENT" message:@"You will be able to see each other’s locations 60mins before the ping when your request is approved by everyone."preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   // [self.trackBtn setBackgroundImage:[UIImage imageNamed:@"TrackIcon"] forState:UIControlStateNormal];
                }];
                [alert addAction:cancelButton];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            
        } else {
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PERMISSION REQUEST SENT" message:@"You will be able to see each other’s locations 60mins before the ping when your request is approved by everyone."preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               // [self.trackBtn setBackgroundImage:[UIImage imageNamed:@"TrackIcon"] forState:UIControlStateNormal];
            }];
            [alert addAction:cancelButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        /*
         if ([now compare:date2] == NSOrderedDescending) {
         NSLog(@"date1 is later than date2");
         } else if ([date1 compare:date2] == NSOrderedAscending) {
         NSLog(@"date1 is earlier than date2");
         } else {
         NSLog(@"dates are the same");
         }
         */
        NSLog(@"isEqualToString");
        //start
        //current time display
        // NSDate *now = [NSDate date];
        //NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
        [dateForm setDateFormat:@"HH:mm"];
        NSString *currentTime = [dateForm stringFromDate:now];
        
        //NSLog(@"currentTime %@", currentTime);
        //end
        toDate = [dateForm dateFromString:currentTime];
        
    }
    else{
        
        
        
        
        NSLog(@"Flag--------- %@",[arrayPassMainEvent valueForKey:@"trackMeetingFlag"]);
        if ([[NSString stringWithFormat:@"%@", [arrayPassMainEvent valueForKey:@"track_flag"]] isEqualToString:@"1"]) {
            
            
            //[self.trackBtn setBackgroundImage:[UIImage imageNamed:@"TrackPinkIcon"] forState:UIControlStateNormal];
            
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:@"Feature available upon participants approval."preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:cancelButton];
            
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            
            
        }else{
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PERMISSION REQUIRED" message:@"We will require everyone’s permission to share each other’s location approaching this ping time slot."preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:cancelButton];
            
            UIAlertAction* confirmButton = [UIAlertAction actionWithTitle:@"REQUEST" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self trackRequestForward];
            }];
            [alert addAction:confirmButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
    
}

-(void)trackRequestForward
{
    NSString *meetingId =  [NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"meeting_id"] ];
    
    if ([meetingId isKindOfClass:[NSString class]]) {
        
        
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
        
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
        [params setObject:meetingId forKey:@"meetingId"];
        [params setObject:[NSString stringWithFormat:@"%@",[arrayPassMainEvent valueForKey:@"start_date"] ] forKey:@"date"];
        
        
        
        
        
        [PGMeetingAction trackRequestWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
         {
             if (success)
             {
                 NSLog(@"");
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PERMISSION REQUEST SENT" message:@"You will be able to see each other’s locations 60mins before the ping when your request is approved by everyone." preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     
//                     NSNumber *someNumber = [NSNumber numberWithInt:1];
//
//                     NSInteger value =[[arrayPassMainEvent valueForKey:@"trackMeetingFlag"]integerValue];
//
//
//                     NSNumber *someNumber1 = [NSNumber numberWithInteger:value];
//
//
//                     if ([someNumber1 isEqual:someNumber])
//                     {
                         [self.trackBtn setBackgroundImage:[UIImage imageNamed:@"TrackPinkIcon"] forState:UIControlStateNormal];
//                     }
//                     else
//                     {
//                         [self.trackBtn setBackgroundImage:[UIImage imageNamed:@"TrackIcon"] forState:UIControlStateNormal];
//                     }
                     
                     [[NSUserDefaults standardUserDefaults] setObject:[arrayPassMainEvent valueForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"reloaddataDateMeetingID" object:self userInfo:nil];
                     
                     
                     
                     
                     
                 }];
                 [alert addAction:cancelButton];
                 [self presentViewController:alert animated:YES completion:nil];
             }
             else
             {
                 
                 [self.trackBtn setBackgroundImage:[UIImage imageNamed:@"TrackIcon"] forState:UIControlStateNormal];
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alert addAction:cancelButton];
                 [self presentViewController:alert animated:YES completion:nil];
             }
         }];
        
        
    }
    
}
- (NSInteger)numberOfUsersInChatAvatarView:(DBChatAvatarView *)chatAvatarView {
    return ArrImages.count;
}


- (NSString *)imageForAvatarAtIndex:(NSInteger)avatarIndex inChatAvatarView:(DBChatAvatarView *)chatAvatarView {
    
    
    
    
    
    
    
    return [[ArrImages valueForKey:@"avthar"] objectAtIndex:avatarIndex];
    
    
    
    
    
}


- (void)didReceiveMemoryWarning
{
    
    
    [super didReceiveMemoryWarning];
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (arrayPassMainEvent.count>0) {
            
            if (isMainDown == false)
            {
                if (isdropDown == true)
                {
                    if (indexPath.row == 0)
                    {
                        return 0;
                    }
                    
                    else if (indexPath.row == 1)
                    {
                        return 141;
                    }
                    else if (indexPath.row == 2)
                    {
                        NSLog(@"963");
                        
                        
                        if (arrayPassMainEvent.count>0) {
                            
                            
                            NSArray *str = [arrayPassMainEvent valueForKey:@"mambers"];
                            
                            
                            if ([[arrayPassMainEvent valueForKey:@"group_flag"] isEqualToString:@"1"])
                            {
                                
                                if (str.count>1) {
                                    return 70;
                                }
                                return 0;
                            }
                            
                            else {
                                return 0;
                            }
                            
                            
                            
                        }
                        else {
                            return 0;
                        }
                        
                        
                        
                        /*if ([[arrayPassMainEvent valueForKey:@"members"] count]>0 && [[arrayPassMainEvent valueForKey:@"group_flag"] isEqualToString:@"0"] )
                         {
                         return 70;
                         }
                         */
                        
                        
                        
                        /*if ([[arrayPassMainEvent valueForKey:@"trackRequest"] count]>0)
                         {
                         NSLog(@"123 me %ld",[[arrayPassMainEvent valueForKey:@"trackRequest"] count]);
                         return 70;
                         }*/
                    }
                    else if (indexPath.row == 3)
                    {
                        if (arrayPassMainEvent.count>0) {
                            
                            
                            if (arrayCount>0)
                            {
                                return arrayCount*60;
                                
                                
                                
                            }else{
                                return 0;
                                
                            }
                            
                            
                            
                        }
                        else {
                            return 0;
                        }
                        
                        
                        
                        
                    }
                    else if (indexPath.row == 4)
                    {
                        if (arrayPassMainEvent.count>0) {
                            //                        NSArray *str = [arrayPassMainEvent valueForKey:@"remind_msg"];
                            //                        NSArray *str1 = [arrayPassMainEvent valueForKey:@"suggLocation"];
                            //
                            //
                            //
                            //
                            //                        if (str.count + str1.count >0)
                            //                        {
                            return suggestRowHeight;
                            
                            
                            
                        }
                        
                        
                        else{
                            return 0;
                            
                        }
                        
                        
                        
                        
                    }
                    else if (indexPath.row == 5)
                    {
                        
                        NSArray *str = [arrayPassMainEvent valueForKey:@"remind_msg"];
                        
                        
                        if ([[arrayPassMainEvent valueForKey:@"group_flag"] isEqualToString:@"1"]||str.count>0||arrayCount>0){
                            
                            return 40;
                            
                        }else{return 0; }
                    }else if (indexPath.row == 6)
                    {
                        return 15;
                        
                    }
                }
                else
                {
                    if (indexPath.row == 0)
                    {
                        return 0;
                    }
                    
                    else if (indexPath.row == 1)
                    {
                        return 141;
                    }
                    else if (indexPath.row == 2)
                    {
                        return 0;
                    }
                    else if (indexPath.row == 3)
                    {
                        return 0;
                    }
                    else if (indexPath.row == 4)
                    {
                        return 0;
                    }
                    else if (indexPath.row == 5)
                    {
                        NSArray *str = [arrayPassMainEvent valueForKey:@"remind_msg"];
                        
                        
                        if ([[arrayPassMainEvent valueForKey:@"group_flag"] isEqualToString:@"1"]||str.count>0||arrayCount>0){
                            
                            return 40;
                            
                        }else{return 0; }
                    }else if (indexPath.row == 6)
                    {
                        return 15;
                        
                    }
                }
            }
            else
            {
                return 0;
            }
        }
        
        else
        {
            //            if (indexPath.row == 0)
            //            {
            //                return 160;
            //            }
            
            return 0;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            return 40;
        }
        else if (indexPath.row == 1)
        {
            return rowHeight;
        }
        else if (indexPath.row == 2)
        {
            return 8;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,1)];
    headerView.backgroundColor=[UIColor clearColor];
    return headerView;
    
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%f",collectionView.frame.size.width);
    if (collectionView.frame.size.width<300) {
        return CGSizeMake(68, 60);
        
    }else if (collectionView.frame.size.width<340) {
        
        return CGSizeMake(64, 60);
    }else   if (collectionView.frame.size.width<380){
        
        return CGSizeMake(72, 60);
    }
    return CGSizeMake(60, 60);
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arraymembermeeting.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MeetingCollectionCell";
    
    PGMeetingCollectionViewCell *meetingCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *urlString = [[arraymembermeeting valueForKeyPath:@"avthar"] objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:urlString];
    //  [meetingCell.iconImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
    
    
    [meetingCell.iconImg sd_setImageWithURL:url
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      if (error) {
                                          
                                          meetingCell.iconImg.image = [UIImage imageNamed:@"UserProfile"];
                                      }
                                  }];
    
    
    
    
    meetingCell.nameLabelColl.text = [[arraymembermeeting valueForKey:@"fname"] objectAtIndex:indexPath.row];
    return meetingCell;
}

@end

