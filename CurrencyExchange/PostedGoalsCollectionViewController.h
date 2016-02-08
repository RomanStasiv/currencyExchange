//
//  PostedGoalsCollectionViewController.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/8/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostedGoalsCollectionViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *imagesDictionaryArray;

@end
