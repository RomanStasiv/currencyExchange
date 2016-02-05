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

NSString* const MetalGoldUrl = @"https://www.quandl.com/api/v1/datasets/LBMA/GOLD.json";
NSString* const MetalSilverUrl = @"https://www.quandl.com/api/v1/datasets/LBMA/SILVER.json";

@interface MetalJSONParse ()

@property (strong, nonatomic) NSDate* priceMetalDate;
@property (strong, nonatomic) NSString* usdPrice;
@property (strong, nonatomic) NSString* euroPrice;
@property (strong, nonatomic) NSManagedObjectContext* context;


@end

@implementation MetalJSONParse

-(void) JSONMetalParse
{
    AppDelegate * delegate = [AppDelegate singleton];
    self.context = delegate.managedObjectContext;

    NSURL* url = [NSURL URLWithString:MetalGoldUrl];
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
    }
    //NSLog(@"%@", self.jsonMetalData);
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSArray* dataWithPrices = [self.jsonMetalData objectForKey:@"data"];
    MetalData* metal = [NSEntityDescription insertNewObjectForEntityForName:@"MetalData" inManagedObjectContext:self.context];
    metal.name = [self.jsonMetalData objectForKey:@"code"];
    for(int i=0; i<10; i++)
    {
        Prices* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Prices" inManagedObjectContext:self.context];
        NSString *myDate = dataWithPrices[i][0];
        NSLog(@"%@", myDate);
        self.priceMetalDate = [dateFormat dateFromString:myDate];
        tmp.date = self.priceMetalDate;
        self.usdPrice = dataWithPrices[i][1];
        tmp.usdPrice = [dataWithPrices[i][1] stringValue];
        self.euroPrice = dataWithPrices[i][5];
        tmp.eurPrice = [dataWithPrices[i][5] stringValue];
        NSLog(@"USD %@",  self.usdPrice);
        NSLog(@"EURO %@", self.euroPrice);
        [metal addPricesObject:tmp];
     }
    NSError *saveError;
    if(![self.context save:&saveError])
    {
        NSLog(@"%@", [saveError localizedDescription]);
    }
}


@end
