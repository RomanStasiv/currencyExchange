//
//  PostedGoalsContainerVC.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/8/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "PostedGoalsContainerVC.h"
#import "PostedGoalsCollectionViewController.h"
#import "PostedModeViewController.h"

#import "VKServerManager.h"
#import "VKUser.h"



@interface PostedGoalsContainerVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PGModeVCWidthConstraint;
@property (assign, nonatomic) PostPresentationContentMode mode;

@property (weak, nonatomic) PostedGoalsCollectionViewController *postedGoalsCVC;
@property (weak, nonatomic) PostedModeViewController *presentationModeVC;

@end

@implementation PostedGoalsContainerVC

/*- ()

VKServerManager *manager = [VKServerManager sharedManager];
[manager authorizeUser:^(VKUser *user)
 {
     UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     PostedGoalsCollectionViewController * pgCVC = (PostedGoalsCollectionViewController *)[sb instantiateViewControllerWithIdentifier:@"PGCVC"];
     pgCVC.imagesDictionaryArray = user.postedImages;
     
     [self.navigationController pushViewController:pgCVC animated:YES];
 }];


#pragma mark - PostedImageVCDelegate

- (void)postImagePresentationModeDidChanged
{
    
}

#pragma mark - navigation
-*/
@end
