//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Richard To on 12/28/12.
//  Copyright (c) 2012 Richard To. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *displayLog;
@property (weak, nonatomic) IBOutlet UILabel *displayEqual;
@property (weak, nonatomic) IBOutlet UILabel *displayVariables;

@end
