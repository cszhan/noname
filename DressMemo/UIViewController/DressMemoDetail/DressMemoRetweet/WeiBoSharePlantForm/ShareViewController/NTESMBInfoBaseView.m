

#import "NTESMBInfoBaseView.h"

@interface NTESMBInfoBaseView (Private)

-(void) drawRoundedRect:(CGRect) rect inContext:(CGContextRef)context withSize:(CGSize) size;

@end


@implementation NTESMBInfoBaseView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
	
	CGFloat width = 150.0;
	
	CGRect centerRect = CGRectMake(
								   (rect.origin.x + rect.size.width - width) / 2,
								   (rect.origin.y + rect.size.height - width) / 2,
								   width, width);
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIColor* bgColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.618];
	[bgColor set];
	
	CGContextBeginPath(context);
    [self drawRoundedRect:centerRect inContext:context withSize:CGSizeMake(10,10)];
    CGContextFillPath(context);
}

@end

@implementation NTESMBInfoBaseView (Private)

-(void) drawRoundedRect:(CGRect) rect inContext:(CGContextRef)context withSize:(CGSize) size
{
	float ovalWidth = size.width;
	float ovalHeight = size.height;
	
    float fw, fh;
	
    if (ovalWidth == 0 || ovalHeight == 0) {// 1
        CGContextAddRect(context, rect);
        return;
    }
	
    CGContextSaveGState(context);// 2
	
    CGContextTranslateCTM (context, CGRectGetMinX(rect),// 3
						   CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);// 4
    fw = CGRectGetWidth (rect) / ovalWidth;// 5
    fh = CGRectGetHeight (rect) / ovalHeight;// 6
	
    CGContextMoveToPoint(context, fw, fh/2); // 7
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);// 8
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);// 9
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);// 10
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
    CGContextClosePath(context);// 12
	
    CGContextRestoreGState(context);// 13
	
}


@end
