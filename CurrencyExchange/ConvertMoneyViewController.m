//
//  ConvertMoneyViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/27/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "ConvertMoneyViewController.h"
#import "Fetcher.h"
#import "AverageCurrency.h"
@interface ConvertMoneyViewController ()
@property (nonatomic, strong) NSString *currency;
@property (weak, nonatomic) IBOutlet UIButton *currencyControlD;
@property (weak, nonatomic) IBOutlet UIButton *currencyControlE;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextFieldFirst;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextFieldSecond;
@property (weak, nonatomic) IBOutlet UILabel *firstCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondCurrencyLabel;

@property (assign, nonatomic) NSInteger currencyTag;
@property (assign, nonatomic) NSInteger usdCurrentAskCurrency;
@property (assign, nonatomic) NSInteger eurCurrentAskCurrency;
@property (strong, nonatomic) Fetcher* fetcherObject;
@property (strong, nonatomic) AverageCurrency* averageCurrencyObject;


@end

@implementation ConvertMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fetcherObject = [[Fetcher alloc] init];
    self.averageCurrencyObject = [[AverageCurrency alloc] init];
    self.currencyTag = 1000;
}


- (IBAction)currencyDidChanged:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1000:
            self.firstCurrencyLabel.text = @"USD";
            self.currencyTag = 1000;
            break;
            
        case 1001:
            self.firstCurrencyLabel.text = @"EUR";
            self.currencyTag = 1001;
            break;
            
        default:
            break;
    }
}
- (IBAction)switchButtonPressed
{
    
}
- (IBAction)okButtonPressed
{
    NSArray* tempArray = [[NSArray alloc] initWithArray:[self.fetcherObject averageCurrencyRate]];
    self.averageCurrencyObject = [tempArray objectAtIndex:[tempArray count] - 1];
    self.usdCurrentAskCurrency = [self.averageCurrencyObject.USDask integerValue];
    self.eurCurrentAskCurrency = [self.averageCurrencyObject.EURask integerValue];
    
    self.usdCurrentAskCurrency = (long)self.usdCurrentAskCurrency;
    self.eurCurrentAskCurrency = (long)self.eurCurrentAskCurrency;
    
    NSInteger result = 0;
    if (self.currencyTag == 1000)
    {
        result = self.usdCurrentAskCurrency * [self.moneyTextFieldFirst.text integerValue];
    }
    else
    {
        result = self.eurCurrentAskCurrency * [self.moneyTextFieldFirst.text integerValue];

    }
    result = (long)result;
    self.moneyTextFieldSecond.text = [NSString stringWithFormat:@"%ld",result];
    //NSLog(@"USD = %ld; EUR = %ld", self.usdCurrentAskCurrency, self.eurCurrentAskCurrency);
}



@end
