//
//  BankData+CoreDataProperties.h
//  CurrencyExchange
//
//  Created by Vitaliy Yarkun on 03.02.16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BankData.h"

NS_ASSUME_NONNULL_BEGIN
@class CurrencyData, BranchData;

@interface BankData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *region;
@property (nullable, nonatomic, retain) NSOrderedSet<BranchData *> *branch;
@property (nullable, nonatomic, retain) NSOrderedSet<CurrencyData *> *currency;

@end

@interface BankData (CoreDataGeneratedAccessors)

- (void)insertObject:(BranchData *)value inBranchAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBranchAtIndex:(NSUInteger)idx;
- (void)insertBranch:(NSArray<BranchData *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBranchAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBranchAtIndex:(NSUInteger)idx withObject:(BranchData *)value;
- (void)replaceBranchAtIndexes:(NSIndexSet *)indexes withBranch:(NSArray<BranchData *> *)values;
- (void)addBranchObject:(BranchData *)value;
- (void)removeBranchObject:(BranchData *)value;
- (void)addBranch:(NSOrderedSet<BranchData *> *)values;
- (void)removeBranch:(NSOrderedSet<BranchData *> *)values;

- (void)insertObject:(CurrencyData *)value inCurrencyAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCurrencyAtIndex:(NSUInteger)idx;
- (void)insertCurrency:(NSArray<CurrencyData *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCurrencyAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCurrencyAtIndex:(NSUInteger)idx withObject:(CurrencyData *)value;
- (void)replaceCurrencyAtIndexes:(NSIndexSet *)indexes withCurrency:(NSArray<CurrencyData *> *)values;
- (void)addCurrencyObject:(CurrencyData *)value;
- (void)removeCurrencyObject:(CurrencyData *)value;
- (void)addCurrency:(NSOrderedSet<CurrencyData *> *)values;
- (void)removeCurrency:(NSOrderedSet<CurrencyData *> *)values;

@end

NS_ASSUME_NONNULL_END
