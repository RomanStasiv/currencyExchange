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

- (NSArray*) arrayOfBankNames
{
    AppDelegate * delegate = [AppDelegate singleton];
    self.context = delegate.managedObjectContext;
    NSMutableArray* banksNames = [[NSMutableArray alloc]init];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"BankData"
                inManagedObjectContext:self.context];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.context executeFetchRequest:request error:&requestError];
    NSInteger qty = [resultArray count];
    
    for(int i = 0; i < qty; i++)
    {
        NSString* tmp = [NSString stringWithString:((BankData *)resultArray[i]).name];
        [banksNames addObject:tmp];
    }
    
    return banksNames;
}

- (NSMutableArray*) dataForTableView
{
    AppDelegate * delegate = [AppDelegate singleton];
    self.context = delegate.managedObjectContext;
    
    NSMutableArray *arrayForTableView = [[NSMutableArray alloc]init];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"BankData"
                inManagedObjectContext:self.context];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.context executeFetchRequest:request error:&requestError];
    for(int k =0; k<[resultArray count]; k++)
    {
        ReportDataForTable* tmp = [[ReportDataForTable alloc]init];
        tmp.bankName =((BankData *)resultArray[k]).name;
        
        NSLog(@"%@", tmp.bankName);
        
        NSMutableArray *finalArray = [[NSMutableArray alloc]init];
        
        NSMutableDictionary* branchs = [[NSMutableDictionary alloc]init];
        for (BranchData *branch in (((BankData *)resultArray[k]).branch))
        {
            NSString* name = [NSString stringWithString:branch.name];
            NSString* address = [NSString stringWithFormat:@"%@, %@, %@, Украина", branch.address, branch.city, branch.region ];
            
            NSLog(@"%@", address);
            [branchs setObject:address forKey:name];
            
        }
        [finalArray addObject:branchs];
        tmp.branchs = finalArray;
        
        NSArray* currency = [[self sortedCurrency]sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];;
        for(int  i = 0; i < [resultArray count]; i++)
        {
            if(tmp.bankName == [currency[i] bank].name)
            {
                tmp.usdCurrencyAsk = [currency[i] usdCurrencyAsk];
                tmp.usdCurrencyBid = [currency[i] usdCurrencyBid];
                tmp.eurCurrencyAsk = [currency[i] eurCurrencyAsk];
                tmp.eurCurrencyBid = [currency[i] eurCurrencyBid];
                break;
            }
            
        }
        [arrayForTableView addObject:tmp];
    }
    return arrayForTableView;
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

- (NSArray*) averageCurrencyRate
{
    AppDelegate * delegate = [AppDelegate singleton];
    self.context = delegate.managedObjectContext;
    
    if(!self.averageRates)
        self.averageRates = [[NSMutableArray alloc] init];
    
    self.averageCurrency = [[AverageCurrency alloc]init];
    
    self.qtyOfBanks = [self allBanksQuantity];
    NSArray* arrayFromCoreData = [self sortedCurrency];
    
    CGFloat sumUSDAsk = 0.0;
    CGFloat sumUSDBid = 0.0;
    CGFloat sumEuroAsk = 0.0;
    CGFloat sumEuroBid = 0.0;
    CGFloat resultUSDAsk;
    CGFloat resultUSDBid;
    CGFloat resultEuroAsk;
    CGFloat resultEuroBid;
    NSInteger k = 0;
    if(self.qtyOfBanks > 0)
    {
        for(int i=0; i<[arrayFromCoreData count]/self.qtyOfBanks; i++)
        {
            for(int j = 0; j< self.qtyOfBanks; j++)
            {
                sumUSDAsk  += [[[arrayFromCoreData objectAtIndex:k ] usdCurrencyAsk ] doubleValue];
                sumUSDBid  += [[[arrayFromCoreData objectAtIndex:k ] usdCurrencyBid ] doubleValue];
                sumEuroAsk += [[[arrayFromCoreData objectAtIndex:k ] eurCurrencyAsk ] doubleValue];
                sumEuroBid += [[[arrayFromCoreData objectAtIndex:k ] eurCurrencyBid ] doubleValue];
                k++;
             }
            
            if(k == [arrayFromCoreData count])
                k -= 1;
            resultUSDAsk  = sumUSDAsk/self.qtyOfBanks;
            resultUSDBid  = sumUSDBid/self.qtyOfBanks;
            resultEuroAsk = sumEuroAsk/self.qtyOfBanks;
            resultEuroBid = sumEuroBid/self.qtyOfBanks;
            
//            NSLog(@"%f", resultUSDAsk );
//            NSLog(@"%f", resultUSDBid );
//            NSLog(@"%f", resultEuroAsk );
//            NSLog(@"%f", resultEuroBid );
            
            
            AverageCurrency * tmp = [[AverageCurrency alloc]init];
            
            tmp.date = [[arrayFromCoreData objectAtIndex:k] date];
//            
//            NSDateFormatter *monhtFormater = [[NSDateFormatter alloc] init];
//            [monhtFormater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
//            NSLog(@"Date:%@",[monhtFormater stringFromDate:tmp.date]);
//            NSLog(@"Date Origin:%@",[monhtFormater stringFromDate:[[arrayFromCoreData objectAtIndex:k] date]]);

            tmp.USDask  = [NSNumber numberWithFloat: resultUSDAsk];
            tmp.USDbid  = [NSNumber numberWithFloat: resultUSDBid];
            tmp.EURask = [NSNumber numberWithFloat: resultEuroAsk];
            tmp.EURbid = [NSNumber numberWithFloat: resultEuroBid];
            
          
            sumUSDAsk = 0.0;
            sumUSDBid = 0.0;
            sumEuroAsk = 0.0;
            sumEuroBid = 0.0;
            
            [self.averageRates addObject:tmp];
        }
        //[self print];
        return self.averageRates;
    }
    return nil;
}

- (void)print
{
    NSDateFormatter *monhtFormater = [[NSDateFormatter alloc] init];
    [monhtFormater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    for (AverageCurrency *c in self.averageRates)
    {
        NSLog(@"Date:%@, USDbid:%@, USDask:%@, EURbid:%@, EURask:%@",[monhtFormater stringFromDate:c.date],c.USDbid,c.USDask,c.EURbid,c.EURask);
    }
}

@end
