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
#import "BranchData.h"
#import "ReportDataForTable.h"

@interface Fetcher : NSObject

@property (strong, nonatomic) NSMutableDictionary* dataFromCoreData;
@property (strong, nonatomic) AverageCurrency* averageCurrency;
@property (strong, nonatomic) NSMutableArray* averageRates;
@property (strong, nonatomic) NSManagedObjectContext* context;

- (NSArray*) arrayOfBranchNames;
- (NSInteger) allBanksQuantity;
- (NSArray*) averageCurrencyRate;
- (NSMutableArray*) dataForTableView;
- (NSArray*) arrayOfBankNames;

@end
