//
//  BranchData+CoreDataProperties.h
//  CurrencyExchange
//
//  Created by Vitaliy Yarkun on 03.02.16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BranchData.h"

NS_ASSUME_NONNULL_BEGIN

@interface BranchData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *region;
@property (nullable, nonatomic, retain) BankData *bank;

@end

NS_ASSUME_NONNULL_END
