//
//  EarnMoneyGraphView.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "EarnMoneyGraphView.h"

@interface EarnMoneyGraphView()

@property (nonatomic, assign) CGFloat segmentLength;
@property (nonatomic, assign) NSUInteger segmentCount;

@end

@implementation EarnMoneyGraphView

- (void)drawRect:(CGRect)rect
{
    [self drawGraph];
}

- (void)configureVariable
{
    self.segmentCount = [self.USDArray count];
    
}

- (void)drawGraph
{
    
}

@end
