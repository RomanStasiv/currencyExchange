//
//  ControllPoint.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/27/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "ControllPoint.h"
#import "ControlPointsEarnChecker.h"
#import "CDControlPoint.h"

@implementation ControllPoint

- (void)calculateEarningPosibilityWithaverageCurrencyObjectsArray:(NSArray *)array
{
    ControlPointsEarnChecker *checker = [[ControlPointsEarnChecker alloc] init];
    checker.averageCurrencyArray = array;
    self.earningPosibility = [checker canBeEarnedfromControlPoint:self];
}

- (BOOL)isEqualToPoint:(ControllPoint *)point
{
    BOOL success = NO;
    
    if ([self.date compare:point.date] == NSOrderedSame &&
        [self.currency isEqualToString:point.currency] &&
        [self.value floatValue] == [point.value floatValue] &&
        [self.exChangeCource floatValue] == [point.exChangeCource floatValue])
    {
        success = YES;
    }
    
    return success;
}

@end
