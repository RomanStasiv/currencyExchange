//
//  BranchInfo.m
//  CurrencyExchange
//
//  Created by Vitaliy Yarkun on 04.02.16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "BranchInfo.h"

@implementation BranchInfo

-(instancetype) initWithName:(NSString*) name
                  withRegion:(NSString*) region
                    withCity:(NSString*) city
                 withAddress:(NSString*) address
                    withBank:(NSString *)bank
{
    self = [super init];
    
    self.branchName = name;
    self.branchRegion = region;
    self.branchCity = city;
    self.branchAddress = address;
    self.bank = bank;
    
    return self;
}

@end
