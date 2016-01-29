//
//  ControlPointCDManager.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ControllPoint;

@interface ControlPointCDManager : NSObject

- (void)saveToCDControlPoint:(ControllPoint *)point;
- (void)deleteFromCDControlPoint:(ControllPoint *)point;
- (NSArray *)getArrayOfControlPointsFromCD;

@end
