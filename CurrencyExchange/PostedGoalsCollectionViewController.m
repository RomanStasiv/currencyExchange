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

#import "VKUser.h"

@implementation PostedGoalsCollectionViewController


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
            return self.imagesDictionaryArray.count;
            break;
            
        case FriendsContentMode:
            return ((VKUser *)[self.friendsArray objectAtIndex:section]).postedImages.count;
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
            NSDictionary *imageSet = [self.imagesDictionaryArray objectAtIndex:indexPath.row];
            
            NSURL *url = [NSURL URLWithString:[imageSet objectForKey:@"src_big"]];
            
            [cell.image setImageWithURL:url];
            
            return cell;
        }
            break;
            
        case FriendsContentMode:
        {
            NSDictionary *imageSet = [((VKUser *)[self.friendsArray objectAtIndex:indexPath.section]).postedImages objectAtIndex:indexPath.row];
            
            NSURL *url = [NSURL URLWithString:[imageSet objectForKey:@"src_big"]];
            
            [cell.image setImageWithURL:url];
            
            return cell;
            
        }
            break;
            
        default:
            break;
    }
}


/*- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowImageViewController * SIVC = (ShowImageViewController *)[sb instantiateViewControllerWithIdentifier:@"SIVC"];
    
    NSDictionary *imageSet = [self.imagesDictionaryArray objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[imageSet objectForKey:@"src_xbig"]];
    SIVC.imageUrl = url;

    [self.navigationController pushViewController:SIVC animated:YES];
}*/

@end
