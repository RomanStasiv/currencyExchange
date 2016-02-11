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

- (void)getPostedGoalsOfUserWithID:(NSString *)ID OnSuccess:(void(^)(NSDictionary *responce)) success
                         onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
