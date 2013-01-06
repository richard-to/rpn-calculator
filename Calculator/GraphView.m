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
@synthesize origin = _origin;

#define DEFAULT_SCALE 1.0

- (CGFloat)scale
{
    if ( !_scale) {
        return DEFAULT_SCALE;
    } else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (void)setOrigin:(CGPoint)origin
{
    if (origin.x != _origin.x || origin.y != _origin.y) {
        _origin = origin;
        [self setNeedsDisplay];
    }
}

- (void)setup
{
    _origin = self.center;
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

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
       gesture.state == UIGestureRecognizerStateEnded) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        CGPoint newPoints;
        newPoints.x = self.origin.x + translation.x;
        newPoints.y = self.origin.y + translation.y;
        self.origin = newPoints;
        [gesture setTranslation: CGPointZero inView:self];
    }
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    self.origin = [gesture locationInView:self];
}

- (void)drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:self.bounds
                 originAtPoint:self.origin
                         scale:self.scale];
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    BOOL startPointSet = NO;
    
    for (CGFloat xPoint = 0.0; xPoint < self.bounds.size.width; xPoint++) {
        CGFloat x = (xPoint - self.origin.x) / self.scale;
        CGFloat y = [self.dataSource getPointY:x];
        CGFloat yPoint = self.origin.y - (y * self.scale);
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
