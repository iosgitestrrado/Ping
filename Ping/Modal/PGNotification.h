//
//  PGNotification.h
//  Ping
//
//  Created by Softnotions Technologies Pvt Ltd on 2/6/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGNotification : NSObject
+(void)notificationList:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)sendPingNotification:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)notificationListClear:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;

@end
