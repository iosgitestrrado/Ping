//
//  PGEvent.h
//  Ping
//
//  Created by Monish M S on 04/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGEvent : NSObject

+(void)fetchEventWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)callBlockWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)shedulePingMeetingWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)pushSwapFreeWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)editMeetingWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)deleteMeetingWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)pushActionWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)swapActionWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)pingoutListWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)pingoutActionWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)pushSwapFullDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;

+(void)acceptTrackRequest:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)rejectTrackRequest:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)fetchIosEventWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)trackFriend:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)callUnBlockWithDetails:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock;

+(void)rejectLocationSuggesion:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock;
+(void)eventDetailsByMeetingId:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)acceptLocationSuggesion:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)acceptPushSuggesion:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)rejectPushSuggesion:(NSDictionary *)params withCompletionBlock:(void(^)(bool, id, NSError *))completionBlock;
+(void)fetchGoogleEventWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)pingOutoutActionWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)rejectPrioritySuggesion:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock;
+(void)acceptPrioritySuggesion:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
@end
