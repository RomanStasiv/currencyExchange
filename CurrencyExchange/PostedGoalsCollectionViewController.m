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

@implementation PostedGoalsCollectionViewController


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.imagesDictionaryArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    NSDictionary *imageSet = [self.imagesDictionaryArray objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[imageSet objectForKey:@"src_big"]];
    
    [cell.image setImageWithURL:url];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowImageViewController * SIVC = (ShowImageViewController *)[sb instantiateViewControllerWithIdentifier:@"SIVC"];
    
    NSDictionary *imageSet = [self.imagesDictionaryArray objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[imageSet objectForKey:@"src_xbig"]];
    SIVC.imageUrl = url;

    [self.navigationController pushViewController:SIVC animated:YES];
}

@end
