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
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat scale;
- (void)setOriginX:(float)xPoint andY:(float)yPoint;
@end

@implementation GraphViewController

@synthesize brain = _brain;
@synthesize graphView = _graphView;
@synthesize equationLabel = _equationLabel;
@synthesize origin = _origin;
@synthesize scale = _scale;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolBar = _toolBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"graphScale"] != nil) {
        self.scale = [defaults floatForKey:@"graphScale"];
        self.graphView.scale = self.scale;
    }
    
    if ([defaults objectForKey:@"graphOriginX"] != nil &&
        [defaults objectForKey:@"graphOriginY"] != nil) {
        [self setOriginX:[defaults floatForKey:@"graphOriginX"]
                    andY:[defaults floatForKey:@"graphOriginY"]];
        self.graphView.origin = self.origin;
    }
    
    self.equationLabel.text = [[self.brain class] descriptionOfProgram:self.brain.program];
}

- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolBar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}

- (void)setBrain:(CalculatorBrain *)brain
{
    _brain = brain;
    [self.graphView setNeedsDisplay];
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [[NSUserDefaults standardUserDefaults] setFloat:_scale
                                                forKey:@"graphScale"];
    }
}

- (void)setOriginX:(float)xPoint andY:(float)yPoint
{
    CGPoint origin;
    origin.x = xPoint;
    origin.y = yPoint;
    self.origin = origin;
}

- (void)setOrigin:(CGPoint)origin
{
    if (origin.x != _origin.x || origin.y != _origin.y) {
        _origin = origin;
        [[NSUserDefaults standardUserDefaults] setFloat:_origin.x
                                                 forKey:@"graphOriginX"];
        [[NSUserDefaults standardUserDefaults] setFloat:_origin.y
                                                 forKey:@"graphOriginY"];
    }
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

- (void)onUpdateOrigin:(CGPoint)origin
{
    self.origin = origin;
}

- (void)onUpdateScale:(float)scale
{
    self.scale = scale;
}
@end
