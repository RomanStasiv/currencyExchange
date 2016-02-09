//
//  PostedModeViewController.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/8/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtocolHeader.h"

@interface PostedModeViewController : UIViewController

@property (nonatomic, weak) id<PostedImageVCDelegate> modeDelegate;

@end
