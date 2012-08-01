//
//  DragDownInfoView.m
//  TweetieTableView
//
//  Created by Xu Han Jie on 10-5-20.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBDragDownInfoView.h"
#import "NSDate+Ex.h"

#define BORDER_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]

@implementation NTESMBDragDownInfoView

@synthesize lastUpdateDate;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.bounds.size.height)];
		
		CGFloat midHeight = self.bounds.size.height - 4;
		
		midBackground = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refreshMid.png"]] autorelease];
		midBackground.frame = CGRectMake(0, 0, 320, midHeight);
		[backgroundView addSubview:midBackground];
		
		background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refreshBottom.png"]] autorelease];
		background.frame = CGRectMake(0, midHeight, 320, 4);
		[backgroundView addSubview:background];
		
		[self addSubview:backgroundView];
		[backgroundView release];
		
		infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, self.bounds.size.height - 65, 200, 70)];
		infoLabel.textAlignment = UITextAlignmentCenter;
		infoLabel.backgroundColor = [UIColor clearColor];
		infoLabel.textColor = [UIColor whiteColor];
		infoLabel.font = [UIFont boldSystemFontOfSize:14.0];
		infoLabel.numberOfLines = 2;
		infoLabel.shadowColor = [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0];
		infoLabel.shadowOffset = CGSizeMake(0, 1);
		[self addSubview:infoLabel];
		
		arrowImage = [[CALayer alloc] init];
		arrowImage.frame = CGRectMake(60.0f, frame.size.height - 45.0f, 19.0f, 32.0f);
		arrowImage.contentsGravity = kCAGravityResizeAspect;
		arrowImage.contents = (id)[UIImage imageNamed:@"blackArrow.png"].CGImage;
		[[self layer] addSublayer:arrowImage];
		//[arrowImage release];
		
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityView.frame = CGRectMake(45.0f, frame.size.height - 44.0f, 20.0f, 20.0f);
		activityView.hidesWhenStopped = YES;
		[self addSubview:activityView];
		//[activityView release];
		
		background.frame = CGRectMake(0,self.bounds.size.height - 20,320,20);
		
		[self setState:DragDownInfoViewStateNormal];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawPath(context,  kCGPathFillStroke);
	[BORDER_COLOR setStroke];
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0.0f, self.bounds.size.height - 1);
	CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - 1);
	CGContextStrokePath(context);
}
*/

- (void) layoutSubviews
{
	[super layoutSubviews];

}

-(void) updateStateText
{
	NSString *text = @"";
	switch (_state)
    {
		case DragDownInfoViewStateNormal:
			text = @"下拉可以刷新";
			break;
		case DragDownInfoViewStateRefresh:
			text = @"松开即可刷新";
			break;
		case DragDownInfoViewStateRefreshing:
			text = @"正在刷新中,请稍候";
			break;
	}
	if (lastUpdateDate!=nil)
    {
		text = [NSString stringWithFormat:@"%@\n最后更新于 %@",text, [lastUpdateDate timeIntervalStringSinceNow]];
	}
	
	infoLabel.text = text;
}

- (void) setLastUpdateDate:(NSDate *) date
{
	if (lastUpdateDate != date)
	{
		[lastUpdateDate release];
	}	
	lastUpdateDate = [date retain];
	[self layoutSubviews];
}

- (void)dealloc {
	[infoLabel release];
	[background release];
	[arrowImage release];
	[activityView release];
	[lastUpdateDate release];
    [super dealloc];
}

- (void) setState:(DragDownInfoViewState) state
{
	if (state == DragDownInfoViewStateNormal)
	{
		//self.backgroundColor = [UIColor redColor];
//		infoLabel.text = @"正常";
		if (_state == DragDownInfoViewStateRefresh)
        {
			[CATransaction begin];
			[CATransaction setAnimationDuration:.18];
			arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
		}
		
		[activityView stopAnimating];
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
		arrowImage.hidden = NO;
		arrowImage.transform = CATransform3DIdentity;
		[CATransaction commit];
	}
	else if (state == DragDownInfoViewStateRefresh)
	{
		//self.backgroundColor = [UIColor greenColor];
//		infoLabel.text = @"刷新";

		[CATransaction begin];
		[CATransaction setAnimationDuration:.18];
		arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
		[CATransaction commit];
	}
	else if (state == DragDownInfoViewStateRefreshing)
	{
		//self.backgroundColor = [UIColor blueColor];
//		infoLabel.text = @"正在刷新";
		[activityView startAnimating];
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
		arrowImage.hidden = YES;
		[CATransaction commit];
	}
	_state = state;
	[self updateStateText];
}

- (DragDownInfoViewState) getState
{
	return _state;
}


@end
