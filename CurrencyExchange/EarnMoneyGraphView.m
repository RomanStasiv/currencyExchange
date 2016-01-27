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

@property (nonatomic, assign) NSUInteger maxYvalue;
@property (nonatomic, assign) NSUInteger minYvalue;

@property (nonatomic, strong) NSArray *pointsOfUSDCurve;
@property (nonatomic, strong) NSArray *pointsOfEURCurve;

@property (nonatomic, assign) CGRect insetFrame;
@property (nonatomic, assign) CGFloat inset;

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
    self.inset = 50;
    self.insetFrame = CGRectMake(self.bounds.origin.x + self.inset, self.bounds.origin.y, self.bounds.size.width - self.inset, self.bounds.size.height - self.inset);
    NSLog(@"frame:%@ insetFrame:%@",NSStringFromCGRect(self.frame), NSStringFromCGRect(self.insetFrame));
    [self configureVariable];
    [self drawGrid];
    [self drawGraphForCurrency:@"dolars"];
    [self drawGraphForCurrency:@"euros"];
    [self drawAxis];
}

//__________________________hard coding 25 - len of USD
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
    self.segmentWidth = self.insetFrame.size.width / self.segmentWidthCount;
    
    int usdMax = [[self.USDArray valueForKeyPath:@"@max.intValue"] intValue];
    int eurMax = [[self.EURArray valueForKeyPath:@"@max.intValue"] intValue];
    self.maxYvalue = MAX(eurMax, usdMax);
    
    int usdMin = [[self.USDArray valueForKeyPath:@"@min.intValue"] intValue];
    int eurMin = [[self.EURArray valueForKeyPath:@"@min.intValue"] intValue];
    self.minYvalue = MIN(usdMin, eurMin);
    
    self.segmentHeightCount = self.maxYvalue - self.minYvalue;
    self.segmentHeight = self.insetFrame.size.height / self.segmentHeightCount;
    
    self.pointsOfUSDCurve = [[NSMutableArray alloc] init];
    self.pointsOfEURCurve = [[NSMutableArray alloc] init];
    self.pointsOfUSDCurve = [self makeArrayOfPointsFromArrayOfCurrency:self.USDArray];
    self.pointsOfEURCurve = [self makeArrayOfPointsFromArrayOfCurrency:self.EURArray];
}

#pragma mark - Grid
- (void)drawGrid
{
    [self drawVerticalLines];
    [self drawHorizontalLines];
}

- (void)drawVerticalLines
{
    CGFloat xPoint = self.inset;
    for (int i = 0; i < self.segmentWidthCount; i++)
    {
        CGPoint a = CGPointMake(xPoint, self.insetFrame.origin.y);
        CGPoint b = CGPointMake(xPoint, self.insetFrame.size.height + 20);
        [self drawLineFromPointA:a toPointB:b WithWidth:((self.segmentHeight + self.segmentWidth) / 2) * 0.01 andColor:[UIColor blackColor]];
        xPoint += self.segmentWidth;
    }
}

- (void)drawHorizontalLines
{
    CGFloat yPoint = self.segmentHeight;
    for (int i = 0; i < self.segmentHeightCount; i++)
    {
        CGPoint a = CGPointMake(self.insetFrame.origin.x - 20, yPoint);
        CGPoint b = CGPointMake(self.frame.size.width, yPoint);
        [self drawLineFromPointA:a toPointB:b WithWidth:((self.segmentHeight + self.segmentWidth) / 2) * 0.01 andColor:[UIColor blackColor]];
        yPoint += self.segmentHeight;
    }
}

- (void)drawLineFromPointA:(CGPoint)a toPointB:(CGPoint)b WithWidth:(CGFloat)width andColor:(UIColor *)color
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [color setStroke];
    path.lineWidth = width;
    path.lineCapStyle = kCGLineCapRound;
    
    [path moveToPoint:a];
    [path addLineToPoint:b];
    
    [path stroke];
}

#pragma mark - Graph
- (void)drawGraphForCurrency:(NSString *)currency
{
    CGFloat width = ((self.segmentWidth + self.segmentHeight) / 2) * 0.1;
    if ([currency isEqualToString: @"dolars"])
        [self drawSmoothLineFromArrayOfPoints:self.pointsOfUSDCurve
                               whithColor:self.USDStrokeColor
                                 andWidth:width];
    else if ([currency isEqualToString:@"euros"])
        [self drawSmoothLineFromArrayOfPoints:self.pointsOfEURCurve
                                   whithColor:self.EURStrokeColor
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
    CGFloat xPoint = self.inset;
    for (int i = 0; i < self.segmentWidthCount; i++)
    {
        CGPoint point = CGPointMake(xPoint, self.insetFrame.size.height - [[calibratedCurrency objectAtIndex:i] floatValue] + (self.minYvalue * self.segmentHeight));
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

#pragma mark - Axis
- (void)drawAxis
{
    //vertical axis
    CGPoint startPoint = CGPointMake(40, self.bounds.size.height);
    CGPoint stopPoint = CGPointMake(40, self.bounds.origin.y + 3);
    [self drawYAxisFromPointA:startPoint ToPointB:stopPoint WithWidth:3 AndColor:[UIColor redColor]];
    
    //horizontal axis
    startPoint = CGPointMake(self.bounds.origin.x, self.bounds.size.height - 40);
    stopPoint = CGPointMake(self.bounds.size.width - 3, self.bounds.size.height - 40);
    [self drawXAxisFromPointA:startPoint ToPointB:stopPoint WithWidth:3 AndColor:[UIColor redColor]];
}

- (void)drawXAxisFromPointA:(CGPoint)a ToPointB:(CGPoint)b WithWidth:(CGFloat)width AndColor:(UIColor *)color
{
    [self drawLineFromPointA:a toPointB:b WithWidth:width andColor:color];
    
    //drawing triangle at the end of axis
    CGFloat length[] = {1,1,1,1,3,1};
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineDash(ctx, 3, length, 6);
    CGContextSetLineWidth(ctx, width);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
    //CGContextSetFillColorWithColor(ctx, [color CGColor]);
    
    CGFloat sideLength = width;
    CGPoint FirstPoint = CGPointMake(b.x - sideLength, b.y - sideLength);
    CGPoint SecondPoint = CGPointMake(b.x - sideLength, b.y + sideLength);
    CGPoint ThirdPoint = CGPointMake(b.x, b.y);
    
    CGContextMoveToPoint(ctx, FirstPoint.x, FirstPoint.y);
    CGContextAddLineToPoint(ctx, SecondPoint.x, SecondPoint.y);
    CGContextAddLineToPoint(ctx, ThirdPoint.x, ThirdPoint.y);
    CGContextClosePath(ctx);
    
    CGContextStrokePath(ctx);
    CGContextFillPath(ctx);
    //UIGraphicsEndImageContext();
}

- (void)drawYAxisFromPointA:(CGPoint)a ToPointB:(CGPoint)b WithWidth:(CGFloat)width AndColor:(UIColor *)color
{
    [self drawLineFromPointA:a toPointB:b WithWidth:width andColor:color];
    
    //drawing triangle at the end of axis
    CGFloat length[] = {1,1,1,1,3,1};

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineDash(ctx, 3, length, 6);
    CGContextSetLineWidth(ctx, width);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    
    CGFloat sideLength = width;
    CGPoint FirstPoint = CGPointMake(b.x - sideLength, b.y + sideLength);
    CGPoint SecondPoint = CGPointMake(b.x + sideLength, b.y + sideLength);
    CGPoint ThirdPoint = CGPointMake(b.x, b.y);
    
    CGContextMoveToPoint(ctx, FirstPoint.x, FirstPoint.y);
    CGContextAddLineToPoint(ctx, SecondPoint.x, SecondPoint.y);
    CGContextAddLineToPoint(ctx, ThirdPoint.x, ThirdPoint.y);
    CGContextClosePath(ctx);
    
    CGContextStrokePath(ctx);
    CGContextFillPath(ctx);
    UIGraphicsEndImageContext();
}

- (void)drawdivisionsOnXaxis
{
    
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
    CGPoint StopPoint = CGPointMake(point.x, self.insetFrame.size.height);
    [self drawLineFromPointA:StartPoint toPointB:StopPoint WithWidth:5 andColor:[UIColor purpleColor]];
}

@end
