//
//  Fetcher.m
//  CurrencyExchange
//
//  Created by Melany on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "Fetcher.h"

@interface Fetcher ()

@property (strong, nonatomic) NSArray* banksArray;
@property (assign, nonatomic) NSInteger qtyOfBanks;

@end


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
    
    NSError* requestError = nil;
    self.banksArray = [self.context executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    self.qtyOfBanks = [self.banksArray count];
    
    NSLog(@" %ld",self.qtyOfBanks);
    
    return self.qtyOfBanks;
}

- (NSMutableArray*) averageCurrencyRate
{
    AppDelegate * delegate = [AppDelegate singleton];
    self.context = delegate.managedObjectContext;
    
    if(!self.averageRates)
        self.averageRates = [[NSMutableArray alloc] init];
    
    self.averageCurrency = [[AverageCurrency alloc]init];
    
    self.qtyOfBanks = [self allBanksQuantity];
    NSArray* arrayFromCoreData = [self sortedCurrency];
    
    double sumUSDAsk;
    double sumUSDBid;
    double sumEuroAsk;
    double sumEuroBid;
    double resultUSDAsk;
    double resultUSDBid;
    double resultEuroAsk;
    double resultEuroBid;
    
    if(self.qtyOfBanks > 0)
    {
        for(int i=0; i<[arrayFromCoreData count]/self.qtyOfBanks; i++)
        {
            for(int j = 0; j< self.qtyOfBanks; j++)
            {
                sumUSDAsk  += [[[arrayFromCoreData objectAtIndex:j ] usdCurrencyAsk ] doubleValue];
                sumUSDBid  += [[[arrayFromCoreData objectAtIndex:j ] usdCurrencyBid ] doubleValue];
                sumEuroAsk += [[[arrayFromCoreData objectAtIndex:j ] eurCurrencyAsk ] doubleValue];
                sumEuroBid += [[[arrayFromCoreData objectAtIndex:j ] eurCurrencyBid ] doubleValue];
                
            }
            
            resultUSDAsk  = sumUSDAsk/self.qtyOfBanks;
            resultUSDBid  = sumUSDBid/self.qtyOfBanks;
            resultEuroAsk = sumEuroAsk/self.qtyOfBanks;
            resultEuroBid = sumEuroBid/self.qtyOfBanks;
            
            NSLog(@"%f", resultUSDAsk );
            NSLog(@"%f", resultUSDBid );
            NSLog(@"%f", resultEuroAsk );
            NSLog(@"%f", resultEuroBid );
            
            self.averageCurrency.date = [[arrayFromCoreData objectAtIndex:i] date];
            self.averageCurrency.USDask  = [NSNumber numberWithFloat: resultUSDAsk];
            self.averageCurrency.USDbid  = [NSNumber numberWithFloat: resultUSDBid];
            self.averageCurrency.EURask = [NSNumber numberWithFloat: resultEuroAsk];
            self.averageCurrency.EURbid = [NSNumber numberWithFloat: resultEuroBid];
            
            [self.averageRates addObject:self.averageCurrency];
        }
        return self.averageRates;
    }
    return nil;
}

- (NSMutableArray*) dataForTableView
{

    self.qtyOfBanks = [self allBanksQuantity];
    
    
    return self.lastBanksRates;
}

@end
