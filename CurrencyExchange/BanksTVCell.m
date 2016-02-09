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

    // Configure the view for the selected state//
    //smallfix
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    CGSize size = self.contentView.frame.size;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, size.width - 10, 25)];
    
    [self.nameLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.nameLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
    
    [self.contentView addSubview:self.nameLabel];
    
    CGRect rect = self.nameLabel.frame;

    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 , rect.size.height + rect.origin.y + 5, size.width - 10, 15)];
    
    [self.cityLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [self.cityLabel setTextAlignment:NSTextAlignmentLeft];
    [self.cityLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
    
    [self.contentView addSubview:self.cityLabel];
    
    rect = self.cityLabel.frame;
    self.streetLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 , rect.size.height + rect.origin.y + 5, size.width - 10, 15)];
    
    [self.streetLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [self.streetLabel setTextAlignment:NSTextAlignmentLeft];
    [self.streetLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
    
    [self.contentView addSubview:self.streetLabel];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    return self;
}

@end
