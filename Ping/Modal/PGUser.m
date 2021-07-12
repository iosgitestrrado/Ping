//
//  PGUser.m
//  Ping
//
//  Created by Monish M S on 04/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGUser.h"
#import "PGServiceManager.h"

static PGUser *_user = nil;

@interface PGUser ()

@property (nonatomic, strong) NSDictionary *profile;

@end

@implementation PGUser

-(instancetype)init
{
    self = [super init];
    return self;
}

+ (id)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"profile"])
        {
            [instance setProfileDetails:[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"]];
        }
    });
    return instance;
}

-(id)initWithUserDetails:(NSDictionary *)userDetails
{
    self = [super init];
    self.fname     = userDetails[@"fname"];
    self.lname      = userDetails[@"lname"];
    self.email     = userDetails[@"email"];
    self.number = userDetails[@"number"];
    self.active  = userDetails[@"active"];
    self.user_id   = userDetails[@"user_id"];
    
    
    
     [[NSUserDefaults standardUserDefaults] setObject:userDetails[@"user_id"] forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] setObject: userDetails[@"avthar"] forKey:@"avthar"];
    [[NSUserDefaults standardUserDefaults] setObject: userDetails[@"fname"] forKey:@"fname"];
    [[NSUserDefaults standardUserDefaults] setObject: userDetails[@"lname"] forKey:@"lname"];
    [[NSUserDefaults standardUserDefaults] setObject: userDetails[@"email"] forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] setObject: userDetails[@"number"] forKey:@"number"];
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject: userDetails[@"ping_status"] forKey:@"ping_status"];
    self.avthar     = userDetails[@"avthar"];
    self.ping_status        = userDetails[@"ping_status"];
    return self;
}

+(void)setValueInObject:(NSDictionary *)dictionary
{
    PGUser *user = [PGUser currentUser];
    user.fname     = [dictionary valueForKey:@"fname"];
    user.lname      = [dictionary valueForKey:@"lname"];
    user.email     = [dictionary valueForKey:@"email"];
    user.number = [dictionary valueForKey:@"number"];
    user.active  = [dictionary valueForKey:@"active"];
    user.user_id   = [dictionary valueForKey:@"user_id"];
    
     [[NSUserDefaults standardUserDefaults] setObject:[dictionary valueForKey:@"user_id"] forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] setObject:[dictionary valueForKey:@"avthar"] forKey:@"avthar"];
    [[NSUserDefaults standardUserDefaults] setObject: [dictionary valueForKey:@"fname"] forKey:@"fname"];
    [[NSUserDefaults standardUserDefaults] setObject: [dictionary valueForKey:@"lname"] forKey:@"lname"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject: [dictionary valueForKey:@"email"] forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] setObject: [dictionary valueForKey:@"number"] forKey:@"number"];
    [[NSUserDefaults standardUserDefaults] setObject: [dictionary valueForKey:@"ping_status"] forKey:@"ping_status"];
    
    user.avthar     = [dictionary valueForKey:@"avthar"];
    user.ping_status        = [dictionary valueForKey:@"ping_status"];
}

- (void)setProfileDetails:(NSDictionary *)dict
{
    if (dict == nil)
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:dict forKey:@"profile"];
        [userDefault synchronize];
    }
    else if (![[dict allKeys] containsObject:@"active"] || [dict[@"active"] isEqualToString:@"verified"])
    {
        self.profile = dict;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:self.profile forKey:@"profile"];
        [userDefault synchronize];
    }
}

+(id)alloc
{
    @synchronized([PGUser class])
    {
        _user = [super alloc];
        return _user;
    }
    return nil;
}

+(PGUser *)currentUser
{
    @synchronized([PGUser class])
    {
        return _user?_user:[[self alloc] init];
    }
    return nil;
}

+(PGUser *) userWithDetails:(NSDictionary *)userDetails
{
    _user = [[PGUser alloc]initWithUserDetails:userDetails];
    return _user;
}

+(void)logOut
{
    _user = nil;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"UserDetails"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)registerUserWithDetails:(NSDictionary *)params WithCompletion:(void (^)(BOOL, id, NSError *))completion{
    
    [[PGServiceManager sharedManager] postDataFromService:@"user/register" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             
             
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completion(YES,result,nil);
             }
             else
             {
                 completion(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[result valueForKey:@"message"] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completion(NO,error.localizedDescription,error);
         }
     }];
}

-(void)loginUserWithDetails:(NSDictionary *)params WithCompletion:(void (^)(BOOL, id, NSError *))completion
{
    [[PGServiceManager sharedManager] postDataFromService:@"user/login" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             _profile = [[NSDictionary alloc]init];
             _profile = [result valueForKey:@"data"];
             
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 _user = [self initWithUserDetails:_profile];
                 NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_profile];
                 [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"UserDetails"];
                 
                 
                 
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 completion(YES,result,nil);
             }
             else
             {
                 completion(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completion(NO,error.localizedDescription,error);
         }
     }];
}

-(void)verificationWithDetails:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"user/otp" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
           _profile = [[NSDictionary alloc]init];
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 
                
                 _profile = [result valueForKey:@"data"];
                 
                 _user = [self initWithUserDetails:_profile];
                 NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_profile];
                 [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"UserDetails"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Wrong OTP" forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
         
     }];
}

+(void)updateProfilePicWithDetails:(NSDictionary *)params imageData:(NSData *)imageData WithCompletion:(void (^)(BOOL, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataMultiPartFromService:@"user/uploadProfilePic" imageData:imageData withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 _user.avthar = [result valueForKeyPath:@"data.avthar"];
                 
                 NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                 [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
                 [dict setValue:_user.email forKey:@"email"];
                 [dict setValue:_user.fname forKey:@"fname"];
                 [dict setValue:_user.lname forKey:@"lname"];
                 [dict setValue:_user.number forKey:@"number"];
                 [dict setValue:_user.ping_status forKey:@"ping_status"];
                 [dict setValue:[result valueForKeyPath:@"data.avthar"] forKey:@"avthar"];
                 [dict setValue:_user.active forKey:@"active"];
                 
                  [[NSUserDefaults standardUserDefaults] setObject:[result valueForKeyPath:@"data.avthar"] forKey:@"avthar"];
                 [[NSUserDefaults standardUserDefaults] setObject:_user.fname forKey:@"fname"];
                 [[NSUserDefaults standardUserDefaults] setObject: _user.lname forKey:@"lname"];
                 [[NSUserDefaults standardUserDefaults] setObject:_user.ping_status forKey:@"ping_status"];
                 [[NSUserDefaults standardUserDefaults] setObject:_user.email forKey:@"email"];
                 [[NSUserDefaults standardUserDefaults] setObject: _user.number forKey:@"number"];
                 
                 NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
                 [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"UserDetails"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Invalid Request" forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
         
     }];
}

-(void)changePasswordWithUserID:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"user/changePassword" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             
             
             
             
             completionBlock(YES,result,nil);
             
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
         
     }];
}

-(void)updateSleepingTimeWithUserId:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"meeting/updateSleepingTIme" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             
             
             
             
             completionBlock(YES,result,nil);
             
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
         
     }];
}





-(void)forgotPasswordWithemail:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"user/forgotPassword" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             
             
            
                 
                 completionBlock(YES,result,nil);
          
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
         
     }];
}
-(void)upgradetoPingPlusWithuserid:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"user/upgradePingPlus" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 completionBlock(YES,result,nil);
             }else{
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] forKey:NSLocalizedDescriptionKey]]);
                 
             }
             
             
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
         
     }];
}


-(void)updateOnlineUseer:(NSDictionary *)params withCompletionBlock:(void (^)(bool, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"user/online" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
        
         
     }];
}









+(void)updateProfileWithDetails:(NSDictionary *)params WithCompletion:(void (^)(BOOL, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"user/updateProfile" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             
             if ([[NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]] isEqualToString:@"Success"])
             {
                 _user.fname = [params valueForKey:@"fname"];
                 _user.lname = [params valueForKey:@"lname"];
                 _user.email = [params valueForKey:@"email"];
                 _user.ping_status = [params valueForKey:@"ping_status"];
                 
                 NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                 [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
                 [dict setValue:[params valueForKey:@"email"] forKey:@"email"];
                 [dict setValue:[params valueForKey:@"fname"] forKey:@"fname"];
                 [dict setValue:[params valueForKey:@"lname"] forKey:@"lname"];
                 [dict setValue:_user.number forKey:@"number"];
                 [dict setValue:[params valueForKey:@"ping_status"] forKey:@"ping_status"];
                 [dict setValue:_user.avthar forKey:@"avthar"];
                 [dict setValue:_user.active forKey:@"active"];
                  [[NSUserDefaults standardUserDefaults] setObject:_user.avthar forKey:@"avthar"];
                   [[NSUserDefaults standardUserDefaults] setObject:[params valueForKey:@"fname"] forKey:@"fname"];
                 
                   [[NSUserDefaults standardUserDefaults] setObject:[params valueForKey:@"lname"] forKey:@"lname"];
                   [[NSUserDefaults standardUserDefaults] setObject:[params valueForKey:@"ping_status"] forKey:@"ping_status"];
                 [[NSUserDefaults standardUserDefaults] setObject:[params valueForKey:@"email"] forKey:@"email"];
                 [[NSUserDefaults standardUserDefaults] setObject:_user.number forKey:@"number"];
                 
                 
                 NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
                 [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"UserDetails"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 completionBlock(YES,result,nil);
             }
             else
             {
                 completionBlock(NO,nil,[[NSError alloc]initWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Invalid Request" forKey:NSLocalizedDescriptionKey]]);
             }
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
         
     }];
}

+(void)logOutUserWithDetails:(NSDictionary *)params WithCompletion:(void (^)(BOOL, id, NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"user/logOut" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
     {
         if (success)
         {
             completionBlock(YES,result,nil);
             [self logOut];
         }
         else
         {
             completionBlock(NO,error.localizedDescription,error);
         }
     }];
    
}

- (BOOL)isLoggedIn
{
    if (_user == nil || [_user valueForKey:@"user_id"] == nil)
    {
        return NO;
    }
    return YES;
}

- (NSDictionary *)getProfile
{
    return self.profile;
}


+(void)updateUserLocation:(NSDictionary *)params withCompletionBlock:(void(^)(bool,id,NSError *))completionBlock
{
    [[PGServiceManager sharedManager] postDataFromService:@"user/userLocation" withParameters:params withCompletionBlock:^(BOOL success, id result, NSError *error)
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
