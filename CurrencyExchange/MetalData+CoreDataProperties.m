//
//  MetalData+CoreDataProperties.m
//  CurrencyExchange
//
//  Created by Melany on 2/9/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MetalData+CoreDataProperties.h"

@implementation MetalData (CoreDataProperties)

@dynamic name;
@dynamic prices;

static NSString *const kItemsKey = @"prices";

- (void)addPricesObject:(Prices *)value
{
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
    NSUInteger idx = [tmpOrderedSet count];
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
    [tmpOrderedSet addObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
}
@end
