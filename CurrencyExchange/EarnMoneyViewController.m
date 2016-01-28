//
//  EarnMoneyViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "EarnMoneyViewController.h"
#import "EarnMoneyGraphView.h"
#import "AddControlPointToEarnMoneyViewController.h"
#import "ControllPoint.h"

@interface EarnMoneyViewController ()

@property (weak, nonatomic) IBOutlet EarnMoneyGraphView *graphView;
@property (weak, nonatomic) IBOutlet UIImageView *USDColorIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *EURColorIndicator;
@property (strong, nonatomic) NSMutableArray *arrayOfControlPoints;

@end

@implementation EarnMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.graphView.USDStrokeColor = [UIColor blueColor];
    self.graphView.EURStrokeColor = [UIColor greenColor];
    [self setNeedsOfIndicator:self.USDColorIndicator WithColor:self.graphView.USDStrokeColor];
    [self setNeedsOfIndicator:self.EURColorIndicator WithColor:self.graphView.EURStrokeColor];
}

- (void)setNeedsOfIndicator:(UIImageView *)colorIndicator WithColor:(UIColor *)color
{
    CGFloat diametr = MIN(colorIndicator.frame.size.height, colorIndicator.frame.size.width);
    
    UIGraphicsBeginImageContext(colorIndicator.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),diametr);
    
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [color CGColor]);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), diametr/2, diametr/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), diametr/2, diametr/2);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    colorIndicator.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - create control point
- (void)addControlPointWithAmountOfMoney:(CGFloat)money andCurrency:(NSString *)currency
{
    if (!self.arrayOfControlPoints)
        self.arrayOfControlPoints = [NSMutableArray array];
    
    ControllPoint *point = [[ControllPoint alloc] init];
    point.currency = currency;
    point.value = [NSNumber numberWithFloat:money];
    point.date = @"today";
    point.pointOnGraph = [NSValue valueWithCGPoint:[self.graphView getLastPointOfCurrency:point.currency]];
    
    //adding point to array in EarnMoneyVC
    if (!self.graphView.controlPointsArray)
        self.graphView.controlPointsArray = [NSArray array];
    NSMutableArray *mutableControlPointsArray = [self.graphView.controlPointsArray mutableCopy];
    [mutableControlPointsArray addObject:point];
    self.graphView.controlPointsArray = mutableControlPointsArray;
    self.graphView.NeedDrawingControlPoints = YES;
    [self.graphView setNeedsDisplay];
    
#warning not fully implement
}

#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"addControlPoint"])
    {
        ((AddControlPointToEarnMoneyViewController *)segue.destinationViewController).owner = self;
    }
}


@end
