//
//  ViewController.m
//  CurrencyExchange
//
//  Created by Roman Stasiv on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "MainScreenViewController.h"
#import "JSONParseCoreDataSave.h"
#import "TestCoreData.h"
#import "Fetcher.h"
#import "MetalJSONParse.h"


@interface MainScreenViewController ()

@property (weak, nonatomic) IBOutlet UIView *graph;
@property (strong, nonatomic) Fetcher* fetching;
@property (strong, nonatomic) JSONParseCoreDataSave * workObject;
@property (strong, nonatomic) NSNumberFormatter* formatter;

@property (nonatomic, strong) NSArray *avarageCurrencyObjectsArray;
@property (nonatomic, strong) UIColor *USDBidColor;
@property (nonatomic, strong) UIColor *USDAskColor;
@property (nonatomic, strong) UIColor *EURBidColor;
@property (nonatomic, strong) UIColor *EURAskColor;


@end

@implementation MainScreenViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.workObject = [[JSONParseCoreDataSave alloc] init];
    self.drawer = [[MainScreenDrawer alloc]init];
    //TestCoreData* testObject = [[TestCoreData alloc] init];
    //MetalJSONParse* tester = [[MetalJSONParse alloc]init];
    self.fetching = [[Fetcher alloc]init];
    
    //[self.workObject deleteAllObjectsFromCoreData];
    [self.workObject JSONParse];
    //[self.workObject loadCoreDataObjects];
    //[tmp allBanksQuantity];
    //[testObject insertFakeDataToCoreData];
    //[tmp dataForTableView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunsat_patternColor"]];
    
    self.graph.backgroundColor = [UIColor clearColor];
    
    self.m_Timer = [NSTimer scheduledTimerWithTimeInterval:660.0
                                                    target: self.workObject
                                                  selector: @selector(JSONParse)
                                                  userInfo: nil
                    
                                                   repeats: YES];
    [self updateAverageCurrencyObjectsArray];
    self.drawer.avarageCurrencyObjectsArray = self.avarageCurrencyObjectsArray;
    CGRect frame = self.graph.frame;
    [self.graph drawRect:frame];
    
    
    
    NSInteger lastIndex = [self.avarageCurrencyObjectsArray count];
    self.formatter = [[NSNumberFormatter alloc] init];
    
    [self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.formatter setMaximumFractionDigits:2];
    
    [self selfUpdate: [UIColor blackColor]  :[UIColor blackColor] :[UIColor purpleColor]  :[UIColor purpleColor]];
    [self.graph setNeedsDisplay];
    
    
    NSNumber *tmp = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] USDask];
    self.USDlabel.text = [self.formatter stringFromNumber:tmp];
    NSNumber*tmpEuro = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] EURask];
    self.EUROlabel.text = [self.formatter stringFromNumber:tmpEuro];
    
    
    self.stateOfSwitchLabel.text = @"Ask";
    self.switchState.on = YES;
    self.switchState.onTintColor = [UIColor orangeColor];
    
}




- (void)selfUpdate:(UIColor*)usdA :(UIColor*) EuroA :(UIColor*)usdP :(UIColor*) EuroP
{
    [self updateAverageCurrencyObjectsArray];
    [self prepareGraphView];
    self.USDBidColor = usdP;
    self.USDAskColor = usdA;
    self.EURBidColor = usdP;
    self.EURAskColor = EuroP;
    
    self.drawer.USDBidStrokeColor = self.USDBidColor;
    self.drawer.USDAskStrokeColor = self.USDAskColor;
    self.drawer.EURBidStrokeColor = self.EURBidColor;
    self.drawer.EURAskStrokeColor = self.EURAskColor;
    
}

- (void)prepareGraphView
{
    self.drawer.avarageCurrencyObjectsArray = self.avarageCurrencyObjectsArray;
    self.drawer.contentMode = UIViewContentModeRedraw;
    //[self restoreAllControlPointsFromCD];
}

- (void)updateAverageCurrencyObjectsArray
{
    self.avarageCurrencyObjectsArray = [[self.fetching averageCurrencyRate] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
    
}
#pragma mark - Notifications

- (id)init
{
    self = [super init];
    if (self)
    {
        
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self
               selector:@selector(averageCurrencyRate)
                   name:JSONParseDidUpdatesCoreDataNotification
                 object:nil];
        
    }
    return self;
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
        [self selfUpdate: [UIColor blackColor]  :[UIColor blackColor] :[UIColor purpleColor]  :[UIColor purpleColor]];
        [self.graph setNeedsDisplay];

        self.stateOfSwitchLabel.text = @"ASK";
        NSNumber *tmp = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] USDask];
        self.USDlabel.text = [self.formatter stringFromNumber:tmp];
         NSNumber*tmpEuro = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] EURask];
        self.EUROlabel.text = [self.formatter stringFromNumber:tmpEuro];
    }
    else
    {
        [self selfUpdate: [UIColor purpleColor]  :[UIColor purpleColor] :[UIColor blackColor]  :[UIColor blackColor]];
        [self.graph setNeedsDisplay];

        NSNumber *tmp = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] USDbid];
        self.USDlabel.text = [self.formatter stringFromNumber:tmp];
        NSNumber*tmpEuro = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] EURbid];
        self.EUROlabel.text = [self.formatter stringFromNumber:tmpEuro];
        self.stateOfSwitchLabel.text = @"BID";
    }
    
}

@end
