//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Richard To on 12/28/12.
//  Copyright (c) 2012 Richard To. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *variableValues;
@property (nonatomic, strong) NSDictionary *variableValuesTest1;
@property (nonatomic, strong) NSDictionary *variableValuesTest2;
@property (nonatomic, strong) NSDictionary *variableValuesTest3;

- (void)displayEquation:(NSString *)anOperatorOrOperand;
- (void)runProgram;
- (void)displayVariablesToScreen;
@end

@implementation CalculatorViewController

@synthesize variableValues = _variableValues;
@synthesize display = _display;
@synthesize displayLog = _displayLog;
@synthesize displayEqual = _displayEqual;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}

- (NSDictionary *)variableValues {
    if(!_variableValues) _variableValues = [[NSDictionary alloc]initWithObjectsAndKeys: [NSNumber numberWithDouble: 3.0], @"x", nil];
    return _variableValues;
}

- (CalculatorBrain *)brain {
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)displayEquation:(NSString *)anOperatorOrOperand {
    if (self.displayLog.text.length > 0) {
        self.displayLog.text = [self.displayLog.text stringByAppendingString:@" "];
    }
    self.displayLog.text =
        [self.displayLog.text stringByAppendingString:anOperatorOrOperand];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([digit compare: @"."] != NSOrderedSame
                || [self.display.text rangeOfString: @"."].location == NSNotFound) {
             self.display.text = [self.display.text stringByAppendingString: digit];
        }
    } else {
        self.userIsInTheMiddleOfEnteringANumber = YES;
        self.displayEqual.text = @"";
        self.display.text = digit;
    }
}

- (IBAction)backPressed {
    if (self.userIsInTheMiddleOfEnteringANumber == YES) {
        NSString *newDisplay =
            [self.display.text substringToIndex:self.display.text.length - 1];
        if (newDisplay.length == 0) {
            [self runProgram];
            self.userIsInTheMiddleOfEnteringANumber = NO;
        } else {
            self.display.text = newDisplay;
            self.displayEqual.text = @"";
        }
    } else {
        [self.brain popOperand];
        [self runProgram];
    }
}

- (IBAction)clearPressed {
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self.brain clearOperands];
    self.displayLog.text = @"";
    self.displayEqual.text = @"";
    [self displayVariablesToScreen];
}

- (IBAction)enterPressed {
    [self.brain pushOperandOrOperator:self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self displayEquation:self.display.text];
    self.displayLog.text = [[self.brain class] descriptionOfProgram:self.brain.program];
    self.displayEqual.text = @"";    
}

- (IBAction)variablePressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *var = sender.currentTitle;
    [self.brain pushOperandOrOperator:var];
    self.display.text = var;
    self.displayLog.text = [[self.brain class] descriptionOfProgram:self.brain.program];
    [self displayVariablesToScreen];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = sender.currentTitle;
    [self.brain pushOperandOrOperator:operation];
    [self runProgram];
}

- (void)runProgram {
    double result = [[self.brain class] runProgram:[self.brain program]
                               usingVariableValues:self.variableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.displayLog.text = [[self.brain class] descriptionOfProgram:self.brain.program];
    self.displayEqual.text = @"=";
    [self displayVariablesToScreen];
}

- (void)displayVariablesToScreen {
    NSSet *varSet = [[self.brain class] variablesUsedInProgram:[self.brain program]];
    NSString *variableOutput = @"";
    NSNumber *num;
    
    if (varSet) {
        for (NSString *var in varSet){
            num = [self.variableValues valueForKey:var];
            if (num) {
                if (variableOutput.length > 0) {
                    variableOutput = [variableOutput stringByAppendingString:@" "];
                }
                variableOutput = [variableOutput stringByAppendingFormat:@"%@ = %@", var, num];
            }
        }
    }
    self.displayVariables.text = variableOutput;
}

- (IBAction)graphPressed {
    id detailVC = [self splitViewBarButtonItemPresenter];
    if (detailVC) {
        [detailVC setBrain:self.brain];
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Graph"]) {
        [segue.destinationViewController setBrain:self.brain];
    }
}
@end
