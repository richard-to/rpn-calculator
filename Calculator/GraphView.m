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

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;

#define DEFAULT_SCALE 1.00

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
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    BOOL startPointSet = NO;
    
    for (CGFloat xPoint = 0.0; xPoint < self.bounds.size.width; xPoint++) {
        CGFloat x = xPoint - self.center.x;
        CGFloat y = [self.dataSource getPointY:x];
        CGFloat yPoint = self.center.y - y;
        if (startPointSet == NO) {
            startPointSet = YES;
            CGContextMoveToPoint(context, xPoint, yPoint);
        } else {
            CGContextAddLineToPoint(context, xPoint, yPoint);
        }
    }
    CGContextStrokePath(context);    
}

@end
