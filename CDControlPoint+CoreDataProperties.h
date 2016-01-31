//
//  CDControlPoint+CoreDataProperties.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDControlPoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDControlPoint (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *value;
@property (nullable, nonatomic, retain) NSString *currency;
@property (nullable, nonatomic, retain) NSNumber *exChangeCource;
@property (nullable, nonatomic, retain) NSNumber *earningPosibility;

@end

NS_ASSUME_NONNULL_END
