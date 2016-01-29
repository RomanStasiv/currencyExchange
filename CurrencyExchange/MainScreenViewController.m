//
//  ViewController.m
//  CurrencyExchange
//
//  Created by Roman Stasiv on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "MainScreenViewController.h"
#import "JSONParseCoreDataSave.h"

@interface MainScreenViewController ()
@property (weak, nonatomic) IBOutlet UIView *graph;

@end

@implementation MainScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    JSONParseCoreDataSave* workObject = [[JSONParseCoreDataSave alloc] init];
    
    //[workObject JSONParse];
    //[workObject deleteAllObjectsFromCoreData];
    //[workObject loadCoreDataObjects];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
