//
//  CurencyCourseGraph.m
//  CurrencyExchange
//
//  Created by Roman Stasiv on 1/27/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "CurencyCourseGraph.h"

@interface CurencyCourseGraph ()

@property (nonatomic,strong) NSArray* EURCourse;
@property (nonatomic,strong) NSArray* USDCourse;


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
    for (int i = 0; i < [course count]; i ++)
    {
        CGContextAddLineToPoint(context, [[course objectAtIndex:i] floatValue], i*(timeIntervalSpace+1) );
    }
    
    CGContextStrokePath(context);
}


@end
