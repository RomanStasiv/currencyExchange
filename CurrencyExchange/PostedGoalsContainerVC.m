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

@property (nonatomic, strong) UIActivityIndicatorView *spinner;

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
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.postedGoalsCVC.view addSubview:self.spinner];
    
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
        [self animateChangingOfConstraint:self.PGModeVCWidthConstraint
                                  ToValue:0];
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
    [self.spinner startAnimating];
    
    self.postedGoalsCVC.postPresentationMode = userContentMode;
    
    VKServerManager *manager = [VKServerManager sharedManager];
    [manager authorizeUser:^(VKUser *user)
     {
         self.postedGoalsCVC.currentUser = user;
         self.navigationItem.title = [NSString stringWithFormat:@"%@s goals",user.firstName];
         
         [self.spinner stopAnimating];
         
         [self.postedGoalsCVC.collectionView reloadData];
     }];
}

- (void)setCurrentUserFriendsToPostedGoalsCVC
{
    [self.spinner startAnimating];
    self.navigationItem.title = [NSString stringWithFormat:@"friends goals"];
    self.postedGoalsCVC.friendsArray = [NSMutableArray array];
    
    self.postedGoalsCVC.postPresentationMode = FriendsContentMode;
    [self.postedGoalsCVC.collectionView reloadData];
    VKServerManager *manager = [VKServerManager sharedManager];
    __block NSArray *friends = manager.currentUser.friendsArray;
    __block PostedGoalsCollectionViewController *pGCVC = self.postedGoalsCVC;
    dispatch_queue_t friendsQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//dispatch_queue_create("FriendsGoalsQueue",NULL);
    
    for (VKFriend *friend in friends)
    {
        dispatch_async(friendsQueue, ^
        {
            NSUInteger index = [friends indexOfObject:friend];
            VKFriend *asynchFriend = [friends objectAtIndex:index];
            
            NSString *friendID = asynchFriend.userId;
            [manager getPostedGoalsOfUserWithID:friendID OnSuccess:^(NSDictionary *responce)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (VKFriend *f in friends)
                    {
                        if ([f.userId isEqual:[responce objectForKey:@"UID"]])
                        {
                            f.postedGoals = [responce objectForKey:@"imagesArray"];
                            if (!pGCVC.friendsArray)
                                pGCVC.friendsArray = [NSMutableArray array];
                            if (f.postedGoals.count)
                            {
                                [pGCVC.friendsArray addObject:f];
                                [pGCVC.collectionView reloadData];
                                [self.spinner stopAnimating];
                            }
                        }
                    }
                });
                
            }
                                      onFailure:^(NSError *error, NSInteger statusCode)
            {
                
            }];
            
            
        });
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
