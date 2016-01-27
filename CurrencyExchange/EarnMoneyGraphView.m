//
//  EarnMoneyGraphView.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "EarnMoneyGraphView.h"

@interface EarnMoneyGraphView()

@property (nonatomic, assign) CGFloat segmentWidth;
@property (nonatomic, assign) NSUInteger segmentWidthCount;
@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, assign) NSUInteger segmentHeightCount;

@property (nonatomic, strong) NSArray *pointsOfUSDCurve;
@property (nonatomic, strong) NSArray *pointsOfEURCurve;

@end


static NSString* USD[] = {
    @"25", @"25.5", @"26", @"24", @"25",
    @"22", @"20", @"19", @"18", @"17",
    @"20", @"22", @"25", @"27", @"30",
    @"31", @"32", @"35", @"33", @"36",
    @"40", @"35", @"30", @"25", @"24",
};
static NSString* EUR[] = {
    @"26", @"28.5", @"29", @"28", @"27",
    @"25", @"27", @"30", @"33", @"33",
    @"33", @"31", @"31", @"32", @"30",
    @"31", @"32", @"35", @"33", @"36",
    @"40", @"35", @"30", @"25", @"24",
};


@implementation EarnMoneyGraphView

- (void)drawRect:(CGRect)rect
{
    [self configureVariable];
    [self drawGraphWithArray:self.USDArray];
    [self drawGraphWithArray:self.EURArray];
}

- (void)configureVariable
{
    self.EURArray = [[NSMutableArray alloc] init];
    self.USDArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 25; i++)
    {
        [self.EURArray addObject:[NSNumber numberWithFloat:[EUR[i] floatValue]]];
        [self.USDArray addObject:[NSNumber numberWithFloat:[USD[i] floatValue]]];
    }
    
    self.segmentWidthCount = [self.USDArray count];
    self.segmentWidth = self.frame.size.width / self.segmentWidthCount;
    
    self.segmentHeightCount = 40;
    self.segmentHeight = self.frame.size.height / self.segmentHeightCount;
}

- (void)drawGrid
{
    for (int i = 0; i < self.segmentWidthCount; i++)
    {
        
    }
}

- (void)drawLineFromPointA:(CGPoint)a toPointB:(CGPoint)b
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [[UIColor blackColor] setStroke];
    path.lineWidth = 0.5;
    path.lineCapStyle = kCGLineCapRound;
    
    [path moveToPoint:a];
    [path addLineToPoint:b];
    
    [path stroke];
}

- (void)drawGraphWithArray:(NSArray *)array
{
    CGFloat width = ((self.segmentWidth + self.segmentHeight) / 2) * 0.2;
    [self drawSmoothLineFromArrayOfPoints:[self makeArrayOfPointsFromArrayOfCurrency:array]
                               whithColor:[UIColor redColor]
                                 andWidth:width];
}

- (NSArray *)makeArrayOfPointsFromArrayOfCurrency:(NSArray *)currency
{
    NSMutableArray *calibratedCurrency = [NSMutableArray array];
    for (int i = 0; i < currency.count; i++)
    {
        [calibratedCurrency addObject:[NSNumber numberWithFloat:[[currency objectAtIndex:i] floatValue] * self.segmentHeight]];
    }
    
    
    NSMutableArray *arrayOfPoints = [NSMutableArray array];
    CGFloat xPoint = 0;
    for (int i = 0; i < self.segmentWidthCount; i++)
    {
        CGPoint point = CGPointMake(xPoint, self.frame.size.height - [[calibratedCurrency objectAtIndex:i] floatValue]);
        [arrayOfPoints addObject:[NSValue valueWithCGPoint:point]];
        xPoint += self.segmentWidth;
    }
    return arrayOfPoints;
}


- (void)drawSmoothLineFromArrayOfPoints:(NSArray *)points whithColor:(UIColor *)color andWidth:(CGFloat)width
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [color setStroke];
    path.lineWidth = width;
    
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    
    NSValue *value = [points firstObject];
    CGPoint firstPoint = [value CGPointValue];
    [path moveToPoint:firstPoint];
    
    if (points.count > 2)
    {
        [path addLineToPoint:[self getMidPointBetweenPointA:firstPoint
                                                       andB:[[points objectAtIndex:1] CGPointValue]]];
        for (int i = 1; i < points.count-1; i++)
        {
            CGPoint midpoint = [self getMidPointBetweenPointA:[[points objectAtIndex:i] CGPointValue]
                                                         andB:[[points objectAtIndex:i+1] CGPointValue]];
            [path addQuadCurveToPoint:midpoint
                         controlPoint:[[points objectAtIndex:i] CGPointValue]];
        }
        [path addLineToPoint:[[points lastObject] CGPointValue]];
    }
    else if (points.count == 2)
    {
        [path addLineToPoint:[self getMidPointBetweenPointA:firstPoint andB:[[points objectAtIndex:1] CGPointValue]]];
    }
    else
    {
        [path addLineToPoint:firstPoint];
    }
    [path stroke];
}

- (CGPoint) getMidPointBetweenPointA:(CGPoint)a andB:(CGPoint)b
{
    return CGPointMake((a.x + b.x)/2, (a.y + b.y)/2);
}




@end
