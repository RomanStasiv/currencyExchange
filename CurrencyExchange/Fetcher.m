//
//  Fetcher.m
//  CurrencyExchange
//
//  Created by Melany on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "Fetcher.h"

@implementation Fetcher

- (NSArray*) sortedCurrency
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"CurrencyData"
                inManagedObjectContext:self.context];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.context executeFetchRequest:request error:&requestError];
    
    if (requestError)
    {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    NSArray* sortedArray = [resultArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    
    return sortedArray;
}

- (NSInteger) allBanksQuantity {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"BankData"
                                                   inManagedObjectContext:self.context];
    
    [request setEntity:description];
    
    NSInteger qtyOfBanks;
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.context executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    qtyOfBanks = [resultArray count];
    
    NSLog(@" %ld",qtyOfBanks);
    
    return qtyOfBanks;
}

- (NSArray*) averageCurrencyRate
{
    AppDelegate * delegate = [AppDelegate singleton];
    self.context = delegate.managedObjectContext;
    
    if(!self.averageRates)
        self.averageRates = [[NSMutableArray alloc] init];
    
    self.averageCurrency = [[AverageCurrency alloc]init];
    
    NSUInteger qtyOfBanks = [self allBanksQuantity];
    NSArray* arrayFromCoreData = [self sortedCurrency];
    
    double sumUSDAsk;
    double sumUSDBid;
    double sumEuroAsk;
    double sumEuroBid;
    CurrencyData* tmp;
    double resultUSDAsk;
    double resultUSDBid;
    double resultEuroAsk;
    double resultEuroBid;
    
    for(int i=0; i<[arrayFromCoreData count]/qtyOfBanks; i++)
    {
    for(int i = 0; i< qtyOfBanks; i++)
    {
        sumUSDAsk  += [[[arrayFromCoreData objectAtIndex:i ] usdCurrencyAsk ] doubleValue];
        sumUSDBid  += [[[arrayFromCoreData objectAtIndex:i ] usdCurrencyBid ] doubleValue];
        sumEuroAsk += [[[arrayFromCoreData objectAtIndex:i ] eurCurrencyAsk ] doubleValue];
        sumEuroBid += [[[arrayFromCoreData objectAtIndex:i ] eurCurrencyBid ] doubleValue];
      
    }
    
    tmp.date = [[arrayFromCoreData objectAtIndex:0] date];
    resultUSDAsk  = sumUSDAsk/qtyOfBanks;
    resultUSDBid  = sumUSDBid/qtyOfBanks;
    resultEuroAsk = sumEuroAsk/qtyOfBanks;
    resultEuroBid = sumEuroBid/qtyOfBanks;
    
    NSLog(@"%f", resultUSDAsk );
    NSLog(@"%f", resultUSDBid );
    NSLog(@"%f", resultEuroAsk );
    NSLog(@"%f", resultEuroBid );
    
    self.averageCurrency.date = tmp.date;
    self.averageCurrency.USDask  = [NSNumber numberWithFloat: resultUSDAsk];
    self.averageCurrency.USDbid  = [NSNumber numberWithFloat: resultUSDBid];
    self.averageCurrency.EURask = [NSNumber numberWithFloat: resultEuroAsk];
    self.averageCurrency.EURbid = [NSNumber numberWithFloat: resultEuroBid];
    
        [self.averageRates addObject:self.averageCurrency];
    }
    return self.averageRates;
    
}

@end
