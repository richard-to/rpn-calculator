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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)setBrain:(CalculatorBrain *)brain
{
    _brain = brain;
    [self.graphView setNeedsDisplay];
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
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
