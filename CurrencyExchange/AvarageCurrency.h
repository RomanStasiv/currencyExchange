//
//  avarageCurrency.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/28/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AvarageCurrency : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *USDbid;
@property (nonatomic, strong) NSNumber *USDask;
@property (nonatomic, strong) NSNumber *EURbid;
@property (nonatomic, strong) NSNumber *EURask;

@end
