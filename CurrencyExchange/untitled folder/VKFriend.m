//
//  VKUser.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "VKFriend.h"

@implementation VKFriend

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: [NSNumber numberWithUnsignedInteger:self.userId] forKey:@"userId"];
    [aCoder encodeObject: self.userName forKey:@"userName"];
    [aCoder encodeObject: self.userGoalImagesArray forKey:@"userGoalImagesArray"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.userId = [[aDecoder decodeObjectForKey:@"userId"] unsignedIntegerValue];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.userGoalImagesArray = [aDecoder decodeObjectForKey:@"userGoalImagesArray"];
    }
    return self;
}

@end
