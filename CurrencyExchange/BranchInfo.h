//
//  BranchInfo.h
//  CurrencyExchange
//
//  Created by Vitaliy Yarkun on 04.02.16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BranchInfo : NSObject

@property (strong, nonatomic) NSString* branchName;
@property (strong, nonatomic) NSString* branchCity;
@property (strong, nonatomic) NSString* branchRegion;
@property (strong, nonatomic) NSString* branchAddress;
@property (strong, nonatomic) NSString* bank;


-(instancetype) initWithName:(NSString*) name
                  withRegion:(NSString*) region
                    withCity:(NSString*) city
                 withAddress:(NSString*) address
                    withBank:(NSString*) bank;

@end
