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
@property (strong, nonatomic) NSNumber* USDBid;
@property (strong, nonatomic) NSNumber* USDAsk;
@property (strong, nonatomic) NSNumber* EuroBid;
@property (strong, nonatomic) NSNumber* EuroAsk;


-(instancetype) initWithEURCurrencyAsk:(NSNumber*) eurAsk
                    withEURCurrencyBid:(NSNumber*) eurBid
                    withUSDCurrencyAsk:(NSNumber*) usdAsk
                    withUSDCurrencyBid:(NSNumber*) usdBid
                              withDate:(NSDate*) date;






@end
