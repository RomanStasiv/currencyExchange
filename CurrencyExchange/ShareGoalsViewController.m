//
//  ShareGoalsViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "ShareGoalsViewController.h"
#import "WebSharingViewController.h"

@interface ShareGoalsViewController ()

@property (nonatomic, strong) NSString *source;

@end

static NSString *seaguewID = @"shareSeague";

@implementation ShareGoalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)wayOfSharingBeenChosen:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
            self.source = @"vk";
            break;
            
        case 2:
            self.source = @"fb";
            break;
            
        case 3:
            self.source = @"Gmail";
            break;
            
        default:
            break;
    }
    [self performSegueWithIdentifier:@"shareSeague" sender:self];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    if ([segue.identifier isEqualToString:seaguewID])
    {
        if ([segue.destinationViewController isKindOfClass:[WebSharingViewController class]])
            [(WebSharingViewController *)segue.destinationViewController setSourceToShare:self.source];
    }
}


@end
