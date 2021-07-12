//
//  PGNewEvent.m
//  Ping
//
//  Created by Monish M S on 06/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGNewEvent.h"
#import "PGServiceManager.h"

@implementation PGNewEvent

+(void)fetchFreeSlotsWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/freeSlots" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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

+(void)fetchFriendsSlotWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"friend/freeFriends" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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

+(void)newEventWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/createMeeting" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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

+(void)freeSlotFriendsWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"friend/freeFriends" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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

@end
