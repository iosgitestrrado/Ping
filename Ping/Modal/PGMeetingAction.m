//
//  PGMeetingAction.m
//  Ping
//
//  Created by Monish M S on 02/01/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "PGMeetingAction.h"
#import "PGServiceManager.h"

@implementation PGMeetingAction

+(void)remindActionWithDetails:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/remind" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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

+(void)remindNotifyActionWithDetails:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/remindNotify" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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













+(void)trackRequestWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"track/trackRequest" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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

+(void)listfriends:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"track/nearMe" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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

+(void)listNotification:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"notification/notificationList" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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
