//
//  CustomNavigationController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/4/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "CustomNavigationController.h"

@implementation CustomNavigationController

-(BOOL)shouldAutorotate
{
    if (self.canBeInLandscape)
        return YES;
    else
        return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (self.canBeInLandscape)
        return YES;
    else
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


@end
