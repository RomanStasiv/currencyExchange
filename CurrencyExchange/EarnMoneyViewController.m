//
//  EarnMoneyViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

#import "EarnMoneyViewController.h"
#import "EarnMoneyGraphView.h"
#import "AddControlPointToEarnMoneyViewController.h"
#import "ControlPointCDManager.h"
#import "ControlPointsEarnChecker.h"
#import "Fetcher.h"
#import "EarnNotificationView.h"
#import "EarningGoalsTableViewController.h"
#import "ShareGoalsViewController.h"

#import "CustomNavigationController.h"
#import <QuartzCore/QuartzCore.h>

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

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (weak, nonatomic) UIView *viewToMove;


@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UIView *timeSliderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeSliderWidthConstraint;


//resize logic
@property (weak, nonatomic) AddControlPointToEarnMoneyViewController * addCPVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraintAddCPContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraintAddCPContainer;




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

static BOOL isAddCPVCOpened = NO;

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveAllContolPointsToCD)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveAllContolPointsToCD)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpdateForNotification)
                                                 name:JSONParseDidUpdatesCoreDataNotification
                                               object:nil];
    self.graphView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunsat_patternColor"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunsat_patternColor"]];
    [super viewDidLoad];
    [self selfUpdate];
    ((CustomNavigationController *)self.navigationController).canBeInLandscape = YES;
    
    [self resizerTimeSliderLogic];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self resizerTimeSliderLogic];
}

- (void)resizerTimeSliderLogic
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
        {
            self.timeSliderWidthConstraint.constant = self.view.frame.size.width - 152;
        }
        else
        {
            self.timeSliderWidthConstraint.constant = 340;
        }
    }
    else
    {
        self.timeSliderWidthConstraint.constant = 340;
    }
}

- (void)UpdateForNotification
{
    [self updateAverageCurrencyObjectsArray];
    [self redrawGraphView];
    [self performAddNavButtonsLogic];
}

- (void)selfUpdate
{
    [self updateAverageCurrencyObjectsArray];
    [self prepareGraphView];
    self.USDBidColor = [UIColor colorWithRed:0.9 green:0.11 blue:0.05 alpha:1];
    self.USDAskColor = [UIColor colorWithRed:0.85 green:0.39 blue:0.06 alpha:1];
    self.EURBidColor = [UIColor colorWithRed:0.09 green:0.41 blue:0.07 alpha:1];
    self.EURAskColor = [UIColor colorWithRed:0.12 green:0.77 blue:0.07 alpha:1];
    [self setNeedsOfIndicator:self.USDBidColorIndicator WithColor:self.USDBidColor];
    [self setNeedsOfIndicator:self.USDAskColorIndicator WithColor:self.USDAskColor];
    [self setNeedsOfIndicator:self.EURBidColorIndicator WithColor:self.EURBidColor];
    [self setNeedsOfIndicator:self.EURAskColorIndicator WithColor:self.EURAskColor];
    
    self.graphView.USDBidStrokeColor = self.USDBidColor;
    self.graphView.USDAskStrokeColor = self.USDAskColor;
    self.graphView.EURBidStrokeColor = self.EURBidColor;
    self.graphView.EURAskStrokeColor = self.EURAskColor;
    
    [self performAddNavButtonsLogic];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handlePan:)];
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)performAddNavButtonsLogic
{
    self.readyToGoControlPoints = [self getControlPointsWithGoodEatningPosibility];
    if (self.readyToGoControlPoints.count)
        [self addBarButtonItemsIncludeEarnGoals:YES];
    else
        [self addBarButtonItemsIncludeEarnGoals:NO];
}

- (void)prepareGraphView
{
    self.graphView.avarageCurrencyObjectsArray = self.avarageCurrencyObjectsArray;
    self.graphView.contentMode = UIViewContentModeRedraw;
    [self restoreAllControlPointsFromCD];
}

- (void)updateAverageCurrencyObjectsArray
{
    Fetcher *fetch = [[Fetcher alloc]init];
    self.avarageCurrencyObjectsArray = [[fetch averageCurrencyRate] mutableCopy];
}

- (NSArray *)shiftAvarageCurrencyArrayToTimeSliderValue:(CGFloat)value
{
    [self updateAverageCurrencyObjectsArray];
    NSUInteger newLen = self.avarageCurrencyObjectsArray.count * value;
    NSUInteger startIndex = self.avarageCurrencyObjectsArray.count - newLen;
    NSArray *resultArray = [self.avarageCurrencyObjectsArray subarrayWithRange:NSMakeRange(startIndex, newLen)];
    return resultArray;
}
- (IBAction)timeSliderValueDidChanged:(UISlider *)sender
{
    if (self.avarageCurrencyObjectsArray.count > 1)
        self.timeSlider.minimumValue = self.avarageCurrencyObjectsArray.count / (self.avarageCurrencyObjectsArray.count * 10);
    CGFloat value = sender.value;
    self.avarageCurrencyObjectsArray = [[self shiftAvarageCurrencyArrayToTimeSliderValue:value] mutableCopy];
    [self redrawGraphView];
}

- (void)redrawGraphView
{
    [self prepareGraphView];
    [self.graphView setNeedsDisplay];
}

#pragma mark - gestures
- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint location = [pan locationInView:self.view];
    UIView *view = [self.view hitTest:location withEvent:nil];
    
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        if(view.tag == 113 || view.tag == 114)
            self.viewToMove = view;
        else if (view.tag == 4545)
            self.viewToMove = self.timeSliderView;
        else
            return;
    }
    else if (pan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [pan translationInView:self.view];
        self.viewToMove.center = CGPointMake(self.viewToMove.center.x + translation.x,
                                             self.viewToMove.center.y + translation.y);
        [pan setTranslation:CGPointZero inView:self.view];
    }
    else
    {
        self.viewToMove = nil;
    }
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
    [self hideAddControlPointViewControllerWithComletionHandler:^() {
        ControllPoint *point = [[ControllPoint alloc] init];
        point.currency = currency;
        point.value = [NSNumber numberWithFloat:money];
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
        
        BOOL shouldAdd = YES;
        for (ControllPoint *existingPoint in self.arrayOfControlPoints)
        {
            if ([existingPoint isEqualToPoint:point])
                shouldAdd = NO;
            
        }
        if (shouldAdd)
        {
            [point calculateEarningPosibilityWithaverageCurrencyObjectsArray:self.avarageCurrencyObjectsArray];
            [self.arrayOfControlPoints addObject:point];
            for (ControllPoint *point in self.arrayOfControlPoints)
            {
                if ([point.earningPosibility floatValue] > 0)
                {
                    [self addBarButtonItemsIncludeEarnGoals:YES];
                    break;
                }
                
            }
            
            if (!self.graphView.controlPointsArray)
                self.graphView.controlPointsArray = [NSArray array];
            
            self.graphView.controlPointsArray = self.arrayOfControlPoints;
            [self saveControlPointToCD:point];
            
            [self.graphView drawAllControlpoints];
        }
    }];
    ((CustomNavigationController *)self.navigationController).canBeInLandscape = YES;
}

#pragma mark - persistance
- (void)saveControlPointToCD:(ControllPoint *)point
{
    ControlPointCDManager *pointManager = [[ControlPointCDManager alloc] init];
    [pointManager saveToCDControlPoint:point];
}

- (void)saveAllContolPointsToCD
{
    ControlPointCDManager *pointManager = [[ControlPointCDManager alloc] init];
    NSArray *existingPoints = [NSArray array];
    existingPoints = [pointManager getArrayOfControlPointsFromCD];
    for (ControllPoint *existingPoint in existingPoints)
    {
        for (ControllPoint *point in self.arrayOfControlPoints)
        {
            if ([existingPoint.date compare: point.date] != NSOrderedSame)
                [pointManager saveToCDControlPoint:point];
        }
    }
}

- (void)restoreAllControlPointsFromCD
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
    
    /*UIImage *shareImage = [UIImage imageNamed:@"tabBar_share.png"];
     UIButton *shareButton = [[UIButton alloc] initWithFrame:ImageRect];
     [shareButton setBackgroundImage:shareImage forState:UIControlStateNormal];
     [shareButton addTarget:self
     action:@selector(showShareGoalsViewController)
     forControlEvents:UIControlEventTouchUpInside];
     [shareButton setShowsTouchWhenHighlighted:YES];
     
     UIBarButtonItem *shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];*/
    
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
        
        self.navigationItem.rightBarButtonItems = @[addBarButton,/* shareBarButton,*/ goalsBarButton];
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        anim.duration = 0.5;
        anim.repeatCount = 5;
        anim.autoreverses = YES;
        anim.removedOnCompletion = YES;
        anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)];
        [goalsButton.layer addAnimation:anim forKey:nil];
    }
    else
    {
        self.navigationItem.rightBarButtonItems = @[addBarButton/*, shareBarButton*/];
    }
}

#pragma mark - navigation
- (void)showEarnGoalsViewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EarningGoalsTableViewController * egTVC = (EarningGoalsTableViewController *)[sb instantiateViewControllerWithIdentifier:@"EarningGoalsTVC"];
    egTVC.averageCurrencyObjectsArray = self.avarageCurrencyObjectsArray;
    
    egTVC.graphViewControllerDelegate = self;//shareGraphViewDelegate
    
    [self.navigationController pushViewController:egTVC animated:YES];
}

//- (void)showShareGoalsViewController
//{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ShareGoalsViewController * shareGoalsVC = (ShareGoalsViewController *)[sb instantiateViewControllerWithIdentifier:@"shareGoalsVC"];
//#warning Maybe not using that ?
//    [self.navigationController pushViewController:shareGoalsVC animated:YES];
//}

- (void)showAddControlPointViewController
{
    if(!isAddCPVCOpened)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
            [self animateChangingOfConstraint:self.widthConstraintAddCPContainer
                                      ToValue:self.view.frame.size.width / 2];
            ((CustomNavigationController *)self.navigationController).canBeInLandscape = NO;
        }
        else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [self animateChangingOfConstraint:self.widthConstraintAddCPContainer
                                      ToValue:self.view.frame.size.width / 4];
        }
        [self animateChangingOfConstraint:self.rightConstraintAddCPContainer
                                  ToValue:0];
        self.addCPVC.owner = self;
        self.addCPVC.avarageCurrencyObjectsArray = self.avarageCurrencyObjectsArray;
        [self.addCPVC prepareAllData];
        isAddCPVCOpened = YES;
    }
    else
    {
        [self hideAddControlPointViewControllerWithComletionHandler:^{
            isAddCPVCOpened = NO;
        }];
        ((CustomNavigationController *)self.navigationController).canBeInLandscape = YES;
    }
}

/*- (BOOL)shouldAutorotate
 {
 if (!self.canBeInLandscape)
 return NO;
 else
 return YES;
 }
 
 - (UIInterfaceOrientationMask)supportedInterfaceOrientations
 {
 if (!self.canBeInLandscape)
 return UIInterfaceOrientationMaskPortrait;
 else
 return UIInterfaceOrientationMaskAll;
 }*/

- (void)hideAddControlPointViewControllerWithComletionHandler:(void(^)())completion
{
    [self animateChangingOfConstraint:self.rightConstraintAddCPContainer
                              ToValue:-self.widthConstraintAddCPContainer.constant];
    isAddCPVCOpened = NO;
    completion();
}

- (void)animateChangingOfConstraint:(NSLayoutConstraint *)constraint ToValue:(CGFloat)value
{
    constraint.constant = value;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.8f animations:^
     {
         [self.view layoutIfNeeded];
     }];
}

#pragma mark - shareGraphViewDelegate methods
- (UIImage *)getGraphDescriptionImageForControlPoint:(CDControlPoint *)point
{
    NSString *earningMoneyString = [NSString stringWithFormat:@"I earn %.f UAN\nAnd You ?", [point.earningPosibility floatValue]];
    
    UIView *darkLight = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                                 self.view.frame.origin.y,
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height)];
    darkLight.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.view addSubview:darkLight];
    
    CGRect frame = CGRectMake(self.view.bounds.origin.x + (self.view.bounds.size.width)/4,
                              self.view.bounds.origin.y + (self.view.bounds.size.height)/4,
                              (self.view.bounds.size.width)*0.6,
                              (self.view.bounds.size.height)*0.6);
    UILabel *showOffLabel = [[UILabel alloc] initWithFrame:frame];
    showOffLabel.numberOfLines = 0;
    showOffLabel.text = earningMoneyString;
    
    showOffLabel.font = [UIFont fontWithName:@"marker felt" size:10];
    [self sizeLabel:showOffLabel toRect:frame];
    showOffLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sea_texture"]];
    [self.view addSubview:showOffLabel];
    
    showOffLabel.transform = CGAffineTransformMakeRotation(RADIANS(330));
    
    UIImage *image = [[UIImage alloc] init];
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 1); //making image from view
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [showOffLabel removeFromSuperview];
    [darkLight removeFromSuperview];
    
    return image;
}

- (void) sizeLabel: (UILabel *) label toRect: (CGRect) labelRect{
    
    // Set the frame of the label to the targeted rectangle
    label.frame = labelRect;
    
    // Try all font sizes from largest to smallest font size
    int fontSize = 300;
    int minFontSize = 5;
    
    // Fit label width wize
    CGSize constraintSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
    
    do {
        // Set current font size
        label.font = [UIFont fontWithName:label.font.fontName size:fontSize];
        
        // Find label size for current font size
        CGRect textRect = [[label text] boundingRectWithSize:constraintSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:label.font}
                                                     context:nil];
        
        CGSize labelSize = textRect.size;
        
        // Done, if created label is within target size
        if( labelSize.height <= label.frame.size.height )
            break;
        
        // Decrease the font size and try again
        fontSize -= 2;
        
    } while (fontSize > minFontSize);
}

- (UIImage *)getImageToShareForControlPoint:(CDControlPoint *)point
{
    return [self getGraphDescriptionImageForControlPoint:point];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addCPVC_segue"])
    {
        self.addCPVC = (AddControlPointToEarnMoneyViewController *)[segue destinationViewController];
    }
}

@end
