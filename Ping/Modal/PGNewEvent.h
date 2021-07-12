//
//  PGNewEvent.h
//  Ping
//
//  Created by Monish M S on 06/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGNewEvent : NSObject

+(void)fetchFreeSlotsWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)fetchFriendsSlotWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)newEventWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)freeSlotFriendsWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;


@end
