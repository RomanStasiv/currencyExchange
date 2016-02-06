//
//  VKUser.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKFriend : NSObject <NSCoding>

@property (nonatomic, assign)NSUInteger userId;
@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSArray *userGoalImagesArray;

@end
