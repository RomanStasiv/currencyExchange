//
//  ReportDataForTable.h
//  CurrencyExchange
//
//  Created by Melany on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ReportDataForTable : NSObject

@property (strong, nonatomic) NSString* bankName;
@property (assign, nonatomic) CGFloat* rateAsk;
@property (assign, nonatomic) CGFloat* rateBid;

@end
