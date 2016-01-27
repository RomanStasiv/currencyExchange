//
//  ControllPoint.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/27/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControllPoint : NSObject // nsmanagedobje/.........

@property (nonatomic, strong) NSValue *pointOnGraph;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSString *currency;

@end
