//
//  EarnNotificationView.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/30/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "EarnNotificationView.h"

@implementation EarnNotificationView

- (instancetype)initWithFrame:(CGRect)frame Notification:(NSString *)notification
{
    self = [super initWithFrame:frame];
    self.notificationString = notification;
    self.backgroundColor = [UIColor redColor];
    [self addNotificationLabel:frame];
    return self;
}

/*- (void)drawRect:(CGRect)rect
{
    [self addNotificationLabel:rect];
}*/

- (void)addNotificationLabel:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = self.notificationString;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:frame.size.height];
}

@end
