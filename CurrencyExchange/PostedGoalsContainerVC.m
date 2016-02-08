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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCurrentUserToPostedGoalsCVC];
    [self addNavigationButtonItem];
}

- (void)addNavigationButtonItem
{
    CGRect ImageRect = CGRectMake(0, 0, 30, 30);
    UIImage *modeImage = [UIImage imageNamed:@"images_icon"];
    UIButton *modeButton = [[UIButton alloc] initWithFrame:ImageRect];
    [modeButton setBackgroundImage:modeImage forState:UIControlStateNormal];
    [modeButton addTarget:self
                    action:@selector(moveModesPanel)
          forControlEvents:UIControlEventTouchUpInside];
    [modeButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *modeBarButton = [[UIBarButtonItem alloc] initWithCustomView:modeButton];

    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItems = @[modeBarButton];
}

- (void)moveModesPanel
{
    static BOOL isOpened = NO;
    if (isOpened)
    {
        self.PGModeVCWidthConstraint.constant = 0;
        isOpened = NO;
    }
    else
    {
        self.PGModeVCWidthConstraint.constant = 100;
        isOpened = YES;
    }
}

- (void)setCurrentUserToPostedGoalsCVC
{
    //dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    VKServerManager *manager = [VKServerManager sharedManager];
    [manager authorizeUser:^(VKUser *user)
     {
         self.postedGoalsCVC.imagesDictionaryArray = user.postedImages;
         [self.postedGoalsCVC.collectionView reloadData];
         //[self.navigationController popViewControllerAnimated:YES];
         /*[self.postedGoalsCVC.collectionView performBatchUpdates:^
         {
             [self.postedGoalsCVC.collectionView reloadData];
         } completion:nil];*/
         //dispatch_semaphore_signal(semaphore);
     }];
    
    //dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}


#pragma mark - PostedImageVCDelegate

- (void)postImagePresentationModeDidChanged
{
    
}

#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PostedGoalsSegue"])
    {
        self.postedGoalsCVC = (PostedGoalsCollectionViewController *)segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"PresentModeSegue"])
    {
        self.presentationModeVC = (PostedModeViewController *)segue.destinationViewController;
    }
}
@end
