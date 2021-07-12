//
//  PGNotification.m
//  Ping
//
//  Created by Softnotions Technologies Pvt Ltd on 2/6/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "PGNotification.h"
#import "PGServiceManager.h"

@implementation PGNotification

+(void)notificationList:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
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


+(void)notificationListClear:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"notification/clear" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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







+(void)sendPingNotification:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"track/pingMe" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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
