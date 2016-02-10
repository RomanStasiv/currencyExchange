//
//  MetalDrawer.m
//  CurrencyExchange
//
//  Created by Melany on 2/9/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "MetalDrawer.h"

@implementation MetalDrawer

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

- (void)drawYAxisFromPointA:(CGPoint)a ToPointB:(CGPoint)b WithWidth:(CGFloat)width Color:(UIColor *)color Dashed:(BOOL)dashed Name:(NSString*)name
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
    CGSize yAxisFrameSize = [@"USD" sizeWithAttributes:
                             @{NSFontAttributeName:
                                   [UIFont systemFontOfSize:10.0f]}];
    
    CGRect yAxisFrame = CGRectMake(self.insetFrame.origin.x,
                                   offset,
                                   yAxisFrameSize.width,
                                   yAxisFrameSize.height);
    UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:yAxisFrame];
    yAxisLabel.font = [UIFont systemFontOfSize:9];
    yAxisLabel.textColor = [UIColor blackColor];
    yAxisLabel.text = @"USD";
    [self addSubview:yAxisLabel];
    
    //day&monthInfoLabels
    CGSize dayInfoFrameSize = [@"day" sizeWithAttributes:
                               @{NSFontAttributeName:
                                     [UIFont systemFontOfSize:10.0f]}];
    
    CGRect dayInfoFrame = CGRectMake(self.frame.origin.x + offset-30,
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
    
    CGRect monthInfoFrame = CGRectMake(self.frame.origin.x + offset-30,////
                                       self.insetFrame.size.height + 17 + dayInfoFrameSize.height + 5,
                                       monthInfoFrameSize.width,
                                       monthInfoFrameSize.height);
    UILabel *monthInfoLabel = [[UILabel alloc] initWithFrame:monthInfoFrame];
    monthInfoLabel.font = [UIFont systemFontOfSize:9];
    monthInfoLabel.textColor = [UIColor darkTextColor];
    monthInfoLabel.text = @"month";
    [self addSubview:monthInfoLabel];
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
        double differencePerMargin = heightDifference / (shrinkedValueArray.count);
        margin = margin + differencePerMargin;
    }
    
    for (int i = 0; i < shrinkedValueArray.count; i++)
    {
        CGRect frame = CGRectMake(0,
                                  self.insetFrame.size.height - size0000.height - ((size0000.height + margin)* i),
                                  size0000.width,
                                  size0000.height);
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:frame];
        valueLabel.font = [UIFont systemFontOfSize:7];
        valueLabel.text = [NSString stringWithFormat:@"%.02f",[[shrinkedValueArray objectAtIndex:i] floatValue]];
        valueLabel.backgroundColor = [UIColor colorWithRed:0.07 green:0.06 blue:0.07 alpha:0.15];
        [self addSubview:valueLabel];
    }
}
- (NSArray *)getShrinkedArrayFromArray:(NSArray *)array ToCount:(NSInteger)desiredCount
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithArray:array];
    
    if (resultArray.count < desiredCount)
    {
        return resultArray;
    }
    else
    {
        NSInteger differance = resultArray.count - desiredCount;
        if (differance > resultArray.count/2)
        {
            for (int i = 1; i < resultArray.count - 1; i++)
            {
                if (i % 2 == 0)
                {
                    [resultArray removeObjectAtIndex:i];
                }
            }
        }
        else
        {
            for (int i = 1; i < resultArray.count - 1; i++)
            {
                if (i % 3 != 0)
                {
                    [resultArray removeObjectAtIndex:i];
                }
            }
        }
    }
    return [self getShrinkedArrayFromArray:resultArray ToCount:desiredCount];;
}





@end
