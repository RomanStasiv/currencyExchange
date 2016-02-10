//
//  ShowImageViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/8/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "ShowImageViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ShowImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ShowImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView setImageWithURL:self.imageUrl];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunsat_patternColor"]];
}

@end
