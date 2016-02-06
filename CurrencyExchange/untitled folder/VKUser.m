//
//  VKUser.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "VKUser.h"
#import "VKFriend.h"

@interface VKUser ()

@property (nonatomic, strong) NSArray *friendsArray;

@end

@implementation VKUser

- (id) initWithServerDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.firstName = [dictionary objectForKey:@"first_name"];
        self.lastName = [dictionary objectForKey:@"last_name"];
        
        NSString* urlString = [dictionary objectForKey:@"photo_50"];
        
        if (urlString)
        {
            self.imageURL = [NSURL URLWithString:urlString];
        }
    }
    return self;
}

@end
