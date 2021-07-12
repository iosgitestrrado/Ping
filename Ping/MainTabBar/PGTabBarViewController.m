//
//  PGTabBarViewController.m
//  Ping
//
//  Created by Monish M S on 25/11/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGTabBarViewController.h"
#import "AppDelegate.h"
#import "MPCoachMarks.h"
@interface PGTabBarViewController ()
{
    
    
    AppDelegate *appDelegate;
}
@end

@implementation PGTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    push = false;
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(eventInfoNotification:) name:@"pushAction" object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(eventInfoCountNotification:) name:@"tabbarCount" object:nil];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *pushDict =     [[NSUserDefaults standardUserDefaults] objectForKey:@"apnsdata"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"HOMETUTORIAL"]) {
     
     [self showTutorial];
    }
    if (pushDict!= nil) {
        
        push = true;
        
        
        
        
        
        if ([[pushDict objectForKey:@"type"] isEqualToString:@"friend"]) {
            
            
            [self setSelectedIndex:1];
            
            
            
            
            
            
        } else if ([[pushDict objectForKey:@"type"] isEqualToString:@"pingme"])
        {
            
            
            
            
            
            [self setSelectedIndex:3];
            
            
            
        }
        else if ([[pushDict objectForKey:@"type"] isEqualToString:@"chat"])
        {
            
             NSDictionary *Dict =[pushDict objectForKey:@"detail"];
            
           
            
             [[NSUserDefaults standardUserDefaults]setObject:[Dict objectForKey:@"chat_id"] forKey:@"Pushchat_id"];
            [self setSelectedIndex:4];
        }
        else
        {
            NSDictionary *Dict =[pushDict objectForKey:@"detail"];
            
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            NSDate * strdateon =   [format dateFromString:[Dict objectForKey:@"date"]];
            
            if ([strdateon isKindOfClass: [NSDate class]]) {
                
                
                
                [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
                [[NSUserDefaults standardUserDefaults]setObject:[Dict objectForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
                [self setSelectedIndex:2];
                
            }
            else{
                
                [self setSelectedIndex:2];
            }
            
            
        }
        
        
        
        
        
    }
    
}
-(void) showTutorial{
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect coachmark1 = CGRectMake(0,self.view.frame.size.height- 49,self.view.frame.size.width/5,49);
        CGRect coachmark2 = CGRectMake(self.view.frame.size.width/5, self.view.frame.size.height- 49, self.view.frame.size.width/5, 49);
        CGRect coachmark3 = CGRectMake(2*self.view.frame.size.width/5,self.view.frame.size.height- 49,self.view.frame.size.width/5,49);
        CGRect coachmark4 = CGRectMake(3*self.view.frame.size.width/5,self.view.frame.size.height- 49,self.view.frame.size.width/5,49);
        CGRect coachmark5 = CGRectMake(4*self.view.frame.size.width/5,self.view.frame.size.height- 49,self.view.frame.size.width/5,49);
        CGRect coachmark6 = CGRectMake(11,20,44,44);
        CGRect coachmark7 = CGRectMake(self.view.frame.size.width-54,20,44,44);
        CGRect coachmark8 = CGRectMake(self.view.frame.size.width-77,self.view.frame.size.height- 126,64,64);
        
        
        CGRect coachmark11 = CGRectMake(0,200,self.view.frame.size.width,self.view.frame.size.height- 250);
        
        
        CGRect coachmark9 = CGRectMake(25,250,1,1);
        CGRect coachmark10 = CGRectMake(self.view.frame.size.width-35,250,1,1);
        
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height == 812){
            coachmark1 = CGRectMake(0,self.view.frame.size.height- 83,self.view.frame.size.width/5,50);
             coachmark2 = CGRectMake(self.view.frame.size.width/5, self.view.frame.size.height- 83, self.view.frame.size.width/5, 50);
             coachmark3 = CGRectMake(2*self.view.frame.size.width/5,self.view.frame.size.height- 83,self.view.frame.size.width/5,50);
            coachmark4 = CGRectMake(3*self.view.frame.size.width/5,self.view.frame.size.height- 83,self.view.frame.size.width/5,50);
             coachmark5 = CGRectMake(4*self.view.frame.size.width/5,self.view.frame.size.height- 83,self.view.frame.size.width/5,50);
            coachmark6 = CGRectMake(12,44,44,44);
             coachmark7 = CGRectMake(self.view.frame.size.width-53,45,44,44);
            coachmark8 = CGRectMake(self.view.frame.size.width-77,self.view.frame.size.height- 160,64,64);
            
         
            
           
        }else if (screenSize.height == 736){
            
            coachmark6 = CGRectMake(14,20,44,44);
            coachmark7 = CGRectMake(self.view.frame.size.width-58,20,44,44);
            
        }
      
        
    
    
    
    
    
    
    
    
    
    
    
    
    
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HOMETUTORIAL"];
    
    
    NSArray *coachMarks = @[@{
                                @"rect": [NSValue valueWithCGRect:coachmark3],
                                @"caption": @"Your daily meetings will be listed here.",
                                @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_BOTTOM],
                                @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_CENTER],
                                @"showArrow":[NSNumber numberWithBool:NO]
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:coachmark1],
                                @"caption": @"You can make your whole day busy using ping out.",
                                @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_BOTTOM],
                                @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                @"showArrow":[NSNumber numberWithBool:NO]
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:coachmark2],
                                @"caption": @"Your ping friends will be listed here.",
                                @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_BOTTOM],
                                @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                @"showArrow":[NSNumber numberWithBool:NO]
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:coachmark4],
                                @"caption": @"View your near by friends.",
                                @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_BOTTOM],
                                @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_RIGHT],
                                @"showArrow":[NSNumber numberWithBool:NO]
                                },@{
                                @"rect": [NSValue valueWithCGRect:coachmark5],
                                @"caption": @"You can chat with your friends or within a group.",
                                @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_BOTTOM],
                                @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_RIGHT],
                                @"showArrow":[NSNumber numberWithBool:NO]
                                },@{
                                @"rect": [NSValue valueWithCGRect:coachmark6],
                                @"caption": @"How others can view you on ping.",
                                @"shape": [NSNumber numberWithInteger:SHAPE_CIRCLE],
                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_BOTTOM],
                                @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_CENTER],
                                @"showArrow":[NSNumber numberWithBool:NO]
                                },@{
                                @"rect": [NSValue valueWithCGRect:coachmark7],
                                @"caption": @"All your notification will be listed here.",
                                @"shape": [NSNumber numberWithInteger:SHAPE_CIRCLE],
                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_BOTTOM],
                                @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_CENTER],
                                @"showArrow":[NSNumber numberWithBool:NO]
                                },@{
                                @"rect": [NSValue valueWithCGRect:coachmark8],
                                @"caption": @"You can create new events in your free slots.",
                                @"shape": [NSNumber numberWithInteger:SHAPE_CIRCLE],
                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_LEFT_BOTTOM],
                                @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_CENTER],
                                @"showArrow":[NSNumber numberWithBool:NO]
                                },@{
                                @"rect": [NSValue valueWithCGRect:coachmark10],
                                @"caption": @"Swipe main event to your left. You can edit/delete the event.",
                                @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_LEFT_BOTTOM],
                                @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_CENTER],
                                @"showArrow":[NSNumber numberWithBool:YES]
                                },@{
                                @"rect": [NSValue valueWithCGRect:coachmark9],
                                @"caption": @"Swipe main event to your right. You can push your meeting to another time or swap a meeting with another meeting.",
                                @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_RIGHT_BOTTOM],
                                @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_CENTER],
                                @"showArrow":[NSNumber numberWithBool:YES]
                                },@{
                                @"rect": [NSValue valueWithCGRect:coachmark11],
                                @"caption": @"You can see the meetings and freeslots here",
                                @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_TOP],
                                @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_CENTER],
                                @"showArrow":[NSNumber numberWithBool:NO]
                                }
                            ];
    
    MPCoachMarks *coachMarksView = [[MPCoachMarks alloc] initWithFrame:self.navigationController.view.bounds coachMarks:coachMarks];
    [self.navigationController.view addSubview:coachMarksView];
    [coachMarksView start];
    }
}

-(void)eventInfoCountNotification:(NSNotification*)notification
{
    
    
    
    
    
    if ([notification.name isEqualToString:@"tabbarCount"])
    {
        
        if (appDelegate.indexValue != 5) {
            [[self.tabBar.items objectAtIndex:4] setBadgeValue:@"1"];
        }
        
        
        
        
    }
}


-(void)eventInfoNotification:(NSNotification*)notification
{
    
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    push = true;
     
    if ([notification.name isEqualToString:@"pushAction"])
    {
        NSDictionary* pushDict = notification.userInfo;
    
        
        if ([[pushDict objectForKey:@"type"] isEqualToString:@"friend"]) {
            if (appDelegate.indexValue != 2) {
                
                [self setSelectedIndex:1];
                
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"friendAction" object:self userInfo:pushDict];
            }
            
            
            
        }
        
        else if ([[pushDict objectForKey:@"type"] isEqualToString:@"delete meeting"])
        {
            NSDictionary *Dict =[pushDict objectForKey:@"detail"];
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            
            NSDate * strdateon =   [format dateFromString:[Dict objectForKey:@"date"]];
            
            if ([strdateon isKindOfClass: [NSDate class]]) {
                
                
                
                [[NSUserDefaults standardUserDefaults] setObject:strdateon forKey:@"DateValueChange"];
                
                
                if (appDelegate.indexValue != 3) {
                    
                    [self setSelectedIndex:2];
                    
                }else{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushdateEventAction" object:self userInfo:pushDict];
                }
                
            }else{
                
                
                if (appDelegate.indexValue != 3) {
                    
                    [self setSelectedIndex:2];
                    
                }
            }
            
            
        }
        else if ([[pushDict objectForKey:@"type"] isEqualToString:@"meeting"])
        {
            NSDictionary *Dict =[pushDict objectForKey:@"detail"];
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            
            NSDate * strdateon =   [format dateFromString:[Dict objectForKey:@"date"]];
            
            if ([strdateon isKindOfClass: [NSDate class]]) {
                
                
                
                [[NSUserDefaults standardUserDefaults] setObject:strdateon forKey:@"DateValueChange"];
                
               
                
                [[NSUserDefaults standardUserDefaults]setObject:[Dict objectForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
                
                
                if (appDelegate.indexValue != 3) {
                    
                    [self setSelectedIndex:2];
                    
                }else{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushdateEventAction" object:self userInfo:pushDict];
                }
                
            }else{
                
                
                if (appDelegate.indexValue != 3) {
                    
                    [self setSelectedIndex:2];
                    
                }
            }
            
            
        }
        else if ([[pushDict objectForKey:@"type"] isEqualToString:@"pingme"])
        {
            
            
            
            if (appDelegate.indexValue != 4) {
                
                [self setSelectedIndex:3];
                
            }else{
              [[NSNotificationCenter defaultCenter] postNotificationName:@"nearmeAction" object:self userInfo:pushDict]; 
                
            }
            
        }
        else if ([[pushDict objectForKey:@"type"] isEqualToString:@"remind"])
        {
            
            NSDictionary *Dict =[pushDict objectForKey:@"detail"];
            
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            
            NSDate * strdateon =   [format dateFromString:[Dict objectForKey:@"date"]];
            
            if ([strdateon isKindOfClass: [NSDate class]]) {
                
                
                
                [[NSUserDefaults standardUserDefaults] setObject:strdateon forKey:@"DateValueChange"];
                [[NSUserDefaults standardUserDefaults]setObject:[Dict objectForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
                
                if (appDelegate.indexValue != 3) {
                    
                    [self setSelectedIndex:2];
                    
                    
                    
                    
                }else{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"dateEventRemiderAction" object:self userInfo:pushDict];
                }
                
                
            }
            else{
                
                
                if (appDelegate.indexValue != 3) {
                    
                    [self setSelectedIndex:2];
                    
                }
            }
            
            
            
            
            
            
            
            
            
        }
        
        else if ([[pushDict objectForKey:@"type"] isEqualToString:@"priority"])
        {
            
            NSDictionary *Dict =[pushDict objectForKey:@"detail"];
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            
            NSDate * strdateon =   [format dateFromString:[Dict objectForKey:@"date"]];
            
            
            if ([strdateon isKindOfClass: [NSDate class]]) {
                
                [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
                [[NSUserDefaults standardUserDefaults]setObject:[Dict objectForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
                
                
                
                
                if (appDelegate.indexValue != 3) {
                    
                    [self setSelectedIndex:2];
                    
                    
                    
                    
                }else{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"dateEventRemiderAction" object:self userInfo:pushDict];
                }
            }else{
                
                
                if (appDelegate.indexValue != 3) {
                    
                    [self setSelectedIndex:2];
                    
                }
            }
            
        }
        else if ([[pushDict objectForKey:@"type"] isEqualToString:@"sugg_push"])
        {
            
            
            NSDictionary *Dict =[pushDict objectForKey:@"detail"];
            
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            
            NSDate * strdateon =   [format dateFromString:[Dict objectForKey:@"date"]];
            
            if ([strdateon isKindOfClass: [NSDate class]]) {
                
                
                
                [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
                [[NSUserDefaults standardUserDefaults]setObject:[Dict objectForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
                
                
                if (appDelegate.indexValue != 3) {
                    
                    [self setSelectedIndex:2];
                    
                }else{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"dateEventRemiderAction" object:self userInfo:pushDict];
                }
            }else{
                
                
                if (appDelegate.indexValue != 3) {
                    
                    [self setSelectedIndex:2];
                    
                }
            }
        }
        
        else if ([[pushDict objectForKey:@"type"] isEqualToString:@"sugg_location"])
        {
            
            
            NSDictionary *Dict =[pushDict objectForKey:@"detail"];
            
            
            //            NSString * strdatepass =  [NSString stringWithFormat:@"%@" ,[Dict objectForKey:@"date"]];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            //            NSString * strdatepass =  [format stringFromDate:[Dict objectForKey:@"date"]];
            //
            //            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate * strdateon =   [format dateFromString:[Dict objectForKey:@"date"]];
            
            if ([strdateon isKindOfClass: [NSDate class]]) {
                
                
                [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
                [[NSUserDefaults standardUserDefaults]setObject:[Dict objectForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
                
                
                
                
                
                
                
                if (appDelegate.indexValue != 3) {
                    
                    [self setSelectedIndex:2];
                    
                }else{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"dateEventRemiderAction" object:self userInfo:pushDict];
                }
            }
            else{
                
                
                if (appDelegate.indexValue != 3) {
                    
                    [self setSelectedIndex:2];
                    
                }
            }
            
        }
        else if ([[pushDict objectForKey:@"type"] isEqualToString:@"chat"])
        {
           
            
            NSDictionary *Dict =[pushDict objectForKey:@"detail"];
            [[NSUserDefaults standardUserDefaults]setObject:[Dict objectForKey:@"chat_id"] forKey:@"Pushchat_id"];
            
            
            if (appDelegate.indexValue != 5) {
                
                
                
                
                
                
                [self setSelectedIndex:4];
                
                
                

                
                
                
                
            }else{
                
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"chatAction" object:self userInfo:pushDict];
            }
            
            
        }
        else if ([[pushDict objectForKey:@"type"] isEqualToString:@"track"])
        {
            
            
            NSDictionary *Dict =[pushDict objectForKey:@"detail"];
            
            
            //            NSString * strdatepass =  [NSString stringWithFormat:@"%@" ,[Dict objectForKey:@"date"]];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            //            NSString * strdatepass =  [format stringFromDate:[Dict objectForKey:@"date"]];
            //
            //            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate * strdateon =   [format dateFromString:[Dict objectForKey:@"date"]];
            
            if ([strdateon isKindOfClass: [NSDate class]]) {
                
                
                [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
                [[NSUserDefaults standardUserDefaults]setObject:[Dict objectForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
                
                
                if (appDelegate.indexValue != 3) {
                    
                    [self setSelectedIndex:2];
                    
                }else{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"dateEventRemiderAction" object:self userInfo:pushDict];
                }
            }
        }else{
            
            
            if (appDelegate.indexValue != 3) {
                
                [self setSelectedIndex:2];
                
            }
        }
        
        
        
        
    }
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     
    int  dateSelected =(int) [[NSUserDefaults standardUserDefaults]integerForKey:@"HighScore"] ;
    
    if (push) {
        push = false;
        
    }else{
        
        if (!dateSelected)
        {
            [self setSelectedIndex:2];
        }
        else
        {
            
            [self setSelectedIndex:dateSelected-1];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"HighScore"];
            
            
            
        }
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
