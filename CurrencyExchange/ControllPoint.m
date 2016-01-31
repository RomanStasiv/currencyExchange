//
//  ControllPoint.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/27/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "ControllPoint.h"
#import "ControlPointsEarnChecker.h"

@implementation ControllPoint

- (void)calculateEarningPosibilityWithaverageCurrencyObjectsArray:(NSArray *)array
{
    ControlPointsEarnChecker *checker = [[ControlPointsEarnChecker alloc] init];
    checker.averageCurrencyArray = array;
    self.earningPosibility = [checker canBeEarnedfromControlPoint:self];
}

@end
