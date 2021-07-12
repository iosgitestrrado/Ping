//
//  MovingEventViewController.m
//  Ping
//
//  Created by Monish M S on 13/03/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "MovingEventViewController.h"
#import "MSEvent.h"
#import "NSDate+Easy.h"
#import "NSArray+Collection.h"
#import "MSHourPerdiod.h"
#import "NSDate+DateTools.h"

@interface MovingEventViewController (){
    
    
    int passMonth ;
}
@property (weak) UIViewController *popupController;
@end

@implementation MovingEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWeekData];
    
    passMonth = 1;
    self.navigationController.navigationBarHidden = true;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height == 812)
            _calendarContentViewHeight.constant = 40;
        else
            _calendarContentViewHeight.constant = 20;
    }
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(receiveExitNotification:) name:@"exitCalendar" object:nil];
    
    // Do any additional setup after loading the view.
}

-(void) receiveExitNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"exitCalendar"])
    {
       
       self.navigationController.navigationBarHidden = false;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)backAction:(id)sender
{
    
  
   self.navigationController.navigationBarHidden = false;
    
    [self.navigationController popViewControllerAnimated:true];
}




-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self.view layoutIfNeeded];
    if (size.height < 420) {
        [UIView animateWithDuration:[coordinator transitionDuration] animations:^{
            self.popupController.view.bounds = CGRectMake(0, 0, (size.height-20) * .75, size.height-20);
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:[coordinator transitionDuration] animations:^{
            self.popupController.view.bounds = CGRectMake(0, 0, 300, 400);
            [self.view layoutIfNeeded];
        }];
    }
}


- (void)setupWeekData{
    
  
    
    
    
  
    eventslist   = [[NSMutableArray alloc]init];
    
    
    
    self.decoratedWeekView = [MSWeekViewDecoratorFactory make:self.weekView
                                                     features:(MSDragableEventFeature | MSNewEventFeature | MSInfiniteFeature )
                                                  andDelegate:self];
    
    //Optional, set minutes precision for drag and new event (by default it is already set to 5)
    [MSWeekViewDecoratorFactory setMinutesPrecisionToAllDecorators:self.decoratedWeekView minutesPrecision:15];
     __block int sum = 0;
    //Create the events
    for (int i = 0; i < _arrayPassEventFree.count; i++) {
        NSDictionary *dict = [_arrayPassEventFree objectAtIndex:i];
        __block int tempsum = 0;
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"Your key : %@", key);
            NSLog(@"Your value : %@", [obj description]);
         
            
            NSDictionary *aValue = [obj mutableCopy];
            
            MSEvent* event ;
       
            
            
            
            if ([[aValue objectForKey:@"meeting_type"] isEqualToString:@"self_event"]||[[aValue objectForKey:@"meeting_type"] isEqualToString:@"single_event"]||[[aValue objectForKey:@"meeting_type"] isEqualToString:@"google_event"]||[[aValue objectForKey:@"meeting_type"] isEqualToString:@"ios_event"]||[[aValue objectForKey:@"meeting_type"] isEqualToString:@"block_event"]||[[aValue objectForKey:@"meeting_type"] isEqualToString:@"group_event"]||[[aValue valueForKey:@"meeting_type"] isEqualToString:@"ping_meeting"]) {
                
                
                
                NSString *myString          = [NSString stringWithFormat:@"%@ %@", [aValue objectForKey:@"start_date"], [aValue objectForKey:@"start_time"]];
                
                
                NSDateFormatter *dateFormatter  =   [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                
                NSDate *startDate                =   [dateFormatter dateFromString:myString];
         
                
                //        MSEvent* event = [MSEvent make:startDate end:endDate title:[[_arrayPassEventFree objectAtIndex:i]objectForKey:@"meeting_title"] subtitle:[[_arrayPassEventFree objectAtIndex:i]objectForKey:@"location"]];
             
                
                NSString *a = [NSString stringWithFormat:@"%@", [aValue objectForKey:@"duration"]];
                int b = [a intValue];
                
               
                 NSString *aDesc = [NSString stringWithFormat:@"%@", [aValue objectForKey:@"description"]];
                if ([aDesc isEqualToString:@""]) {
                    
                    
                        
                        if ([[aValue objectForKey:@"meeting_type"] isEqualToString:@"ios_event"]){
                            aDesc = @"iOS Calender Event";
                            
                            
                        }else if ([[aValue objectForKey:@"meeting_type"] isEqualToString:@"self_event"]){
                           aDesc = @"Self Event";
                            
                            
                        }else if ([[aValue objectForKey:@"meeting_type"] isEqualToString:@"google_event"]){
                            aDesc = @"Google Calender Event";
                            
                            
                        }
                        else if ([[aValue objectForKey:@"meeting_type"] isEqualToString:@"group_event"]){
                            aDesc = @"Grouping";
                            
                            
                        }
                        else if ([[aValue objectForKey:@"meeting_type"] isEqualToString:@"block_event"]){
                            aDesc = @"Block Event";
                            
                            
                        }
                        else{
                            
                            
                            aDesc = @"Ping";
                        }
                        
                        
                   
                }
                
                
                
                
                
                
                if ([[aValue objectForKey:@"start_date"] isEqualToString:  [_arrayPassEventMain objectForKey:@"start_date"] ] ) {
                    
                    if ([[aValue objectForKey:@"start_time"] isEqualToString:  [_arrayPassEventMain objectForKey:@"start_time"] ] ) {
                        
                        sum = tempsum;
                        
                        
                event = [MSEvent make:startDate duration:b title:aDesc  subtitle:[aValue objectForKey:@"location"] completeDict:aValue editable:true];
                        
                        
                        NSMutableDictionary *dict =  [[NSMutableDictionary   alloc]init];
                        dict = [aValue mutableCopy];
                        [dict setObject:[NSString stringWithFormat:@"%d",b] forKey:@"Duration"];
                        
                        
                        
                        
                        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"eventMain"];
                        
                    }else{
                        event = [MSEvent make:startDate duration:b title:aDesc  subtitle:[aValue objectForKey:@"location"] completeDict:aValue editable:false];
                    }
                    
                    
                }else{
                    
                       event = [MSEvent make:startDate duration:b title:aDesc  subtitle:[aValue objectForKey:@"location"] completeDict:aValue editable:false];
                }
                
                
             
                
                
                
                
                
                [eventslist addObject:event];
            }
            
            tempsum = tempsum + 1;
            
        }];
        
        
        
       
        
        
        
        
        
        
        
        
        
             
             
       
        }
        
        
        
         NSLog(@"%@",_arrayPassEventMain) ;

    
    
    
    
    
    NSString *myString          = [NSString stringWithFormat:@"%@ %@", [_arrayPassEventMain objectForKey:@"start_date"], [_arrayPassEventMain objectForKey:@"start_time"]];
    
    
    NSDateFormatter *dateFormatter  =   [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *startDate                =   [dateFormatter dateFromString:myString];
    _passdate = startDate;
   
    
    
    _weekView.delegate                                = self;
    _weekView.weekFlowLayout.show24Hours            = YES;
    _weekView.weekFlowLayout.hourGridDivisionValue    = MSHourGridDivision_NONE;
    
  
        _weekView.daysToShowOnScreen        = 1;
    
    _weekView.daysToShow                    = 60;
    _weekView.weekFlowLayout.hourHeight     = 60;
    NSLog(@"%@",_weekView.firstDay) ;
    NSArray *array = [eventslist copy];
    
    
    self.tabBarController.tabBar.hidden= YES;
    _weekView.events = array;
    
    
    _weekView.myValue = sum;
    _weekView.checkDate = _passdate;
  
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        
        statusBar.backgroundColor =   [UIColor colorWithRed:85.0/255.0 green:82./255.0 blue:93.0/255.0 alpha:1.0];
    }
    
    
}

//=========================================
#pragma mark - Week View delegate
//=========================================
-(void)weekView:(id)sender eventSelected:(MSEventCell*)eventCell{
    NSLog(@"Event selected: %@",eventCell.event.title);
 
}

- (IBAction)didDismissSegue:(UIStoryboardSegue *)segue {
    
    

    
    
    [self dismissViewControllerAnimated:self.popupController completion:nil];
}





#pragma mark - EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

#pragma mark - EKEventViewDelegate

- (void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action
{
   
    if (controller.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [controller.navigationController popViewControllerAnimated:YES];
    }
}
//This one is optional
-(NSArray*)weekView:(id)sender unavailableHoursPeriods:(NSDate*)date{
    if(!unavailableHours){
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
        
        NSLog(@"%ld   %ld",(long)appDelegate.starttimeApp,(long)appDelegate.endtimeApp);
        
        
        
        
         if (appDelegate.starttimeApp == appDelegate.endtimeApp) {
        
             unavailableHours = @[
                                  ];
             
             
             
         }
        
        
        
        
        
        
      else  if (appDelegate.starttimeApp<12&&appDelegate.endtimeApp<12) {
            
            
            if (appDelegate.endtimeApp>appDelegate.starttimeApp)
            {
                NSString *starttime;
                NSString *endtime;
                
                
                if (appDelegate.endtimeApp<10) {
                    endtime = [NSString stringWithFormat:@"0%ld:00",(long)appDelegate.endtimeApp];
                    
                    
                    
                }else {
                    
                    
                    endtime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.endtimeApp];
                }
                if (appDelegate.starttimeApp<10) {
                    starttime = [NSString stringWithFormat:@"0%ld:00",(long)appDelegate.starttimeApp];
                    
                    
                    
                }else {
                    
                    
                    starttime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.starttimeApp];
                }
                
                
                
                
                unavailableHours = @[
                                     [MSHourPerdiod make:starttime end:endtime]
                                     ];
                
            }else{
                
                NSString *starttime;
                NSString *endtime;
                
                
                if (appDelegate.endtimeApp<10) {
                    endtime = [NSString stringWithFormat:@"0%ld:00",(long)appDelegate.endtimeApp];
                    
                    
                    
                }else {
                    
                    
                    endtime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.endtimeApp];
                }
                if (appDelegate.starttimeApp<10) {
                    starttime = [NSString stringWithFormat:@"0%ld:00",(long)appDelegate.starttimeApp];
                    
                    
                    
                }else {
                    
                    
                    starttime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.starttimeApp];
                }
                
                
                
                
                unavailableHours = @[
                                     [MSHourPerdiod make:starttime end:@"24:00"], [MSHourPerdiod make:@"00:00" end:endtime]
                                     ];
                
                
                
                
                
            }
            
        }
        
      else  if (appDelegate.starttimeApp>=12&&appDelegate.endtimeApp>=12) {
          
          
          if (appDelegate.endtimeApp>appDelegate.starttimeApp)
          {
              NSString *starttime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.starttimeApp];
              NSString *endtime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.endtimeApp];
              
                  
                  
              
            
              
              
              
              
              unavailableHours = @[
                                   [MSHourPerdiod make:starttime end:endtime]
                                   ];
              
          }else{
              
              NSString *starttime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.starttimeApp];
              NSString *endtime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.endtimeApp];
              
              
              if (appDelegate.endtimeApp<10) {
                  endtime = [NSString stringWithFormat:@"0%ld:00",(long)appDelegate.endtimeApp];
                  
                  
                  
              }else {
                  
                  
                  endtime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.endtimeApp];
              }
              if (appDelegate.starttimeApp<10) {
                  starttime = [NSString stringWithFormat:@"0%ld:00",(long)appDelegate.starttimeApp];
                  
                  
                  
              }else {
                  
                  
                  starttime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.starttimeApp];
              }
              
              
              
              
              unavailableHours = @[
                                   [MSHourPerdiod make:starttime end:@"24:00"], [MSHourPerdiod make:@"00:00" end:endtime]
                                   ];
              
              
              
              
              
          }
          
      }
        
        
      else  if (appDelegate.starttimeApp>=12&&appDelegate.endtimeApp<12) {
          
          
        
              NSString *starttime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.starttimeApp];
          
          
          
              NSString *endtime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.endtimeApp];
          if (appDelegate.endtimeApp<10) {
              endtime = [NSString stringWithFormat:@"0%ld:00",(long)appDelegate.endtimeApp];
              
              
              
          }else {
              
              
              endtime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.endtimeApp];
          }
              
              
              
              
              
              
          unavailableHours = @[
                               [MSHourPerdiod make:starttime end:@"24:00"], [MSHourPerdiod make:@"00:00" end:endtime]
                               ];
              
          
      }
      else  if (appDelegate.starttimeApp<12&&appDelegate.endtimeApp>=12) {
          
          
          
          NSString *starttime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.starttimeApp];
          
          
          
          NSString *endtime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.endtimeApp];
          if (appDelegate.starttimeApp<10) {
              starttime = [NSString stringWithFormat:@"0%ld:00",(long)appDelegate.starttimeApp];
              
              
              
          }else {
              
              
              starttime = [NSString stringWithFormat:@"%ld:00",(long)appDelegate.starttimeApp];
          }
          
          
          
          
          
          
          unavailableHours = @[
                               [MSHourPerdiod make:starttime end:endtime]
                               ];
          
          
      }
        
     else {
            
         unavailableHours = @[[MSHourPerdiod make:@"22:00" end:@"24:00"], [MSHourPerdiod make:@"00:00" end:@"08:00"]
                                 ];
            
            
            
        }



    }
    return unavailableHours;
}

//=========================================
#pragma mark - Week View Decorator Dragable delegate
//=========================================
-(void)weekView:(MSWeekView *)weekView event:(MSEvent *)event moved:(NSDate *)date{
    
    NSLog(@"Event moved");
}

-(BOOL)weekView:(MSWeekView*)weekView canStartMovingEvent:(MSEvent*)event{
    return YES;
}

-(BOOL)weekView:(MSWeekView *)weekView canMoveEvent:(MSEvent *)event to:(NSDate *)date{
    return YES;
  
}

//=========================================
#pragma mark - Week View Decorator New event delegate
//=========================================
-(void)weekView:(MSWeekView*)weekView onLongPressAt:(NSDate*)date{
    //    NSLog(@"Long pressed at: %@", date);
    //    MSEvent *newEvent = [MSEvent make:date title:@"New Event" subtitle:@"Platinium stadium"];
    //    [_weekView addEvent:newEvent];
}

-(void)weekView:(MSWeekView*)weekView onTapAt:(NSDate*)date{
    NSLog(@"Short pressed at: %@", date);
}


//=========================================
#pragma mark - Week View Decorator Infinite delegate
//=========================================
-(BOOL)weekView:(MSWeekView*)weekView newDaysLoaded:(NSDate*)startDate to:(NSDate*)endDate{
    NSLog(@"New days loaded: %@ - %@", startDate, endDate);

    return YES;
}
//=========================================
#pragma mark - Week View Decorator Change duration delegate
//=========================================
-(BOOL)weekView:(MSWeekView*)weekView canChangeDuration:(MSEvent*)event startDate:(NSDate*)startDate endDate:(NSDate*)endDate{
    return YES;
}
-(void)weekView:(MSWeekView*)weekView event:(MSEvent*)event durationChanged:(NSDate*)startDate endDate:(NSDate*)endDate{
    NSLog(@"Changed event duration");
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
