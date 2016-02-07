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

@end

@implementation MainScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.workObject = [[JSONParseCoreDataSave alloc] init];
    
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
    //self.graph.backgroundColor = [UIColor blackColor];
    self.m_Timer = [NSTimer scheduledTimerWithTimeInterval:7200.0
                                                    target: self.workObject
                                                  selector: @selector(JSONParse)
                                                  userInfo: nil
                                                   repeats: YES];
    
    NSArray* dataArray = [self.fetching averageCurrencyRate];
    NSInteger lastIndex = [dataArray count];
    NSNumber *tmp = [[dataArray objectAtIndex:lastIndex-1] USDask];
    self.USDlabel.text =[tmp stringValue];
    NSNumber*tmpEuro = [[dataArray objectAtIndex:lastIndex-1] EURask];
    self.EUROlabel.text = [tmpEuro stringValue];
    //self.USDlabel.text = @"25.0";
    //self.EUROlabel.text = @"35.0";
    self.stateOfSwitchLabel.text = @"Ask";
    self.switchState.on = YES;
    self.switchState.onTintColor = [UIColor orangeColor];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
    
}
#pragma mark - Notifications

- (void) dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (IBAction)statusOfSwitchChanged:(id)sender
{
    NSArray* dataArray = [self.fetching averageCurrencyRate];
    NSInteger lastIndex = [dataArray count];
    if([sender isOn])
    {
        self.stateOfSwitchLabel.text = @"ASK";
        NSNumber *tmp = [[dataArray objectAtIndex:lastIndex-1] USDask];
        self.USDlabel.text =[tmp stringValue];
        NSNumber*tmpEuro = [[dataArray objectAtIndex:lastIndex-1] EURask];
        self.EUROlabel.text = [tmpEuro stringValue];
        //NSLog(@"Switch is ON");
    }
    else
    {
        NSNumber *tmp = [[dataArray objectAtIndex:lastIndex-1] USDbid];
        self.USDlabel.text =[tmp stringValue];
        NSNumber*tmpEuro = [[dataArray objectAtIndex:lastIndex-1] EURbid];
        self.EUROlabel.text = [tmpEuro stringValue];

        self.stateOfSwitchLabel.text = @"BID";
        //NSLog(@"Switch is OFF");
    }
    
}
@end
