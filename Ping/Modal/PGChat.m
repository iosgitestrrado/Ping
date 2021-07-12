//
//  PGChat.m
//  Ping
//
//  Created by Monish M S on 23/03/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "PGChat.h"

@implementation PGChat
+(void)callChatList:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"chat/chatList" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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

+(void)callChatAdd:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"chat/addChat" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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

+(void)callChatHistory:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock{
    
    [[PGServiceManager sharedManager] postDataFromService:@"chat/chatHistory" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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

         
         +(void)callChatAddGroup:(NSDictionary *)params imageData:(NSData *)imageData WithCompletion:(void (^)(BOOL, id, NSError *))completionBlock
         {
             [[PGServiceManager sharedManager] postDataMultiPartFromService:@"chat/newChat" imageData:imageData withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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
