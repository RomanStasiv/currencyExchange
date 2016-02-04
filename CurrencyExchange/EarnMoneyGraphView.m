//
//  EarnMoneyGraphView.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "EarnMoneyGraphView.h"
#import "ControllPoint.h"
#import "Line.h"


@interface EarnMoneyGraphView()

@property (nonatomic, strong) NSMutableArray *drawingQueue;

@end

@implementation EarnMoneyGraphView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.shouldDrawControlPoints)
        [self drawAllControlpoints];
    if (self.drawingQueue.count)
    {
        [self drawLinesFromQueue];
        self.drawingQueue = nil;
    }
}

- (void)drawLinesFromQueue
{
    for (Line *line in self.drawingQueue)
    {
        [self drawLineFromPointA:[line.firstPoint CGPointValue]
                        toPointB:[line.lastPoint CGPointValue]
                       WithWidth:3
                           Color:line.color
                          Dashed:YES];
        [self drawCircleInPoint:[line.originalPoint CGPointValue]
                     WithRadius:10
                          Color:line.color];
    }
}

- (void)drawCircleInPoint:(CGPoint)point WithRadius:(CGFloat)radius Color:(UIColor *)color
{
    CGRect rect = CGRectMake(point.x - radius/2, point.y - radius/2, radius, radius);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
    CGContextSetLineWidth(ctx, 2);
    CGContextAddEllipseInRect(ctx, CGRectInset(rect, 1, 1));
    CGContextStrokePath(ctx);
}

#pragma mark - Control point methods
- (void)drawAllControlpoints
{
    self.drawingQueue = nil;
    for (ControllPoint *point in self.controlPointsArray)
    {
        if ([self isItTimeForControlPoint:point])
            [self addControlPointToDrawingQueue:point withColor:[UIColor greenColor]];
        else
            [self addControlPointToDrawingQueue:point withColor:[UIColor blackColor]];
        
    }
    [self setNeedsDisplay];
}

- (BOOL)isItTimeForControlPoint:(ControllPoint *)point
{
    BOOL success = NO;
    
    if ([point.earningPosibility floatValue] > 0)
        success = YES;
    
    return success;
}

- (void)addControlPointToDrawingQueue:(ControllPoint *)point withColor:(UIColor *)successColor
{
    if (self.avarageCurrencyObjectsArray.count)
    {
        for (int i = 0; i < self.avarageCurrencyObjectsArray.count - 1; i++)
        {
            if ([((AverageCurrency *)[self.avarageCurrencyObjectsArray objectAtIndex:i]).date compare:point.date] == NSOrderedSame)
            {
                if ([point.currency isEqualToString: @"dolars"])
                {
                    CGFloat xPoint = [[self.pointsOfUSDAskCurve objectAtIndex:i] CGPointValue].x;
                    CGFloat originalYPoint = [[self.pointsOfUSDAskCurve objectAtIndex:i] CGPointValue].y;
                    Line *line = [[Line alloc]init];
                    line.firstPoint = [NSValue valueWithCGPoint:CGPointMake(xPoint, self.insetFrame.origin.y + self.topAndRightMargin)];
                    line.lastPoint = [NSValue valueWithCGPoint:CGPointMake(xPoint, self.insetFrame.size.height)];
                    line.color = successColor;
                    line.originalPoint = [NSValue valueWithCGPoint:CGPointMake(xPoint, originalYPoint)];
                    
                    if (!self.drawingQueue)
                        self.drawingQueue = [NSMutableArray array];
                    
                    if (![self.drawingQueue containsObject:line])
                        [self.drawingQueue addObject:line];
                    return;
                }
                else if ([point.currency isEqualToString: @"euro"])
                {
                    CGFloat xPoint = [[self.pointsOfEURAskCurve objectAtIndex:i] CGPointValue].x;
                    CGFloat originalYPoint = [[self.pointsOfEURAskCurve objectAtIndex:i] CGPointValue].y;
                    Line *line = [[Line alloc]init];
                    line.firstPoint = [NSValue valueWithCGPoint:CGPointMake(xPoint, self.insetFrame.origin.y + self.topAndRightMargin)];
                    line.lastPoint = [NSValue valueWithCGPoint:CGPointMake(xPoint, self.insetFrame.size.height)];
                    line.color = successColor;
                    line.originalPoint = [NSValue valueWithCGPoint:CGPointMake(xPoint, originalYPoint)];
                    
                    if (!self.drawingQueue)
                        self.drawingQueue = [NSMutableArray array];
                    if (![self.drawingQueue containsObject:line])
                        [self.drawingQueue addObject:line];
                    return;
                }
            }
        }
    }
}

@end
