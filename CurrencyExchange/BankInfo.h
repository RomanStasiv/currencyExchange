//
//  BankInfo.h
//  CurrencyExchange
//
//  Created by Vitaliy Yarkun on 04.02.16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BranchInfo;

@interface BankInfo : NSObject

@property (strong, nonatomic) NSString* bankName;
@property (strong, nonatomic) NSString* bankCity;
@property (strong, nonatomic) NSString* bankRegion;
@property (strong, nonatomic) NSString* bankAddress;
@property (strong, nonatomic) NSString* bankEURCurrencyAsk;
@property (strong, nonatomic) NSString* bankEURCurrencyBid;
@property (strong, nonatomic) NSString* bankUSDCurrencyAsk;
@property (strong, nonatomic) NSString* bankUSDCurrencyBid;
@property (strong, nonatomic) NSDate* bankDate;

@property (strong, nonatomic) NSArray* branches;

-(instancetype) initWithName:(NSString*) name
                  withRegion:(NSString*) region
                    withCity:(NSString*) city
                 withAddress:(NSString*) address
                  withEURAsk:(NSString*) eurAsk
                  withEURBid:(NSString*) eurBid
                 withUSDAsks:(NSString*) usdAsk
                  withUSDBid:(NSString*) usdBid
                    withDate:(NSDate*) date;



@end
