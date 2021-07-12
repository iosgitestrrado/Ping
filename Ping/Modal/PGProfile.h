//
//  PGProfile.h
//  Ping
//
//  Created by Monish M S on 02/01/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGProfile : NSObject

+(void)profileWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)changePasswordWithUserID:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
@end
