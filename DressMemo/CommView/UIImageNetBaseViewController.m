//
//  UIDataNetBaseViewController.m
//  DressMemo
//
//  Created by  on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImageNetBaseViewController.h"
#import "ZCSNetClient.h"
@interface UIImageNetBaseViewController ()

@end

@implementation UIImageNetBaseViewController
@synthesize dataArray;
@synthesize isRefreshing;
@synthesize request;
@synthesize isVisitOther;
@synthesize userId;
@synthesize requestDict;
@synthesize data;
#ifdef LOADING_VIEW
@synthesize animationView;
#endif
@synthesize memoTimelineDataSource;
@synthesize myEmptyBgView;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
        allIconDownloaders = [[NSMutableDictionary alloc] init];
        self.dataArray =[NSMutableArray array];
        self.requestDict = [[NSMutableDictionary alloc]init];
        currentPageNum = 1;
    }
    return self;
}
- (void)dealloc 
{
	self.myEmptyBgView = nil;
    [tweetieTableView release];
	[allIconDownloaders release];
    self.requestDict = nil;
    self.dataArray = nil;
    self.data = nil;
	[super dealloc];
}                     
- (void)addObservers
{
#if 1
    [ZCSNotficationMgr addObserver:self call:@selector(didReloadRequest:) msgName:kZCSNetWorkReloadRequest];
    [ZCSNotficationMgr addObserver:self call:@selector(didNetWorkOK:) msgName:kZCSNetWorkOK];
    ///[ZCSNotficationMgr addObserver:self call:@selector(didNetWorkFailed:) msgName:kZCSNetWorkRespondFailed];
    [ZCSNotficationMgr addObserver:self call:@selector(didNetWorkRequestFailed:) msgName:kZCSNetWorkRequestFailed];
    [ZCSNotficationMgr addObserver:self call:@selector(didUserLogin:) msgName:kUserDidLoginOk];
#endif
}
- (void)setEmptyDataUI
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.autoresizingMask = YES;
    self.view.autoresizingMask = YES;
    //if(isVisitOther)
    {
         [self setHiddenRightBtn:YES];
    }
    if(!isVisitOther)
    {
        [self setEmptyDataUI];
    }
    CGRect tweetieTableViewFrame = CGRectMake(0,kMBAppTopToolBarHeight, kMBAppRealViewWidth,kMBAppRealViewHeight);
	NE_LOG(@"FrameTableViewFrame:");
	NE_LOGRECT(self.view.frame);
	NE_LOGRECT(tweetieTableViewFrame);
	tweetieTableView = [[NTESMBTweetieTableView alloc] initWithFrame:tweetieTableViewFrame hasDragEffect:!noDragEffect hasSearchBar:hasSearchBar];
	//tweetieTableView = [[NTESMBTweetieTableView alloc] initWithFrame:self.view.bounds hasDragEffect:!noDragEffect hasSearchBar:hasSearchBar withStyle:UITableViewStyleGrouped];
	tweetieTableView.delegate = self;
    tweetieTableView.tweetieTableViewDelegate = self;
    tweetieTableView.backgroundColor = [UIColor clearColor];
	tweetieTableView.dataSource = self;
	tweetieTableView.autoresizingMask = YES;
    //tweetieTableView.separatorStyle = UITableViewCellSeparatorStyle;
	tweetieTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //no downdrag effect
    tweetieTableView.hasDownDragEffect = NO;
    //memoTimelineDataSource = self;
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
#pragma mark -
#pragma mark - reflush load data action
- (void) shouldLoadNewerData:(NTESMBTweetieTableView *) tweetieTableView
{
    NSLog(@"loader new data");
    /*
    if(isRefreshing)
        return;
     */
    [memoTimelineDataSource getNewData];
}
- (void) shouldLoadOlderData:(NTESMBTweetieTableView *) tweetieTableView
{
    /*
    if(isRefreshing)
        return;
    */
    NSLog(@"loader old data");
    //[self ];
    [memoTimelineDataSource getOldData];
}
-(void) reloadAllData
{
    [tweetieTableView reloadData];
}
#pragma mark net work respond failed
/*
-(void)didNetDataOK:(NSNotification*)ntf
{
    //kNetEnd(self.view);
    isRefreshing = NO;
    NE_LOG(@"warning not implemetation net respond");
    //self.view.userInteractionEnabled = YES;
}
-(void)didNetDataFailed:(NSNotification*)ntf
{
    isRefreshing = NO;
    NE_LOG(@"warning not implemetation net respond");
}
*/
-(void)didNetWorkOK:(NSNotification*)ntf
{
    [self performSelectorOnMainThread:@selector(didNetDataOK:) withObject:ntf waitUntilDone:NO];
    
}
-(void)didNetWorkFailed:(NSNotification*)ntf
{
    [self performSelectorOnMainThread:@selector(didNetDataFailed:) withObject:ntf waitUntilDone:NO];
}
-(void)didNetWorkRequestFailed:(NSNotification*)ntf
{

    [self performSelectorOnMainThread:@selector(didRequestFailed:) withObject:ntf waitUntilDone:NO];

}
-(void)didReloadRequest:(NSNotification*)ntf
{
    @synchronized(self)
    {
        //we should renew the request 
        self.request = [ntf object];
    
    }
}
#ifdef LOADING_VIEW
-(void)startShowLoadingView
{
    //@synchronized(self)
    {
        isRefreshing = YES;
    }
    [self stopShowLoadingView];
    self.animationView =[UIBaseFactory forkNetLoadingImageAnimationView];
    [self.view addSubview:animationView];
    [animationView  startShowImageAnimation:0.5];

}
-(void)stopShowLoadingView
{
   // @synchronized(self)
    {
        isRefreshing = NO;
    }
    [self.animationView stopShowImageAnimation:0.5];
    self.animationView = nil;
}
#endif

#pragma mark -reflush 
-(void)didNetDataOK:(NSNotification*)ntf
{
    //kNetEnd(self.view);
    //NE_LOG(@"warning not implemetation net respond");
    //self.view.userInteractionEnabled = YES;
    
    id obj = [ntf object];
    id respRequest = [obj objectForKey:@"request"];
    id data = [obj objectForKey:@"data"];
    //NSString *resKey = [respRequest resourceKey];
    if(self.request == respRequest)
    {
        [self stopShowLoadingView];
        [self processReturnData:data];
        currentPageNum++;
        [self reloadAllData];
    }
    if([self.dataArray count]==0&&!isVisitOther)
    {
        self.myEmptyBgView.hidden = NO;
    }
    
}
/*{"memoid":"101","uid":"2","addtime":"1343109729","emotionid":"2","occasionid":"1","countryid":"1","location":"kkk","picid":"289","picpath":"\/memo\/2012\/07\/24\/20120724140209_6mSq_e955570c.jpg","isrecommend":"0"}
 */
-(void)processReturnData:(id)data
{
    NSArray *addData = nil;
    if([data isKindOfClass:[NSDictionary class]])
    {
        id result = [data objectForKey:@"results"];
        if([result isKindOfClass:[NSDictionary class]])
        {
            addData = [result allValues];
        }
        if([result  isKindOfClass:[NSArray class]])
        {
            addData = result;
        }
    }
    else if([data isKindOfClass:[NSArray class]])
    {
        addData = data;
    }
    [self.dataArray addObjectsFromArray:addData]; 
    
}
-(void)didNetDataFailed:(NSNotification*)ntf
{
    id obj = [ntf object];
    ZCSNetClient *respRequest = [obj objectForKey:@"sender"];
    
     id data = [obj objectForKey:@"data"];
    if([data isKindOfClass:[NSError class]])
    {
    
    }
    /*
     NSString *resKey = [respRequest resourceKey];
     */
    
    if(respRequest.followRequest == self.request||self.request == respRequest)
    {
        [self stopShowLoadingView];
    }
    //
    //NE_LOG(@"warning not implemetation net respond");
}
-(void)didRequestFailed:(NSNotification*)ntf
{
    [self stopShowLoadingView];
}
-(void)didUserLogin:(NSNotification*)ntf{

}
@end
