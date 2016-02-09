//
//  MainScreenDrawer.m
//  CurrencyExchange
//
//  Created by Melany on 2/7/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "MainScreenDrawer.h"

@implementation MainScreenDrawer

#pragma mark - Axis





- (void)drawAxis
{
   double lightAxisInset = 5;
//vertical axis
CGPoint startPoint = CGPointMake(40, self.bounds.size.height);
CGPoint stopPoint = CGPointMake(40, self.bounds.origin.y + lightAxisInset);
    [self drawYAxisFromPointA:startPoint ToPointB:stopPoint WithWidth:3 Color:[UIColor blackColor] Dashed:YES];
    
    //horizontal axis
    startPoint = CGPointMake(self.bounds.origin.x, self.bounds.size.height - 40);
    stopPoint = CGPointMake(self.bounds.size.width - lightAxisInset, self.bounds.size.height - 40);
    [self drawXAxisFromPointA:startPoint ToPointB:stopPoint WithWidth:3 Color:[UIColor blackColor] Dashed:YES];
}


- (void)drawXAxisFromPointA:(CGPoint)a ToPointB:(CGPoint)b WithWidth:(CGFloat)width Color:(UIColor *)color Dashed:(BOOL)dashed
{
    [self drawLineFromPointA:a toPointB:b WithWidth:width Color:color Dashed:YES];
    
    //drawing triangle at the end of axis
    CGContextRef ctx = UIGraphicsGetCurrentContext();
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
    UIGraphicsEndImageContext();
}

- (void)drawYAxisFromPointA:(CGPoint)a ToPointB:(CGPoint)b WithWidth:(CGFloat)width Color:(UIColor *)color Dashed:(BOOL)dashed
{
    [self drawLineFromPointA:a toPointB:b WithWidth:width Color:color Dashed:YES];
    
    //drawing triangle at the end of axis
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, width);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
    
    CGFloat sideLength = width;
    CGPoint FirstPoint = CGPointMake(b.x - sideLength, b.y + sideLength);
    CGPoint SecondPoint = CGPointMake(b.x + sideLength, b.y + sideLength);
    CGPoint ThirdPoint = CGPointMake(b.x, b.y);
    
    CGContextMoveToPoint(ctx, FirstPoint.x, FirstPoint.y);
    CGContextAddLineToPoint(ctx, SecondPoint.x, SecondPoint.y);
    CGContextAddLineToPoint(ctx, ThirdPoint.x, ThirdPoint.y);
    CGContextClosePath(ctx);
    
    CGContextStrokePath(ctx);
    UIGraphicsEndImageContext();
}

- (void)drawInformationLabels
{
    double offset = 8;
    
    //xAxisLabel
    CGSize xAxisFrameSize = [@"time" sizeWithAttributes:
                             @{NSFontAttributeName:
                                   [UIFont systemFontOfSize:10.0f]}];
    
    CGRect xAxisFrame = CGRectMake(self.frame.size.width - (xAxisFrameSize.width + offset),
                                   self.insetFrame.size.height - offset,
                                   xAxisFrameSize.width,
                                   xAxisFrameSize.height);
    UILabel *xAxisLabel = [[UILabel alloc] initWithFrame:xAxisFrame];
    xAxisLabel.font = [UIFont systemFontOfSize:9];
    xAxisLabel.textColor = [UIColor blackColor];
    xAxisLabel.text = @"time";
    [self addSubview:xAxisLabel];
    
    //yAxisLabel
    CGSize yAxisFrameSize = [@"UAN" sizeWithAttributes:
                             @{NSFontAttributeName:
                                   [UIFont systemFontOfSize:10.0f]}];
    
    CGRect yAxisFrame = CGRectMake(self.insetFrame.origin.x,
                                   offset,
                                   yAxisFrameSize.width,
                                   yAxisFrameSize.height);
    UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:yAxisFrame];
    yAxisLabel.font = [UIFont systemFontOfSize:9];
    yAxisLabel.textColor = [UIColor blackColor];
    yAxisLabel.text = @"UAN";
    [self addSubview:yAxisLabel];
    
    //day&monthInfoLabels
    CGSize dayInfoFrameSize = [@"day" sizeWithAttributes:
                               @{NSFontAttributeName:
                                     [UIFont systemFontOfSize:10.0f]}];
    
    CGRect dayInfoFrame = CGRectMake(self.frame.origin.x + offset-20,////
                                     self.insetFrame.size.height + 17,
                                     dayInfoFrameSize.width,
                                     dayInfoFrameSize.height);
    UILabel *dayInfoLabel = [[UILabel alloc] initWithFrame:dayInfoFrame];
    dayInfoLabel.font = [UIFont systemFontOfSize:9];
    dayInfoLabel.textColor = [UIColor darkTextColor];
    dayInfoLabel.text = @"day";
    [self addSubview:dayInfoLabel];
    
    CGSize monthInfoFrameSize = [@"month" sizeWithAttributes:
                                 @{NSFontAttributeName:
                                       [UIFont systemFontOfSize:10.0f]}];
    
    CGRect monthInfoFrame = CGRectMake(self.frame.origin.x + offset-20,////
                                       self.insetFrame.size.height + 17 + dayInfoFrameSize.height + 5,
                                       monthInfoFrameSize.width,
                                       monthInfoFrameSize.height);
    UILabel *monthInfoLabel = [[UILabel alloc] initWithFrame:monthInfoFrame];
    monthInfoLabel.font = [UIFont systemFontOfSize:9];
    monthInfoLabel.textColor = [UIColor darkTextColor];
    monthInfoLabel.text = @"month";
    [self addSubview:monthInfoLabel];
}


/*
- (void)removeSubviews
{
    for (UIView *view in self.subviews)
    {
        if (view.tag != 113 && view.tag != 114 && view.tag != 115)
            [view removeFromSuperview];
    }
}

#pragma mark - preparation


- (void)configureVariable
{
    self.topAndRightMargin = 20;
    self.inset = 50;
    self.insetFrame = CGRectMake(self.bounds.origin.x + self.inset,
                                 self.bounds.origin.y,
                                 self.bounds.size.width - self.inset - self.topAndRightMargin,
                                 self.bounds.size.height - self.inset);
    //Dynamic Drid
    // ____________________________________________________________________________
    self.segmentWidthCount = [self.avarageCurrencyObjectsArray count];
    self.segmentWidth = self.insetFrame.size.width / self.segmentWidthCount;
    
    NSMutableArray * USDbidValues = [[NSMutableArray alloc] init];
    NSMutableArray * USDaskValues = [[NSMutableArray alloc] init];
    NSMutableArray * EURbidValues = [[NSMutableArray alloc] init];
    NSMutableArray * EURaskValues = [[NSMutableArray alloc] init];
    for (AverageCurrency *object in self.avarageCurrencyObjectsArray)
    {
        [USDbidValues addObject:object.USDbid];
        [USDaskValues addObject:object.USDask];
        [EURbidValues addObject:object.EURbid];
        [EURaskValues addObject:object.EURask];
    }
    
    int usdAksMax = [[USDaskValues valueForKeyPath:@"@max.intValue"] intValue];
    int eurAskMax = [[EURaskValues valueForKeyPath:@"@max.intValue"] intValue];
    self.maxYvalue = MAX(usdAksMax, eurAskMax);
    
    int usdBitMin = [[USDbidValues valueForKeyPath:@"@min.intValue"] intValue];
    int eurBitMin = [[EURbidValues valueForKeyPath:@"@min.intValue"] intValue];
    self.minYvalue = MIN(usdBitMin, eurBitMin);
    
    self.segmentHeightCount = self.maxYvalue - self.minYvalue +1;
    self.segmentHeight = (self.insetFrame.size.height - self.topAndRightMargin) / self.segmentHeightCount;
    
    
    
    //Points though which graph draws
    // ____________________________________________________________________________
    self.pointsOfUSDBidCurve = [[NSMutableArray alloc] init];
    self.pointsOfEURBidCurve = [[NSMutableArray alloc] init];
    self.pointsOfUSDAskCurve = [[NSMutableArray alloc] init];
    self.pointsOfEURAskCurve = [[NSMutableArray alloc] init];
    
    self.pointsOfUSDBidCurve = [self makeArrayOfPointsFromArrayOfCurrency:USDbidValues];
    self.pointsOfEURBidCurve = [self makeArrayOfPointsFromArrayOfCurrency:EURbidValues];
    self.pointsOfUSDAskCurve = [self makeArrayOfPointsFromArrayOfCurrency:USDaskValues];
    self.pointsOfEURAskCurve = [self makeArrayOfPointsFromArrayOfCurrency:EURaskValues];
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

#pragma mark - Graph
- (void)drawGraphForCurrency:(NSString *)currency
{
    CGFloat width = ((self.segmentWidth + self.segmentHeight) / 2) * 0.1;
    if ([currency isEqualToString: @"dolarsBid"])
    {
        [self drawSmoothLineFromArrayOfPoints:self.pointsOfUSDBidCurve
                                   whithColor:self.USDBidStrokeColor
                                     andWidth:width];
    }
    else if ([currency isEqualToString: @"dolarsAsk"])
    {
        [self drawSmoothLineFromArrayOfPoints:self.pointsOfUSDAskCurve
                                   whithColor:self.USDAskStrokeColor
                                     andWidth:width];
    }
    else if ([currency isEqualToString: @"euroBid"])
    {
        [self drawSmoothLineFromArrayOfPoints:self.pointsOfEURBidCurve
                                   whithColor:self.EURBidStrokeColor
                                     andWidth:width];
    }
    else if ([currency isEqualToString: @"euroAsk"])
    {
        [self drawSmoothLineFromArrayOfPoints:self.pointsOfEURAskCurve
                                   whithColor:self.EURAskStrokeColor
                                     andWidth:width];
    }
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
        for (int i = 0; i < points.count; i++)
        {
            [path addLineToPoint:[[points objectAtIndex:i] CGPointValue]];
        }

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
- (void)drawRect:(CGRect)rect
{
    self.fetcher = [[Fetcher alloc]init];
    self.avarageCurrencyObjectsArray = [self.fetcher averageCurrencyRate];
    [self removeSubviews];
    [self configureVariable];
    //[self drawGrid];
    [self drawGraphForCurrency:@"dolarsBid"];
    [self drawGraphForCurrency:@"dolarsAsk"];
    [self drawGraphForCurrency:@"euroBid"];
    [self drawGraphForCurrency:@"euroAsk"];
    [self drawAxis];
    //[self drawDivisionsOnAxis];
    [self drawInformationLabels];
}*/
@end
