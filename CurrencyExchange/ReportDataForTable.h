//
//  ReportDataForTable.h
//  CurrencyExchange
//
//  Created by Melany on 1/29/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CurrencyData.h"


@interface ReportDataForTable : NSObject

@property (strong, nonatomic) NSString* bankName;
@property (strong, nonatomic) NSArray* branchs;
//@property (strong, nonatomic) NSString* branchAddress;
@property (strong, nonatomic) NSString *eurCurrencyAsk;
@property (strong, nonatomic) NSString *eurCurrencyBid;
@property (strong, nonatomic) NSString *usdCurrencyAsk;
@property (strong, nonatomic) NSString *usdCurrencyBid;



@end
