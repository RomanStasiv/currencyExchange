//
//  VKLoginViewController.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/5/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VKAccessToken;

typedef void(^LoginCompletionBlock)(VKAccessToken* token);

@interface VKLoginViewController : UIViewController

- (id) initWithCompletionBlock:(LoginCompletionBlock) completionBlock;

@end
