//
//  ControlPointCDManager.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "ControlPointCDManager.h"
#import "AppDelegate.h"

@implementation ControlPointCDManager

+ (instancetype) sharedManager
{
    static ControlPointCDManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ControlPointCDManager alloc] init];
    });
    return instance;
}

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
    coreDataPoint.earningPosibility = point.earningPosibility;
    [self.context save:nil];
}

- (void)deleteFromCDControlPoint:(CDControlPoint *)coreDataPoint
{
    /* NSFetchRequest *request = [[NSFetchRequest alloc]init];
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
     }*/
    
    [self.context deleteObject:(NSManagedObject *)coreDataPoint];
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
        point.earningPosibility = object.earningPosibility;
        
        [controlPointsArray addObject:point];
    }
    return controlPointsArray;
}

- (NSArray *)getSortedArrayOfControlPointsFromCDAscending:(BOOL) ascending
{
    ControlPointsCDSotrer *sorter = [[ControlPointsCDSotrer alloc] init];
    NSArray *resultArray ;//= [NSArray array];
    resultArray = [sorter sort:[self getArrayOfControlPointsFromCD]
                     Ascending:ascending];
    return resultArray;
}
@end
