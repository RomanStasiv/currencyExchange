//
//  ControlPointsEarnChecker.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ControllPoint.h"

@interface ControlPointsEarnChecker : NSObject

@property (nonatomic, strong) NSArray *averageCurrencyArray;

- (NSNumber *)canBeEarnedfromControlPoint:(ControllPoint *)point;

@end
