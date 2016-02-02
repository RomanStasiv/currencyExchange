//
//  JSONParseCoreDataSave.m
//  CurrencyExchange
//
//  Created by Vitaliy Yarkun on 29.01.16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "JSONParseCoreDataSave.h"
#import "AppDelegate.h"
#import "BankData.h"
#import "CurrencyData.h"
#import "BranchData.h"
#import "Fetcher.h"

@interface JSONParseCoreDataSave ()

@property (assign, nonatomic) NSInteger banksCount;
@property (assign, nonatomic) BOOL haveBranch;

@property (strong, nonatomic) NSString* bankName;
@property (strong, nonatomic) NSString* bankCity;
@property (strong, nonatomic) NSString* bankRegion;
@property (strong, nonatomic) NSString* bankAddress;
@property (strong, nonatomic) NSString* bankEURCurrencyAsk;
@property (strong, nonatomic) NSString* bankEURCurrencyBid;
@property (strong, nonatomic) NSString* bankUSDCurrencyAsk;
@property (strong, nonatomic) NSString* bankUSDCurrencyBid;
@property (strong, nonatomic) NSDate* bankDate;

@property (strong, nonatomic) NSManagedObjectContext* context;



@end


@implementation JSONParseCoreDataSave


-(void) JSONParse
{
    {
        NSString* dataUrl = @"http://resources.finance.ua/ua/public/currency-cash.json";
        NSURL* url = [NSURL URLWithString:dataUrl];
        self.jsonData = [[NSDictionary alloc] init];
        self.context = [AppDelegate singleton].managedObjectContext;
        Fetcher* fetcherObject = [[Fetcher alloc] init];
        
        
        NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url
         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){

        self.jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray* jsonArray = [self.jsonData objectForKey:@"organizations"];
        NSArray* bankNamesArray = [fetcherObject arrayOfBankNames];
        NSArray* branchNamesArray = [fetcherObject arrayOfBranchNames];
        NSString* regionToParse = @"";
        NSString* cityToParse = @"";
        NSString* dateToConvert = @"";
        NSString* dateToCut = @"";
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
             
        self.banksCount = [jsonArray count];
        
        BankData* bankToBindOrigin = nil;
        BankData* bankToBindNew = nil;
        BankData* bankToUpdate = nil;
             
        for (int i = 1; i < self.banksCount; i++)
        {
            self.bankName = [[jsonArray objectAtIndex:i] objectForKey:@"title"];
             
            self.bankAddress = [[jsonArray objectAtIndex:i] objectForKey:@"address"];
             
            self.bankEURCurrencyAsk = [[[[jsonArray objectAtIndex:i] objectForKey:@"currencies"] objectForKey:@"EUR"] objectForKey:@"ask"];
            
            self.bankEURCurrencyBid = [[[[jsonArray objectAtIndex:i] objectForKey:@"currencies"] objectForKey:@"EUR"] objectForKey:@"bid"];
             
            self.bankUSDCurrencyAsk = [[[[jsonArray objectAtIndex:i] objectForKey:@"currencies"] objectForKey:@"USD"] objectForKey:@"ask"];
             
            self.bankUSDCurrencyBid = [[[[jsonArray objectAtIndex:i] objectForKey:@"currencies"] objectForKey:@"USD"] objectForKey:@"bid"];
             
            dateToCut  = [self.jsonData objectForKey:@"date"];
            dateToConvert = [dateToCut substringWithRange:NSMakeRange(0, 19)];
            self.bankDate = [dateFormat dateFromString:dateToConvert];
             
            regionToParse = [[jsonArray objectAtIndex:i] objectForKey:@"regionId"];
             
            self.bankRegion = [[self.jsonData objectForKey:@"regions"] objectForKey:regionToParse];
             
            cityToParse = [[jsonArray objectAtIndex:i] objectForKey:@"cityId"];
            self.bankCity = [[self.jsonData objectForKey:@"cities"] objectForKey:cityToParse];
             
            self.haveBranch = [[[jsonArray objectAtIndex:i] objectForKey:@"branch"] boolValue];
             
           
            if (![bankNamesArray containsObject:self.bankName] && ![branchNamesArray containsObject:self.bankName])
            {
                
                    if (self.haveBranch == false)
                    {
                        BankData* bankData = [NSEntityDescription insertNewObjectForEntityForName:@"BankData" inManagedObjectContext:self.context];
                        
                        bankData.name = self.bankName;
                        bankData.region = self.bankRegion;
                        bankData.city = self.bankCity;
                        bankData.address = self.bankAddress;
                        
                        CurrencyData* currencyData = [NSEntityDescription insertNewObjectForEntityForName:@"CurrencyData" inManagedObjectContext:self.context];
                        currencyData.date = self.bankDate;
                        currencyData.eurCurrencyAsk = self.bankEURCurrencyAsk;
                        currencyData.eurCurrencyBid = self.bankEURCurrencyBid;
                        currencyData.usdCurrencyAsk = self.bankUSDCurrencyAsk;
                        currencyData.usdCurrencyBid = self.bankUSDCurrencyBid;
                        
                        [bankData addCurrencyObject:currencyData];
                        
                        bankToBindOrigin = bankData;
                        
                        
                    }
                    
                    if (self.haveBranch == true)
                    {
                        
                        BranchData* branchData = [NSEntityDescription insertNewObjectForEntityForName:@"BranchData" inManagedObjectContext:self.context];
                        
                        branchData.name = self.bankName;
                        branchData.region = self.bankRegion;
                        branchData.city = self.bankCity;
                        branchData.address = self.bankAddress;
                        
                        [bankToBindOrigin addBranchObject:branchData];
                    }
                
            }
           
            else  if ([bankNamesArray containsObject:self.bankName] && [branchNamesArray containsObject:self.bankName])
            {
                if (self.haveBranch == false)
                {
                    bankToUpdate = [self getBankByName:self.bankName];
                    CurrencyData* currencyData = [NSEntityDescription insertNewObjectForEntityForName:@"CurrencyData" inManagedObjectContext:self.context];
                    currencyData.date = self.bankDate;
                    currencyData.eurCurrencyAsk = self.bankEURCurrencyAsk;
                    currencyData.eurCurrencyBid = self.bankEURCurrencyBid;
                    currencyData.usdCurrencyAsk = self.bankUSDCurrencyAsk;
                    currencyData.usdCurrencyBid = self.bankUSDCurrencyBid;
                    
                    [bankToUpdate addCurrencyObject:currencyData];
                    
                    bankToBindNew = bankToUpdate;
                }
                
                if (self.haveBranch == true)
                {
                    
                    BranchData* branchData = [NSEntityDescription insertNewObjectForEntityForName:@"BranchData" inManagedObjectContext:self.context];
                    
                    branchData.name = self.bankName;
                    branchData.region = self.bankRegion;
                    branchData.city = self.bankCity;
                    branchData.address = self.bankAddress;
                    
                    [bankToBindNew addBranchObject:branchData];
                }
            }

        }
        NSError* saveError = nil;
        if (![self.context save:&saveError]) {
            NSLog(@"%@", [error localizedDescription]);
        }
             
        }];
        
        
        [downloadTask resume];
    }
    NSLog(@"Called by NSTimer!!!");
}

#pragma mark - Check the Result

- (void) loadCoreDataObjects
{
    self.context = [AppDelegate singleton].managedObjectContext;

    NSArray* objectsArray = [self getAllBanks];
    
    for (BankData* bankObject in objectsArray)
    {
        
        NSArray* currenciesArray = [bankObject.currency allObjects];
        NSArray* branchesArray = [bankObject.branch allObjects];

        
        NSLog(@"BANK: name = %@, region = %@, city = %@, address = %@ ", bankObject.name, bankObject.region, bankObject.city, bankObject.address);
        
        for (int i = 0; i < [currenciesArray count]; i++)
        {
            NSLog(@"CURRENCY of bank %@: EUR ask = %@, EUR bid = %@, USD ask = %@, USD bid = %@ DATE: %@", bankObject.name,
                  [[currenciesArray objectAtIndex:i] eurCurrencyAsk],
                  [[currenciesArray objectAtIndex:i] eurCurrencyBid],
                  [[currenciesArray objectAtIndex:i] usdCurrencyAsk],
                  [[currenciesArray objectAtIndex:i] usdCurrencyBid],
                  [[currenciesArray objectAtIndex:i] date]);
        }
        
        for (int j = 0; j < [branchesArray count]; j++)
        {
            NSLog(@"BRANCH of bank %@: name = %@, region = %@, city = %@, address = %@", bankObject.name,
                  [[branchesArray objectAtIndex:j] name],
                  [[branchesArray objectAtIndex:j] region],
                  [[branchesArray objectAtIndex:j] city],
                  [[branchesArray objectAtIndex:j] address]);
        }
            
        
    }
    
}
- (NSArray*) getAllBanks
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"BankData"
                                                   inManagedObjectContext:self.context];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.context executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

- (NSArray*) allObjects {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"ObjectData"
                                                   inManagedObjectContext:self.context];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.context executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

- (void) deleteAllObjectsFromCoreData
{
    self.context = [AppDelegate singleton].managedObjectContext;
    NSArray* allObjects = [self allObjects];
    
    for (id object in allObjects)
    {
        [self.context deleteObject:object];
    }
    
    [self.context save:nil];

}


-(BankData*) getBankByName:(NSString*) name
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"BankData"
                                                   inManagedObjectContext:self.context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"name == %@", name];
    [request setPredicate:predicate];
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.context executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return [resultArray objectAtIndex:0];
}







@end
