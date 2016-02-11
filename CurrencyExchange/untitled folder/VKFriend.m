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
        NSString* urlString = [dictionary objectForKey:@"photo_50"];
        
        if (urlString)
        {
            self.imageURL = [NSURL URLWithString:urlString];
        }
    }
    
    return self;
}

@end
