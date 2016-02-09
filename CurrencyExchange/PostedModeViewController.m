//
//  PostedModeViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/8/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "PostedModeViewController.h"

@implementation PostedModeViewController
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
