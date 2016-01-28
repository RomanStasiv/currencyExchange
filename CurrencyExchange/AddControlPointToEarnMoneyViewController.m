//
//  AddControlPointToEarnMoneyViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "AddControlPointToEarnMoneyViewController.h"

@interface AddControlPointToEarnMoneyViewController ()

@property (nonatomic, assign) CGFloat amountOfMoney;
@property (nonatomic, strong) NSString *currency;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@end

@implementation AddControlPointToEarnMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)currencyDidChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            self.currency = @"dolars";
            break;
            
        case 1:
            self.currency = @"euro";
            break;
            
        default:
            break;
    }
}

- (IBAction)amountOfMoneyDidChanged:(UITextField *)sender
{
    
}

/*- (NSString *)deleteLastCharInString:(NSString *)string
{
    NSString *result = nil;
    
    if ([string length])
    {
        result = [string substringToIndex:[string length]-1];
    }
    
    return result;
}*/

- (BOOL) TextIsNumeric:(NSString *)text
{
    BOOL result = false;
    NSString *pattern = @"^\\d+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    result = [test evaluateWithObject:text];
    return result;
}

- (IBAction)saveButtonBeenPressed:(id)sender
{
    if (self.moneyTextField.text)
    {
        if ([self TextIsNumeric:self.moneyTextField.text])
        {
            self.amountOfMoney = [self.moneyTextField.text floatValue];
            [self.owner addControlPointWithAmountOfMoney:self.amountOfMoney
                                             andCurrency:self.currency];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            self.moneyTextField.text = nil;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
