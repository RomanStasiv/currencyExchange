//
//  EarnMoneyGraphView.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphDrawer.h"

@interface EarnMoneyGraphView : GraphDrawer

@property (nonatomic, strong) NSArray *controlPointsArray;

- (void)drawAllControlpoints;

@end
