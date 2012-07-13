//
//  BlogActivityView.m
//  BlogPress
//
//  Created by Feng Huajun on 08-6-18.
//  Copyright 2008 Coollittlethings. All rights reserved.
//

#import "NTESMBActivityView.h"


@interface NTESMBActivityView (Private)

-(void) drawRoundedRect:(CGRect) rect inContext:(CGContextRef)context withSize:(CGSize) size;

@end

@implementation NTESMBActivityView

@dynamic text;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 50)];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont boldSystemFontOfSize:18];
		label.adjustsFontSizeToFitWidth = YES;
		label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 19, 15)];
		imageView.hidden = YES;
		[self addSubview:activityIndicator];
		[self addSubview:imageView];
		[self addSubview:label];
		//activityIndicator.center = CGPointMake(self.bounds.size.width / 2
	}
	return self;
}

-(void) setText:(NSString*) text
{
	label.text = text;
}

-(NSString*) text
{
	return label.text;
}

- (void)startAnimating
{
	imageView.hidden = YES;
	[activityIndicator startAnimating];
}

- (void)stopAnimating
{
	[activityIndicator stopAnimating];
}

- (void)stopAnimatingWithCheckmark{
	imageView.image = [UIImage imageNamed:@"checkmark.png"];
	[self stopAnimating];
	imageView.hidden = NO;
}

- (void)stopAnimatingWithCross{
	imageView.image = [UIImage imageNamed:@"cross.png"];
	[self stopAnimating];
	imageView.hidden = NO;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	activityIndicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
	imageView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
	label.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 + 45);
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


- (void)dealloc {
	[activityIndicator release];
	[imageView release];
	[label release];
	[super dealloc];
}


@end


@implementation NTESMBActivityView (Private)

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