//
//  PieChartView.h
//  CurrencyExchange
//
//  Created by Roman Stasiv on 2/10/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartView : UIView
-(void)updateWithArray: (NSArray *) chartPieces
         segmentColors: (NSArray *) colors;
@end
