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
#import "EarnNotificationView.h"
#import "EarningGoalsTableViewController.h"
#import "ShareGoalsViewController.h"

@interface EarnMoneyViewController ()

@property (weak, nonatomic) IBOutlet EarnMoneyGraphView *graphView;
@property (weak, nonatomic) IBOutlet UIImageView *USDBidColorIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *USDAskColorIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *EURBidColorIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *EURAskColorIndicator;

@property (nonatomic, strong) UIColor *USDBidColor;
@property (nonatomic, strong) UIColor *USDAskColor;
@property (nonatomic, strong) UIColor *EURBidColor;
@property (nonatomic, strong) UIColor *EURAskColor;

@property (strong, nonatomic) NSMutableArray *arrayOfControlPoints;
@property (nonatomic,strong) NSArray *readyToGoControlPoints;
@property (nonatomic, strong) NSMutableArray *avarageCurrencyObjectsArray;

@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;

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
       self.USDBidColor = [UIColor brownColor];
    self.USDAskColor = [UIColor blueColor];
    self.EURBidColor = [UIColor darkGrayColor];
    self.EURAskColor = [UIColor grayColor];
    [self setNeedsOfIndicator:self.USDBidColorIndicator WithColor:self.USDBidColor];
    [self setNeedsOfIndicator:self.USDAskColorIndicator WithColor:self.USDAskColor];
    [self setNeedsOfIndicator:self.EURBidColorIndicator WithColor:self.EURBidColor];
    [self setNeedsOfIndicator:self.EURAskColorIndicator WithColor:self.EURAskColor];
    
    self.graphView.USDBidStrokeColor = self.USDBidColor;
    self.graphView.USDAskStrokeColor = self.USDAskColor;
    self.graphView.EURBidStrokeColor = self.EURBidColor;
    self.graphView.EURAskStrokeColor = self.EURAskColor;

    self.readyToGoControlPoints = [self getControlPointsWithGoodEatningPosibility];
    if (self.readyToGoControlPoints.count)
        [self addBarButtonItemsIncludeEarnGoals:YES];
    else
        [self addBarButtonItemsIncludeEarnGoals:NO];
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
        {
            thisCurrency = currency;
            break;
        }
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
    [self calculateEarningPosibilitiesOfControlPoints];
    for (ControllPoint *point in self.arrayOfControlPoints)
    {
        [pointManager saveToCDControlPoint:point];
    }
}

- (void)restoreData
{
    ControlPointCDManager *pointManager = [[ControlPointCDManager alloc] init];
    self.arrayOfControlPoints = [[pointManager getArrayOfControlPointsFromCD] mutableCopy];
    
    self.graphView.controlPointsArray = self.arrayOfControlPoints;
    self.graphView.shouldDrawControlPoints = YES;
}

- (void)calculateEarningPosibilitiesOfControlPoints
{
    for (ControllPoint *point in self.arrayOfControlPoints)
    {
        [point calculateEarningPosibilityWithaverageCurrencyObjectsArray:self.avarageCurrencyObjectsArray];
    }
}

- (NSArray *)getControlPointsWithGoodEatningPosibility
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (ControllPoint *point in self.arrayOfControlPoints)
    {
        if ([point.earningPosibility floatValue] > 0)
            [resultArray addObject:point];
    }
    
    return resultArray;
}

/*- (void)showNotificationForControlPoint:(ControllPoint *)point
{
    CGRect frame = CGRectMake(self.graphView.insetFrame.origin.x,
                              self.graphView.insetFrame.origin.y,
                              self.graphView.inset,
                              self.graphView.inset);
    NSString *notification = [NSString stringWithFormat:@"Earn %f!",[point.earningPosibility floatValue]];
    EarnNotificationView *notificationView = [[EarnNotificationView alloc] initWithFrame:frame Notification:notification];
    [self.graphView addSubview:notificationView];
    
    
}*/
/*
- (void)showEarnGoalsBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self
               action:@selector(showEarnGoalsViewController)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.title = @"You've got oportunity";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
*/
- (void)addBarButtonItemsIncludeEarnGoals:(BOOL)goals
{
    
    CGRect ImageRect = CGRectMake(0, 0, 30, 30);
    
    UIImage *addImage = [UIImage imageNamed:@"tabBar_Add.png"];
    UIButton *addButton = [[UIButton alloc] initWithFrame:ImageRect];
    [addButton setBackgroundImage:addImage forState:UIControlStateNormal];
    [addButton addTarget:self
                    action:@selector(showAddControlPointViewController)
          forControlEvents:UIControlEventTouchUpInside];
    [addButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    UIImage *shareImage = [UIImage imageNamed:@"tabBar_share.png"];
    UIButton *shareButton = [[UIButton alloc] initWithFrame:ImageRect];
    [shareButton setBackgroundImage:shareImage forState:UIControlStateNormal];
    [shareButton addTarget:self
                    action:@selector(showShareGoalsViewController)
          forControlEvents:UIControlEventTouchUpInside];
    [shareButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];

    if (goals)
    {
        UIImage *goalsImage = [UIImage imageNamed:@"tabBar_money.png"];
        UIButton *goalsButton = [[UIButton alloc] initWithFrame:ImageRect];
        [goalsButton setBackgroundImage:goalsImage forState:UIControlStateNormal];
        [goalsButton addTarget:self
                        action:@selector(showEarnGoalsViewController)
              forControlEvents:UIControlEventTouchUpInside];
        [goalsButton setShowsTouchWhenHighlighted:YES];

        UIBarButtonItem *goalsBarButton = [[UIBarButtonItem alloc] initWithCustomView:goalsButton];
        
        self.navigationItem.rightBarButtonItems = @[addBarButton, shareBarButton, goalsBarButton];
    }
    else
    {
        self.navigationItem.rightBarButtonItems = @[addBarButton, shareBarButton];
    }
}

- (void)showEarnGoalsViewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EarningGoalsTableViewController * egTVC = (EarningGoalsTableViewController *)[sb instantiateViewControllerWithIdentifier:@"EarningGoalsTVC"];
    egTVC.averageCurrencyObjectsArray = self.avarageCurrencyObjectsArray;
    [self.navigationController pushViewController:egTVC animated:YES];
}

- (void)showShareGoalsViewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShareGoalsViewController * shareGoalsVC = (ShareGoalsViewController *)[sb instantiateViewControllerWithIdentifier:@"shareGoalsVC"];
    [self.navigationController pushViewController:shareGoalsVC animated:YES];
}

- (void)showAddControlPointViewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddControlPointToEarnMoneyViewController * addCPVC = (AddControlPointToEarnMoneyViewController *)[sb instantiateViewControllerWithIdentifier:@"addCPVC"];
    addCPVC.owner = self;
    addCPVC.avarageCurrencyObjectsArray = self.avarageCurrencyObjectsArray;
    [self.navigationController pushViewController:addCPVC animated:YES];
}

#pragma mark - navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"addCPVC"])
    {
        ((AddControlPointToEarnMoneyViewController *)segue.destinationViewController).owner = self;
        ((AddControlPointToEarnMoneyViewController *)segue.destinationViewController).avarageCurrencyObjectsArray = self.avarageCurrencyObjectsArray;
    }
}*/


@end
