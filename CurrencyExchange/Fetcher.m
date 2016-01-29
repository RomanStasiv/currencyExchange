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
    NSArray* sortedArray = [resultArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    
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

- (AverageCurrency*) averageCurrencyRate
{
    AppDelegate * delegate = [AppDelegate singleton];
    self.context = delegate.managedObjectContext;
    
    self.averageCurrency = [[AverageCurrency alloc]init];
    
    NSUInteger qtyOfBanks = [self allBanksQuantity];    NSArray* arrayFromCoreData = [self sortedCurrency];
    
    double sumUSDAsk;
    double sumUSDBid;
    double sumEuroAsk;
    double sumEuroBid;
    CurrencyData* tmp;
    
    
    
    for(int i = 0; i< qtyOfBanks; i++)
    {
        sumUSDAsk  += [[[arrayFromCoreData objectAtIndex:i ] usdCurrencyAsk ] doubleValue];
        sumUSDBid  += [[[arrayFromCoreData objectAtIndex:i ] usdCurrencyBid ] doubleValue];
        sumEuroAsk += [[[arrayFromCoreData objectAtIndex:i ] eurCurrencyAsk ] doubleValue];
        sumEuroBid += [[[arrayFromCoreData objectAtIndex:i ] eurCurrencyBid ] doubleValue];
       
    }
    
    NSLog(@"%f", sumUSDAsk );
    NSLog(@"%f", sumUSDBid );
    NSLog(@"%f", sumEuroAsk );
    NSLog(@"%f", sumEuroBid );
    
    double resultUSDAsk  = sumUSDAsk/qtyOfBanks;
    double resultUSDBid  = sumUSDBid/qtyOfBanks;
    double resultEuroAsk = sumEuroAsk/qtyOfBanks;
    double resultEuroBid = sumEuroBid/qtyOfBanks;
    
    NSLog(@"%f", resultUSDAsk );
    NSLog(@"%f", resultUSDBid );
    NSLog(@"%f", resultEuroAsk );
    NSLog(@"%f", resultEuroBid );
    
    self.averageCurrency.date = tmp.date;
    self.averageCurrency.USDAsk  = [NSNumber numberWithFloat: resultUSDAsk];
    self.averageCurrency.USDBid  = [NSNumber numberWithFloat: resultUSDBid];
    self.averageCurrency.EuroAsk = [NSNumber numberWithFloat: resultEuroAsk];
    self.averageCurrency.EuroBid = [NSNumber numberWithFloat: resultEuroBid];
    
    
    return self.averageCurrency;
    
}

@end
