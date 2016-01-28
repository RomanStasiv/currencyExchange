//
//  EarnMoneyGraphView.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "EarnMoneyGraphView.h"
#import "ControllPoint.h"

@implementation EarnMoneyGraphView

- (void)drawRect:(CGRect)rect
{
    self.inset = 50;
    self.insetFrame = CGRectMake(self.bounds.origin.x + self.inset, self.bounds.origin.y, self.bounds.size.width - self.inset, self.bounds.size.height - self.inset);
    NSLog(@"frame:%@ insetFrame:%@",NSStringFromCGRect(self.frame), NSStringFromCGRect(self.insetFrame));
    [self configureVariable];
    [self drawGrid];
    [self drawGraphForCurrency:@"dolars"];
    [self drawGraphForCurrency:@"euros"];
    [self drawAxis];
    if (self.NeedDrawingControlPoints)
    {
        for (ControllPoint *p in self.controlPointsArray)
        {
            [self drawControlPointLineOnPoint:[p.pointOnGraph CGPointValue]];
        }
    }
}

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
    CGPoint StopPoint = CGPointMake(point.x, self.insetFrame.size.height + 20);
    [self drawLineFromPointA:StartPoint toPointB:StopPoint WithWidth:3 andColor:[UIColor purpleColor]];
}

@end
