//
//  MetalData+CoreDataProperties.h
//  CurrencyExchange
//
//  Created by Melany on 2/4/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MetalData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MetalData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSMutableSet<NSManagedObject *> *prices;

@end

@interface MetalData (CoreDataGeneratedAccessors)

- (void)addPricesObject:(NSManagedObject *)value;
- (void)removePricesObject:(NSManagedObject *)value;
- (void)addPrices:(NSMutableSet<NSManagedObject *> *)values;
- (void)removePrices:(NSMutableSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
