//
//  TestCoreData.m
//  CurrencyExchange
//
//  Created by Vitaliy Yarkun on 29.01.16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "TestCoreData.h"
#import "BankData.h"
#import "CurrencyData.h"
#import "BranchData.h"
#import "AppDelegate.h"

@interface TestCoreData ()

@property (strong, nonatomic) NSManagedObjectContext* context;

@end

@implementation TestCoreData

static NSString* regions[] = {@""};

-(void) insertFakeDataToCoreData
{
    self.context = [AppDelegate singleton].managedObjectContext;

    NSError* error = nil;
    
    for (int i = 0; i < 10; i++) {
        
        
        if (![self.context save:&error]) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
}


-(BankData*) BankDataByIndex:(NSInteger) bankIndex
{
    
    BankData* bank = [NSEntityDescription insertNewObjectForEntityForName:@"BankData" inManagedObjectContext:self.context];
    bank.name = [NSString stringWithFormat:@"Bank #%ld", bankIndex];
    bank.region = [NSString stringWithFormat:@"Bank region #%ld", bankIndex];
    
    return bank;
    
}

-(BranchData*) BranchDataByIndex:(NSInteger) branchIndex withString:(NSString*) string
{
    
    BranchData* branch = [NSEntityDescription insertNewObjectForEntityForName:@"BranchData" inManagedObjectContext:self.context];
    return branch;
    
}

-(CurrencyData*) BankDataByIndex:(NSInteger) bankIndex withEURString:(NSString*) eurString withUSDString:(NSString*) usdString withDate: (NSDate*) date
{
    
    CurrencyData* currency = [NSEntityDescription insertNewObjectForEntityForName:@"CurrencyData" inManagedObjectContext:self.context];
    return currency;
    
}







@end
