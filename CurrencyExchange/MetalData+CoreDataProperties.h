//
//  MetalData+CoreDataProperties.h
//  CurrencyExchange
//
//  Created by Melany on 2/5/16.
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
@property (nullable, nonatomic, retain) NSOrderedSet<Prices *> *prices;

@end

@interface MetalData (CoreDataGeneratedAccessors)

- (void)insertObject:(Prices *)value inPricesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPricesAtIndex:(NSUInteger)idx;
- (void)insertPrices:(NSArray<Prices *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePricesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPricesAtIndex:(NSUInteger)idx withObject:(Prices *)value;
- (void)replacePricesAtIndexes:(NSIndexSet *)indexes withPrices:(NSArray<Prices *> *)values;
- (void)addPricesObject:(Prices *)value;
- (void)removePricesObject:(Prices *)value;
- (void)addPrices:(NSOrderedSet<Prices *> *)values;
- (void)removePrices:(NSOrderedSet<Prices *> *)values;

@end

NS_ASSUME_NONNULL_END
