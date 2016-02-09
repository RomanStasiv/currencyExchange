//
//  VKUser.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKUser : NSObject

- (instancetype)initWithServerDictionary:(NSDictionary *)dictionary;

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSString* userID;

@property (nonatomic, strong) NSMutableArray *friendsArray;

@property (nonatomic, strong) NSMutableArray *postedImages;

@end
