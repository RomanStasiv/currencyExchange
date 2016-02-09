//
//  ConvertMoneyViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/27/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "ConvertMoneyViewController.h"

@interface ConvertMoneyViewController ()
@property (nonatomic, strong) NSString *currency;
@property (weak, nonatomic) IBOutlet UIButton *currencyControlD;
@property (weak, nonatomic) IBOutlet UIButton *currencyControlE;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextFieldFirst;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextFieldSecond;

@end

@implementation ConvertMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)currencyDidChanged:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1000:
            self.currency = @"dolars";
            break;
            
        case 1001:
            self.currency = @"euro";
            break;
            
        default:
            break;
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
