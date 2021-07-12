//
//  TRLoginViewController.h
//  PIng
//
//  Created by User on 01/12/16.
//  Copyright © 2016 Estrrado. All rights reserved.
//


#import "PGServiceManager.h"
#import <AFNetworking/AFNetworking.h>

#define base_URL @"http://13.232.170.55:8080/ping/"

static PGServiceManager *serviceManager = nil;

@interface PGServiceManager ()
{
    
}

@property (strong, nonatomic) AFHTTPRequestOperationManager *operationManger;

@end

@implementation PGServiceManager

+ (id)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[self alloc]init];
        [self setBaseUrl];
    });
    return serviceManager;
}

+ (void)setBaseUrl
{
    serviceManager.operationManger = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:base_URL]];
    serviceManager.operationManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html",nil];
}

#pragma mark - GET Method
-(void)getDataFromService:(NSString *)serviceName withParameters:(NSDictionary *)parameters withCompletionBlock:(void (^)(BOOL, id, NSError *))completion{
    [self.operationManger GET:serviceName parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"URL: %@",operation.request.URL);
        completion(responseObject ? YES:NO,responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(NO,error.localizedDescription,error);
    }];
}

-(void)postDataFromService:(NSString *)serviceName withParameters:(NSDictionary *)parameters withCompletionBlock:(void (^)(BOOL, id, NSError *))completion
{
    [self.operationManger POST:serviceName parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        NSLog(@"URL: %@",operation.request.URL);
        completion(responseObject ? YES:NO,responseObject,nil);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error: %@", error);
        completion(NO,error.localizedDescription,error);
    }];
}

-(void)postDataMultiPartFromService:(NSString *)serviceName imageData:(NSData *)imageData withParameters:(NSDictionary *)parameters withCompletionBlock:(void(^)(BOOL, id, NSError *))completion
{
    [self.operationManger POST:serviceName parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         [formData appendPartWithFileData:imageData name:@"image" fileName:[NSString stringWithFormat:@"image.jpg"] mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    {
       NSLog(@"URL: %@",operation.request.URL);
        completion(responseObject ? YES:NO,responseObject,nil);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        completion(NO,error.localizedDescription,error);
    }];
}

@end
