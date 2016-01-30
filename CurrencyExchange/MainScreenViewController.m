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

@interface MainScreenViewController ()
@property (weak, nonatomic) IBOutlet UIView *graph;

@end

@implementation MainScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    JSONParseCoreDataSave* workObject = [[JSONParseCoreDataSave alloc] init];
    TestCoreData* testObject = [[TestCoreData alloc] init];
    //Fetcher*tmp = [[Fetcher alloc]init];
    
    //[workObject JSONParse];
    [workObject deleteAllObjectsFromCoreData];
    //[workObject loadCoreDataObjects];
    //[testObject insertFakeDataToCoreData];
    //[tmp averageCurrencyRate];
    self.graph.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
