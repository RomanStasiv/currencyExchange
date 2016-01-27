//
//  EarnMoneyGraphView.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarnMoneyGraphView : UIView

@property (nonatomic, strong) NSMutableArray *USDArray;
@property (nonatomic, strong) NSMutableArray *EURArray;

@property (nonatomic, strong) UIColor *USDStrokeColor;
@property (nonatomic, strong) UIColor *EURStrokeColor;

- (CGPoint)getLastPointOfCurrency:(NSString *)currency;
- (void)drawControlPointLineOnPoint:(CGPoint)point;

@end
