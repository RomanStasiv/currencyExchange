//
//  GraphDrawer.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/28/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "GraphDrawer.h"

@implementation GraphDrawer

- (void)drawRect:(CGRect)rect
{
    [self removeSubviews];
    [self configureVariable];
    [self drawGrid];
    [self drawGraphForCurrency:@"dolarsBid"];
    [self drawGraphForCurrency:@"dolarsAsk"];
    [self drawGraphForCurrency:@"euroBid"];
    [self drawGraphForCurrency:@"euroAsk"];
    [self drawAxis];
    [self drawDivisionsOnAxis];
}

- (void)removeSubviews
{
    for (UIView *view in self.subviews)
    {
        if (view.tag != 113 && view.tag != 114)
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
        CGPoint a = CGPointMake(xPoint, self.insetFrame.origin.y + self.topAndRightMargin);
        CGPoint b = CGPointMake(xPoint, self.insetFrame.size.height + 20);
        [self drawLineFromPointA:a toPointB:b WithWidth:((self.segmentHeight + self.segmentWidth) / 2) * 0.01 Color:[UIColor blackColor] Dashed:NO];
        xPoint += self.segmentWidth;
    }
}

- (void)drawHorizontalLines
{
    CGFloat yPoint = self.segmentHeight + self.topAndRightMargin;
    for (int i = 0; i < self.segmentHeightCount; i++)
    {
        CGPoint a = CGPointMake(self.insetFrame.origin.x - 20, yPoint);
        CGPoint b = CGPointMake(self.frame.size.width - self.topAndRightMargin, yPoint);
        [self drawLineFromPointA:a toPointB:b WithWidth:((self.segmentHeight + self.segmentWidth) / 2) * 0.01 Color:[UIColor blackColor] Dashed:NO];
        yPoint += self.segmentHeight;
    }
}

- (void)drawLineFromPointA:(CGPoint)a toPointB:(CGPoint)b WithWidth:(CGFloat)width Color:(UIColor *)color Dashed:(BOOL)dashed
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [color setStroke];
    path.lineWidth = width;
    path.lineCapStyle = kCGLineCapRound;
    
    if (dashed)
    {
        float dashPattern[] = {width/2,width*2};
        [path setLineDash:dashPattern count:2 phase:3];
    }
    
    [path moveToPoint:a];
    [path addLineToPoint:b];
    
    [path stroke];
    [path closePath];
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
        for (int i = 0; i < points.count-1; i++)
        {
            [path addLineToPoint:[[points objectAtIndex:i] CGPointValue]];
        }
#warning HOW THIS SHOULD BE DONE?
        /*[path addLineToPoint:[self getMidPointBetweenPointA:firstPoint
                                                       andB:[[points objectAtIndex:1] CGPointValue]]];
        for (int i = 1; i < points.count-1; i++)
        {
            CGPoint midpoint = [self getMidPointBetweenPointA:[[points objectAtIndex:i] CGPointValue]
                                                         andB:[[points objectAtIndex:i+1] CGPointValue]];
            [path addQuadCurveToPoint:midpoint
                         controlPoint:[[points objectAtIndex:i] CGPointValue]];
        }
        [path addLineToPoint:[[points lastObject] CGPointValue]];*/
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
    double lightAxisInset = 5;
    //vertical axis
    CGPoint startPoint = CGPointMake(40, self.bounds.size.height - lightAxisInset);
    CGPoint stopPoint = CGPointMake(40, self.bounds.origin.y + lightAxisInset);
    [self drawYAxisFromPointA:startPoint ToPointB:stopPoint WithWidth:3 Color:[UIColor redColor] Dashed:YES];
    
    //horizontal axis
    startPoint = CGPointMake(self.bounds.origin.x + lightAxisInset, self.bounds.size.height - 40);
    stopPoint = CGPointMake(self.bounds.size.width - lightAxisInset, self.bounds.size.height - 40);
    [self drawXAxisFromPointA:startPoint ToPointB:stopPoint WithWidth:3 Color:[UIColor redColor] Dashed:YES];
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

- (void)drawDivisionsOnAxis
{
    
    if ([self.avarageCurrencyObjectsArray count])
    {
        [self drawDivisionsOnYAxe];
        [self drawDivisionsOnXAxe];
    }
}

- (void)drawDivisionsOnYAxe
{
    CGSize size0000 = [@"00.00" sizeWithAttributes:
                     @{NSFontAttributeName:
                           [UIFont systemFontOfSize:11.0f]}];
    double margin = 3;
    
    NSInteger maximumPosibleYDivisionsCount = (self.insetFrame.size.height - self.topAndRightMargin) / (size0000.height + margin);
    
    NSMutableArray *valueArray = [NSMutableArray array];
    
    CGFloat value = self.minYvalue;
    CGFloat distance = (self.maxYvalue - self.minYvalue) / (self.segmentHeightCount - 1);
    for (int i = 0; i < self.segmentHeightCount; i++)
    {
        [valueArray addObject:[NSNumber numberWithFloat:value]];
        value += distance;
    }
    
    NSArray *shrinkedValueArray = [self getShrinkedArrayFromArray:valueArray ToCount:maximumPosibleYDivisionsCount];
    
    double heightDifference = (self.insetFrame.size.height - self.topAndRightMargin) - ((size0000.height + margin) * (shrinkedValueArray.count));
    if (heightDifference > 0)
    {
        double differencePerMargin = heightDifference / (shrinkedValueArray.count - 1);
        margin = margin + differencePerMargin;
    }
    
    for (int i = 0; i < shrinkedValueArray.count; i++)
    {
        CGRect frame = CGRectMake(0,
                                  self.insetFrame.size.height - size0000.height/2 - ((size0000.height + margin)* i),
                                  size0000.width,
                                  size0000.height);
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:frame];
        valueLabel.font = [UIFont systemFontOfSize:10];
        valueLabel.text = [NSString stringWithFormat:@"%.02f",[[shrinkedValueArray objectAtIndex:i] floatValue]];
        valueLabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:valueLabel];
    }
}

- (void)drawDivisionsOnXAxe
{
    NSMutableArray *month = [NSMutableArray array];
    NSMutableArray *days = [NSMutableArray array];
    
    NSDateFormatter *monhtFormater = [[NSDateFormatter alloc] init];
    [monhtFormater setDateFormat:@"MM"];
    NSDateFormatter *dayFormater = [[NSDateFormatter alloc] init];
    [dayFormater setDateFormat:@"dd"];
    
    for (AverageCurrency *object in self.avarageCurrencyObjectsArray)
    {
        [month addObject:[monhtFormater stringFromDate:object.date]];
        [days addObject:[dayFormater stringFromDate:object.date]];
    }
    
    CGSize size00 = [@"00" sizeWithAttributes:
                     @{NSFontAttributeName:
                           [UIFont systemFontOfSize:12.0f]}];
    double margin = 3;
    NSInteger maximumPosibleXDivisionsCount = self.insetFrame.size.width / (size00.width + margin);
    

    NSArray *shrinkedDayArray = [self getShrinkedArrayFromArray:days ToCount:maximumPosibleXDivisionsCount];
    NSArray *shrinkedMonthArray = [self getShrinkedArrayFromArray:month ToCount:maximumPosibleXDivisionsCount];
    
    double widthDifference = self.insetFrame.size.width - ((size00.width + margin) * (shrinkedDayArray.count));
    if (widthDifference > 0)
    {
        double differencePerMargin = widthDifference / (shrinkedDayArray.count - 1);
        margin = margin + differencePerMargin;
    }
    
    for (int i = 0; i < shrinkedDayArray.count; i++)
    {
        
        CGRect monthFrame = CGRectMake(self.inset - size00.width/2 + ((size00.width + margin) * i),
                                       self.insetFrame.size.height + 20,
                                       size00.height,
                                       size00.width);
        
        UILabel *monthLabel = [[UILabel alloc] initWithFrame:monthFrame];
        monthLabel.backgroundColor = [UIColor lightGrayColor];
        monthLabel.font = [UIFont systemFontOfSize:11];
        monthLabel.text = [shrinkedMonthArray objectAtIndex:i];
        
        CGRect dayFrame = CGRectMake(self.inset - size00.width/2 + ((size00.width + margin) * i),
                                     self.insetFrame.size.height + 20 + size00.height,
                                     size00.height,
                                     size00.width);
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayFrame];
        dayLabel.backgroundColor = [UIColor lightGrayColor];
        dayLabel.font = [UIFont systemFontOfSize:11];
        dayLabel.text = [shrinkedDayArray objectAtIndex:i];
        [self addSubview:monthLabel];
        [self addSubview:dayLabel];
    }
}

- (NSArray *)getShrinkedArrayFromArray:(NSArray *)array ToCount:(NSInteger)desiredCount
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    if (array.count < desiredCount)
    {
        resultArray = [[NSMutableArray alloc] initWithArray:array];
    }
    else
    {
        NSInteger differance = array.count - desiredCount;
        if (differance > array.count/2)
        {
            for (int i = 1; i < array.count; i++)
            {
                if (i % 2 == 0)
                {
                    [resultArray addObject:[array objectAtIndex:i]];
                }
            }
            [self getShrinkedArrayFromArray:resultArray ToCount:desiredCount];
        }
        else
        {
            for (int i = 1; i < array.count; i++)
            {
                if (i % 3 != 0)
                {
                    [resultArray addObject:[array objectAtIndex:i]];
                }
            }
            [self getShrinkedArrayFromArray:resultArray ToCount:desiredCount];
        }
    }
    
    return resultArray;
}
    
//    CGSize size00 = [@"00" sizeWithAttributes:
//                                    @{NSFontAttributeName:
//                                          [UIFont systemFontOfSize:11.0f]}];
//    double margin = (self.segmentWidth / 10);
//    for (int i = 0; i < self.segmentWidthCount; i++)
//    {
//        if (self.segmentWidthCount > 10)
//        {
//            if (i % 2 == 0)
//            {
//                CGRect monthFrame = CGRectMake(self.inset + (self.segmentWidth * i) - (self.segmentWidth / 2) + margin,
//                                               self.frame.size.height - 30,
//                                               size00.width,
//                                               size00.height);
//                UILabel *monthLabel = [[UILabel alloc] initWithFrame:monthFrame];
//                //monthLabel.adjustsFontSizeToFitWidth = YES;
//                monthLabel.font = [UIFont systemFontOfSize:self.segmentHeight];
//                monthLabel.text = [month objectAtIndex:i];
//                
//                CGRect dayFrame = CGRectMake(self.inset + (self.segmentWidth * i) - (self.segmentWidth / 2) + (self.segmentWidth / 10),
//                                             self.frame.size.height - 30 + self.segmentWidth,
//                                             30,
//                                             self.segmentWidth);
//                UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayFrame];
//#warning HOW TO AJUST ???
//                dayLabel.font = [UIFont systemFontOfSize:self.segmentWidth - (self.segmentWidth / 10)];
//                //dayLabel.adjustsFontSizeToFitWidth = YES;
//                dayLabel.text = [days objectAtIndex:i];
//                [self addSubview:monthLabel];
//                [self addSubview:dayLabel];
//            }
//        }
//        else
//        {
//            CGRect monthFrame = CGRectMake(self.inset + (self.segmentWidth * i) - (self.segmentWidth / 2) + (self.segmentWidth / 10),
//                                           self.frame.size.height - 30,
//                                           30,
//                                           self.segmentWidth);
//            UILabel *monthLabel = [[UILabel alloc] initWithFrame:monthFrame];
//            //monthLabel.adjustsFontSizeToFitWidth = YES;
//            monthLabel.font = [UIFont systemFontOfSize:self.segmentHeight];
//            monthLabel.text = [month objectAtIndex:i];
//            
//            CGRect dayFrame = CGRectMake(self.inset + (self.segmentWidth * i) - (self.segmentWidth / 2) + (self.segmentWidth / 10),
//                                         self.frame.size.height - 30 + self.segmentWidth,
//                                         30,
//                                         self.segmentWidth);
//            UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayFrame];
//#warning HOW TO AJUST ???
//            dayLabel.font = [UIFont systemFontOfSize:self.segmentWidth - (self.segmentWidth / 10)];
//            //dayLabel.adjustsFontSizeToFitWidth = YES;
//            dayLabel.text = [days objectAtIndex:i];
//            [self addSubview:monthLabel];
//            [self addSubview:dayLabel];
//        }
//    }
//}

@end
