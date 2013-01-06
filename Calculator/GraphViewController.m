//
//  GraphViewController.m
//  Calculator
//
//  Created by Richard To on 1/3/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphDataSource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController

@synthesize brain = _brain;
@synthesize graphView = _graphView;
@synthesize equationLabel = _equationLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.equationLabel.text = [[self.brain class] descriptionOfProgram:self.brain.program];
}

- (void)setBrain:(CalculatorBrain *)brain
{
    _brain = brain;
    [self.graphView setNeedsDisplay];
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    [self.graphView addGestureRecognizer: [[UIPinchGestureRecognizer alloc]
                                           initWithTarget:self.graphView
                                           action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer: [[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action: @selector(pan:)]];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self.graphView addGestureRecognizer: tapRecognizer];
    self.graphView.dataSource = self;
}

- (float)getPointY:(float)pointX
{
    NSDictionary *varDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithFloat: pointX], @"x", nil];
    return [[self.brain class] runProgram:self.brain.program
                   usingVariableValues:varDict];
}

@end
