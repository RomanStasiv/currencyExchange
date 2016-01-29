//
//  AverageCurrency.m
//  CurrencyExchange
//
//  Created by Melany on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "AverageCurrency.h"


@implementation AverageCurrency

-(instancetype) initWithEURCurrencyAsk:(NSNumber*) eurAsk
                    withEURCurrencyBid:(NSNumber*) eurBid
                    withUSDCurrencyAsk:(NSNumber*) usdAsk
                    withUSDCurrencyBid:(NSNumber*) usdBid
                              withDate:(NSDate*) date
{
    self = [super init];
    
    self.USDBid = usdBid;
    self.USDAsk = usdAsk;
    self.EuroBid = eurBid;
    self.EuroAsk = eurAsk;
    self.date = date;
    
    return self;
    
}


@end
