//
//  GraphView.h
//  Calculator
//
//  Created by Richard To on 1/5/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphDataSource
- (float)getPointY:(float)pointX;

@optional
- (void)onUpdateOrigin:(CGPoint)origin;
- (void)onUpdateScale:(float)scale;
@end

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
@property (nonatomic, weak) IBOutlet id <GraphDataSource> dataSource;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;
- (void)tap:(UITapGestureRecognizer *)gesture;

@end
