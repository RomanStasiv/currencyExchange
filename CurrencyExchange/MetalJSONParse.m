//
//  MetalJSONParse.m
//  CurrencyExchange
//
//  Created by Melany on 2/4/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "MetalJSONParse.h"
#import "Prices.h"
#import "MetalData.h"
#import "AppDelegate.h"
#import "Fetcher.h"

NSString* const MetalGoldUrl = @"https://www.quandl.com/api/v1/datasets/LBMA/GOLD.json";
NSString* const MetalSilverUrl = @"https://www.quandl.com/api/v1/datasets/LBMA/SILVER.json";

@interface MetalJSONParse ()

@property (strong, nonatomic) NSDate* priceMetalDate;
@property (strong, nonatomic) NSString* usdPrice;
@property (strong, nonatomic) NSString* euroPrice;
@property (strong, nonatomic) NSManagedObjectContext* context;


@end

@implementation MetalJSONParse

-(void) JSONMetalParse:(NSString*)nameOfUrl
{
    AppDelegate * delegate = [AppDelegate singleton];
    self.context = delegate.managedObjectContext;
    
    NSURL* url = [NSURL URLWithString:nameOfUrl];
    NSError * e = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&e];
    
    self.jsonMetalData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    if (e)
    {
        NSLog(@"%@", [e localizedDescription]);
    }
    else
    {
        NSLog(@"Data has loaded successfully.");
        [self saveMetalCoreData];
        //        //NSLog(@"%@", self.jsonMetalData);
        //        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        //
        //        NSArray* dataWithPrices = [self.jsonMetalData objectForKey:@"data"];
        //        MetalData* metal = [NSEntityDescription insertNewObjectForEntityForName:@"MetalData" inManagedObjectContext:self.context];
        //        metal.name = [self.jsonMetalData objectForKey:@"code"];
        //        for(int i=0; i<10; i++)
        //        {
        //            Prices* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Prices" inManagedObjectContext:self.context];
        //            NSString *myDate = dataWithPrices[i][0];
        //            NSLog(@"%@", myDate);
        //            self.priceMetalDate = [dateFormat dateFromString:dataWithPrices[i][0]];
        //            tmp.date = self.priceMetalDate;
        //            self.usdPrice = dataWithPrices[i][1];
        //            tmp.usdPrice = [dataWithPrices[i][1] stringValue];
        //            self.euroPrice = dataWithPrices[i][5];
        //            tmp.eurPrice = [dataWithPrices[i][5] stringValue];
        //            NSLog(@"USD %@",  self.usdPrice);
        //            NSLog(@"EURO %@", self.euroPrice);
        //            [metal addPricesObject:tmp];
        //       }
        
    }
    NSError *saveError;
    if(![self.context save:&saveError])
    {
        NSLog(@"%@", [saveError localizedDescription]);
    }
}

- (void) movementThroughUrls
{
    [self JSONMetalParse:MetalGoldUrl];
    [self JSONMetalParse:MetalSilverUrl];
}

- (void) saveMetalCoreData
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    int j = 0;
    BOOL isNotInCoreData = YES;
    Fetcher* tmp = [[Fetcher alloc]init];
    NSArray* pricesArray = [tmp sortedPrices:NO];
    NSArray* dataWithPrices = [self.jsonMetalData objectForKey:@"data"];
    BOOL metalWithThisNameExist = NO;
    if([pricesArray count]>0)
    {
        NSInteger metalQuantity = [tmp allMetalsQuantity];
        for(int  k = 0; k < metalQuantity; k++)
        {
            if([[self.jsonMetalData objectForKey:@"code"] isEqualToString:[[pricesArray objectAtIndex:k] metal].name])
            {
                metalWithThisNameExist = YES;
                while(isNotInCoreData)
                {
                    NSString *dateDisplay = [dateFormat stringFromDate:[[pricesArray objectAtIndex:0]date]];
                    NSLog(@"%@",dateDisplay);
                    NSLog(@"%@",dataWithPrices[j][0]);
                    if (![dateDisplay isEqualToString:dataWithPrices[j][0]])
                    {
                        NSLog(@"date1 is later than date2");
                        for(int i = 0; i<metalQuantity; i++)
                        {
                            
                            Prices* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Prices" inManagedObjectContext:self.context];
                            NSString *myDate = dataWithPrices[j][0];
                            NSLog(@"%@", myDate);
                            self.priceMetalDate = [dateFormat dateFromString:dataWithPrices[i][0]];
                            tmp.date = self.priceMetalDate;
                            self.usdPrice = dataWithPrices[j][1];
                            tmp.usdPrice = [dataWithPrices[j][1] stringValue];
                            self.euroPrice = dataWithPrices[j][5];
                            tmp.eurPrice = [dataWithPrices[j][5] stringValue];
                            NSLog(@"USD %@",  self.usdPrice);
                            NSLog(@"EURO %@", self.euroPrice);
                            tmp.metal.name = [self.jsonMetalData objectForKey:@"code"];
                            [tmp.metal addPricesObject:tmp];
                            j++;
                        }
                        
                    }
                    else
                    {
                        isNotInCoreData = NO;
                        NSLog(@"dates are the same");
                        return;
                    }
                }
            }
        }
        if(!metalWithThisNameExist)
        {
            NSArray* dataWithPrices = [self.jsonMetalData objectForKey:@"data"];
           // NSInteger lastIndex = [dataWithPrices[0] count];
            MetalData* metal = [NSEntityDescription insertNewObjectForEntityForName:@"MetalData" inManagedObjectContext:self.context];
            metal.name = [self.jsonMetalData objectForKey:@"code"];
            for(int i=0; i<10; i++)
            {
                Prices* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Prices" inManagedObjectContext:self.context];
                NSString *myDate = dataWithPrices[i][0];
                NSLog(@"%@", myDate);
                self.priceMetalDate = [dateFormat dateFromString:dataWithPrices[i][0]];
                tmp.date = self.priceMetalDate;
                self.usdPrice = dataWithPrices[i][1];
                tmp.usdPrice = [dataWithPrices[i][1] stringValue];
                self.euroPrice = dataWithPrices[i][[dataWithPrices[i] count] -1];
                tmp.eurPrice = [dataWithPrices[i][[dataWithPrices[i] count] -1] stringValue];
                NSLog(@"USD %@",  self.usdPrice);
                NSLog(@"EURO %@", self.euroPrice);
                [metal addPricesObject:tmp];
            }

        }
        
    }
    else
    {
        NSArray* dataWithPrices = [self.jsonMetalData objectForKey:@"data"];
        MetalData* metal = [NSEntityDescription insertNewObjectForEntityForName:@"MetalData" inManagedObjectContext:self.context];
        metal.name = [self.jsonMetalData objectForKey:@"code"];
        for(int i=0; i<10; i++)
        {
            Prices* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Prices" inManagedObjectContext:self.context];
            NSString *myDate = dataWithPrices[i][0];
            NSLog(@"%@", myDate);
            self.priceMetalDate = [dateFormat dateFromString:dataWithPrices[i][0]];
            tmp.date = self.priceMetalDate;
            self.usdPrice = dataWithPrices[i][1];
            tmp.usdPrice = [dataWithPrices[i][1] stringValue];
            self.euroPrice = dataWithPrices[i][5];
            tmp.eurPrice = [dataWithPrices[i][5] stringValue];
            NSLog(@"USD %@",  self.usdPrice);
            NSLog(@"EURO %@", self.euroPrice);
            [metal addPricesObject:tmp];
        }
        
    }
    //    else
    //    {
    //        NSArray* dataWithPrices = [self.jsonMetalData objectForKey:@"data"];
    //        MetalData* metal = [NSEntityDescription insertNewObjectForEntityForName:@"MetalData" inManagedObjectContext:self.context];
    //        metal.name = [self.jsonMetalData objectForKey:@"code"];
    //        for(int i=0; i<10; i++)
    //        {
    //            Prices* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Prices" inManagedObjectContext:self.context];
    //            NSString *myDate = dataWithPrices[i][0];
    //            NSLog(@"%@", myDate);
    //            self.priceMetalDate = [dateFormat dateFromString:dataWithPrices[i][0]];
    //            tmp.date = self.priceMetalDate;
    //            self.usdPrice = dataWithPrices[i][1];
    //            tmp.usdPrice = [dataWithPrices[i][1] stringValue];
    //            self.euroPrice = dataWithPrices[i][5];
    //            tmp.eurPrice = [dataWithPrices[i][5] stringValue];
    //            NSLog(@"USD %@",  self.usdPrice);
    //            NSLog(@"EURO %@", self.euroPrice);
    //            [metal addPricesObject:tmp];
    //        }
    //    }
}

//- (NSArray*) allObjects
//{
//
//    NSFetchRequest* request = [[NSFetchRequest alloc] init];
//
//    NSEntityDescription* description = [NSEntityDescription entityForName:@"MetalData"
//                                                   inManagedObjectContext:self.context];
//
//    [request setEntity:description];
//
//    NSError* requestError = nil;
//    NSArray* resultArray = [self.context executeFetchRequest:request error:&requestError];
//    if (requestError) {
//        NSLog(@"%@", [requestError localizedDescription]);
//    }
//
//    return resultArray;
//}
//
//
//- (void) deleteAllObjectsFromCoreData
//{
//    self.context = [AppDelegate singleton].managedObjectContext;
//    NSArray* allObjects = [self allObjects];
//    
//    for (id object in allObjects)
//    {
//        [self.context deleteObject:object];
//    }
//    
//    [self.context save:nil];
//    
//}

@end
