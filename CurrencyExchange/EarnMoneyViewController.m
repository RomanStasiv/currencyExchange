//
//  EarnMoneyViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "EarnMoneyViewController.h"
#import "EarnMoneyGraphView.h"

@interface EarnMoneyViewController ()

@property (weak, nonatomic) IBOutlet EarnMoneyGraphView *graphView;
@property (weak, nonatomic) IBOutlet UIImageView *USDColorIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *EURColorIndicator;


@end

@implementation EarnMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.grapgView setNeedsDisplay];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addControlpointButtonClick:(id)sender
{
   /* self.imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerController.delegate  = self;
    self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.modalPresentationStyle = UIModalPresentationPopover;
    self.imagePickerController.popoverPresentationController.sourceView = self.sourceViewButtonForImagePicker;
    self.imagePickerController.popoverPresentationController.sourceRect = self.sourceViewButtonForImagePicker.bounds;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];*/

}

- (void)setNeedsOfIndicator:(UIImageView *)colorIndicator WithRed:(CGFloat)red WithGreen:(CGFloat)green WithBlue:(CGFloat)blue WithAlpha:(CGFloat)alpha
{
    CGFloat diametr = MIN(colorIndicator.frame.size.height, colorIndicator.frame.size.width);
    
    UIGraphicsBeginImageContext(colorIndicator.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),diametr);
    
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), diametr/2, diametr/2);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), diametr/2, diametr/2);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    colorIndicator.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
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
