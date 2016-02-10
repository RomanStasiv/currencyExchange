//
//  PostedGoalsCollectionViewController.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/8/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtocolHeader.h"
@class VKUser;

@interface PostedGoalsCollectionViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) VKUser *currentUser;

@property (nonatomic, strong) NSMutableArray *friendsArray;

@property (nonatomic, assign) PostPresentationContentMode postPresentationMode;

@end
