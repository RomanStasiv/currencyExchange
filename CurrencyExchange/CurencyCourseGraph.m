//
//  CurencyCourseGraph.m
//  CurrencyExchange
//
//  Created by Roman Stasiv on 1/27/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "CurencyCourseGraph.h"

@interface CurencyCourseGraph ()

@property (nonatomic, strong) NSArray *EURCourse;
@property (nonatomic, strong) NSArray *USDCourse;

@property (nonatomic, strong) NSNumber *minCurencyElement;

@property (nonatomic, strong) NSNumber *maxCurencyElement;
@end

@implementation CurencyCourseGraph

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self fillCourseArrays];
    [self drawLineWithColor:[UIColor redColor] fromArray:self.EURCourse];
}


-(void) fillCourseArrays
{
    self.EURCourse = [NSArray arrayWithObjects: @21.2, @21.4, @22.1, @22.2, @22.0, @21.9,  nil];
    
    self.USDCourse = [NSArray arrayWithObjects: @19.2, @19.4, @20.1, @20.2, @20.0, @19.9,  nil];
    
    NSMutableArray *tempEUR = [[self.EURCourse sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    NSMutableArray *tempUSD = [[self.USDCourse sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    [tempUSD addObject:[tempEUR firstObject]];
    [tempUSD addObject:[tempEUR lastObject]];
    [tempUSD sortUsingSelector:@selector(compare:)];
    double min = [[tempUSD firstObject] doubleValue];
    double max = [[tempUSD lastObject] doubleValue];
    
    for (int i = 1; i < [self.EURCourse count]; i ++)
    {
        self.EURCourse[i] = (([self.EURCourse[i] doubleValue] - min) / (max - min)) * self.frame.size.height;
    }
}

-(void) fixArrayPoints
{
    //NSNumber * upperGraphLimit = @20;
}

-(void) drawLineWithColor:(UIColor *)lineColor fromArray:(NSArray *) course
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    double timeIntervalSpace = self.frame.size.width / [course count];
    
    CGContextSetStrokeColorWithColor(context, [lineColor CGColor]);
    CGContextMoveToPoint(context, 0*timeIntervalSpace, [[course firstObject] floatValue]);
    
    for (int i = 1; i < [course count]; i ++)
    {
        CGContextAddLineToPoint(context, i*timeIntervalSpace, [[course objectAtIndex:i] floatValue] );
    }
    
    CGContextStrokePath(context);
}


@end
