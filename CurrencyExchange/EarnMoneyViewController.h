//
//  EarnMoneyViewController.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtocolHeader.h"

@interface EarnMoneyViewController : UIViewController <GraphViewDelegate>

- (void)addControlPointWithAmountOfMoney:(CGFloat)money Currency:(NSString *)currency ForDate:(NSDate *)date;
- (void)hideAddControlPointViewControllerWithComletionHandler:(void(^)())completion;

@end
