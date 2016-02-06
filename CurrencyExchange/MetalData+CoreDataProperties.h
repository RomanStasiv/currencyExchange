//
//  MetalData+CoreDataProperties.h
//  CurrencyExchange
//
//  Created by Melany on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MetalData.h"
#import "Prices.h"

NS_ASSUME_NONNULL_BEGIN

@interface MetalData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Prices *> *prices;

@end

@interface MetalData (CoreDataGeneratedAccessors)

- (void)addPricesObject:(Prices *)value;
- (void)removePricesObject:(Prices *)value;
- (void)addPrices:(NSSet<Prices *> *)values;
- (void)removePrices:(NSSet<Prices *> *)values;

@end

NS_ASSUME_NONNULL_END
