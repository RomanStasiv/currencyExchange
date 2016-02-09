//
//  VKServerManager.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VKUser;
@class VKFriend;

@interface VKServerManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) VKUser *currentUser;

- (void) authorizeUser:(void(^)(VKUser* user)) completion;

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(VKUser* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;
/*//call only in such order : getUser, getPostedGoals
- (void)getPostedGoalsOfCurrentUserOnSuccess:(void(^)(VKUser* user)) success
                                   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;*/

@end
