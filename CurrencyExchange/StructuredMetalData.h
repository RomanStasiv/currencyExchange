//
//  StructuredMetalData.h
//  CurrencyExchange
//
//  Created by Melany on 2/9/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StructuredMetalData : NSObject


@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSNumber* goldUsdPrice;
@property (strong, nonatomic) NSNumber* goldEuroPrice;
@property (strong, nonatomic) NSNumber* silverUsdPrice;;
@property (strong, nonatomic) NSNumber* silverEuroPrice;


@end
