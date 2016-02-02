//
//  GraphDrawer.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/28/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AverageCurrency.h"

@interface GraphDrawer : UIView

@property (nonatomic, strong) NSArray *avarageCurrencyObjectsArray;

@property (nonatomic, assign) CGRect insetFrame;
@property (nonatomic, assign) CGFloat inset;
@property (nonatomic, assign) double topAndRightMargin;

@property (nonatomic, assign) CGFloat segmentWidth;
@property (nonatomic, assign) NSUInteger segmentWidthCount;
@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, assign) NSUInteger segmentHeightCount;

@property (nonatomic, assign) NSUInteger maxYvalue;
@property (nonatomic, assign) NSUInteger minYvalue;

@property (nonatomic, strong) UIColor *USDBidStrokeColor;
@property (nonatomic, strong) UIColor *USDAskStrokeColor;
@property (nonatomic, strong) UIColor *EURBidStrokeColor;
@property (nonatomic, strong) UIColor *EURAskStrokeColor;

@property (nonatomic, strong) NSArray *pointsOfUSDBidCurve;
@property (nonatomic, strong) NSArray *pointsOfEURBidCurve;
@property (nonatomic, strong) NSArray *pointsOfUSDAskCurve;
@property (nonatomic, strong) NSArray *pointsOfEURAskCurve;

- (void)drawLineFromPointA:(CGPoint)a toPointB:(CGPoint)b WithWidth:(CGFloat)width Color:(UIColor *)color Dashed:(BOOL)dashed;
- (void)configureVariable;

@end
