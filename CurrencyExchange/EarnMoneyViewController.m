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
#import "ControlPointCDManager.h"
#import "ControlPointsEarnChecker.h"
#import "Fetcher.h"

@interface EarnMoneyViewController ()

@property (weak, nonatomic) IBOutlet EarnMoneyGraphView *graphView;
@property (weak, nonatomic) IBOutlet UIImageView *USDColorIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *EURColorIndicator;
@property (strong, nonatomic) NSMutableArray *arrayOfControlPoints;
@property (nonatomic, strong) NSMutableArray *avarageCurrencyObjectsArray;

@end
/*
static NSString* USDbid[] = {
    @"25", @"25.5", @"26", @"24", @"25",
    @"22", @"20", @"19", @"18", @"17",
    @"20", @"22", @"25", @"27", @"30"
};
static NSString* USDask[] = {
    @"26", @"27", @"28", @"25", @"26",
    @"23", @"21", @"20", @"19", @"18",
    @"22", @"23", @"26", @"28", @"31"
};
static NSString* EURbid[] = {
    @"26", @"28.5", @"29", @"28", @"27",
    @"25", @"27", @"30", @"33", @"33",
    @"33", @"31", @"31", @"32", @"30"
    
};
static NSString* EURask[] = {
    @"27", @"29", @"30", @"30", @"29",
    @"27", @"27", @"33", @"35", @"35",
    @"35", @"33", @"33", @"34", @"32"
};*/

@implementation EarnMoneyViewController

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveData)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveData)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(restoreData)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(restoreData)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];*/
    [super viewDidLoad];
    [self prepareGraphView];
    /*self.graphView.USDStrokeColor = [UIColor blueColor];
     self.graphView.EURStrokeColor = [UIColor greenColor];
     [self setNeedsOfIndicator:self.USDColorIndicator WithColor:self.graphView.USDStrokeColor];
     [self setNeedsOfIndicator:self.EURColorIndicator WithColor:self.graphView.EURStrokeColor];*/
    
    
}

- (void)prepareGraphView
{
    Fetcher *fetch = [[Fetcher alloc]init];
    self.avarageCurrencyObjectsArray = [[fetch averageCurrencyRate] mutableCopy];
    self.graphView.avarageCurrencyObjectsArray = self.avarageCurrencyObjectsArray;
    [self restoreData];
}

/*- (NSArray *)avarageCurrencyObjectsArray
{
    if (!_avarageCurrencyObjectsArray)
    {
        _avarageCurrencyObjectsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 15; i++)
        {
            NSTimeInterval secondsPerDay = 24 * 60 * 60; // Интервал в 1 день равный 86 400 секунд
            NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay * i];
            
            AverageCurrency *object = [[AverageCurrency alloc] init];
            object.USDbid = [NSNumber numberWithFloat:[USDbid[i] floatValue]];
            object.USDask = [NSNumber numberWithFloat:[USDask[i] floatValue]];
            object.EURbid = [NSNumber numberWithFloat:[EURbid[i] floatValue]];
            object.EURask = [NSNumber numberWithFloat:[EURask[i] floatValue]];
            object.date = date;
            
            [_avarageCurrencyObjectsArray addObject:object];
        }
    }
    return _avarageCurrencyObjectsArray;
}*/

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
- (void)addControlPointWithAmountOfMoney:(CGFloat)money Currency:(NSString *)currency ForDate:(NSDate *)date
{
    ControllPoint *point = [[ControllPoint alloc] init];
    point.currency = currency;
    point.value = [NSNumber numberWithFloat:money];
   /* NSTimeInterval secondsPerDay = 24 * 60 * 60; // Интервал в 1 день равный 86 400 секунд
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay * 4];
    point.date = [[NSDate alloc] init];*/
    point.date = date;
    AverageCurrency *thisCurrency = [[AverageCurrency alloc] init];
    for (AverageCurrency *currency in self.avarageCurrencyObjectsArray)
    {
        if ([currency.date compare:date] == NSOrderedSame)
            thisCurrency = currency;
    }
    if ([currency isEqualToString:@"dolars"])
        point.exChangeCource = thisCurrency.USDask;
    else if ([currency isEqualToString:@"euro"])
        point.exChangeCource = thisCurrency.EURask;
    
    //adding point to array in EarnMoneyVC
    if (!self.arrayOfControlPoints)
        self.arrayOfControlPoints = [NSMutableArray array];
    [self.arrayOfControlPoints addObject:point];
    
    if (!self.graphView.controlPointsArray)
        self.graphView.controlPointsArray = [NSArray array];
    
    /*NSMutableArray *mutableControlPointsArray = [self.graphView.controlPointsArray mutableCopy];
    [mutableControlPointsArray addObject:point];*/
    self.graphView.controlPointsArray = self.arrayOfControlPoints;
    [self.graphView drawAllControlpoints];

#warning not fully implement
}

#pragma mark - persistance
- (void)saveData
{
    ControlPointCDManager *pointManager = [[ControlPointCDManager alloc] init];
    for (ControllPoint *point in self.arrayOfControlPoints)
    {
        [pointManager saveToCDControlPoint:point];
    }
}

- (void)restoreData
{
    ControlPointCDManager *pointManager = [[ControlPointCDManager alloc] init];
    self.arrayOfControlPoints = [[pointManager getArrayOfControlPointsFromCD] mutableCopy];
    [self calculateEarningPosibilitiesOfControlPoints];
    self.graphView.controlPointsArray = self.arrayOfControlPoints;
    self.graphView.shouldDrawControlPoints = YES;
}

- (void)calculateEarningPosibilitiesOfControlPoints
{
    ControlPointsEarnChecker *checker = [[ControlPointsEarnChecker alloc] init];
    checker.averageCurrencyArray = self.avarageCurrencyObjectsArray;
    for (ControllPoint *point in self.arrayOfControlPoints)
    {
        point.earningPosibility = [checker canBeEarnedfromControlPoint:point];
    }
}

#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"addControlPoint"])
    {
        ((AddControlPointToEarnMoneyViewController *)segue.destinationViewController).owner = self;
        ((AddControlPointToEarnMoneyViewController *)segue.destinationViewController).avarageCurrencyObjectsArray = self.avarageCurrencyObjectsArray;
    }
}


@end
