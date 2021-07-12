//
//  PGProfile.m
//  Ping
//
//  Created by Monish M S on 02/01/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "PGProfile.h"
#import "PGServiceManager.h"

@implementation PGProfile

+(void)profileWithDetails:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"user/profile" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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
+(void)changePasswordWithUserID:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"user/changePassword" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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
