//
//  PieChartView.m
//  CurrencyExchange
//
//  Created by Roman Stasiv on 2/10/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "PieChartView.h"

#define degreesToRadians(x) ((x) * M_PI / 180.0)
#define radiansToDegrees(x) ((x) * 180.0 / M_PI)

@interface PieChartView()
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *chartPieces;
@property (nonatomic, strong) UILabel *leftLabel;

@end
@implementation PieChartView

-(void)updateWithArray: (NSArray *) chartPieces
         segmentColors: (NSArray *) colors
{
    self.colors = colors;
    self.chartPieces = chartPieces;
    [self setNeedsDisplay];
    self.clipsToBounds = true;
    static dispatch_once_t onceToken;
    [self configureLabel];
    
    
}

-(void)configureLabel
{
    if (!self.leftLabel)
    {
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height/2 - 20, self.frame.size.width/2 - 20, 40, 40)];
        [self addSubview:self.leftLabel];
    }
    self.leftLabel.text = [[self.chartPieces lastObject] stringValue];
    [self.leftLabel sizeToFit];
    CGRect frame = self.leftLabel.frame;
    frame.origin.x = (self.frame.size.height/2 - self.leftLabel.frame.size.height/2);
    frame.origin.y = (self.frame.size.height/2 - self.leftLabel.frame.size.height/2);
    self.leftLabel.frame = frame;
}

-(void)chartPathSegmentsWithArray:(NSArray *)chartPieces
{
    //chartPieces = [NSArray arrayWithObjects:@5, @60, @5,  nil];
    NSMutableArray *pointsForArcs = [[NSMutableArray alloc] init];
    double R = self.frame.size.width/2.f;
    double k = 0;
    double n = [chartPieces count];
    int sum = 0;
    for (NSNumber *pieceLenght in chartPieces)
    {
        sum += [pieceLenght intValue];
    }
    [pointsForArcs addObject:[NSValue valueWithCGPoint:CGPointMake(50, 0)]];
    double alpha = 270;
    while (k < n)
    {
        alpha += 360*([[chartPieces objectAtIndex:k] doubleValue] / sum);
        
        CGPoint point = CGPointMake(0 + R*cos(M_PI*alpha/180)+R, 0 + R*sin(M_PI*alpha/180)+R);
        [pointsForArcs addObject:[NSValue valueWithCGPoint:point]];
        k++;
    }
    
    CGPoint chartCenter = CGPointMake(0 + self.frame.size.height/2, 0 + self.frame.size.width/2);
    
    double curentAngle = 270;
    
    for (int i = 0; i < [chartPieces count]; i++)
    {
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:chartCenter];
        [path addLineToPoint:[[pointsForArcs objectAtIndex:i] CGPointValue]];
        double distanceBeetweenPoints = sqrt(pow([[pointsForArcs objectAtIndex:i] CGPointValue].x - [[pointsForArcs objectAtIndex:i + 1] CGPointValue].x, 2) +
                                             pow([[pointsForArcs objectAtIndex:i] CGPointValue].y - [[pointsForArcs objectAtIndex:i + 1] CGPointValue].y, 2) );
        NSLog(@"%f", distanceBeetweenPoints);
        double angle = acos((2*pow(chartCenter.x, 2) - pow(distanceBeetweenPoints, 2) )/(2*pow(chartCenter.x, 2)) );
        
        if ([[chartPieces objectAtIndex:i] integerValue] > sum / 2)
        {
            angle = 2 * M_PI - angle;
        }
        
        [path addArcWithCenter:chartCenter radius:chartCenter.x startAngle:degreesToRadians(curentAngle) endAngle:degreesToRadians(curentAngle) + angle clockwise:YES];
        curentAngle += radiansToDegrees(angle);
        [path addLineToPoint:chartCenter];
        
        [[self.colors objectAtIndex:i] setFill];
        [path fill];
    }
    self.alpha = 0.7;
}



- (void)drawRect:(CGRect)rect
{
    [self chartPathSegmentsWithArray:self.chartPieces];
    CGPoint chartCenter = CGPointMake(0 + self.frame.size.width/2, 0 + self.frame.size.height/2);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 40);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextMoveToPoint(context, chartCenter.x, chartCenter.y);
    CGContextAddLineToPoint(context, chartCenter.x, chartCenter.y);
    CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
    CGContextStrokePath(context);
}


@end
