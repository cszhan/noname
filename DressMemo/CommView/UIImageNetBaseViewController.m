//
//  UIDataNetBaseViewController.m
//  DressMemo
//
//  Created by  on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImageNetBaseViewController.h"

@interface UIImageNetBaseViewController ()

@end

@implementation UIImageNetBaseViewController
@synthesize isRefreshing;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
        allIconDownloaders = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)addObservers
{
#if 1
    [ZCSNotficationMgr addObserver:self call:@selector(didNetWorkOK:) msgName:kZCSNetWorkOK];
    [ZCSNotficationMgr addObserver:self call:@selector(didNetWorkFailed:) msgName:
     kZCSNetWorkRespondFailed];
    [ZCSNotficationMgr addObserver:self call:@selector(didNetWorkFailed:) msgName:kZCSNetWorkRequestFailed];
#endif
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect tweetieTableViewFrame = CGRectMake(0,kMBAppTopToolBarHeight, kMBAppRealViewWidth,kMBAppRealViewHeight);
	NE_LOG(@"FrameTableViewFrame:");
	NE_LOGRECT(self.view.frame);
	NE_LOGRECT(tweetieTableViewFrame);
	tweetieTableView = [[NTESMBTweetieTableView alloc] initWithFrame:tweetieTableViewFrame hasDragEffect:!noDragEffect hasSearchBar:hasSearchBar];
	//tweetieTableView = [[NTESMBTweetieTableView alloc] initWithFrame:self.view.bounds hasDragEffect:!noDragEffect hasSearchBar:hasSearchBar withStyle:UITableViewStyleGrouped];
	tweetieTableView.delegate = self;
    tweetieTableView.backgroundColor = [UIColor clearColor];
	tweetieTableView.dataSource = self;
	tweetieTableView.autoresizingMask = YES;
    //tweetieTableView.separatorStyle = UITableViewCellSeparatorStyle;
	tweetieTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //tweetieTableView.contentSize
    [self.view addSubview:tweetieTableView];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];

	//self.view.frame = CGRectMake(0.f, -kMBAppStatusBar, kMBAppRealViewWidth, 480);
    
	
	//[self.view addSubview:tweetieTableView];
    
}
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}
- (void)dealloc 
{
	[tweetieTableView release];
	[allIconDownloaders release];
	[super dealloc];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    return cell;
}
#pragma mark -
#pragma mark ImageData Download
- (void) loadImagesForOnscreenRows
{

	NSArray *indexPathArray = [tweetieTableView indexPathsForVisibleRows];
    
	for (NSIndexPath *indexPath in indexPathArray)
	{
        [self startloadVisibleCellImageData:indexPath];
	}
	
}
-(void)startloadVisibleCellImageData:(NSIndexPath*)path
{
    NE_LOG(@"warning load visibleCellImagedata not implementation");
}
-(void)updatesegmentTitle:(NSInteger)icount
{
	
}
- (void) cancelAllIconDownloads
{
	//	NE_LOG(@"cancel all icon downloads");
	NSArray *allkeys = [allIconDownloaders allKeys];
	
}
#pragma mark -
#pragma mark UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[tweetieTableView tableViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	//[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	[tweetieTableView tableViewDidEndDragging];
	[self cancelAllIconDownloads];
	if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
		/*
         if([scrollView respondsToSelector:@selector(reloadData)]){
         [scrollView reloadData];
         }
         */
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}
-(void)scrollViewDidScrollToTop:(UIScrollView*)scrollView
{
	//[self scrollViewDidScrollToTop:scrollView];
	NE_LOG(@"kkk");
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	
}
#pragma mark net work respond failed

-(void)didNetDataOK:(NSNotification*)ntf
{
    //kNetEnd(self.view);
    NE_LOG(@"warning not implemetation net respond");
    //self.view.userInteractionEnabled = YES;
}
-(void)didNetDataFailed:(NSNotification*)ntf
{
    NE_LOG(@"warning not implemetation net respond");
}

-(void)didNetWorkOK:(NSNotification*)ntf
{
    [self performSelectorOnMainThread:@selector(didNetDataOK:) withObject:ntf waitUntilDone:NO];
    
}
-(void)didNetWorkFailed:(NSNotification*)ntf
{
    [self performSelectorOnMainThread:@selector(didNetDataFailed:) withObject:ntf waitUntilDone:NO];
}
@end
