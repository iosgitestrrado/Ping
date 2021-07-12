//
//  PGEvent.m
//  Ping
//
//  Created by Monish M S on 04/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGEvent.h"
#import "PGServiceManager.h"

@implementation PGEvent

+(void)fetchEventWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
   
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/viewMeeting" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {

         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}

+(void)fetchIosEventWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
  
    [[PGServiceManager sharedManager] postDataFromService:@"calendar/addIosevent" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}

+(void)fetchGoogleEventWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    // NSLog(@"viewMeeting----- params %@",params);
    [[PGServiceManager sharedManager] postDataFromService:@"calendar/addGoogleEvent" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         //        // NSLog(@"viewMeeting-----%@",[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]]);
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}






+(void)callBlockWithDetails:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/blockMeeting" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
        //// NSLog(@"blockMeeting-----%@",[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]]);
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}
+(void)callUnBlockWithDetails:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/unBlockMeeting" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
        // NSLog(@"blockMeeting-----%@",[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]]);
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}










+(void)shedulePingMeetingWithDetails:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
   
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/shedulePingMeeting" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
        // NSLog(@"shedulePingMeeting-----%@",[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]]);
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}

+(void)pushSwapFreeWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
NSLog(@"pushSwapFreeSlots----- params %@",params);
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/pushSwapFreeSlots" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
            // NSLog(@"pushSwapFreeSlots-----%@",[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]]);
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}


+(void)pushSwapFullDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
   // NSLog(@"pushSwapFreeSlots----- params %@",params);
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/multiDayMeeting" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
            // NSLog(@"pushSwapFreeSlots-----%@",[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]]);
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}


+(void)eventDetailsByMeetingId:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/meetingDetail" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,result,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
    
}
+(void)editMeetingWithDetails:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/editMeeting" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}
+(void)acceptLocationSuggesion:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/acceptLocationSuggesion" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 if ([result isKindOfClass:[NSDictionary class]]) {
                     completionBlock(NO,result,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
                 }else{
                     
                     completionBlock(NO,error.localizedDescription,error);                }
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
    
}

+(void)acceptPushSuggesion:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/acceptPushSuggesion" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
               if ([result isKindOfClass:[NSDictionary class]]) {
                     completionBlock(NO,result,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
                 }else{
                     
                     completionBlock(NO,error.localizedDescription,error);                }
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
    
}
+(void)rejectPushSuggesion:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/rejectPushSuggesion" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 if ([result isKindOfClass:[NSDictionary class]]) {
                     completionBlock(NO,result,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
                 }else{
                     
                     completionBlock(NO,error.localizedDescription,error);                }
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}
+(void)acceptPrioritySuggesion:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/acceptPriority" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 if ([result isKindOfClass:[NSDictionary class]]) {
                     completionBlock(NO,result,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
                 }else{
                     
                     completionBlock(NO,error.localizedDescription,error);                }
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
    
}
+(void)rejectPrioritySuggesion:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/rejectPriority" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 if ([result isKindOfClass:[NSDictionary class]]) {
                     completionBlock(NO,result,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
                 }else{
                     
                     completionBlock(NO,error.localizedDescription,error);                }
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}




+(void)rejectLocationSuggesion:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/rejectLocationSuggesion" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 
                 
                 if ([result isKindOfClass:[NSDictionary class]]) {
                         completionBlock(NO,result,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
                 }else{
                     
                     completionBlock(NO,error.localizedDescription,error);                }
                 
                 
                 
             
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}

+(void)deleteMeetingWithDetails:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    
    
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/deleteMeeting" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}

+(void)pushActionWithDetails:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    // NSLog(@"pushMeeting----- params %@",params);
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/pushMeeting" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
//        // NSLog(@"pushMeeting-----%@",[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]]);
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,result,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}

+(void)swapActionWithDetails:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
   // NSLog(@"swapMeeting----- params %@",params);
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/swapMeeting" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         
         // NSLog(@"swapMeeting-----%@",[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]]);
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,result,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}

+(void)pingoutListWithDetails:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/pingOutMeetings" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}
+(void)pingoutActionWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/pingOut" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}


+(void)pingOutoutActionWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/undoPingOut" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}












+(void)acceptTrackRequest:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"track/acceptTrackRequest" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
              // NSLog(@"acceptTrackRequest ---------%@",result);
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}

+(void)rejectTrackRequest:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"track/rejectTrackRequest" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
            // NSLog(@"rejectTrackRequest ---------%@",result);
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}

+(void)trackFriend:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"track/trackFriend" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
        // NSLog(@"trackFriend ---------%@",result);
         if (success)
         {
            // NSLog(@"trackFriend ---------%@",result);
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
}


@end

/*
 public function baseUrl(){ return 'http://elviserp.in/ping/'; }
 
 1. Registration
 -------------
 http://elviserp.in/ping/user/register/
 API params : number, email, password, fname, lname, country, deviceToken, latitude, longitude, image
 
 2. Login
 -----
 http://elviserp.in/ping/user/login/
 API params : number, password,deviceToken  (+918973732732 / merlin)  (+919626621571 / merlin )
 
 3. create event
 ------------
 http://elviserp.in/ping/meeting/createMeeting/
 API params : user_id, startDate, endDate, startTime, endTime, friends, title, description, location, priority, latitude, longitude
 
 friends format : ["number":"+918973732732"},"number":"+918973732732"}]
 
 4. view meeting
 ------------
 http://elviserp.in/ping/meeting/viewMeeting/
 API params : user_id, date
 
 5. Free slot
 ------------
 http://elviserp.in/ping/meeting/freeSlots/
 // API params : user_id, date, friends
 
 date : [{"date":"2017-11-10"},{"date":"2017-11-10"}]
 friends : [{"number":"+918973732721"},{"number":"+918973732721"}]
 
 6. Free friends
 -----------------
 http://elviserp.in/ping/friend/freeFriends/
 // API params : user_id, date, startTime, endTime
 date : [{"date":"2017-11-10"},{"date":"2017-11-10"}]
 
 
 7. Add Friends
 ---------------
 
 http://elviserp.in/ping/friend/addFriends/
 // API params : user_id, friends
 friends : [{"number":"+918973732721"},{"number":"+918973732721"}]
 
 
 8. Accept Friend
 ---------------
 
 http://elviserp.in/ping/friend/acceptFriend/
 
 // API params : user_id, friendNumber
 
 
 
 9. Friends List
 ---------------
 
 http://elviserp.in/ping/friend/friends/
 
 // API params : user_id
 
 10. Block
 ------
 http://elviserp.in/ping/meeting/blockMeeting/
 // API params : user_id, startDate, endDate, startTime, endTime, repeatEvent, everyday
 ( repeatEvent = 0 & everyday  = '' )
 
 11. Unblock
 ------
 http://elviserp.in/ping/meeting/unBlockMeeting/
 // API params : user_id, meetingId
 
 12. Logout
 --------
 http://elviserp.in/ping/user/logOut/
 API params : user_id
 
 13. Profile
 --------
 http://elviserp.in/ping/user/profile/
 API params : user_id
 
 14. Edit Profile
 --------
 http://elviserp.in/ping/user/updateProfile/
 API params : user_id, fname, lname, email, ping_status
 
 15. Upload Profile Pic.
 --------
 http://elviserp.in/ping/user/uploadProfilePic/
 API params : user_id, image (type : file (img))
 
 16. Reject Friend
 ---------------
 http://elviserp.in/ping/friend/rejectFriend/
 // API params : user_id, friendNumber
 
 
 17. Contacts
 ---------------
 http://elviserp.in/ping/friend/contacts/
 // API params : user_id, contactList
 
 
 18. Friend Profile
 --------------
 http://elviserp.in/ping/friend/friendProfile/
 // API params : user_id, number
 
 19. Remind
 ---------
 http://elviserp.in/ping/meeting/remind/
 // API params : user_id, meetingId
 
 20. Edit Meeting
 ---------
 http://elviserp.in/ping/meeting/editMeeting/
 // API params : user_id, meetingId, description, location, latitude, longitude, addFriends, removeFriends
 addFriends | removeFriends format : [{"number":"+918973732721"},{"number":"+918973732721"}]
 
 21. Delete Meeting
 ---------
 http://elviserp.in/ping/meeting/deleteMeeting/
 // API params : user_id, meetingId
 
 
 22. Push / Swap slots (Availabel slots for push & swap)
 ------------------
 http://elviserp.in/ping/meeting/pushSwapFreeSlots/
 // API params : user_id, meetingId, date
 http://elviserp.in/ping/meeting/freeSlotsNew/
 
 23. Push Meeting
 ------------
 http://elviserp.in/ping/meeting/pushMeeting/
 // API params : user_id, meetingId, date, startTime, endTime
 
 24. Swap Meeting
 ------------
 http://elviserp.in/ping/meeting/swapMeeting/
 // API params : user_id, meetingId1, meetingId2
 
 26. OTP Verification
 ---------------------
 http://elviserp.in/ping/user/otp/
 //    API params : number, otp
 
 27. Accept Push Suggestion
 ------------
 http://elviserp.in/ping/meeting/acceptPushSuggesion/
 // API params : user_id, suggId
 
 28. Reject Push Suggestion
 ------------
 http://elviserp.in/ping/meeting/rejectPushSuggesion/
 // API params : user_id, suggId
 
 29. Accept Location Suggesion
 ------------------------------
 http://elviserp.in/ping/meeting/acceptLocationSuggesion/
 // API params : user_id, suggId
 
 30. Reject Location Suggesion
 ------------------------------
 http://elviserp.in/ping/meeting/rejectLocationSuggesion/
 // API params : user_id, suggId
 
 31. Update User Location
 --------------------------
 http://elviserp.in/ping/user/userLocation/
 //    API params : user_id, latitude, longitude
 
 32. Ping Out
 -------------
 http://elviserp.in/ping/meeting/pingOut/
 //    API params : user_id, date, meetingIds
 
 33. Shedule Ping Meeting
 ------------------------
 http://elviserp.in/ping/meeting/shedulePingMeeting
 //    API params : user_id, startTime, endTime, timeSlots, friendId
 
 34. Chat List
 ----------------
 http://elviserp.in/ping/chat/chatList/
 //    API params : user_id
 
 35. http://elviserp.in/ping/chat/newChat/   (for create group)
 //    API params : user_id, friendIds, groupName  || ["2","3"]
 
 36. http://elviserp.in/ping/chat/addChat/
 //    API params : user_id, chatId, message
 
 37. http://elviserp.in/ping/chat/chatHistory/
 //    API params : user_id, chatId
 
 38. http://elviserp.in/ping/track/trackRequest/
 //    API params : user_id, meetingId
 
 39. http://elviserp.in/ping/track/acceptTrackRequest/
 //    API params : user_id, trackId
 
 40. http://elviserp.in/ping/track/rejectTrackRequest/
 //    API params : user_id, trackId
 
 41. http://elviserp.in/ping/track/trackFriend/
 //    API params : user_id, meetingId, friendNumber
 
 42. http://elviserp.in/ping/track/pingMe/
 //    API params : user_id, distance
 
 43. http://elviserp.in/ping/user/upgradePingPlus/
 //    API params : user_id
 
 44. http://elviserp.in/ping/meeting/updateSleepingTIme/
 // API params : user_id, startTime, endTime
 
 45. http://elviserp.in/ping/user/public/
 //    API params : user_id
 
 46. http://elviserp.in/ping/meeting/pingOutMeetings/
 //    API params : user_id, date
 

*/

 
 
 
 

