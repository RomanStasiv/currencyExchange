//
//  EarnMoneyGraphView.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "EarnMoneyGraphView.h"

@implementation EarnMoneyGraphView

#pragma mark - Control point methods
- (CGPoint)getLastPointOfCurrency:(NSString *)currency;
{
    CGPoint lastPoint;
    if ([currency isEqualToString: @"dolars"])
    {
        lastPoint = [[self.pointsOfUSDCurve lastObject] CGPointValue];
    }
    else if ([currency isEqualToString:@"euros"])
    {
        lastPoint = [[self.pointsOfEURCurve lastObject] CGPointValue];
    }
    return lastPoint;
}

- (void)drawControlPointLineOnPoint:(CGPoint)point
{
    CGPoint StartPoint = CGPointMake(point.x, self.insetFrame.origin.y);
    CGPoint StopPoint = CGPointMake(point.x, self.insetFrame.size.height);
    [self drawLineFromPointA:StartPoint toPointB:StopPoint WithWidth:5 andColor:[UIColor purpleColor]];
}

@end
