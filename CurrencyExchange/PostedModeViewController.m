//
//  PostedModeViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/8/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "PostedModeViewController.h"

@implementation PostedModeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunsat_patternColor"]];
    self.view.layer.cornerRadius = 10;
    
    // border
    [self.view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.view.layer setBorderWidth:0.5f];
}

- (IBAction)modeDidChanged:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
            [self.modeDelegate changePostModePresentationTo:userContentMode];
            break;
            
        case 2:
            [self.modeDelegate changePostModePresentationTo:FriendsContentMode];
            break;
            
        default:
            break;
    }
}

@end
