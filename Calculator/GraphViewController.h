//
//  GraphViewController.h
//  Calculator
//
//  Created by Richard To on 1/3/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@protocol SplitViewBarButtonItemPresenter <NSObject>
@property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;
@end

@interface GraphViewController : UIViewController <SplitViewBarButtonItemPresenter>
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *equationLabel;
@property (nonatomic, strong) CalculatorBrain *brain;
@end
