//
//  ZCSRoundLabel.m
//  DressMemo
//
//  Created by  on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZCSRoundLabel.h"

@implementation ZCSRoundLabel
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
    [super drawRect:rect];
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
-(void)drawRoundConner:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, self.cornerColor.CGColor);
    CGContextSetFillColorWithColor(context, self.cornerColor.CGColor);
    
    CGRect rrect = self.bounds;
    
    CGFloat radius = 5.f;
    CGFloat width = CGRectGetWidth(rrect);
    CGFloat height = CGRectGetHeight(rrect);
    
    if (radius > width/2.0)
        radius = width/2.0;
    if (radius > height/2.0)
        radius = height/2.0;    
    
    CGFloat minx = CGRectGetMinX(rrect);
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat midy = CGRectGetMidY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect);
    switch (1) 
    {
        case 1://表示左上角
            CGContextMoveToPoint(context, minx, midy);
            CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
            CGContextAddLineToPoint(context,maxx,miny);
            CGContextAddLineToPoint(context,maxx,maxy);
            CGContextAddLineToPoint(context,minx,maxy);
            break;
        case 2://表示左下角和右下角
            CGContextMoveToPoint(context, midx, maxy);
            CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
            CGContextAddLineToPoint(context,minx,miny);
            CGContextAddLineToPoint(context,maxx,miny);
            CGContextAddLineToPoint(context,maxx,midy);
            CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
            break;
        case 3:
            CGContextMoveToPoint(context, minx, midy);
            CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
            CGContextAddLineToPoint(context,maxx,miny);
            CGContextAddLineToPoint(context,maxx,maxy);
            CGContextAddLineToPoint(context,minx,maxy);
            break;
        default:
            CGContextMoveToPoint(context, minx, midy);
            CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
            CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
            CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
            CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
            break;
    }
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    /*CGRect arect = CGRectMake(rrect.origin.x + 7,rrect.origin.y + 7,rrect.size.width - 14,rrect.size.height - 14);
     
     CGFloat aradius = 18;
     CGFloat awidth = CGRectGetWidth(arect);
     CGFloat aheight = CGRectGetHeight(arect);
     
     if (aradius > awidth/2.0)
     aradius = awidth/2.0;
     if (aradius > aheight/2.0)
     aradius = aheight/2.0;   
     
     CGFloat aminx = CGRectGetMinX(arect);
     CGFloat amidx = CGRectGetMidX(arect);
     CGFloat amaxx = CGRectGetMaxX(arect);
     CGFloat aminy = CGRectGetMinY(arect);
     CGFloat amidy = CGRectGetMidY(arect);
     CGFloat amaxy = CGRectGetMaxY(arect);
     if (type == 0 ){
     CGContextMoveToPoint(context, aminx, amidy);
     CGContextAddArcToPoint(context, aminx, aminy, amidx, aminy, aradius);
     CGContextAddLineToPoint(context,amaxx,aminy);
     CGContextAddLineToPoint(context,amaxx,amaxy);
     CGContextAddLineToPoint(context,aminx,amaxy);
     } else if (type == 1){
     CGContextMoveToPoint(context, amaxx, amidy);
     CGContextAddArcToPoint(context, amaxx, amaxx, amidx, amaxx, 12);
     CGContextAddLineToPoint(context,aminx,amaxy);
     CGContextAddLineToPoint(context,aminx,aminy);
     CGContextAddLineToPoint(context,amaxx,aminy);
     }
     
     CGContextClosePath(context);
     CGContextDrawPath(context, kCGPathFillStroke);*/
}
@end
