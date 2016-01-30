//
//  ControlPointsEarnChecker.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "ControlPointsEarnChecker.h"
#import "AverageCurrency.h"

@implementation ControlPointsEarnChecker

- (NSNumber *)canBeEarnedfromControlPoint:(ControllPoint *)point;
{
    AverageCurrency *CurrentCurrency = [self getLastCurrency];
    NSNumber *value = [self canBeEarnedOnCurrency:CurrentCurrency
                                 FromControlPoint:point];
    if ([value floatValue] > 0)
        return value;
    else
        return [NSNumber numberWithFloat:-1];
}

- (AverageCurrency *)getLastCurrency
{
    if ([self.averageCurrencyArray count])
        return [self.averageCurrencyArray lastObject];
    else
        return nil;
}

- (NSNumber *)canBeEarnedOnCurrency:(AverageCurrency *)currency FromControlPoint:(ControllPoint *)point
{
    if (point != nil && currency != nil)
    {
        NSNumber *SpendValueInGRN;
        SpendValueInGRN = [NSNumber numberWithFloat:([point.exChangeCource floatValue] * [point.value floatValue])];
        
        NSNumber *CanBeEarnedValueInGRN;
        if ([point.currency isEqualToString: @"dolars"])
        {
            CanBeEarnedValueInGRN = [NSNumber numberWithFloat:([currency.USDbid floatValue] * [point.value floatValue])];
        }
        else if ([point.currency isEqualToString: @"euro"])
        {
            CanBeEarnedValueInGRN = [NSNumber numberWithFloat:([currency.EURbid floatValue] * [point.value floatValue])];
        }
        return [NSNumber numberWithFloat:([CanBeEarnedValueInGRN floatValue] - [SpendValueInGRN floatValue])];
    }
    else
        return nil;
}

@end
