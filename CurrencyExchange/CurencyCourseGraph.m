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
{/*
    [self fillCourseArrays];
    [self drawGrid];
    
    [self drawLineWithColor:[UIColor redColor] fromArray:self.EURCourse];
    [self drawLineWithColor:[UIColor purpleColor] fromArray:self.USDCourse];*/
}


-(void) fillCourseArrays
{
    self.EURCourse = [NSArray arrayWithObjects: @21.2, @21.4, @22.1, @22.2, @22.0, @21.9,  nil];
    
    self.USDCourse = [NSArray arrayWithObjects: @21.2, @21.4, @22.1, @22.2, @22.0, @21.9,  nil];
    
    NSMutableArray *tempEUR = [[self.EURCourse sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    NSMutableArray *tempUSD = [[self.USDCourse sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    [tempUSD addObject:[tempEUR firstObject]];
    [tempUSD addObject:[tempEUR lastObject]];
    [tempUSD sortUsingSelector:@selector(compare:)];
    double min = [[tempUSD firstObject] doubleValue];
    double max = [[tempUSD lastObject] doubleValue];
    
    for (int i = 1; i < [self.EURCourse count]; i ++)
    {
        //self.EURCourse[i] = (([self.EURCourse[i] doubleValue] - min) / (max - min)) * self.frame.size.height;
    }
}

-(void) fixArrayPoints
{
    //NSNumber * upperGraphLimit = @20;
}

-(void) drawLineWithColor:(UIColor *)lineColor fromArray:(NSArray *) course
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    double timeIntervalSpace = self.frame.size.width / ([course count] + 1);
    
    CGContextSetStrokeColorWithColor(context, [lineColor CGColor]);
    
    double min = [self.minCurencyElement doubleValue];
    double max = [self.maxCurencyElement doubleValue];
    CGContextMoveToPoint(context, 1*timeIntervalSpace, self.bounds.size.height - (([[course firstObject] doubleValue] - min) / (max - min) * self.bounds.size.height) );
    
    for (int i = 1; i < [course count]; i ++)
    {
        CGContextAddLineToPoint(context, (i+1)*timeIntervalSpace, self.bounds.size.height - (([[course objectAtIndex:i] doubleValue] - min) / (max - min) * self.bounds.size.height) );
    }
    
    CGContextStrokePath(context);
}

-(void) drawGrid
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    double timeIntervalSpace = self.frame.size.width / ([self.USDCourse count] + 1);
    CGContextMoveToPoint(context, 1*timeIntervalSpace, 0 );
    CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
    
    for (int i = 1; i <= [self.USDCourse count]; i++)
    {
        CGContextMoveToPoint(context, i*timeIntervalSpace, 0 );
        CGContextAddLineToPoint(context, i*timeIntervalSpace, self.bounds.size.height);
    }
    
    for (int i = 1; i < (self.bounds.size.height / timeIntervalSpace); i++)
    {
        CGContextMoveToPoint(context, 0, i*timeIntervalSpace );
        CGContextAddLineToPoint(context, self.bounds.size.height, i*timeIntervalSpace );

    }
    CGContextStrokePath(context);
}


@end
