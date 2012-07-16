//
//  BSPreviewScrollView.h
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "StyledPageControl.h"

@class BSPreviewScrollView;

@protocol BSPreviewScrollViewDelegate
@required
-(UIView*)viewForItemAtIndex:(BSPreviewScrollView*)scrollView index:(int)index;
-(int)itemCount:(BSPreviewScrollView*)scrollView;
-(void)didScrollerView:(BSPreviewScrollView*)scrollView;
@end


@interface BSPreviewScrollView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;	
	id<BSPreviewScrollViewDelegate, NSObject> delegate;
	NSMutableArray *scrollViewPages;
	BOOL firstLayout;
	CGSize pageSize;
	BOOL dropShadow;
    BOOL isAnimationZoom;
    BOOL isNeedInsertBgView;
    StyledPageControl *pageControl;
    CGFloat lastContentOffset;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) id<BSPreviewScrollViewDelegate, NSObject> delegate;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) BOOL dropShadow;
@property (nonatomic, assign) BOOL useMask;
@property (nonatomic, retain) UIImageView *bgView;
@property (nonatomic, assign) CGPoint zoomScale;
//three custom property set
@property (nonatomic,assign) CGSize zoomOutSize;
@property (nonatomic,assign) CGSize zoomInSize;

-(void)setPageViewPendingWidth:(CGFloat)pendingx;
-(void)setScrollerZoom:(BOOL)zoomTag;
//-(void)setZoomScale:(CGPoint)zoomScale;
- (void)setInsertBgView:(BOOL)tag;
//user mask image
- (void)setMaskImage:(UIImage*)maskImage;

//set the Page 
-(void)setPageControlHidden:(BOOL)hidden;
-(void)setPageControlFrame:(CGRect)rect;
-(id)getPageControl;
-(NSArray*)getScrollerPageViews;

- (void)didReceiveMemoryWarning;
-(void)insertSubview:(UIView*)bgView belowIndex:(NSInteger)num;
- (id)initWithFrameAndPageSize:(CGRect)frame pageSize:(CGSize)size;
-(void)scrollerRightTonextPageNum:(NSInteger)num;
-(void)scrollerLeftTonextPageNum:(NSInteger)num;
-(void)reloadScrollerPageViewNum:(NSInteger)index;
-(UIView*)getScrollerPage:(NSInteger)index;
@end
