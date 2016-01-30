//
//  AverageCurrency.h
//  CurrencyExchange
//
//  Created by Melany on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AverageCurrency : NSObject

@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSNumber* USDbid;
@property (strong, nonatomic) NSNumber* USDask;
@property (strong, nonatomic) NSNumber* EURbid;
@property (strong, nonatomic) NSNumber* EURask;


-(instancetype) initWithEURCurrencyAsk:(NSNumber*) eurAsk
                    withEURCurrencyBid:(NSNumber*) eurBid
                    withUSDCurrencyAsk:(NSNumber*) usdAsk
                    withUSDCurrencyBid:(NSNumber*) usdBid
                              withDate:(NSDate*) date;






@end
