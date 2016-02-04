//
//  AddControlPointToEarnMoneyViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "AddControlPointToEarnMoneyViewController.h"
#import "AverageCurrency.h"

@interface AddControlPointToEarnMoneyViewController ()

@property (nonatomic, assign) CGFloat amountOfMoney;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic ,strong) NSDate *date;

@property (weak, nonatomic) IBOutlet UISegmentedControl *currencyControl;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *dateExchangePicker;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (nonatomic, strong) NSArray *stringDatesArray;

@property (nonatomic, strong) NSString *hint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hintHeightConstraint;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation AddControlPointToEarnMoneyViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stringDatesArray = [self ArrayOfStringDatesFromAvarageCurrencyObjectsArray];
    self.currency = @"dolars";
    
    self.hintLabel.userInteractionEnabled = YES;
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnHintLabelDetected)];
    [self.hintLabel addGestureRecognizer:self.pan];
    
    self.hint = @"Add nessesary info about your currency exchanging, and app will tell You, when you can earn.";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunsat_patternColor"]];
#warning how to ???
    /*
    UIView *glassTexture= [[UIView alloc] initWithFrame:self.view.frame];
    glassTexture.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"clearGlass_texture"]];
    glassTexture.alpha = 0.1;
    [self.view insertSubview:glassTexture belowSubview:self.view];*/
    
}

- (void)prepareAllData
{
    self.stringDatesArray = [self ArrayOfStringDatesFromAvarageCurrencyObjectsArray];
    self.currency = @"dolars";
    [self.dateExchangePicker reloadAllComponents];
}

#pragma mark hideKeyboard
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)tapOnHintLabelDetected
{
    static BOOL isOpened = NO;
    if (!isOpened)
    {
        self.pan.enabled = NO;
        self.hintLabel.textColor = [UIColor darkTextColor];
        self.hintLabel.adjustsFontSizeToFitWidth = YES;
        self.hintLabel.numberOfLines = 0;
        self.hintLabel.textAlignment = NSTextAlignmentLeft;
        self.hintLabel.text = self.hint;
        [self animateChangingOfConstraint:self.hintHeightConstraint ToValue:150];
        isOpened = YES;
    }
    else
    {
        self.pan.enabled = NO;
        self.hintLabel.textColor = [UIColor lightGrayColor];
        self.hintLabel.adjustsFontSizeToFitWidth = YES;
        self.hintLabel.textAlignment = NSTextAlignmentCenter;
        self.hintLabel.text = @"Show hint";
        [self animateChangingOfConstraint:self.hintHeightConstraint ToValue:40];
        isOpened = NO;
    }
}

- (void)animateChangingOfConstraint:(NSLayoutConstraint *)constraint ToValue:(CGFloat)value
{
    constraint.constant = value;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.8f animations:^
     {
         [self.view layoutIfNeeded];
     }];
    self.pan.enabled = YES;
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
        if ([self TextIsNumeric:self.moneyTextField.text] && self.date && self.currency)
        {
            self.amountOfMoney = [self.moneyTextField.text floatValue];
            [self.owner addControlPointWithAmountOfMoney:self.amountOfMoney Currency:self.currency ForDate:self.date];
        }
        else
        {
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            anim.duration = 0.1;
            anim.repeatCount = 4;
            anim.autoreverses = YES;
            anim.removedOnCompletion = YES;
            anim.fromValue = [NSNumber numberWithFloat:-5.f];
            anim.toValue = [NSNumber numberWithFloat:5.f];
    
            if (![self TextIsNumeric:self.moneyTextField.text])
            {
                [self.moneyTextField.layer addAnimation:anim forKey:nil];
            }
            else if (!self.date)
            {
                [self.dateExchangePicker.layer addAnimation:anim forKey:nil];
            }
            else if (!self.currency)
            {
                [self.currencyControl.layer addAnimation:anim forKey:nil];
            }
        }
        /*
         else if (![self TextIsNumeric:self.moneyTextField.text])
         {
         [self showMessageWith:@"Wrong amount of mooney"];
         }
         else if (!self.date)
         {
         [self showMessageWith:@"Chose a date"];
         }
         else if (!self.currency)
         {
         [self showMessageWith:@"Chose a currency"];
         }*/
    }
}

- (void)showMessageWith:(NSString *)message
{
    
    
    UIColor *normalColor = self.moneyTextField.backgroundColor;
    NSString *normalText = self.moneyTextField.text;
    
    self.moneyTextField.text = message;
    self.moneyTextField.backgroundColor = [UIColor redColor];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^
                   {
                       self.moneyTextField.text = normalText;
                       self.moneyTextField.backgroundColor = normalColor;
                   });
}

#pragma mark - pickerMethods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.avarageCurrencyObjectsArray.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.date = ((AverageCurrency *)[self.avarageCurrencyObjectsArray objectAtIndex:row]).date;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.stringDatesArray objectAtIndex:row];
}

- (NSArray *)ArrayOfStringDatesFromAvarageCurrencyObjectsArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    for (AverageCurrency *object in self.avarageCurrencyObjectsArray)
    {
        [array addObject:[formater stringFromDate:object.date]];
    }
    return array;
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
