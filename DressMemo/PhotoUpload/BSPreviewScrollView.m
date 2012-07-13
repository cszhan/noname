//
//  BSPreviewScrollView.m
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "BSPreviewScrollView.h"
#import "StyledPageControl.h"
#define SHADOW_HEIGHT 20.0
#define SHADOW_INVERSE_HEIGHT 10.0
#define SHADOW_RATIO (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT)
@interface BSPreviewScrollView()
@property(nonatomic,assign)CGFloat xPagePending;
@property(nonatomic,retain)StyledPageControl *pageControl;
@property(nonatomic,assign)int lastLoadIndex;
@end
@implementation BSPreviewScrollView
@synthesize zoomOutSize;
@synthesize zoomInSize;
@synthesize scrollView, pageSize, dropShadow, delegate;
@synthesize bgView;
@synthesize xPagePending;
@synthesize pageControl;
@synthesize zoomScale;
@synthesize lastLoadIndex;

- (void)awakeFromNib
{
	firstLayout = YES;
	dropShadow = YES;
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		firstLayout = YES;
		dropShadow = YES;
        zoomScale = CGPointMake(1.f, 1.f);
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f,0.f,frame.size.width,frame.size.height)];
		scrollView.clipsToBounds = NO; // Important, this creates the "preview"
		scrollView.pagingEnabled = YES;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.delegate = self;
        pageControl = [[StyledPageControl alloc]initWithFrame:CGRectMake(0.f,self.frame.size.height-20.f,kDeviceScreenWidth, 40.f)];
        pageControl.center = CGPointMake(self.frame.size.width/2.f,pageControl.center.y);
        [pageControl setPageControlStyle:PageControlStyleDefault];
        [pageControl setCoreNormalColor:[UIColor whiteColor]];
        [pageControl setCoreSelectedColor:[UIColor redColor]];
        pageControl.hidden = YES;
        //[UIView addSubview:]
         /*
         [pageControl setGapWidth:5];
         // change diameter
         [pageControl setDiameter:9];
         StyledPageControl
         */
        [self addSubview:pageControl];
        
		[self addSubview:scrollView];
	}
	
	return self;
}

- (id)initWithFrameAndPageSize:(CGRect)frame pageSize:(CGSize)size 
{    
	if (self = [self initWithFrame:frame]) 
	{
		self.pageSize = size;
    }
    return self;
}
-(void)setPageViewPendingWidth:(CGFloat)pendingx
{
    xPagePending = pendingx;
}
-(void)setScrollerZoom:(BOOL)zoomTag
{
    isAnimationZoom = zoomTag;
}
-(void)setPageControlHidden:(BOOL)hidden
{
    pageControl.hidden = hidden;
}

-(void)setPageControlFrame:(CGRect)rect
{
    pageControl.frame = rect;
}
-(id)getPageControl
{
    return pageControl;
}
-(UIView*)getScrollerPage:(NSInteger)index{

 return [scrollViewPages objectAtIndex:index];
}
-(NSArray*)getScrollerPageViews{

    return scrollViewPages;
}
-(void)loadPage:(int)page
{
	// Sanity checks
    if (page < 0) return;
    if (page >= [scrollViewPages count]) return;
	
	// Check if the page is already loaded
	UIView *view = [scrollViewPages objectAtIndex:page];
	
	// if the view is null we request the view from our delegate
	if ((NSNull *)view == [NSNull null]) 
	{
		view = [delegate viewForItemAtIndex:self index:page];
		[scrollViewPages replaceObjectAtIndex:page withObject:view];
	}
	
	// add the controller's view to the scroll view	if it's not already added
	if (view.superview == nil) 
	{
		// Position the view in our scrollview
		CGRect viewFrame = view.frame;
		viewFrame.origin.x = viewFrame.size.width * page;
        //NE_LOGPOINT(view.)
		viewFrame.origin.y = 0;
		viewFrame = CGRectInset(viewFrame,xPagePending, 0.0f);
		view.frame = viewFrame;
		NE_LOGRECT(view.frame);
		[self.scrollView addSubview:view];
	}
}

// Shadow code from http://cocoawithlove.com/2009/08/adding-shadow-effects-to-uitableview.html
- (CAGradientLayer *)shadowAsInverse:(BOOL)inverse
{
    CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];
    CGRect newShadowFrame =	CGRectMake(0, 0, self.frame.size.width, inverse ? SHADOW_INVERSE_HEIGHT : SHADOW_HEIGHT);
    newShadow.frame = newShadowFrame;
    CGColorRef darkColor =[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:inverse ? (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT) * 0.5 : 0.5].CGColor;
    CGColorRef lightColor =	[self.backgroundColor colorWithAlphaComponent:0.0].CGColor;
    newShadow.colors = [NSArray arrayWithObjects: (id)(inverse ? lightColor : darkColor), (id)(inverse ? darkColor : lightColor), nil];
    return newShadow;
}

- (void)layoutSubviews
{
	// We need to do some setup once the view is visible. This will only be done once.
	if(firstLayout)
	{
		// Add drop shadow to add that 3d effect
		if(dropShadow && 0)
		{
			CAGradientLayer *topShadowLayer = [self shadowAsInverse:NO];
			CAGradientLayer *bottomShadowLayer = [self shadowAsInverse:YES];
			[self.layer insertSublayer:topShadowLayer atIndex:0];
			[self.layer insertSublayer:bottomShadowLayer atIndex:0];
			
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			
			// Position and stretch the shadow layers to fit
			CGRect topShadowLayerFrame = topShadowLayer.frame;
			topShadowLayerFrame.size.width = self.frame.size.width;
			topShadowLayerFrame.origin.y = 0;
			topShadowLayer.frame = topShadowLayerFrame;
			
			CGRect bottomShadowLayerFrame = bottomShadowLayer.frame;
			bottomShadowLayerFrame.size.width = self.frame.size.width;
			bottomShadowLayerFrame.origin.y = self.frame.size.height - bottomShadowLayer.frame.size.height;
			bottomShadowLayer.frame = bottomShadowLayerFrame;
			
			[CATransaction commit];
		}
        
         // Position and size the scrollview. It will be centered in the view.
         CGRect scrollViewRect = CGRectMake(0, 0, pageSize.width, pageSize.height);
         NE_LOGRECT(self.frame);
         scrollViewRect.origin.x = ((self.frame.size.width - pageSize.width) / 2);
         scrollViewRect.origin.y = ((self.frame.size.height - pageSize.height) / 2);
          
		//scrollView
		
		int pageCount = [delegate itemCount:self];
        self.pageControl.numberOfPages= pageCount;
		scrollViewPages = [[NSMutableArray alloc] initWithCapacity:pageCount];
		
		// Fill our pages collection with empty placeholders
		for(int i = 0; i < pageCount; i++)
		{
			[scrollViewPages addObject:[NSNull null]];
		}
		
		// Calculate the size of all combined views that we are scrolling through 
		self.scrollView.contentSize = CGSizeMake([delegate itemCount:self] * self.scrollView.frame.size.width, scrollView.frame.size.height);
		lastContentOffset = self.scrollView.contentOffset.x;
		// Load the first two pages
		[self loadPage:0];
        //UIview.layers.scale
		[self loadPage:1];
		[self loadPage:2];
#if 1
        if(isAnimationZoom)
        {
            
            //UIView *view = [scrollViewPages objectAtIndex:page];
             
            UIView *zoomView = nil;
            
            //if(0<=page<[scrollViewPages count])
            {
                NSLog(@"Zoom out 1 frame:%@",NSStringFromCGRect(zoomView.frame));
                zoomView = [scrollViewPages objectAtIndex:0];
                [self viewZoom:zoomView scale:CGPointMake(zoomScale.x,zoomScale.y)];
                NSLog(@"Zoom out 2 frame:%@",NSStringFromCGRect(zoomView.frame));
            }
        }
#endif
		firstLayout = NO;
	}
}
-(void)insertSubview:(UIView*)_bgView belowIndex:(NSInteger)num
{
#if 1
    for(int i = 0;i<[scrollViewPages count];i++)
    {
    
        UIView *item = [scrollViewPages objectAtIndex:i];
        if([item isKindOfClass:[NSNull class]])
        {
            continue;
        }
#if 1
        UIView *subView = [[item subviews]lastObject];
        if(i == num)
        {
            
            subView.hidden = YES;
        }
        else 
        {
            subView.hidden = NO;
        }
#else
        [self setAlphaForPage:item];
#endif
    
    }
    return;
#endif
    
    
#if 1
    if([_bgView superview])
    {
        [_bgView removeFromSuperview];
    }
    CGSize size = scrollView.frame.size;
    UIView *zoomView = [scrollViewPages objectAtIndex:num];  
    [scrollView insertSubview:_bgView belowSubview:zoomView];
    _bgView.center = CGPointMake(size.width/2.f+num*self.pageSize.width,size.height/2.f);
    int allCount = [scrollViewPages count];
    if(num+1<allCount)
    {
        UIView *belowView = [scrollViewPages objectAtIndex:num+1];
        [scrollView sendSubviewToBack:belowView];
    }
    if(num-1>=0)
    {
        UIView *belowView = [scrollViewPages objectAtIndex:num-1];
        [scrollView sendSubviewToBack:belowView];
        
    }
#else
     //UIView *parentView = [scrollView superview];
    UIView *selectView = [scrollViewPages objectAtIndex:num]; 
    [scrollView bringSubviewToFront:selectView];
     int allCount = [scrollViewPages count];
     if(num+1<allCount)
     {
         UIView *belowView = [scrollViewPages objectAtIndex:num+1];
         [scrollView sendSubviewToBack:belowView];
     }
     if(num-1>=0)
     {
         UIView *belowView = [scrollViewPages objectAtIndex:num-1];
         [scrollView sendSubviewToBack:belowView];
         
     }
     
#endif
    
  
}
- (void) setAlphaForPage : (UIView*) page
{
	CGFloat delta = scrollView.contentOffset.x - page.frame.origin.x;
	CGFloat step = scrollView.frame.size.width;
	CGFloat alpha = fabs(delta/step)*2./5.;
    //alpha = 1.f-alpha;
	if(alpha > 0.2) alpha = 0;
	if(alpha < 0.05) alpha = 1.;
	//CGFloat alpha = 1.0 - fabs(delta/step);
	//if(alpha > 0.) alpha = 1.0;
	//page.alpha = alpha;
	[self setOpacity:alpha forObstructionLayerOfPage:page];
}

- (void)setOpacity:(CGFloat)alpha forObstructionLayerOfPage:(UIView *)page
{
 
    [[page.layer.sublayers lastObject] setOpacity:alpha];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

	// If the point is not inside the scrollview, ie, in the preview areas we need to return
	// the scrollview here for interaction to work
   
    /*
	if (CGRectContainsPoint(self.scrollView.frame, point))
    {
		return self.scrollView;
	}
    */
	// If the point is inside the scrollview there's no reason to mess with the event.
	// This allows interaction to be handled by the active subview just like any scrollview
	return [super hitTest:point	withEvent:event];
}

-(int)currentPage
{
	// Calculate which page is visible 
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	return page;
}
- (void)setInsertBgView:(BOOL)tag{
    isNeedInsertBgView = tag;
}
/*
-(void)setZoomScale:(CGPoint)_zoomScale{
    self.zoomScale= _zoomScale;
}
*/
#pragma mark -
#pragma mark UIScrollViewDelegate methods
#define RIGHT  0
#define LEFT 1 
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate){
        return;
    }
    NSLog(@"tttt");

}
-(void)scrollViewDidScroll:(UIScrollView *)sv
{
	int scrollDirection;
    UIView *zoomView = [scrollViewPages objectAtIndex:0];
    NSLog(@"Zoom out 1 frame:%@",NSStringFromCGRect(zoomView.frame));
    
    
    NSLog(@"KKKK:%lf",scrollView.contentOffset.x);
    if (lastContentOffset > scrollView.contentOffset.x)
        scrollDirection = RIGHT;
    else if (lastContentOffset < scrollView.contentOffset.x) 
        scrollDirection = LEFT;
    
    lastContentOffset = scrollView.contentOffset.x;

    
    int page = [self currentPage];
    int max = [scrollViewPages count];
    // Update the page control
    if(page>=max||page<0)
    {
        return;
        
    }
    /*
    if(lastLoadIndex == page)
        return;
    */
    lastLoadIndex = page;
    self.pageControl.currentPage = page;
	// Load the visible and neighbouring pages 
	[self loadPage:page-1];
	[self loadPage:page];
   
	[self loadPage:page+1];
    
    
    if(isAnimationZoom)
    {
    //UIView *view = [scrollViewPages objectAtIndex:page];
        UIView *zoomView = nil;
         
        if(0<=page<max)
        {
            zoomView = [scrollViewPages objectAtIndex:page];
            //[self viewZoom:zoomView scale:CGPointMake(zoomScale.x,zoomScale.y) zoomOut:YES];
            [self viewZoom:zoomView scale:CGPointMake(zoomScale.x,zoomScale.y)];
             NSLog(@"Zoom out frame:%@",NSStringFromCGRect(zoomView.frame));
        }
        if(page>=1&&(scrollDirection == LEFT))
        {
            zoomView = [scrollViewPages objectAtIndex:page-1];
            NSLog(@"frame:%@",NSStringFromCGRect(zoomView.frame));
            //[self viewZoom:zoomView scale:CGPointMake(1.0/zoomScale.x,1.0/zoomScale.y) zoomOut:NO];
            [self viewZoom:zoomView scale:CGPointMake(1.0,1.0)];
             NSLog(@"Zoom Zin frame:%@",NSStringFromCGRect(zoomView.frame));
        }
        if(page<[scrollViewPages count]-1&&(scrollDirection==RIGHT))
        {
            zoomView = [scrollViewPages objectAtIndex:page+1];
            
           // [self viewZoom:zoomView scale:CGPointMake(1.0/zoomScale.x,1.0/zoomScale.y) zoomOut:NO];
            [self viewZoom:zoomView scale:CGPointMake(1.0,1.0)];
             NSLog(@"Zoom end frame:%@",NSStringFromCGRect(zoomView.frame));
        }
    }
    if(isNeedInsertBgView)
        [self insertSubview:self.bgView belowIndex:page];
}
-(void)scrollerRightTonextPageNum:(NSInteger)num
{
    CGPoint originOffset = scrollView.contentOffset;
    NE_LOGPOINT(originOffset);
    scrollView.contentOffset = CGPointMake(originOffset.x +self.pageSize.width*num,originOffset.y);
    NE_LOGPOINT(scrollView.contentOffset);
    [self scrollViewDidScroll:(UIScrollView*)self];
}
-(void)scrollerLeftTonextPageNum:(NSInteger)num
{
    CGPoint originOffset = scrollView.contentOffset;
    scrollView.contentOffset = CGPointMake(originOffset.x -self.pageSize.width*num,originOffset.y);
    [self scrollViewDidScroll:(UIScrollView*)self];
}
-(void)reloadScrollerPageViewNum:(NSInteger)index
{
    if(index<[scrollViewPages count])
    {
        int i = index;
        UIView *viewController = [scrollViewPages objectAtIndex:i];
        if((NSNull *)viewController != [NSNull null])
        {
                
#if 0     
            [UIView animateWithDuration:0.6 animations:
             ^{
                 viewController.frame = CGRectOffset(viewController.frame,0.f,100.f); 
             }];
#endif
            [viewController removeFromSuperview];
            
            [scrollViewPages replaceObjectAtIndex:i withObject:[NSNull null]];
        }
    }
    [self loadPage:index];
}
-(void)reloadScrollerPageViewAnimation:(NSInteger)index
{
    int totalCount = [scrollViewPages count];
    int removeIndex = index;
    if(index< totalCount)
    {
        int i = index;
        UIView *viewController = [scrollViewPages objectAtIndex:i];
        if((NSNull *)viewController != [NSNull null])
        {
            
#if 0   
            [UIView animateWithDuration:0.2 animations:
             ^{
                 viewController.frame = CGRectOffset(viewController.frame,0.f,100.f); 
             }];
#endif
            [viewController removeFromSuperview];
           
           //[scrollViewPages replaceObjectAtIndex:i withObject:[NSNull null]];
        }
    }
    index++;
    //next page animation left 
    if(index< totalCount)
    {
        UIView *viewController = [scrollViewPages objectAtIndex:index];
        [UIView animateWithDuration:0.5 animations:
         ^{
             viewController.frame = CGRectOffset(viewController.frame,-self.pageSize.width,0.f); 
         }
                            completion:^(BOOL finished)
        {
        
            
         
        }];
        
        index++;
        //then left move the rest
        while (index<[scrollViewPages count])
        {
            UIView *viewController = [scrollViewPages objectAtIndex:index];
            if((NSNull*)viewController != [NSNull null])
            {
                viewController.frame = CGRectOffset(viewController.frame,-self.pageSize.width,0.f);
               
            }
             index++;
        }
        /*
         self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width-self.pageSize.width, self.scrollView.contentSize.height);
         */
        //at last remove the data
        [scrollViewPages removeObjectAtIndex:removeIndex];
        [scrollViewPages addObject:[NSNull null]];
        [self loadPage:index-1];
        if(isNeedInsertBgView)
            [self insertSubview:nil belowIndex:0];
        
        //[scrollViewPages replaceObjectAtIndex:i withObject:[NSNull null]];
    }
    else 
    {
        [scrollViewPages replaceObjectAtIndex:index-1 withObject:[NSNull null]];
        [self loadPage:index-1];
    }
   
}
-(void)didEndAnimation:(NSInteger)index
{


    
}
#pragma mark -
#pragma mark Memory management

// didReceiveMemoryWarning is not called automatically for views, 
// make sure you call it from your view controller
- (void)didReceiveMemoryWarning 
{
	// Calculate the current page in scroll view
    int currentPage = [self currentPage];
	
	// unload the pages which are no longer visible
	for (int i = 0; i < [scrollViewPages count]; i++) 
	{
		UIView *viewController = [scrollViewPages objectAtIndex:i];
        if((NSNull *)viewController != [NSNull null])
		{
			if(i < currentPage-1 || i > currentPage+1)
			{
				[viewController removeFromSuperview];
				[scrollViewPages replaceObjectAtIndex:i withObject:[NSNull null]];
			}
		}
	}
	
}
-(void)viewZoom:(UIView*)currentView scale:(CGPoint)point
{
   
    [UIView animateWithDuration:0.5 
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^
     {
         CGAffineTransform newTransform;
         newTransform =CGAffineTransformMakeScale(point.x,point.y);
         currentView.transform= newTransform;
     }
                     completion:^(BOOL finished)
     {
         //newPageView.transform=CGAffineTransformIdentity;
         //currentView.frame = CGRectMake(origin.x,origin,y,
             //currentView.frame = CGRectMake(origin.x, origin.y, currentView.frame.size.width, currentView.frame.size.height);
      
     }];

    
}
-(void)viewZoom:(UIView*)currentView scale:(CGPoint)point zoomOut:(BOOL)zoomOut{
    [UIView animateWithDuration:0.5 
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^
     {
         currentView.transform = CGAffineTransformMakeScale(point.x,point.y);
     }
                     completion:^(BOOL finished)
     {
         //newPageView.transform=CGAffineTransformIdentity;
         if(zoomOut)
         {  
             CGPoint origin = currentView.frame.origin;
             currentView.frame = CGRectMake(origin.x, origin.y,zoomOutSize.width,zoomOutSize.height);
         
         }
         else 
         {
             CGPoint origin = currentView.frame.origin;
             currentView.frame = CGRectMake(origin.x, origin.y,zoomInSize.width,zoomInSize.height);
         }
         
     }];

}
-(void)viewZoomOut:(UIView*)currentView{
    
    [UIView animateWithDuration:0.5 
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^
     {
         currentView.transform=CGAffineTransformMakeScale(0.5,0.5);
     }
                     completion:^(BOOL finished)
     {
         //newPageView.transform=CGAffineTransformIdentity;
         
     }];
}
- (void)dealloc 
{
	[scrollViewPages release];
	[scrollView release];
    [super dealloc];
}

@end
