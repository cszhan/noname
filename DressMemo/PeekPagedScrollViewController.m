//
//  PeekPagedScrollViewController.m
//  ScrollViews
//
//  Created by Matt Galloway on 01/03/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "PeekPagedScrollViewController.h"
//#import ""
@interface PeekPagedScrollViewController ()
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
@end

@implementation PeekPagedScrollViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

#pragma mark -
//static int currIndex;
- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++)
    {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
#if 1
    UIView *zoomView = nil;
    if(0<=page<[self.pageViews count])
    {
        zoomView = [self.pageViews objectAtIndex:page];
        [self viewZoom:zoomView scale:CGPointMake(1.25,1.25)];
    }
    if(page>=1)
    {
        zoomView = [self.pageViews objectAtIndex:page-1];
        [self viewZoom:zoomView scale:CGPointMake(0.8,0.8)];
    }
    if(page<[self.pageViews count]-1){
        zoomView = [self.pageViews objectAtIndex:page+1];
        [self viewZoom:zoomView scale:CGPointMake(0.8,0.8)];
    }
#endif
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) 
    {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    if(page <0 ||page >= self.pageViews.count)
    {
        return;
    }
    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    //CGFloat offset = 0;
    if ((NSNull*)pageView == [NSNull null]) 
    {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
         [self.scrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page 
{
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    if(page <0 ||page >= self.pageViews.count){
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) 
    {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}
-(void)setPageScrollerViewData:(NSArray*)imageData{
    self.pageImages = imageData;
}
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
#if 0
    self.title = @"Paged";
    // Set up the image we want to scroll & zoom and add it to the scroll view
    self.pageImages = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"defaultpic.png"],
                       [UIImage imageNamed:@"defaultpic.png"],
                       [UIImage imageNamed:@"defaultpic.png"],
                       //[UIImage imageNamed:@"photo4.png"],
                       //[UIImage imageNamed:@"photo5.png"],
                     nil];

#endif
    
    
    NSInteger pageCount = self.pageImages.count;
    // Set up the page control
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) 
    {
        [self.pageViews addObject:[NSNull null]];
    }
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    // Load the initial set of pages that are on screen
    [self loadVisiblePages];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.scrollView = nil;
    self.pageControl = nil;
    self.pageImages = nil;
    self.pageViews = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages which are now on screen
    [self loadVisiblePages];
}
-(void)viewZoom:(UIView*)currentView scale:(CGPoint)point
{
    [UIView animateWithDuration:0.5 
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^
     {
         currentView.transform=CGAffineTransformMakeScale(point.x,point.y);
     }
                     completion:^(BOOL finished)
     {
         //newPageView.transform=CGAffineTransformIdentity;
         
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
@end
