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
#import "VKFriend.h"

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
                                                 [self getFriendsOfCurrentUserOnSuccess:^(VKUser *user)
                                                  {
                                                      if (completion)
                                                      {
                                                          completion(user);
                                                      }
                                                      
                                                  } onFailure:^(NSError *error, NSInteger statusCode)
                                                  {
                                                      
                                                  }];
                                                 
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
     @"nom",        @"name_case",
     @"en",         @"lang", nil];
    
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
             
             self.currentUser = user;
             [self getPostedGoalsOfUserWithID:userID OnSuccess:^(NSDictionary *responce)
              {
                  self.currentUser.postedImages = [responce objectForKey:@"imagesArray"];
                  success (self.currentUser);
              }
                                              onFailure:^(NSError *error, NSInteger statusCode)
              {
                  failure(nil, operation.response.statusCode);
              }];
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

- (void)getPostedGoalsOfUserWithID:(NSString *)ID OnSuccess:(void(^)(NSDictionary *responce)) success
                                   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure
{
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     ID, @"owner_id",
     @"owner",  @"filter",
     @"50",        @"count"    ,nil];
    
    [self.requestOperationManager
     GET:@"wall.get"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject)
     {
         //NSLog(@"JSON: %@", responseObject);
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
         {
             if (![[NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"response"] firstObject]] isEqualToString:@"0"] && [responseObject objectForKey:@"response"])
             {
                 NSArray* dictsArray = [responseObject objectForKey:@"response"];
                 
                 NSMutableDictionary *responce = [[NSMutableDictionary alloc] init];
                 
                 NSMutableArray *imagesArray = [NSMutableArray array];
                 
                 NSString *UID;
                 
                 if ([dictsArray count] > 0)
                 {
                     for (int i = 1; i < dictsArray.count; i++)
                     {
                         NSDictionary *post = [dictsArray objectAtIndex:i];
                         
                         UID = [post objectForKey:@"from_id"];
                         NSString *text = [post objectForKey:@"text"];
                         if ([text rangeOfString:@"#Earn#IOS#"].location != NSNotFound)
                         {
                             NSArray *wrapper = [post objectForKey:@"attachments"];
                             NSDictionary *attachments = [wrapper firstObject];
                             
                             
                             if (attachments)
                             {
                                 NSDictionary *photo = [attachments objectForKey:@"photo"];
                                 NSDictionary *responceDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [photo objectForKey:@"src_big"], @"src_big",
                                                               [photo objectForKey:@"src_xbig"],  @"src_xbig", nil];
                                 
                                 [imagesArray addObject:responceDict];
                                 
                             }
                         }
                         
                         
                     }
                     
                     if (success)
                     {
                         [responce setValue:imagesArray forKey:@"imagesArray"];
                         [responce setValue:UID forKey:@"UID"];
                         success(responce);
                     }
                 }
             }
             else
             {
                 if (failure)
                 {
                     failure(nil, operation.response.statusCode);
                 }
             }
             
         });
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


- (void) getFriendsOfCurrentUserOnSuccess:(void(^)(VKUser* user)) success
                                onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure
{
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     self.accessToken.userID,        @"user_id",
     @"photo_50",   @"fields",
     @"nom",        @"name_case", nil];
    
    [self.requestOperationManager
     GET:@"friends.get"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         
         NSArray* dictsArray = [responseObject objectForKey:@"response"];
         
         if ([dictsArray count] > 0)
         {
             for (NSDictionary *dict in dictsArray)
             {
                 VKFriend *friend = [[VKFriend alloc] initWithServerDictionary:dict];
                 
                 if (!self.currentUser.friendsArray)
                     self.currentUser.friendsArray = [NSMutableArray array];
                 [self.currentUser.friendsArray addObject:friend];
                 
             }
             
             if (success)
             {
                 success(self.currentUser);
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

/*- (void)getPostedApplicationPhotoPostsForFriend:(VKFriend *)friend
                                      onSuccess:(void(^)(NSArray *postsArray))success
                                      onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure
{
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
//     friend.userId, @"owner_id",
//     @"Эпичный",  @"query",
//     @"1",          @"owners_only",
//     @"50",        @"count"    ,nil];
     friend.userId, @"owner_id",
      @"owner",  @"filter",
      @"50",        @"count"    ,nil];
    
    [self.requestOperationManager
     GET:@"wall.get"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         
         if (![[NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"response"] firstObject]] isEqualToString:@"0"] && [responseObject objectForKey:@"response"])
         {
             NSArray* dictsArray = [responseObject objectForKey:@"response"];
             
             if ([dictsArray count] > 0)
             {
                 for (NSDictionary *post in dictsArray)
                 {
                     NSString *text = [post objectForKey:@"text"];
                     if ([text rangeOfString:@"#Earn#IOS#"].location != NSNotFound)
                     {
                         
                     }
                         
                     
                 }
                 
                 if (success)
                 {
                     //success(self.currentUser);
                 }
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

}*/

@end
