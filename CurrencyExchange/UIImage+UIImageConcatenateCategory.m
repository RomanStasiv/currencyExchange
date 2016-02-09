//
//  UIImage+UIImageConcatenateCategory.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/9/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "UIImage+UIImageConcatenateCategory.h"

@implementation UIImage (UIImageConcatenateCategory)

+(UIImage *)imageWithImage:(UIImage *)image secondImage:(UIImage *)secondImage covertToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake( 0, 0, size.width, size.height)];
    [secondImage drawInRect:CGRectMake( 0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

@end
