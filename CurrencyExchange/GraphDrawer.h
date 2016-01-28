//
//  GraphDrawer.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/28/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvarageCurrency.h"

@interface GraphDrawer : UIView

@property (nonatomic, strong) NSMutableArray *avarageCurrencyObjectsArray;


@property (nonatomic, strong) NSMutableArray *USDArray;
@property (nonatomic, strong) NSMutableArray *EURArray;

@property (nonatomic, strong) UIColor *USDStrokeColor;
@property (nonatomic, strong) UIColor *EURStrokeColor;

@property (nonatomic, assign) CGFloat segmentWidth;
@property (nonatomic, assign) NSUInteger segmentWidthCount;
@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, assign) NSUInteger segmentHeightCount;

@property (nonatomic, assign) NSUInteger maxYvalue;
@property (nonatomic, assign) NSUInteger minYvalue;

@property (nonatomic, strong) NSArray *pointsOfUSDCurve;
@property (nonatomic, strong) NSArray *pointsOfEURCurve;

@property (nonatomic, assign) CGRect insetFrame;
@property (nonatomic, assign) CGFloat inset;

- (void)drawLineFromPointA:(CGPoint)a toPointB:(CGPoint)b WithWidth:(CGFloat)width andColor:(UIColor *)color;
- (void)configureVariable;
- (void)drawGrid;
- (void)drawGraphForCurrency:(NSString *)currency;
- (void)drawAxis;

@end
