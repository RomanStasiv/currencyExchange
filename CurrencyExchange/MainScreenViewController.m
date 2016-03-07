//
//  ViewController.m
//  CurrencyExchange
//
//  Created by Roman Stasiv on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "CustomNavigationController.h"
#import "MainScreenViewController.h"
#import "JSONParseCoreDataSave.h"
#import "TestCoreData.h"
#import "Fetcher.h"
#import "MetalJSONParse.h"

@interface MainScreenViewController ()

@property (weak, nonatomic) IBOutlet MainScreenDrawer *drawer;
@property (strong, nonatomic) Fetcher* fetching;
@property (strong, nonatomic) JSONParseCoreDataSave * workObject;
@property (strong, nonatomic) NSNumberFormatter* formatter;
@property (nonatomic, strong) NSMutableArray *avarageCurrencyObjectsArray;
@property (nonatomic, strong) UIColor *USDBidColor;
@property (nonatomic, strong) UIColor *USDAskColor;
@property (nonatomic, strong) UIColor *EURBidColor;
@property (nonatomic, strong) UIColor *EURAskColor;
@property (weak, nonatomic) IBOutlet UIButton *converterButton;
@property (weak, nonatomic) IBOutlet UIButton *earnOnExchangeButton;
@property (weak, nonatomic) IBOutlet UIButton *banksButton;


@end

@implementation MainScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ((CustomNavigationController *)self.navigationController).canBeInLandscape = YES;
//    self.converterButton.multipleTouchEnabled = YES;
//    self.earnOnExchangeButton.multipleTouchEnabled = YES;
//    self.banksButton.multipleTouchEnabled = YES;
    
    for(UIView* v in self.view.subviews)
    {
        if([v isKindOfClass:[UIButton class]])
        {
            UIButton* btn = (UIButton*)v;
            [btn setExclusiveTouch:YES];
        }
    }
    self.fetching = [[Fetcher alloc] init];
    if (!self.avarageCurrencyObjectsArray)
        self.avarageCurrencyObjectsArray = [NSMutableArray array];
    [self prepareGraphView];
    [self selfUpdate: [UIColor blackColor]  :[UIColor darkGrayColor] :[UIColor clearColor]  :[UIColor clearColor]];
    ((CustomNavigationController *)self.navigationController).canBeInLandscape = YES;


    self.workObject = [[JSONParseCoreDataSave alloc] init];
    TestCoreData* testObject = [[TestCoreData alloc] init];
    MetalJSONParse* tester = [[MetalJSONParse alloc]init];
    //[self.fetching arrayOfMetalForDrawing];
    self.EUROlabel.textColor = [UIColor darkGrayColor];
    [self.workObject deleteAllObjectsFromCoreData];
    //[self.workObject JSONParse];
    //[self.workObject loadCoreDataObjects];
    //[tmp allBanksQuantity];
    //[testObject insertFakeDataToCoreData];
    //[tmp dataForTableView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunsat_patternColor"]];
    
    self.drawer.backgroundColor = [UIColor clearColor];
    
    self.m_Timer = [NSTimer scheduledTimerWithTimeInterval: 300.0
                                                    target: self.workObject
                                                  selector: @selector(JSONParse)
                                                  userInfo: nil
                                                   repeats: YES];
    
        dispatch_queue_t queueJsonMetal = dispatch_queue_create("Metal", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queueJsonMetal, ^{
            [tester movementThroughUrls];
        });
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(updatedCoreDataShouldBeRedrawn:)
               name:CoreDataDidSavedNotification
             object:nil];
    
    
    
    NSInteger lastIndex = [self.avarageCurrencyObjectsArray count];
    self.formatter = [[NSNumberFormatter alloc] init];
    
    [self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.formatter setMaximumFractionDigits:2];
  
    NSNumber *tmp = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] USDask];
    self.USDlabel.text = [self.formatter stringFromNumber:tmp];
    NSNumber*tmpEuro = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] EURask];
    self.EUROlabel.text = [self.formatter stringFromNumber:tmpEuro];
    
    self.stateOfSwitchLabel.text = @"Ask";
    self.switchState.on = YES;
    self.switchState.onTintColor = [UIColor orangeColor];
}



- (void)redrawGraphView
{
    [self prepareGraphView];
    [self.drawer setNeedsDisplay];
    [self.drawer setNeedsDisplay];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self prepareGraphView];
    [self selfUpdate: [UIColor blackColor]  :[UIColor darkGrayColor] :[UIColor clearColor]  :[UIColor clearColor]];
    [self.drawer setNeedsDisplay];

}


- (void)selfUpdate:(UIColor*)usdA :(UIColor*) EuroA :(UIColor*)usdP :(UIColor*) EuroP
{
    self.USDBidColor = usdP;
    self.USDAskColor = usdA;
    self.EURBidColor = EuroP;
    self.EURAskColor = EuroA;
    
    self.drawer.USDBidStrokeColor = self.USDBidColor;
    self.drawer.USDAskStrokeColor = self.USDAskColor;
    self.drawer.EURBidStrokeColor = self.EURBidColor;
    self.drawer.EURAskStrokeColor = self.EURAskColor;
    
}

- (void)prepareGraphView
{
    [self updateAverageCurrencyObjectsArray];
    self.drawer.contentMode = UIViewContentModeRedraw;
}

- (void)updateAverageCurrencyObjectsArray
{
    [self.avarageCurrencyObjectsArray removeAllObjects];
    self.avarageCurrencyObjectsArray = [[self.fetching averageCurrencyRate]mutableCopy];
    NSMutableArray* array = [[NSMutableArray alloc]init];
    if(self.avarageCurrencyObjectsArray.count > 35)
    {
        NSInteger difference = self.avarageCurrencyObjectsArray.count - 15;
        for(NSInteger i = difference; i < self.avarageCurrencyObjectsArray.count; i++)
        {
            [array addObject:[self.avarageCurrencyObjectsArray objectAtIndex:i]];
        }
         self.drawer.avarageCurrencyObjectsArray = array;
    }
    else
         self.drawer.avarageCurrencyObjectsArray = self.avarageCurrencyObjectsArray;
  [self.drawer setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
    
}

- (void) dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - Methods


- (IBAction)statusOfSwitchChanged:(id)sender
{
    [self updateAverageCurrencyObjectsArray];
    NSInteger lastIndex = [self.avarageCurrencyObjectsArray count];
    if([sender isOn])
    {
        [self selfUpdate: [UIColor blackColor]  :[UIColor darkGrayColor] :[UIColor clearColor]  :[UIColor clearColor]];
        [self.drawer setNeedsDisplay];
        self.stateOfSwitchLabel.text = @"ASK";
        NSNumber *tmp = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] USDask];
        self.USDlabel.text = [self.formatter stringFromNumber:tmp];
       NSNumber*tmpEuro = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] EURask];
        self.EUROlabel.text = [self.formatter stringFromNumber:tmpEuro];
    }
    else
    {
        [self selfUpdate: [UIColor clearColor]  :[UIColor clearColor] :[UIColor blackColor]  :[UIColor darkGrayColor]];
        [self.drawer setNeedsDisplay];
        NSNumber *tmp = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] USDbid];
        self.USDlabel.text = [self.formatter stringFromNumber:tmp];
        NSNumber*tmpEuro = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] EURbid];
        self.EUROlabel.text = [self.formatter stringFromNumber:tmpEuro];
        self.stateOfSwitchLabel.text = @"BID";
    }
    
}


#pragma mark - Notifications

-(void) updatedCoreDataShouldBeRedrawn:(NSNotification*) notification
{
    self.avarageCurrencyObjectsArray = [notification.userInfo objectForKey:CoreDataDidSavedUserInfoKey];
    self.drawer.contentMode = UIViewContentModeRedraw;
    [self.drawer setNeedsDisplay];
    
}

@end
