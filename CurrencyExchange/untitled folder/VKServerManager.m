//
//  VKServerManager.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomNavigationController.h"
#import "AFNetworking.h"
#import "VKServerManager.h"
#import "VKLoginViewController.h"
#import "VKAccessToken.h"
#import "VKUser.h"

@interface VKServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;
@property (strong, nonatomic) VKAccessToken *accessToken;

@end

@implementation VKServerManager

+ (instancetype)sharedManager
{
    static VKServerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VKServerManager alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}

- (void) authorizeUser:(void(^)(VKUser* user)) completion
{
    VKLoginViewController* VKlvc = [[VKLoginViewController alloc] initWithCompletionBlock:^(VKAccessToken *token)
                                    {
                                        self.accessToken = token;
                                        
                                        if (token)
                                        {
                                            [self getUser:self.accessToken.userID
                                                onSuccess:^(VKUser *user)
                                             {
                                                 if (completion)
                                                 {
                                                     completion(user);
                                                 }
                                             }
                                                onFailure:^(NSError *error, NSInteger statusCode)
                                             {
                                                 if (completion)
                                                 {
                                                     completion(nil);
                                                 }
                                             }];
                                            
                                        }
                                        else if (completion)
                                        {
                                            completion(nil);
                                        }
        
    }];
    
    UINavigationController* nav = (CustomNavigationController *)[AppDelegate singleton].window.rootViewController;
    
    [nav pushViewController:VKlvc animated:YES];
}

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(VKUser* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure
{
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userID,        @"user_ids",
     @"photo_50",   @"fields",
     @"nom",        @"name_case", nil];
    
    [self.requestOperationManager
     GET:@"users.get"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject)
    {
         NSLog(@"JSON: %@", responseObject);
         
         NSArray* dictsArray = [responseObject objectForKey:@"response"];
         
         if ([dictsArray count] > 0)
         {
             VKUser* user = [[VKUser alloc] initWithServerDictionary:[dictsArray firstObject]];
             if (success)
             {
                 success(user);
             }
         }
         else
         {
             if (failure)
             {
                 failure(nil, operation.response.statusCode);
             }
         }
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
         NSLog(@"Error: %@", error);
         
         if (failure)
         {
             failure(error, operation.response.statusCode);
         }
     }];
}

@end
