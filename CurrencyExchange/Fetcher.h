//
//  Fetcher.h
//  CurrencyExchange
//
//  Created by Melany on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONParseCoreDataSave.h"
#import "AverageCurrency.h"
#import "CurrencyData.h"
#import "BankData.h"
#import "AppDelegate.h"

@interface Fetcher : NSObject

@property (strong, nonatomic) NSMutableDictionary* dataFromCoreData;
@property (strong, nonatomic) JSONParseCoreDataSave* JSON;
@property (strong, nonatomic) AverageCurrency* averageCurrency;
@property (strong, nonatomic) NSMutableArray* averageRates;
@property (strong, nonatomic) NSMutableArray* lastBanksRates;
@property (strong, nonatomic) NSManagedObjectContext* context;


- (NSArray*) averageCurrencyRate;
- (NSMutableArray*) dataForTableView;

@end
