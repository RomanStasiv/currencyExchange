//
//  ControlPointsCDSotrer.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/31/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "ControlPointsCDSotrer.h"

@implementation ControlPointsCDSotrer

-(NSArray *)sort:(NSArray *)unsortedArray Ascending:(BOOL) ascending
{
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"date"
                                        ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedArray = [unsortedArray
                                 sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}

@end
