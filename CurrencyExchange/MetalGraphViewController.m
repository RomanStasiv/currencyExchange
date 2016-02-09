//
//  MetalGraphViewController.m
//  CurrencyExchange
//
//  Created by Melany on 2/9/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "MetalGraphViewController.h"
#import "MetalDrawer.h"

@interface MetalGraphViewController ()

@property (weak, nonatomic) IBOutlet UILabel *goldPrices;
@property (weak, nonatomic) IBOutlet UILabel *silverPrices;
@property (weak, nonatomic) IBOutlet MetalDrawer *drawer;
@property (nonatomic, strong) NSMutableArray *metalPricesArray;
@property (nonatomic, strong) UIColor *USDgoldColor;
@property (nonatomic, strong) UIColor *USDsilverColor;
@property (nonatomic, strong) UIColor *EURgoldColor;
@property (nonatomic, strong) UIColor *EURsilverColor;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateOfsegmentedController;

@end

@implementation MetalGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
