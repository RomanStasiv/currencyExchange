//
//  TableViewCell.h
//  CurrencyExchange
//
//  Created by Roman Stasiv on 2/4/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BanksTVCell : UITableViewCell

@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UILabel* cityLabel;
@property (strong, nonatomic) UILabel* streetLabel;
@property (strong, nonatomic) UILabel* regionLabel;

@end
