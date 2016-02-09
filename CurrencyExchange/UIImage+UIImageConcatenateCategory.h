//
//  UIImage+UIImageConcatenateCategory.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/9/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageConcatenateCategory)

+(UIImage *)imageWithImage:(UIImage *)image secondImage:(UIImage *)secondImage covertToSize:(CGSize)size;

@end
