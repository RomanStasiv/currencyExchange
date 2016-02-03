//
//  ProtocolHeader.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/2/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#ifndef ProtocolHeader_h
#define ProtocolHeader_h

@class CDControlPoint;

@protocol GraphViewDelegate <NSObject>

- (UIImage *)getImageToShareForControlPoint:(CDControlPoint *)point;
- (void)redrawGraphView;

@end

#endif /* ProtocolHeader_h */
