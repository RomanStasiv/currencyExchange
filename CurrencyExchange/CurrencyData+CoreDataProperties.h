//
//  CurrencyData+CoreDataProperties.h
//  CurrencyExchange
//
//  Created by Vitaliy Yarkun on 03.02.16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CurrencyData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *eurCurrencyAsk;
@property (nullable, nonatomic, retain) NSString *eurCurrencyBid;
@property (nullable, nonatomic, retain) NSString *usdCurrencyAsk;
@property (nullable, nonatomic, retain) NSString *usdCurrencyBid;
@property (nullable, nonatomic, retain) BankData *bank;

@end

NS_ASSUME_NONNULL_END
