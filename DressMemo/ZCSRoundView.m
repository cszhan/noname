//
//  ZCSRoundView.m
//  DressMemo
//
//  Created by  on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZCSRoundView.h"
#import <QuartzCore/QuartzCore.h>
@implementation ZCSRoundView
@synthesize cornerColor;
@synthesize radius;
@synthesize roundUpperLeft;
@synthesize roundUpperRight;
@synthesize roundLowerLeft;
@synthesize roundLowerRight;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void) drawRect:(CGRect) rect 
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    if (c != nil)  {
        CGContextSetFillColorWithColor(c, self.cornerColor.CGColor);
        [self drawRoundedCornersInRect:self.bounds inContext:c];
        CGContextFillPath(c);
    }
}

-(void) drawCornerInContext:(CGContextRef)c cornerX:(int) x cornerY:(int) y
                    arcEndX:(int) endX arcEndY:(int) endY 
{
    CGContextMoveToPoint(c, x, endY);
    CGContextAddArcToPoint(c, x, y, endX, y, radius);
    CGContextAddLineToPoint(c, x, y);
    CGContextAddLineToPoint(c, x, endY);
}

-(void) drawRoundedCornersInRect:(CGRect) rect inContext:(CGContextRef) c
{
    
    int x_left = rect.origin.x;
    int x_left_center = rect.origin.x + radius;
    int x_right_center = rect.origin.x + rect.size.width - radius;
    int x_right = rect.origin.x + rect.size.width;
    int y_top = rect.origin.y;
    int y_top_center = rect.origin.y + radius;
    int y_bottom_center = rect.origin.y + rect.size.height - radius;
    int y_bottom = rect.origin.y + rect.size.height;
    CGContextBeginPath(c);
    if (roundUpperLeft) 
    {
        [self drawCornerInContext:c cornerX: x_left cornerY: y_top
                          arcEndX: x_left_center arcEndY: y_top_center];
    }
    
    if (roundUpperRight) {
        [self drawCornerInContext:c cornerX: x_right cornerY: y_top
                          arcEndX: x_right_center arcEndY: y_top_center];
    }
    
    if (roundLowerRight) {
        [self drawCornerInContext:c cornerX: x_right cornerY: y_bottom
                          arcEndX: x_right_center arcEndY: y_bottom_center];
    }
    
    if (roundLowerLeft) {
        [self drawCornerInContext:c cornerX: x_left cornerY: y_bottom
                          arcEndX: x_left_center arcEndY: y_bottom_center];
    }
    /* Done */
    CGContextClosePath(c);
}
@end
