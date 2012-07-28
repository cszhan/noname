//
//  DragDownBottomInfoView.m
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-21.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBDragDownBottomInfoView.h"


@implementation NTESMBDragDownBottomInfoView

@synthesize isRefreshing;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		isRefreshing = NO;
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityView.frame = CGRectMake(0, 0, 20, 20);
		activityView.hidesWhenStopped = YES;
		[self addSubview:activityView];
		[activityView startAnimating];
		activityView.center = self.center;		
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) startLoading
{
	[activityView startAnimating];
}

- (void) stopLoading
{
	[activityView stopAnimating];
}

- (void)dealloc {
	[activityView release];
    [super dealloc];
}


@end
