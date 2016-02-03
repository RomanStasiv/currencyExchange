//
//  AddControlPointToEarnMoneyViewController.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EarnMoneyViewController.h"

@interface AddControlPointToEarnMoneyViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) EarnMoneyViewController *owner;
@property (nonatomic, strong) NSArray *avarageCurrencyObjectsArray;

- (void)prepareAllData;

@end
