//
//  BankData+CoreDataProperties.h
//  CurrencyExchange
//
//  Created by Vitaliy Yarkun on 29.01.16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BankData.h"

NS_ASSUME_NONNULL_BEGIN

@class BranchData, CurrencyData;

@interface BankData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *region;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSSet<BranchData *> *branch;
@property (nullable, nonatomic, retain) NSSet<CurrencyData *> *currency;

@end

@interface BankData (CoreDataGeneratedAccessors)

- (void)addBranchObject:(BranchData *)value;
- (void)removeBranchObject:(BranchData *)value;
- (void)addBranch:(NSSet<BranchData *> *)values;
- (void)removeBranch:(NSSet<BranchData *> *)values;

- (void)addCurrencyObject:(CurrencyData *)value;
- (void)removeCurrencyObject:(CurrencyData *)value;
- (void)addCurrency:(NSSet<CurrencyData *> *)values;
- (void)removeCurrency:(NSSet<CurrencyData *> *)values;

@end

NS_ASSUME_NONNULL_END
