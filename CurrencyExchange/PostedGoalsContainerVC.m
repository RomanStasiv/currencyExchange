    //
//  PostedGoalsContainerVC.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/8/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//
#import "CustomNavigationController.h"

#import "PostedGoalsContainerVC.h"
#import "PostedGoalsCollectionViewController.h"
#import "PostedModeViewController.h"

#import "VKServerManager.h"
#import "VKUser.h"
#import "VKFriend.h"



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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunsat_patternColor"]];
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
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
            [self animateChangingOfConstraint:self.PGModeVCWidthConstraint
                                      ToValue:self.view.frame.size.width / 3];
        }
        else
        {
            [self animateChangingOfConstraint:self.PGModeVCWidthConstraint
                                      ToValue:self.view.frame.size.width / 4];
        }
        isOpened = YES;
    }
}

- (void)animateChangingOfConstraint:(NSLayoutConstraint *)constraint ToValue:(CGFloat)value
{
    constraint.constant = value;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.8f animations:^
     {
         [self.view layoutIfNeeded];
     }];
}

- (void)setCurrentUserToPostedGoalsCVC
{
    //dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    self.postedGoalsCVC.postPresentationMode = userContentMode;
    
    VKServerManager *manager = [VKServerManager sharedManager];
    [manager authorizeUser:^(VKUser *user)
     {
         self.postedGoalsCVC.currentUser = user;
         self.navigationItem.title = [NSString stringWithFormat:@"%@s goals",user.firstName];
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

- (void)setCurrentUserFriendsToPostedGoalsCVC
{
    self.postedGoalsCVC.postPresentationMode = FriendsContentMode;
    
    VKServerManager *manager = [VKServerManager sharedManager];
    NSArray *friends = manager.currentUser.friendsArray;
    
    self.postedGoalsCVC.friendsArray = [NSMutableArray array];
    
    for (int i = 0; i < friends.count; i++)
    {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

        NSString *frienfID = ((VKFriend *)[friends objectAtIndex:i]).userId;
        
            [manager getUser:frienfID onSuccess:^(VKUser *user)
             {
                 [self.postedGoalsCVC.friendsArray addObject:user];
                 self.navigationItem.title = [NSString stringWithFormat:@"friends goals"];
                 [self.postedGoalsCVC.collectionView reloadData];
                 
                 dispatch_semaphore_signal(semaphore);
             }
                   onFailure:^(NSError *error, NSInteger statusCode)
             {
                 
             }];
        while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
    
}

#pragma mark - PostedImageVCDelegate

- (void)changePostModePresentationTo:(PostPresentationContentMode)mode
{
    switch (mode)
    {
        case userContentMode:
            [self setCurrentUserToPostedGoalsCVC];
            [self moveModesPanel];
            break;
            
        case FriendsContentMode:
            [self setCurrentUserFriendsToPostedGoalsCVC];
            [self moveModesPanel];
            break;
            
        default:
            break;
    }
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
        self.presentationModeVC.modeDelegate = self;
    }
}

@end
