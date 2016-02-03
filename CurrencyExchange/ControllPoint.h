//
//  ControllPoint.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/27/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDControlPoint;

@interface ControllPoint : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSNumber *exChangeCource;

//should be called, before using earningPosibility property of object
- (void)calculateEarningPosibilityWithaverageCurrencyObjectsArray:(NSArray *)array;

@property (nonatomic, strong) NSNumber *earningPosibility;

@end
