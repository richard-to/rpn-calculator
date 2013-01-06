//
//  GraphView.m
//  Calculator
//
//  Created by Richard To on 1/5/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize scale = _scale;

#define DEFAULT_SCALE 0.90

- (CGFloat)scale
{
    if ( !_scale) {
        return DEFAULT_SCALE;
    } else {
        return _scale;
    }
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:self.bounds
                 originAtPoint:self.center
                         scale:self.scale];
}

@end
