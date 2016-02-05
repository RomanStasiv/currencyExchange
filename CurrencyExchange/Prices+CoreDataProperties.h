//
//  Prices+CoreDataProperties.h
//  CurrencyExchange
//
//  Created by Melany on 2/5/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Prices.h"

NS_ASSUME_NONNULL_BEGIN

@interface Prices (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *eurPrice;
@property (nullable, nonatomic, retain) NSString *usdPrice;
@property (nullable, nonatomic, retain) MetalData *metal;

@end

NS_ASSUME_NONNULL_END
