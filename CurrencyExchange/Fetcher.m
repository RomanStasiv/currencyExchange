//
//  Fetcher.m
//  CurrencyExchange
//
//  Created by Melany on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "Fetcher.h"

NSString* const CoreDataDidSavedNotification = @"CoreDataDidSavedNotification";
NSString* const CoreDataDidSavedUserInfoKey = @"CoreDataDidSavedUserInfoKey";


@interface Fetcher ()

@property (strong, nonatomic) NSArray* banksArray;
@property (assign, nonatomic) NSInteger qtyOfBanks;

@end


@implementation Fetcher

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];

        [nc addObserver:self
               selector:@selector(averageCurrencyRate)
                   name:JSONParseDidUpdatesCoreDataNotification
                 object:nil];
        
    }
    return self;
}

- (void) dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - Methods

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

- (NSArray*) allBanks
{
    AppDelegate * delegate = [AppDelegate singleton];
    self.context = delegate.managedObjectContext;
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"BankData"
                inManagedObjectContext:self.context];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.context executeFetchRequest:request error:&requestError];
    
    //    NSInteger qty = [resultArray count];
    //
    //    for(int i = 0; i < qty; i++)
    //    {
    //        NSString* tmp = [NSString stringWithString:((BankData *)resultArray[i]).name];
    //        NSLog(@"%@", tmp);
    //    }
    
    return resultArray;
}

- (NSArray*) allBranchs
{
    AppDelegate * delegate = [AppDelegate singleton];
    self.context = delegate.managedObjectContext;
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"BranchData"
                inManagedObjectContext:self.context];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.context executeFetchRequest:request error:&requestError];
    
    return resultArray;
}


- (NSArray*) arrayOfBankNames
{
    NSMutableArray* banksNames = [[NSMutableArray alloc]init];
    
    NSArray* resultArray = [self allBanks];
    NSInteger qty = [resultArray count];
    
    for(int i = 0; i < qty; i++)
    {
        NSString* tmp = [NSString stringWithString:((BankData *)resultArray[i]).name];
        [banksNames addObject:tmp];
    }
    return banksNames;
}

- (NSArray*) arrayOfBranchNames
{
    NSMutableArray* branchNames = [[NSMutableArray alloc]init];
    
    NSArray* resultArray = [self allBranchs];
    NSInteger qty = [resultArray count];
    
    for(int i = 0; i < qty; i++)
    {
        NSString* tmp = [NSString stringWithString:((BranchData *)resultArray[i]).name];
        [branchNames addObject:tmp];
    }
    return branchNames;
}

- (NSMutableArray*) dataForTableView
{
    NSMutableArray *arrayForTableView = [[NSMutableArray alloc]init];
    
    NSArray* resultArray = [self allBanks];
    NSArray* resultBranchArray = [self allBranchs];
    NSInteger qty = [resultArray count];
    for(int k =0; k<qty; k++)
    {
        ReportDataForTable* tmp = [[ReportDataForTable alloc]init];
        tmp.bankName =((BankData *)resultArray[k]).name;
        tmp.bankStreet = ((BankData *)resultArray[k]).address;
        tmp.bankCity = ((BankData *)resultArray[k]).city;
        tmp.bankRegion = ((BankData *)resultArray[k]).region ;
       // tmp.bankAddress = [NSString stringWithFormat:@"%@, %@, %@", ((BankData *)resultArray[k]).address, ((BankData *)resultArray[k]).city, ((BankData *)resultArray[k]).region ];
        //NSLog(@"%@", tmp.brankAddress);
        
        //NSLog(@"%@", tmp.bankName);
        
        NSMutableArray *finalArray = [[NSMutableArray alloc]init];
        
        NSMutableDictionary* branchs = [[NSMutableDictionary alloc]init];
        for (BranchData *branch in resultBranchArray)
        {
            if(tmp.bankName == branch.bank.name)
            {
                NSString* name = [NSString stringWithString:branch.name];
                //NSString* address = [NSString stringWithFormat:@"%@, %@, %@", branch.address, branch.city, branch.region ];
                
                // NSLog(@"%@", name);
                [branchs setObject:name forKey:@"name"];
                [branchs setObject:branch.address forKey:@"address"];
                [branchs setObject:branch.city forKey:@"city"];
                [branchs setObject:branch.region forKey:@"region"];
            }
           
        }
        //NSLog(@"%lu", (unsigned long)[branchs count]);
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
        // NSLog(@"%@, %lu, USD:%@, USD:%@, EURO:%@, EURO:%@", tmp.bankName, (unsigned long)[tmp.branchs count], tmp.usdCurrencyAsk, tmp.usdCurrencyBid, tmp.eurCurrencyAsk, tmp.eurCurrencyBid);
        [arrayForTableView addObject:tmp];
    }
    return arrayForTableView;
}


- (NSInteger) allBanksQuantity
{
    
    self.qtyOfBanks = [[self allBanks]count];
    
    NSLog(@" %ld",self.qtyOfBanks);
    
    return self.qtyOfBanks;
}

- (NSArray*) averageCurrencyRate
{
    AppDelegate * delegate = [AppDelegate singleton];
    self.context = delegate.managedObjectContext;
   // NSLog(@"Qty of Currencies %lu", [[self sortedCurrency]count]/[self allBanksQuantity]);
//   NSLog(@"Qty of Currencies %lu", [[self sortedCurrency]count]);
//   NSLog(@"Qty of Banks %lu", [self allBanksQuantity]);
//   NSLog(@"Qty of Currencies %lu", [[self sortedCurrency]count]/[self allBanksQuantity]);
    
    
    if(!self.averageRates)
        self.averageRates = [[NSMutableArray alloc] init];
    
    self.averageCurrency = [[AverageCurrency alloc]init];
    
    self.qtyOfBanks = [self allBanksQuantity];
    NSArray* arrayFromCoreData = [self sortedCurrency];
    
    CGFloat sumUSDAsk = 0.0;
    CGFloat sumUSDBid = 0.0;
    CGFloat sumEuroAsk = 0.0;
    CGFloat sumEuroBid = 0.0;
    CGFloat resultUSDAsk, resultUSDBid, resultEuroAsk, resultEuroBid ;
    
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
        
        NSDictionary* dictionary = [NSDictionary dictionaryWithObject:self.averageRates
                                                               forKey:CoreDataDidSavedUserInfoKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CoreDataDidSavedNotification
                                                            object:nil
                                                          userInfo:dictionary];
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
