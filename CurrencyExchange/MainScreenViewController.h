//
//  ViewController.h
//  CurrencyExchange
//
//  Created by Roman Stasiv on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurencyCourseGraph.h"
#import "MainScreenDrawer.h"
//#import "MSWeakTimer.h"

@interface MainScreenViewController : UIViewController

@property (retain, nonatomic ) NSTimer* m_Timer;
@property (nonatomic, strong) IBOutlet UILabel *USDlabel;
@property (nonatomic, strong) IBOutlet UILabel *EUROlabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchState;
@property (weak, nonatomic) IBOutlet UILabel *stateOfSwitchLabel;



- (IBAction)statusOfSwitchChanged:(id)sender;

@end

