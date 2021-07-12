//
//  PGUser.h
//  Ping
//
//  Created by Monish M S on 04/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGUser : NSObject

@property (nonatomic,strong) NSString *fname;
@property (nonatomic,strong) NSString *lname;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *number;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *avthar;
@property (nonatomic,strong) NSString *active;
@property (nonatomic,strong) NSString *ping_status;

+(PGUser *)currentUser;
+(PGUser *) userWithDetails:(NSDictionary *)userDetails;
+(void)setValueInObject:(NSDictionary *)dictionary;

-(void)registerUserWithDetails:(NSDictionary *)params WithCompletion:(void (^)(BOOL, id, NSError *))completion;
-(void)loginUserWithDetails:(NSDictionary *)params WithCompletion:(void (^)(BOOL, id, NSError *))completion;
-(void)verificationWithDetails:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;
+(void)logOutUserWithDetails:(NSDictionary *)params WithCompletion:(void (^)(BOOL, id, NSError *))completionBlock;
+(void)updateProfilePicWithDetails:(NSDictionary *)params imageData:(NSData *)imageData WithCompletion:(void (^)(BOOL, id, NSError *))completionBlock;
+(void)updateProfileWithDetails:(NSDictionary *)params WithCompletion:(void (^)(BOOL, id, NSError *))completionBlock;
-(void)forgotPasswordWithemail:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock;
+(void)updateUserLocation:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock;

-(void)updateOnlineUseer:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock;
-(void)upgradetoPingPlusWithuserid:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock;
-(void)updateSleepingTimeWithUserId:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock;
- (BOOL)isLoggedIn;
+ (id)sharedManager;
+(void)logOut;

@end
