//
//  PostedGoalsCollectionViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/8/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "PostedGoalsCollectionViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ShowImageViewController.h"
#import "CustomCollectionViewCell.h"
#import "CustomHeaderCRV.h"
#import "UIImage+UIImageConcatenateCategory.h"

#import "VKUser.h"
#import "VKFriend.h"

@implementation PostedGoalsCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunsat_patternColor"]];
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        CustomHeaderCRV *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeader" forIndexPath:indexPath];
        
        switch (self.postPresentationMode)
        {
            case userContentMode:
                [headerView.photoView setImageWithURL:self.currentUser.imageURL];
                headerView.firstNameLabel.text = self.currentUser.firstName;
                headerView.secondNameLabel.text = self.currentUser.lastName;
                break;
                
            case FriendsContentMode:
                [headerView.photoView setImageWithURL:((VKFriend *)[self.friendsArray objectAtIndex:indexPath.section]).imageURL];
                headerView.firstNameLabel.text = ((VKFriend *)[self.friendsArray objectAtIndex:indexPath.section]).firstName;
                headerView.secondNameLabel.text = ((VKFriend *)[self.friendsArray objectAtIndex:indexPath.section]).lastName;
                break;
                
            default:
                break;
        }
        
        headerView.backgroundColor = [UIColor colorWithPatternImage:
                                      [UIImage imageWithImage:[UIImage imageNamed:@"sunsat_patternColor"]
                                                  secondImage:[UIImage imageNamed:@"alpha_texture"]
                                                 covertToSize:CGSizeMake(self.view.bounds.size.width * 1.5, self.view.bounds.size.height)]];
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    switch (self.postPresentationMode)
    {
        case userContentMode:
            return 1;
            break;
            
        case FriendsContentMode:
            return self.friendsArray.count;
            break;
            
        default:
            break;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    switch (self.postPresentationMode)
    {
        case userContentMode:
            return self.currentUser.postedImages.count;
            break;
            
        case FriendsContentMode:
            return ((VKFriend *)[self.friendsArray objectAtIndex:section]).postedGoals.count;
            break;
            
        default:
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    [self configureCell:cell ForItemAtIndexPath:indexPath];
    
    return cell;
}

- (CustomCollectionViewCell *)configureCell:(CustomCollectionViewCell *)cell ForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.postPresentationMode)
    {
        case userContentMode:
        {
            NSDictionary *imageSet = [self.currentUser.postedImages objectAtIndex:indexPath.row];
            
            NSURL *url = [NSURL URLWithString:[imageSet objectForKey:@"src_big"]];
            
            [cell.image setImageWithURL:url];
            
            return cell;
        }
            break;
            
        case FriendsContentMode:
        {
            NSDictionary *imageSet = [((VKFriend *)[self.friendsArray objectAtIndex:indexPath.section]).postedGoals objectAtIndex:indexPath.row];
            
            NSURL *url = [NSURL URLWithString:[imageSet objectForKey:@"src_big"]];
            
            [cell.image setImageWithURL:url];
            
            return cell;
            
        }
            break;
            
        default:
            break;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowImageViewController * SIVC = (ShowImageViewController *)[sb instantiateViewControllerWithIdentifier:@"SIVC"];
    
    switch (self.postPresentationMode)
    {
        case userContentMode:
        {
            NSDictionary *imageSet = [self.currentUser.postedImages objectAtIndex:indexPath.row];
            NSURL *url;
            
            if ([imageSet objectForKey:@"src_xbig"])
                url = [NSURL URLWithString:[imageSet objectForKey:@"src_xbig"]];
            else
                url = [NSURL URLWithString:[imageSet objectForKey:@"src_big"]];
            
            SIVC.imageUrl = url;
        }
            break;
            
        case FriendsContentMode:
        {
            NSArray *postedImagesArray = [NSArray array];
            postedImagesArray = ((VKFriend *)[self.friendsArray objectAtIndex:indexPath.section]).postedGoals;
            
            NSDictionary *imageSet = [postedImagesArray objectAtIndex:indexPath.row];
            NSURL *url;
            
            if ([imageSet objectForKey:@"src_xbig"])
                url = [NSURL URLWithString:[imageSet objectForKey:@"src_xbig"]];
            else
                url = [NSURL URLWithString:[imageSet objectForKey:@"src_big"]];
            
            SIVC.imageUrl = url;
        }
            break;
            
        default:
            break;
    }

    [self.navigationController pushViewController:SIVC animated:YES];
}

@end
