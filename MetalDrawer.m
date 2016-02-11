//
//  MetalDrawer.m
//  CurrencyExchange
//
//  Created by Melany on 2/11/16.
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
    if(self.text == NO)
    {
    CGSize yAxisFrameSize = [@"EURO" sizeWithAttributes:
                             @{NSFontAttributeName:
                                   [UIFont systemFontOfSize:10.0f]}];
    
    CGRect yAxisFrame = CGRectMake(self.insetFrame.origin.x,
                                   offset,
                                   yAxisFrameSize.width,
                                   yAxisFrameSize.height);
    UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:yAxisFrame];
    yAxisLabel.font = [UIFont systemFontOfSize:9];
    yAxisLabel.textColor = [UIColor blackColor];
    yAxisLabel.text = @"EURO";
    [self addSubview:yAxisLabel];
    }
    else
    {
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
    }
    
    //day&monthInfoLabels
    CGSize dayInfoFrameSize = [@"day" sizeWithAttributes:
                               @{NSFontAttributeName:
                                     [UIFont systemFontOfSize:10.0f]}];
    
    CGRect dayInfoFrame = CGRectMake(self.frame.origin.x + offset-20,
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
    
    CGRect monthInfoFrame = CGRectMake(self.frame.origin.x + offset-20,
                                       self.insetFrame.size.height + 17 + dayInfoFrameSize.height + 5,
                                       monthInfoFrameSize.width,
                                       monthInfoFrameSize.height);
    UILabel *monthInfoLabel = [[UILabel alloc] initWithFrame:monthInfoFrame];
    monthInfoLabel.font = [UIFont systemFontOfSize:9];
    monthInfoLabel.textColor = [UIColor darkTextColor];
    monthInfoLabel.text = @"month";
    [self addSubview:monthInfoLabel];
}




@end
