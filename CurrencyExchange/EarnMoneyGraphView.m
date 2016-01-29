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
    if (self.drawingQueue.count)
    {
        [self drawLinesFromQueue];
    }
}

- (void)drawLinesFromQueue
{
    for (Line *line in self.drawingQueue)
    {
        [self drawLineFromPointA:[line.firstPoint CGPointValue]
                        toPointB:[line.lastPoint CGPointValue]
                       WithWidth:self.segmentWidth / 3
                        andColor:[UIColor redColor]];
    }
}

#pragma mark - Control point methods
- (void)drawAllControlpoints
{
    [self configureVariable];
    for (ControllPoint *point in self.controlPointsArray)
    {
        [self addControlPointToDrawingQueue:point];
    }
    [self setNeedsDisplay];
}

- (void)addControlPointToDrawingQueue:(ControllPoint *)point
{
    if (self.avarageCurrencyObjectsArray.count)
    {
        for (int i = 0; i < self.avarageCurrencyObjectsArray.count - 1; i++)
        {
            if (/*([((AvarageCurrency *)[self.avarageCurrencyObjectsArray objectAtIndex:i]).date compare:point.date] == NSOrderedAscending &&
                [((AvarageCurrency *)[self.avarageCurrencyObjectsArray objectAtIndex:i + 1]).date compare:point.date] == NSOrderedDescending) ||*/
                [((AvarageCurrency *)[self.avarageCurrencyObjectsArray objectAtIndex:i]).date compare:point.date] == NSOrderedSame)
            {
                if ([point.currency isEqualToString: @"dolars"])
                {
                    CGFloat xPoint = [[self.pointsOfUSDAskCurve objectAtIndex:i] CGPointValue].x;
                    Line *line = [[Line alloc]init];
                    line.firstPoint = [NSValue valueWithCGPoint:CGPointMake(xPoint, self.insetFrame.origin.y + self.inset)];
                    line.lastPoint = [NSValue valueWithCGPoint:CGPointMake(xPoint, self.insetFrame.size.height + 20)];
                    if (!self.drawingQueue)
                        self.drawingQueue = [NSMutableArray array];
                    
                    [self.drawingQueue addObject:line];
                    return;
                }
                else if ([point.currency isEqualToString: @"euro"])
                {
                    CGFloat xPoint = [[self.pointsOfEURAskCurve objectAtIndex:i] CGPointValue].x;
                    Line *line = [[Line alloc]init];
                    line.firstPoint = [NSValue valueWithCGPoint:CGPointMake(xPoint, self.insetFrame.origin.y + self.inset)];
                    line.lastPoint = [NSValue valueWithCGPoint:CGPointMake(xPoint, self.insetFrame.size.height + 20)];
                    if (!self.drawingQueue)
                        self.drawingQueue = [NSMutableArray array];
                    
                    [self.drawingQueue addObject:line];
                    return;
                }
            }
        }
    }
}
/*
- (void)insertControlPointArray:(ControllPoint *)point
{
    if (self.avarageCurrencyObjectsArray.count)
    {
        for (int i = 0; i < self.avarageCurrencyObjectsArray.count - 1; i++)
        {
#warning nonproper insertion of object
            if ([((AvarageCurrency *)[self.avarageCurrencyObjectsArray objectAtIndex:i]).date compare:point.date] == NSOrderedDescending &&
                [((AvarageCurrency *)[self.avarageCurrencyObjectsArray objectAtIndex:i + 1]).date compare:point.date] == NSOrderedAscending)
            {
                [self.avarageCurrencyObjectsArray insertObject:point atIndex:i+1];
            }
        }
    }
}


- (CGPoint)getLastPointOfCurrency:(NSString *)currency;
{
    CGPoint lastPoint;
    if ([currency isEqualToString: @"dolars"])
    {
        lastPoint = [[self.pointsOfUSDAskCurve lastObject] CGPointValue];
    }
    else if ([currency isEqualToString:@"euros"])
    {
        lastPoint = [[self.pointsOfEURAskCurve lastObject] CGPointValue];
    }
    return lastPoint;
}

- (void)drawControlPointLineOnPoint:(CGPoint)point
{
    CGPoint StartPoint = CGPointMake(point.x, self.insetFrame.origin.y);
    CGPoint StopPoint = CGPointMake(point.x, self.insetFrame.size.height + 20);
    [self drawLineFromPointA:StartPoint toPointB:StopPoint WithWidth:3 andColor:[UIColor purpleColor]];
}*/

@end
