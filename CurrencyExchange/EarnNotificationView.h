//
//  EarnNotificationView.h
//  CurrencyExchange
//
//  Created by alex4eetah on 1/30/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarnNotificationView : UIView

- (instancetype)initWithFrame:(CGRect)frame Notification:(NSString *)notification;

@property (nonatomic, strong) NSString *notificationString;

@end
