//
//  EarningGoalsTableViewController.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/31/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControlPointCDManager.h"

@interface EarningGoalsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSArray *averageCurrencyObjectsArray;
@property (nonatomic, strong) NSFetchedResultsController *fetchResultController;
@property (nonatomic, strong) ControlPointCDManager *manager;

@end
