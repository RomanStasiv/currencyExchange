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

NSString* const MetalGoldUrl = @"https://www.quandl.com/api/v1/datasets/LBMA/GOLD.json";
NSString* const MetalSilverUrl = @"https://www.quandl.com/api/v1/datasets/LBMA/SILVER.json";

@interface MetalJSONParse ()

@property (strong, nonatomic) NSDate* priceMetalDate;
@property (strong, nonatomic) NSString* usdPrice;
@property (strong, nonatomic) NSString* euroPrice;

@end

@implementation MetalJSONParse

-(void) JSONMetalParse
{
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
    
    for(int i=0; i<3; i++)
    {
        Prices* tmp = [[Prices alloc]init];
        NSString *myDate = dataWithPrices[i][0];
        NSLog(@"%@", myDate);
        tmp.date = [dateFormat dateFromString:myDate];
        tmp.usdPrice = dataWithPrices[i][1];
        tmp.eurPrice = dataWithPrices[i][5];
        NSLog(@"USD %@", tmp.usdPrice);
        NSLog(@"EURO %@", tmp.eurPrice);
        
    }
    
}


@end
