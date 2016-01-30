//
//  ControlPointCDManager.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "ControlPointCDManager.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "ControllPoint.h"
#import "CDControlPoint.h"

@interface ControlPointCDManager()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ControlPointCDManager

- (NSManagedObjectContext *)context
{
    if (!_context)
    {
        AppDelegate *delegate = [AppDelegate singleton];
        _context = delegate.managedObjectContext;
    }
    return _context;
}

- (void)saveToCDControlPoint:(ControllPoint *)point
{
    CDControlPoint *coreDataPoint = [NSEntityDescription insertNewObjectForEntityForName:@"CDControlPoint" inManagedObjectContext:self.context];
    coreDataPoint.date = point.date;
    coreDataPoint.value = point.value;
    coreDataPoint.currency = point.currency;
    coreDataPoint.exChangeCource = point.exChangeCource;
    [self.context save:nil];
}

- (void)deleteFromCDControlPoint:(ControllPoint *)point
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription * description =
    [NSEntityDescription entityForName:@"CDControlPoint"
                inManagedObjectContext:self.context];
    [request setEntity:description];
    NSArray *fetchResult = [self.context executeFetchRequest:request error:nil];
    
    ControllPoint *toDel = [[ControllPoint alloc] init];
    for (ControllPoint *fetchPoint in fetchResult)
    {
        if ([fetchPoint.date compare:point.date] == NSOrderedSame)
        {
            toDel = fetchPoint;
        }
    }
    
    [self.context deleteObject:(NSManagedObject *)toDel];
    [self.context save:nil];
}

- (NSArray *)getArrayOfControlPointsFromCD
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription * description =
    [NSEntityDescription entityForName:@"CDControlPoint"
                inManagedObjectContext:self.context];
    [request setEntity:description];
    
    NSArray *fetchResult = [self.context executeFetchRequest:request error:nil];
    NSMutableArray *controlPointsArray = [NSMutableArray array];
    for (CDControlPoint *object in fetchResult)
    {
        ControllPoint *point = [[ControllPoint alloc] init];
        point.date = object.date;
        point.value = object.value;
        point.currency = object.currency;
        point.exChangeCource = object.exChangeCource;
        
        [controlPointsArray addObject:point];
    }
    return controlPointsArray;
}
@end
