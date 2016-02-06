//
//  VKServerManager.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VKUser;

@interface VKServerManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) VKUser *currentUser;

- (void) authorizeUser:(void(^)(VKUser* user)) completion;

@end
