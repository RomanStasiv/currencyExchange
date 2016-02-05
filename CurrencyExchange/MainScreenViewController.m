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

@property (strong, nonatomic) JSONParseCoreDataSave * workObject;

@end

@implementation MainScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(coreDataUpdated:)
               name:CoreDataDidSavedNotification
             object:nil];
    
    
    
    self.workObject = [[JSONParseCoreDataSave alloc] init];
    //TestCoreData* testObject = [[TestCoreData alloc] init];
    Fetcher*tmp = [[Fetcher alloc]init];
    
    //[self.workObject deleteAllObjectsFromCoreData];
    //[self.workObject JSONParse];
    //[workObject loadCoreDataObjects];
    [tmp allBanksQuantity];
    //[testObject insertFakeDataToCoreData];
    //[tmp dataForTableView];
    self.graph.backgroundColor = [UIColor blackColor];
    /*self.m_Timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                    target: workObject
                                                  selector: @selector(JSONParse)
                                                  userInfo: nil
                                                   repeats: YES];
    */
}

#pragma mark - Notifications

- (void) coreDataUpdated:(NSNotification*) notification
{
    
    NSArray* array = [notification.userInfo objectForKey:CoreDataDidSavedUserInfoKey];
    
}

#pragma mark - Timer


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
