//
//  WebSharingViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "WebSharingViewController.h"

@interface WebSharingViewController ()

@end

@implementation WebSharingViewController

- (void) setSourceToShare:(NSString *)sourceToShare
{
    _sourceToShare = sourceToShare;
    NSLog(@"source: %@",sourceToShare);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
