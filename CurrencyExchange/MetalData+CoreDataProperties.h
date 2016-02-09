//
//  MetalData+CoreDataProperties.h
//  CurrencyExchange
//
//  Created by Melany on 2/9/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MetalData.h"

NS_ASSUME_NONNULL_BEGIN
@class Prices;

@interface MetalData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSOrderedSet<NSManagedObject *> *prices;

@end

@interface MetalData (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inPricesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPricesAtIndex:(NSUInteger)idx;
- (void)insertPrices:(NSArray<NSManagedObject *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePricesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPricesAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replacePricesAtIndexes:(NSIndexSet *)indexes withPrices:(NSArray<NSManagedObject *> *)values;
- (void)addPricesObject:(NSManagedObject *)value;
- (void)removePricesObject:(NSManagedObject *)value;
- (void)addPrices:(NSOrderedSet<NSManagedObject *> *)values;
- (void)removePrices:(NSOrderedSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
