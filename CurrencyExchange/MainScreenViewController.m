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
@property (strong, nonatomic) MainScreenDrawer* drawer;
@property (nonatomic, strong) NSArray *avarageCurrencyObjectsArray;
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
    self.graph.backgroundColor = [UIColor blackColor];
    self.m_Timer = [NSTimer scheduledTimerWithTimeInterval:660.0
                                                    target: self.workObject
                                                  selector: @selector(JSONParse)
                                                  userInfo: nil
                                                   repeats: YES];
    
    [self updateAverageCurrencyObjectsArray];
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
    if (self) {
        
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
        self.stateOfSwitchLabel.text = @"ASK";
        NSNumber *tmp = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] USDask];
        self.USDlabel.text = [self.formatter stringFromNumber:tmp];
         NSNumber*tmpEuro = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] EURask];
        self.EUROlabel.text = [self.formatter stringFromNumber:tmpEuro];
    }
    else
    {
        NSNumber *tmp = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] USDbid];
        self.USDlabel.text = [self.formatter stringFromNumber:tmp];
        NSNumber*tmpEuro = [[self.avarageCurrencyObjectsArray objectAtIndex:lastIndex-1] EURbid];
        self.EUROlabel.text = [self.formatter stringFromNumber:tmpEuro];
        self.stateOfSwitchLabel.text = @"BID";
    }
    
}

@end
