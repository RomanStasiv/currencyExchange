//
//  ShowImageViewController.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/8/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSURL *imageUrl;
@end
