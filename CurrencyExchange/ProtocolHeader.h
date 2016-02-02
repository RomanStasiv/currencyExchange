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

@protocol shareGraphViewDelegate <NSObject>

- (UIImage *)getGraphDescriptionImageForControlPoint:(CDControlPoint *)point;
- (UIImage *)getImageToShareForControlPoint:(CDControlPoint *)point;

@end

#endif /* ProtocolHeader_h */
