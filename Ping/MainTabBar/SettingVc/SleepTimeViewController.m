//
//  SleepTimeViewController.m
//  Ping
//
//  Created by Monish M S on 25/06/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "SleepTimeViewController.h"



@interface SleepTimeViewController ()

@end

@implementation SleepTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Unavailable";
    
    
    [self blockTimeView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)blockTimeView
{
    
    
    NSString *start =  [[NSUserDefaults standardUserDefaults] objectForKey:@"sleepStart"];
    NSString *end = [[NSUserDefaults standardUserDefaults] objectForKey:@"sleepEnd"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    dateStart = [dateFormatter dateFromString:start];
    dateEnd = [dateFormatter dateFromString:end];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * dateStart1 = [dateFormatter stringFromDate:dateStart];
    NSString *  dateEnd1 = [dateFormatter stringFromDate:dateEnd];
    NSDate *dateT = [dateFormatter dateFromString:dateStart1];
    NSDate *dateS = [dateFormatter dateFromString:dateEnd1];
    myPickerViewStart.datePickerMode = UIDatePickerModeTime;
    [myPickerViewStart setDate:dateT];
    myPickerViewStart.minuteInterval=30;
    [myPickerViewStart setBackgroundColor:[UIColor whiteColor]];
    myPickerViewEnd.datePickerMode = UIDatePickerModeTime;
    
    
    [myPickerViewEnd setDate:dateS];
    
    [myPickerViewEnd setBackgroundColor:[UIColor whiteColor]];
    myPickerViewEnd.minuteInterval=30;
    
    
    
}

- (IBAction)cancelButtonAction:(id)sender
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *startStr =[dateFormatter stringFromDate: myPickerViewStart.date] ;
    
    NSString *endStr =[dateFormatter stringFromDate: myPickerViewEnd.date] ;
    
    
    dateStart = [dateFormatter dateFromString:startStr];
    dateEnd = [dateFormatter dateFromString:endStr];
    [dateFormatter setDateFormat:@"HH"];
    
    NSString  *startTimeSlots=[dateFormatter stringFromDate:dateStart];
    NSString  *endTimeSlots=[dateFormatter stringFromDate:dateEnd];
    
    
    
    
    
    
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    
    
    
    newUser = [[PGUser alloc]init];
    
    
    
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[NSString stringWithFormat:@"%@:00", startTimeSlots] forKey:@"startTime"];
    [params setObject:[NSString stringWithFormat:@"%@:00", endTimeSlots] forKey:@"endTime"];
    
    
    [newUser updateSleepingTimeWithUserId:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     
     
     
     {
         if (success)
         {
             
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             
             [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@:00", startTimeSlots] forKey:@"sleepStart"];
             [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@:00", endTimeSlots] forKey:@"sleepEnd"];
             AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             appDelegate.endtimeApp =[endTimeSlots intValue];
             appDelegate.starttimeApp = [startTimeSlots intValue];
             
             
             
             
             
             
             
             
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action)
                                  {
                                      
                                      
                                      
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }];
             [alertController addAction:ok];
             [self presentViewController:alertController animated:YES completion:nil];
             
             
             
             
         }
         else
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                        handler:nil];
             [alertController addAction:ok];
             [self presentViewController:alertController animated:YES completion:nil];
         }
     }];
 
}

-(int) minutesSinceMidnight:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    return 60 * (int)[components hour] + (int)[components minute];
}

@end
