//
//  MetalGraphViewController.m
//  CurrencyExchange
//
//  Created by Melany on 2/9/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "MetalGraphViewController.h"
#import "MetalDrawer.h"
#import "Fetcher.h"

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
@property (strong, nonatomic) Fetcher* fetcher;
@property (strong, nonatomic) NSNumberFormatter* formatter;

@end

@implementation MetalGraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fetcher = [[Fetcher alloc]init];
    if (!self.metalPricesArray)
        self.metalPricesArray = [NSMutableArray array];
    [self prepareGraphView];
    [self selfUpdate: [UIColor blackColor]  :[UIColor darkGrayColor] :[UIColor clearColor]  :[UIColor clearColor]];
    self.metalPricesArray = [[self.fetcher arrayOfMetalForDrawing]mutableCopy];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunsat_patternColor"]];
    self.drawer.avarageCurrencyObjectsArray = self.metalPricesArray;
    [self.drawer setNeedsDisplay];
    
    
    self.formatter = [[NSNumberFormatter alloc] init];
    
    [self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.formatter setMaximumFractionDigits:2];

    self.drawer.backgroundColor = [UIColor clearColor];
}

- (void)redrawGraphView
{
    [self prepareGraphView];
    [self.drawer setNeedsDisplay];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self prepareGraphView];
    [self selfUpdate: [UIColor yellowColor]  :[UIColor grayColor] :[UIColor clearColor]  :[UIColor clearColor]];
    [self.drawer setNeedsDisplay];
    
}


- (void)selfUpdate:(UIColor*)usdA :(UIColor*) EuroA :(UIColor*)usdP :(UIColor*) EuroP
{
    self.USDgoldColor = usdP;
    self.USDsilverColor = usdA;
    self.EURgoldColor = EuroP;
    self.EURsilverColor = EuroA;
    
    self.drawer.USDBidStrokeColor = self.USDgoldColor;
    self.drawer.USDAskStrokeColor = self.USDsilverColor;
    self.drawer.EURBidStrokeColor = self.EURgoldColor;
    self.drawer.EURAskStrokeColor = self.EURsilverColor;
    
}

- (void)prepareGraphView
{
     self.drawer.contentMode = UIViewContentModeRedraw;
}
- (void)didReceiveMemoryWarning
{
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

- (IBAction)segmentedControllerSelected:(UISegmentedControl *)sender
{
    NSInteger lastIndex = [self.metalPricesArray count];
    if(sender.selectedSegmentIndex == 0)
    {
        [self selfUpdate: [UIColor yellowColor]  :[UIColor grayColor] :[UIColor clearColor]  :[UIColor clearColor]];
        [self.drawer setNeedsDisplay];

        NSNumber *tmp = [[self.metalPricesArray objectAtIndex:lastIndex-1]USDask];
        self.goldPrices.text = [self.formatter stringFromNumber:tmp];
        NSNumber*tmpEuro = [[self.metalPricesArray objectAtIndex:lastIndex-1]EURask];
        self.silverPrices.text = [self.formatter stringFromNumber:tmpEuro];
    }
    else if(sender.selectedSegmentIndex == 1)
    {
        [self selfUpdate: [UIColor clearColor]  :[UIColor clearColor] :[UIColor yellowColor]  :[UIColor grayColor]];
        [self.drawer setNeedsDisplay];

        NSNumber *tmp = [[self.metalPricesArray objectAtIndex:lastIndex-1]USDbid];
        self.goldPrices.text = [self.formatter stringFromNumber:tmp];
        NSNumber*tmpEuro = [[self.metalPricesArray objectAtIndex:lastIndex-1]EURbid];
        self.silverPrices.text = [self.formatter stringFromNumber:tmpEuro];
    }
}
@end
