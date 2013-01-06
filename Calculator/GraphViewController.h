//
//  GraphViewController.h
//  Calculator
//
//  Created by Richard To on 1/3/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface GraphViewController : UIViewController
@property (nonatomic, strong) CalculatorBrain *brain;
@end
