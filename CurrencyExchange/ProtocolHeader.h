//
//  ProtocolHeader.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/2/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#ifndef ProtocolHeader_h
#define ProtocolHeader_h

typedef enum postPresentationTypes
{
    userContentMode,
    FriendsContentMode
}PostPresentationContentMode;

@class CDControlPoint;

@protocol GraphViewDelegate <NSObject>

- (UIImage *)getImageToShareForControlPoint:(CDControlPoint *)point;
- (void)redrawGraphView;
- (void)restoreAllControlPointsFromCD;
- (void)performAddNavButtonsLogic;
@end

@protocol PostedImageVCDelegate <NSObject>

- (void)changePostModePresentationTo:(PostPresentationContentMode)mode;

@end
#endif /* ProtocolHeader_h */
