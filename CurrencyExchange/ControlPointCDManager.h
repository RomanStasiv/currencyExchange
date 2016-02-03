//
//  ControlPointCDManager.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ControllPoint.h"
#import "CDControlPoint.h"
#import "ControlPointsCDSotrer.h"

@interface ControlPointCDManager : NSObject

+ (instancetype) sharedManager;

@property (nonatomic, strong) NSManagedObjectContext *context;

- (void)saveToCDControlPoint:(ControllPoint *)point;
- (void)deleteFromCDControlPoint:(CDControlPoint *)point;
- (NSArray *)getArrayOfControlPointsFromCD;

@end
