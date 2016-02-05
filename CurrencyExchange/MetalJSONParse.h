//
//  MetalJSONParse.h
//  CurrencyExchange
//
//  Created by Melany on 2/4/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetalJSONParse : NSObject

@property (strong, nonatomic) NSDictionary* jsonMetalData;

-(void) JSONMetalParse;

@end
