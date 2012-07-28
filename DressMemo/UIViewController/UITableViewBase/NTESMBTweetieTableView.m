//
//  TweetieTableView.m
//  TweetieTableView
//
//  Created by Xu Han Jie on 10-5-20.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBTweetieTableView.h"
//#import "UIParamsCfg.h"
#define     kDragDownHasSearchBar  100.f
#define     kDragDownNoSearchBar   60.f 
@interface NTESMBTweetieTableView (TweetieTableViewPrivate)

- (void) initInfoView;

@end


@implementation NTESMBTweetieTableView

@synthesize topInfoView;
@synthesize tweetieTableViewDelegate;
@synthesize isRefreshing;
@synthesize searchBar;
@synthesize hasDownDragEffect;
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		hasDragEffect = YES;
		hasDownDragEffect = YES;
		hasUpDragEffect = YES;
		[self initInfoView];
	}
    return self;
}

- (id)initWithFrame:(CGRect)frame hasDragEffect:(BOOL)has hasSearchBar:(BOOL) _hasSearchbar{
	if ((self = [super initWithFrame:frame])) {
        // Initialization code
		hasDragEffect = has;
		hasSearchbar = _hasSearchbar;
		hasDownDragEffect = YES;
		hasUpDragEffect = YES;
		[self initInfoView];
	}
    return self;
}
- (id)initWithFrame:(CGRect)frame hasDragEffect:(BOOL)has hasSearchBar:(BOOL) _hasSearchbar withStyle:(UITableViewStyle)_style{
	if ((self = [super initWithFrame:frame style:_style])) {
        // Initialization code
		hasDragEffect = has;
		hasSearchbar = _hasSearchbar;
		hasDownDragEffect = YES;
		hasUpDragEffect = YES;
		[self initInfoView];
	}
    return self;
}
- (void)awakeFromNib
{
	[self initInfoView];
}

- (void) initInfoView
{
	if (hasDragEffect) {
		if (hasSearchbar)
		{
			topInfoView = [[NTESMBDragDownInfoView alloc] initWithFrame:CGRectMake(0, -44 - self.bounds.size.height,kMBAppRealViewWidth , self.bounds.size.height)];
			[self addSubview:topInfoView];
			[self sendSubviewToBack:topInfoView];
			[topInfoView setState:DragDownInfoViewStateNormal];
			
			searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -44, kMBAppRealViewWidth, 44)];
			[self addSubview:searchBar];
			[self sendSubviewToBack:searchBar];
			
			bottomInfoView = [[NTESMBDragDownBottomInfoView alloc] initWithFrame:CGRectMake(0, 0, kMBAppRealViewWidth, 40)];
			[self addSubview:bottomInfoView];
			[self setContentInset:UIEdgeInsetsMake(44, 0, 0, 0)];
		}
		else
		{
			topInfoView = [[NTESMBDragDownInfoView alloc] initWithFrame:CGRectMake(0, 0 - self.bounds.size.height, kMBAppRealViewWidth, self.bounds.size.height)];
			[self addSubview:topInfoView];
			[self sendSubviewToBack:topInfoView];
			[topInfoView setState:DragDownInfoViewStateNormal];
			
			bottomInfoView = [[NTESMBDragDownBottomInfoView alloc] initWithFrame:CGRectMake(0, 0, kMBAppRealViewWidth, 40)];
			[self addSubview:bottomInfoView];
		}		

	}else {
		//top background
		UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - self.bounds.size.height, kMBAppRealViewWidth, self.bounds.size.height)];
		
		CGFloat midHeight = self.bounds.size.height - 4;
		
		UIImageView *midBackground = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refreshMid.png"]] autorelease];
		midBackground.frame = CGRectMake(0, 0, kMBAppRealViewWidth, midHeight);
		[backgroundView addSubview:midBackground];
		
		UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refreshBottom.png"]] autorelease];
		background.frame = CGRectMake(0, midHeight, kMBAppRealViewWidth, 4);
		[backgroundView addSubview:background];
		
		[self addSubview:backgroundView];
		[self sendSubviewToBack:backgroundView];
		[backgroundView release];
		
	}
	isRefreshing = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
	[super layoutSubviews];
	if (hasDragEffect) {
		if (self.contentSize.height >= self.bounds.size.height)
		{
			bottomInfoView.hidden = NO;
		}
		else
		{
			bottomInfoView.hidden = YES;
		}
		bottomInfoView.frame = CGRectMake(0, self.contentSize.height, kMBAppRealViewWidth, 40);
	}

}

- (void)dealloc {
	[topInfoView release];
	[bottomInfoView release];
	[searchBar release];
	
    [super dealloc];
}

- (CGFloat) getDragDownOffset
{
	CGFloat dragDownOffset = 0;
	if (hasSearchbar)
	{
		dragDownOffset = kDragDownHasSearchBar;//85.0;
	}
	else
	{
		dragDownOffset = kDragDownNoSearchBar;//65.0;
	}
	return dragDownOffset;
}

- (void) tableViewDidScroll
{
	
    if (hasDragEffect) 
    {
		CGFloat offset = self.contentOffset.y;
        [self tableViewDragDownRefresh:offset];
	}
    
    //[self tableViewDidEndDragging];
}
-(void)tableViewDragDownRefresh:(CGFloat)offset{
    if (offset>200) 
    {
        return;
    }
    if ( [topInfoView getState] != DragDownInfoViewStateRefreshing )
    {
        //用户拉下来所需要的距离			
        if (offset < -[self getDragDownOffset] )
        {
            [topInfoView setState:DragDownInfoViewStateRefresh];
        }
        else
        {
            [topInfoView setState:DragDownInfoViewStateNormal];
        }
    }

}

- (void) tableViewDidEndDragging
{
	if (hasDragEffect) 
    {
		
		if (isRefreshing == NO)
		{
			CGFloat offset = self.contentOffset.y;
			if ( [topInfoView getState] != DragDownInfoViewStateRefreshing )
            {
				if ( offset < -[self getDragDownOffset] && hasDownDragEffect )
				{
					isRefreshing = YES;
#if 0
					//for analysis
					[[NTESMASession sharedSession]tagEvent:@"refresh_drag_down"];
#endif				
					[topInfoView setState:DragDownInfoViewStateRefreshing];
					[UIView beginAnimations:nil context:NULL];
					[UIView setAnimationDuration:0.2];
					self.contentInset = UIEdgeInsetsMake([self getDragDownOffset] + 10, 0.0f, 0.0f, 0.0f);
					[UIView commitAnimations];
					[tweetieTableViewDelegate shouldLoadNewerData:self];
					return;
				}

				//NE_LOG(@"%lf",self.contentSize.height - self.bounds.size.height);
				if (offset > self.contentSize.height - self.bounds.size.height+60.f && hasUpDragEffect)
				{
					if (self.contentSize.height >= self.bounds.size.height && hasUpDragEffect)//up reflush
					{
						//isRefreshing = YES;
						
						//[self showBottomView];
						[tweetieTableViewDelegate shouldLoadOlderData:self];
					}
				}
			}
		}
	}
	
}
- (void) closeInfoViewWhenError{
	isRefreshing = NO;
	if (hasDragEffect) {
		[topInfoView setState:DragDownInfoViewStateNormal];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		if (hasSearchbar)
		{
			self.contentInset = UIEdgeInsetsMake(44.0f, 0.0f, 0.0f, 0.0f);
		}
		else
		{
			self.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
		}		
		[UIView commitAnimations];
	}
	
}

- (void) closeInfoView
{
	[self reloadData];
	isRefreshing = NO;
	if (hasDragEffect) {
		[topInfoView setState:DragDownInfoViewStateNormal];
		[topInfoView setLastUpdateDate:[NSDate date]];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		if (hasSearchbar)
		{
			self.contentInset = UIEdgeInsetsMake(44.0f, 0.0f, 0.0f, 0.0f);
		}
		else
		{
			self.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
		}		
		[UIView commitAnimations];
	}

}

- (void) showBottomView
{
	if (hasDragEffect) {
		[bottomInfoView startLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 40.0f, 0.0f);
		[UIView commitAnimations];
	}

}

- (void) closeBottomView
{
	[self reloadData];
	isRefreshing = NO;
	if (hasDragEffect) {
		[bottomInfoView stopLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void) closeBottomViewWhenError
{
	isRefreshing = NO;
	if (hasDragEffect) {
		[bottomInfoView stopLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}




@end
