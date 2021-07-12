//
//  PGMeetingAction.h
//  Ping
//
//  Created by Monish M S on 02/01/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGMeetingAction : NSObject

+(void)remindActionWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)trackRequestWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;

+(void)listfriends:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)listNotification:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)remindNotifyActionWithDetails:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock;


@end
