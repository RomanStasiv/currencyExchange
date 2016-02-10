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

#import "BankInfo.h"
#import "BranchInfo.h"

#import "BranchStorage.h"

#import "Fetcher.h"

NSString* const JSONParseDidUpdatesCoreDataNotification = @"JSONParseDidUpdatedCoreDataNotification";


@interface JSONParseCoreDataSave ()

@property (assign, nonatomic) NSInteger banksCount;
@property (assign, nonatomic) BOOL haveBranch;

@property (strong, nonatomic) NSString* bankJSONName;
@property (strong, nonatomic) NSString* bankJSONCity;
@property (strong, nonatomic) NSString* bankJSONRegion;
@property (strong, nonatomic) NSString* bankJSONAddress;
@property (strong, nonatomic) NSString* bankJSONEURCurrencyAsk;
@property (strong, nonatomic) NSString* bankJSONEURCurrencyBid;
@property (strong, nonatomic) NSString* bankJSONUSDCurrencyAsk;
@property (strong, nonatomic) NSString* bankJSONUSDCurrencyBid;
@property (strong, nonatomic) NSDate* bankJSONDate;

@property (strong, nonatomic) NSManagedObjectContext* context;

@property (strong, nonatomic) NSMutableArray* branchesTempArray;
@property (strong, nonatomic) NSArray* sortedBranchesArray;
@property (strong, nonatomic) NSMutableArray* banks;

@end


@implementation JSONParseCoreDataSave


-(void) JSONParse
{
   {
        NSString* dataUrl = @"http://resources.finance.ua/ua/public/currency-cash.json";
        NSURL* url = [NSURL URLWithString:dataUrl];
        
        self.jsonData = [[NSDictionary alloc] init];
        self.banks = [NSMutableArray array];
        self.branchesTempArray = [NSMutableArray array];
        
        NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url
         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        

        self.jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray* jsonOrganizationsArray = [self.jsonData objectForKey:@"organizations"];
        
        NSString* regionToParse = @"";
        NSString* cityToParse = @"";
        NSString* dateToConvert = @"";
        NSString* dateToCut = @"";
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        BankInfo* bankToBind = nil;
             
        self.banksCount = [jsonOrganizationsArray count];
        
             
        for (int i = 1; i < self.banksCount; i++)
        {
            NSDictionary* jsonCurrenciesDictionary = [[jsonOrganizationsArray objectAtIndex:i] objectForKey:@"currencies"];

            self.bankJSONName = [[jsonOrganizationsArray objectAtIndex:i] objectForKey:@"title"];
            
            self.bankJSONAddress = [[jsonOrganizationsArray objectAtIndex:i] objectForKey:@"address"];
            
            regionToParse = [[jsonOrganizationsArray objectAtIndex:i] objectForKey:@"regionId"];
            self.bankJSONRegion = [[self.jsonData objectForKey:@"regions"] objectForKey:regionToParse];
            
            cityToParse = [[jsonOrganizationsArray objectAtIndex:i] objectForKey:@"cityId"];
            self.bankJSONCity = [[self.jsonData objectForKey:@"cities"] objectForKey:cityToParse];
            
            self.haveBranch = [[[jsonOrganizationsArray objectAtIndex:i] objectForKey:@"branch"] boolValue];
            
            if (self.haveBranch == NO) {
                
                
                
                self.bankJSONEURCurrencyAsk = [[jsonCurrenciesDictionary objectForKey:@"EUR"] objectForKey:@"ask"];
                self.bankJSONEURCurrencyBid = [[jsonCurrenciesDictionary objectForKey:@"EUR"] objectForKey:@"bid"];
                self.bankJSONUSDCurrencyAsk = [[jsonCurrenciesDictionary objectForKey:@"USD"] objectForKey:@"ask"];
                self.bankJSONUSDCurrencyBid = [[jsonCurrenciesDictionary objectForKey:@"USD"] objectForKey:@"bid"];
                
                dateToCut  = [self.jsonData objectForKey:@"date"];
                dateToConvert = [dateToCut substringWithRange:NSMakeRange(0, 19)];
                self.bankJSONDate = [dateFormat dateFromString:dateToConvert];
                
                BankInfo* bank = [[BankInfo alloc] initWithName:self.bankJSONName
                                                     withRegion:self.bankJSONRegion
                                                       withCity:self.bankJSONCity
                                                    withAddress:self.bankJSONAddress
                                                     withEURAsk:self.bankJSONEURCurrencyAsk
                                                     withEURBid:self.bankJSONEURCurrencyBid
                                                    withUSDAsks:self.bankJSONUSDCurrencyAsk
                                                     withUSDBid:self.bankJSONUSDCurrencyBid
                                                       withDate:self.bankJSONDate];
                
                [self.banks addObject:bank];
                bankToBind = bank;
            }
            else
            {
                BranchInfo* branch = [[BranchInfo alloc] initWithName:self.bankJSONName
                                                           withRegion:self.bankJSONRegion
                                                             withCity:self.bankJSONCity
                                                          withAddress:self.bankJSONAddress
                                                             withBank:bankToBind.bankName];
                
                [self.branchesTempArray addObject:branch];
                
            }
            
        }
             
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveToCoreData];
            NSLog(@"called NSTimer!!!");
        });
             
        }];
        
        [downloadTask resume];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:JSONParseDidUpdatesCoreDataNotification
                                                        object:nil
                                                      userInfo:nil];
  }

#pragma mark - Save To CoreData

-(void) saveToCoreData
{
    Fetcher* fetcher = [[Fetcher alloc] init];
    self.context = [AppDelegate singleton].managedObjectContext;
    [self saveBranchToCoreData];
    
    self.sortedBranchesArray = [[NSArray alloc] init];
    
    NSArray* bankNamesArray = [fetcher arrayOfBankNames];
    NSArray* branchNamesArray = [fetcher arrayOfBranchNames];
    
    BankData* bankToUpdate = nil;
    
    for (BankInfo* bankObject in self.banks)
    {
        if (![bankNamesArray containsObject:bankObject.bankName])
        {
            BankData* bankData = [NSEntityDescription insertNewObjectForEntityForName:@"BankData" inManagedObjectContext:self.context];
            
            bankData.name = bankObject.bankName;
            bankData.region = bankObject.bankRegion;
            bankData.city = bankObject.bankCity;
            bankData.address = bankObject.bankAddress;
            
            CurrencyData* currencyData = [NSEntityDescription insertNewObjectForEntityForName:@"CurrencyData" inManagedObjectContext:self.context];
            currencyData.date = bankObject.bankDate;
            currencyData.eurCurrencyAsk = bankObject.bankEURCurrencyAsk;
            currencyData.eurCurrencyBid = bankObject.bankEURCurrencyBid;
            currencyData.usdCurrencyAsk = bankObject.bankUSDCurrencyAsk;
            currencyData.usdCurrencyBid = bankObject.bankUSDCurrencyBid;
            
            [bankData addCurrencyObject:currencyData];
            
            NSArray* tempArray = [self getBranchesByName:bankObject.bankName];  
                
            for (BranchStorage* branchObject in tempArray)
            {
                if (![branchNamesArray containsObject:branchObject.name])
                {
                    BranchData* branchData = [NSEntityDescription insertNewObjectForEntityForName:@"BranchData" inManagedObjectContext:self.context];
                    branchData.name = branchObject.name;
                    branchData.region = branchObject.region;
                    branchData.city = branchObject.city;
                    branchData.address = branchObject.address;
                    
                    [bankData addBranchObject:branchData];
                }
            }
        }
        else
        {
            bankToUpdate = [self getBankByName:bankObject.bankName];
            
            //NSArray* tempArray = [self getBranchesByName:bankObject.bankName];
            
            
            CurrencyData* currencyData = [NSEntityDescription insertNewObjectForEntityForName:@"CurrencyData" inManagedObjectContext:self.context];
            currencyData.date = bankObject.bankDate;
            currencyData.eurCurrencyAsk = bankObject.bankEURCurrencyAsk;
            currencyData.eurCurrencyBid = bankObject.bankEURCurrencyBid;
            currencyData.usdCurrencyAsk = bankObject.bankUSDCurrencyAsk;
            currencyData.usdCurrencyBid = bankObject.bankUSDCurrencyBid;
            
            [bankToUpdate addCurrencyObject:currencyData];
        }
       
    }
    NSError *saveError;
    if(![self.context save:&saveError]){
        NSLog(@"%@", [saveError localizedDescription]);
    }
    
    
}

-(void) saveBranchToCoreData
{
    for (BranchInfo* branch in self.branchesTempArray) {
        BranchStorage* branchData = [NSEntityDescription insertNewObjectForEntityForName:@"BranchStorage" inManagedObjectContext:self.context];
        
        branchData.name = branch.branchName;
        branchData.region = branch.branchRegion;
        branchData.city = branch.branchCity;
        branchData.address = branch.branchAddress;
        branchData.bank = branch.bank;
        
    }
    
    NSError *saveError;
    if(![self.context save:&saveError]){
        NSLog(@"%@", [saveError localizedDescription]);
    }
    
}

#pragma mark - Check the Result

- (void) loadCoreDataObjects
{
    self.context = [AppDelegate singleton].managedObjectContext;

    NSArray* objectsArray = [self getAllBanks];
    
    for (BankData* bankObject in objectsArray)
    {
        
        NSArray* currenciesArray = [bankObject.currency array];
        NSArray* branchesArray = [bankObject.branch array];

        
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

-(NSArray*) getBranchesByName:(NSString*) name
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"BranchStorage"
                                                   inManagedObjectContext:self.context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"bank == %@", name];
    [request setPredicate:predicate];
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.context executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}







@end
