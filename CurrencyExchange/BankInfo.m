//
//  BankInfo.m
//  CurrencyExchange
//
//  Created by Vitaliy Yarkun on 04.02.16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "BankInfo.h"

@implementation BankInfo

-(instancetype) initWithName:(NSString*) name
                  withRegion:(NSString*) region
                    withCity:(NSString*) city
                 withAddress:(NSString*) address
                  withEURAsk:(NSString*) eurAsk
                  withEURBid:(NSString*) eurBid
                 withUSDAsks:(NSString*) usdAsk
                  withUSDBid:(NSString*) usdBid
                    withDate:(NSDate*) date
{
    self = [super init];
    self.bankName = name;
    self.bankRegion = region;
    self.bankCity = city;
    self.bankAddress = address;
    self.bankEURCurrencyAsk = eurAsk;
    self.bankEURCurrencyBid = eurBid;
    self.bankUSDCurrencyAsk = usdAsk;
    self.bankUSDCurrencyBid = usdBid;
    self.bankDate = date;
    
    return self;
    
}



@end
