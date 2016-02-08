//
//  Section.h
//  CurrencyExchange
//
//  Created by Roman Stasiv on 2/4/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSMutableArray * banks;

@end
