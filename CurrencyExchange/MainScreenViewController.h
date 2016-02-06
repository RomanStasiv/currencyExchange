//
//  ViewController.h
//  CurrencyExchange
//
//  Created by Roman Stasiv on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurencyCourseGraph.h"
//#import "MSWeakTimer.h"

@interface MainScreenViewController : UIViewController

@property (retain, nonatomic ) NSTimer* m_Timer;
@property (nonatomic, strong) IBOutlet UILabel *USDAsklabel;
@property (nonatomic, strong) IBOutlet UILabel *EUROAsklabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchState;
@property (weak, nonatomic) IBOutlet UILabel *stateOfSwitchLabel;

@end

