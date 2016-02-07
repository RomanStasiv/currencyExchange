//
//  VKUser.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "VKFriend.h"

@implementation VKFriend

- (instancetype)initWithServerDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        self.firstName = [dictionary objectForKey:@"first_name"];
        self.lastName = [dictionary objectForKey:@"last_name"];
        self.userId = [dictionary objectForKey:@"user_id"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: self.userId forKey:@"userId"];
    [aCoder encodeObject: self.firstName forKey:@"firstName"];
    [aCoder encodeObject: self.lastName forKey:@"lastName"];
    [aCoder encodeObject: self.userGoalImagesArray forKey:@"userGoalImagesArray"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.userGoalImagesArray = [aDecoder decodeObjectForKey:@"userGoalImagesArray"];
    }
    return self;
}

@end
