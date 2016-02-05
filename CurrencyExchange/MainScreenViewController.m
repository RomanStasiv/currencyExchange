//
//  ViewController.m
//  CurrencyExchange
//
//  Created by Roman Stasiv on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "MainScreenViewController.h"
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

@property (strong, nonatomic) JSONParseCoreDataSave * workObject;

@end

@implementation MainScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [workObject deleteAllObjectsFromCoreData];
    //[workObject JSONParse];
    //[workObject loadCoreDataObjects];
    //[tmp allBanksQuantity];
    
//    dispatch_queue_t queueJsonMetal = dispatch_queue_create("Metal", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queueJsonMetal, ^{
//        [tester JSONMetalParse];
//    });
    
    //[testObject insertFakeDataToCoreData];
    //[tmp dataForTableView];
    self.graph.backgroundColor = [UIColor blackColor];
    self.m_Timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                    target: workObject
                                                  selector: @selector(JSONParse)
                                                  userInfo: nil
                                                   repeats: YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notifications

- (void) dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end