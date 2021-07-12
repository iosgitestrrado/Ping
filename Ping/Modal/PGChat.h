//
//  PGChat.h
//  Ping
//
//  Created by Monish M S on 23/03/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGServiceManager.h"

@interface PGChat : NSObject
+(void)callChatList:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock;

+(void)callChatAdd:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock;

+(void)callChatAddGroup:(NSDictionary *)params imageData:(NSData *)imageData WithCompletion:(void (^)(BOOL, id, NSError *))completionBlock;




+(void)callChatHistory:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock;

@end
