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

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *dateExchangePicker;
@property (nonatomic, strong) NSArray *stringDatesArray;

@end

@implementation AddControlPointToEarnMoneyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stringDatesArray = [self ArrayOfStringDatesFromAvarageCurrencyObjectsArray];
    self.currency = @"dolars";
    self.amountOfMoney = 200;
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
        if (/*[self TextIsNumeric:self.moneyTextField.text] && self.date && self.currency*/true)
        {
            self.amountOfMoney = [self.moneyTextField.text floatValue];
            [self.owner addControlPointWithAmountOfMoney:self.amountOfMoney Currency:self.currency ForDate:self.date];
            [self.navigationController popViewControllerAnimated:YES];
        }
        /*else if (![self TextIsNumeric:self.moneyTextField.text])
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
    [formater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
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
