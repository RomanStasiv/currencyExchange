//
//  CustomEGTableViewCell.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/31/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomEGTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *investingDate;
@property (weak, nonatomic) IBOutlet UILabel *investingAmount;
@property (weak, nonatomic) IBOutlet UILabel *investingCurrency;
@property (weak, nonatomic) IBOutlet UILabel *earningAmount;

@property (weak, nonatomic) IBOutlet UIButton *removeControlPoint;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@end
