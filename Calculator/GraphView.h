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
@end

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
@property (nonatomic, weak) IBOutlet id <GraphDataSource> dataSource;
@end
