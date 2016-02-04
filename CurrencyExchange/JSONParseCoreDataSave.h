//
//  JSONParseCoreDataSave.h
//  CurrencyExchange
//
//  Created by Vitaliy Yarkun on 29.01.16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString* const JSONParseDidUpdatesCoreDataNotification;

@interface JSONParseCoreDataSave : NSObject

@property (strong, nonatomic) NSDictionary* jsonData;

-(void) JSONParse;
-(void) deleteAllObjectsFromCoreData;
-(void) loadCoreDataObjects;

@end
