//
//  TRLoginViewController.h
//  PIng
//
//  Created by User on 01/12/16.
//  Copyright © 2016 Estrrado. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface PGServiceManager : NSObject

/*
 Creates the singleton instance of the Service Manager.
 Also setup the base URL and initilise session and operation.
 */
+ (id)sharedManager;

/*
 Fetch data from the service using HTTP GET Method.
 */
- (void)getDataFromService:(NSString *)serviceName withParameters:(NSDictionary *)parameters withCompletionBlock:(void(^)(BOOL,id , NSError *))completion;

-(void)postDataFromService:(NSString *)serviceName withParameters:(NSDictionary *)parameters withCompletionBlock:(void(^)(BOOL, id, NSError *))completion;

-(void)postDataMultiPartFromService:(NSString *)serviceName imageData:(NSData *)imageData withParameters:(NSDictionary *)parameters withCompletionBlock:(void(^)(BOOL, id, NSError *))completion;


@end
