//
//  TableViewCell.m
//  CurrencyExchange
//
//  Created by Roman Stasiv on 2/4/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "BanksTVCell.h"

@implementation BanksTVCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    CGSize size = self.contentView.frame.size;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, size.width - 20, 25)];
    
    [self.nameLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.nameLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
    
    [self.contentView addSubview:self.nameLabel];
    
    CGSize nameSize = self.nameLabel.frame.size;
    self.adressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 , self.nameLabel.frame.size.height + 10 + 10, size.width - 20, 15)];
    
    [self.adressLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [self.adressLabel setTextAlignment:NSTextAlignmentLeft];
    [self.adressLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
    
    [self.contentView addSubview:self.adressLabel];
    
    
    return self;
}

@end
