    //
//  TweetieViewController.m
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-26.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBTweetieViewController.h"
//#import <QuartzCore/QuartzCore.h>
#import "NEDebugTool.h"
#undef NEWUI
//#import "UIParamsCfg.h"
//#import "NTESMBTimelineCell.h"
//#import "NTESMBUserSettingsCenter.h"

@interface NTESMBTweetieViewController (TimelinePrivate)

- (void) updateIconAfterDownload:(UIImage *) iconImage withIndexPath:(NSIndexPath *)indexPath;
#ifdef USEC_MODEL
-(NTESMBUserModel *)getUserModelFromIndexPath:(NSIndexPath *)indexPath;
#endif
@end


@implementation NTESMBTweetieViewController

@synthesize isRefreshing;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibNameOrNil])
    {
    
        allIconDownloaders = [[NSMutableDictionary alloc] init];
    }
    return self;
}
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
#ifdef NEWUI
	self.view.frame = CGRectMake(0.f, -kMBAppStatusBar, kMBAppRealViewWidth, kMBAppRealViewHeight-kMBAppUITabBarViewOffset);
//	self.view.layer.cornerRadius = 10.0;
//	self.view.layer.masksToBounds = YES;
//	tweetieTableView = [[TweetieTableView alloc] initWithFrame:self.view.bounds  hasDragEffect:!noDragEffect];
	/*
	NE_LOGRECT(self.view.bounds);
	UIView *parentView = [self.view superview];
	if(parentView){
		CGRect rect = parentView.bounds;
		NE_LOGRECT(rect);
	}
	*/
	//UIView *content  = [[UIView alloc] initWithFrame:CGRectMake(0.f,0.f, 320.f, 460.f)];
//	CGRect rect = self.view.frame;
	CGRect tweetieTableViewFrame = CGRectMake(0,-kMBAppStatusBar, kMBAppRealViewWidth,kMBAppRealViewHeight);
#else
	self.view.frame = CGRectMake(0.f, -kMBAppStatusBar, kMBAppRealViewWidth, 480);
	//	self.view.layer.cornerRadius = 10.0;
	//	self.view.layer.masksToBounds = YES;
	//	tweetieTableView = [[TweetieTableView alloc] initWithFrame:self.view.bounds  hasDragEffect:!noDragEffect];
	/*
	 NE_LOGRECT(self.view.bounds);
	 UIView *parentView = [self.view superview];
	 if(parentView){
	 CGRect rect = parentView.bounds;
	 NE_LOGRECT(rect);
	 }
	 */
	//UIView *content  = [[UIView alloc] initWithFrame:CGRectMake(0.f,0.f, 320.f, 460.f)];
	//	CGRect rect = self.view.frame;
	//NE_LOG(@"%lf",kMBAppRealViewHeight);
	CGRect tweetieTableViewFrame = CGRectMake(0,0.f, kMBAppRealViewWidth,kMBAppRealViewHeight);
	
#endif
	
	NE_LOG(@"FrameTableViewFrame:");
	NE_LOGRECT(self.view.frame);
	NE_LOGRECT(tweetieTableViewFrame);
	tweetieTableView = [[NTESMBTweetieTableView alloc] initWithFrame:tweetieTableViewFrame hasDragEffect:!noDragEffect hasSearchBar:hasSearchBar];
	//tweetieTableView = [[NTESMBTweetieTableView alloc] initWithFrame:self.view.bounds hasDragEffect:!noDragEffect hasSearchBar:hasSearchBar withStyle:UITableViewStyleGrouped];
	tweetieTableView.delegate = self;
	tweetieTableView.dataSource = self;
	tweetieTableView.autoresizingMask = YES;
	tweetieTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:tweetieTableView];
	
	//[self viewWillAppear:YES];

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
	return 0;
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
#pragma mark IconDownload
#ifdef USE_MODEL
- (void) startDownloadIcons:(NTESMBUserModel *) u indexPath:(NSIndexPath *) indexPath
{	
	if (u.userImageData == nil)
	{
		//userImageData为空也不一定需要下载图标，在inmemorytimeline中很大部分还是可以从
		//cache+db中获得
		if ([[NTESMBUserIconCache getInstance] hasCacheWithUserModel:u])
        {
			return;	
		}
#ifdef DEBUG
		NE_LOG(@"[start download icon]%@",[u screenName]);
#endif	
	}
	else 
    {
		/*
		 *check weather update at net
		 */
		if ([[NTESMBUserIconCache getInstance] getImageFromDBWithUserModel:u]) {
			return;	
		}
		NE_LOG(@"[Update icon from net]%@",[u screenName]);
	}
	NTESMBIconDownloader *downloader = [allIconDownloaders objectForKey:indexPath];
	if (downloader == nil && ![u.userImageURL isEqual: [NSNull null]] && [u.userImageURL length]>0)
	{
		downloader = [[NTESMBIconDownloader alloc] initWithUserModel:u indexPath:indexPath];
		[allIconDownloaders setObject:downloader forKey:indexPath];
		downloader.delegate = self;
		[[NTESMBServer getInstance] addRequest:downloader];
		[downloader release];
	}
}
-(void)startDownloadStatusImage:(NTESMBStatusModel *) status  indexPath:(NSIndexPath*)indexPath
{
	//if (status.imageData == nil)
	{		
		if ([[NTESMBUserIconCache getInstance] getImageWithStatusModel:status])
        {
			NE_LOG(@"status image hit file db!!");
			return;	
		}
		NESkipPhotoDownloader *downloader = [[NESkipPhotoDownloader alloc] initWithStatusModel:status indexPath:indexPath];
		downloader.delegate = self;
		[[NTESMBServer getInstance] addRequest:downloader];
		[downloader release];
		
	}
}
- (void) loadImagesForOnscreenRows
{
	//没有登录的时候是不下载图片的
	/*
	if (![NTESMBServer getInstance].logon) {
		return;
	}
	*/
	if([[NTESMBUserSettingsCenter getInstance] skimTimelineCellViewType] == Skim_Text)
    {
		return;
	}
	NSArray *indexPathArray = [tweetieTableView indexPathsForVisibleRows];
    
	for (NSIndexPath *indexPath in indexPathArray)
	{
		NTESMBStatusModel *statusModel = nil;
		NTESMBUserModel *userModel = nil ;
		if(statusModel = [self getStatusModelFromIndexPath:indexPath])
        {
			userModel = [statusModel user];
		}
		else {
			userModel = [self getUserModelFromIndexPath:indexPath];
		}

		if(userModel!=nil && ![userModel.userImageURL isEqual: [NSNull null]] && [userModel.userImageURL length]>0)
			[self startDownloadIcons:userModel indexPath:indexPath];
		if([[NTESMBUserSettingsCenter getInstance] skimTimelineCellViewType] == Skim_Default)
        {
			//NTESMBUserModel *userModel = [self getUserModelFromIndexPath:indexPath];
			if(statusModel!=nil && [statusModel.hasPhoto boolValue])
				[self startDownloadStatusImage:statusModel indexPath:indexPath];
		}
#ifdef TABLE_PERFORMQUICK
		UITableViewCell * _cell = [tweetieTableView cellForRowAtIndexPath:indexPath];
		if ([_cell isKindOfClass:[NTESMBTimelineCell class]] ) {
			NTESMBTimelineCell *cell = (NTESMBTimelineCell *)_cell;
			cell.needUpdateContent = YES;
			//cell.delegate = self;
			//cell.fromTableView = self;
			//新的status的背景图片
			//cell.isNew = tempIndexPath.row < numberOfNewStatuses;
			[cell setNeedsLayout];
			//cell.frame = CGRectMake(0.f, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
			//[tweetieTableView reloadData];
		}
#endif
		
	}
	
}

-(void)updatesegmentTitle:(NSInteger)icount
{
	
}
- (void) cancelAllIconDownloads
{
	//	NE_LOG(@"cancel all icon downloads");
	NSArray *allkeys = [allIconDownloaders allKeys];
	for (NTESMBIconDownloader *downlaoder in allkeys)
	{
		[[NTESMBServer getInstance] cancelRequest:downlaoder];
		[allIconDownloaders removeObjectForKey:downlaoder];
	}
	
}
#pragma mark -
#pragma mark RequestDelegate
- (void) requestCompleted:(NTESMBRequest *) request
{
	if([request isKindOfClass:[NESkipPhotoDownloader class]])
    {
		NESkipPhotoDownloader *d = (NESkipPhotoDownloader *)request;
		if(request.receiveData)
        {
			[[NTESMBLocalImageStorage getInstance] saveImageDataToTinyDir:request.receiveData urlString:request.urlString];
		}
		UIImage *image = [UIImage imageWithData:request.receiveData];
		NSIndexPath *indexPath = d.indexPath;
		id cell = nil;
		cell = [tweetieTableView cellForRowAtIndexPath:indexPath];
		if([cell respondsToSelector:@selector(skipPhotoBtn)])
			//image = [NTESMBUtility imageByCropping:image toRect:CGRectMake(0.f, 0.f, 70.f, 70.f)];
			[[cell skipPhotoBtn] setImage:image forState:UIControlStateNormal];
		return;
	}
	if ([request isKindOfClass:[NTESMBIconDownloader class]])
	{
		NTESMBIconDownloader *d = (NTESMBIconDownloader *)request;
		
		NTESMBUserModel *u = d.user;
		u.userImageData = d.receiveData;
		if (!doNotSaveUser) 
        {
			BOOL e = NO;
			User *dbUser = [[NTESMBDB getInstance] getOrInsertUserWithUserModel:u isExisted:&e];
			dbUser.userImageData = d.receiveData;
			dbUser.userImageURL = u.userImageURL;
		}
		//更新缓存
		UIImage *iconImage = [[NTESMBUserIconCache getInstance] updateCacheWithUserModel:u];
		NSIndexPath *indexPath = d.indexPath;
		id cell = nil;
		cell = [tweetieTableView cellForRowAtIndexPath:indexPath];
		if([cell respondsToSelector:@selector(photoButton)])
			[[cell photoButton] setImage:iconImage forState:UIControlStateNormal];
		//[self updateIconAfterDownload:iconImage withIndexPath:indexPath];
		[allIconDownloaders removeObjectForKey:d.indexPath];
	}
	//[self updatesegmentTitle:2];
}
- (void) requestFailed:(NTESMBRequest *) request
{
	NTESMBIconDownloader *d = (NTESMBIconDownloader *)request;
	[allIconDownloaders removeObjectForKey:d.indexPath];
}


- (void) updateIconAfterDownload:(UIImage *) iconImage withIndexPath:(NSIndexPath *)indexPath
{
	
	//[tweetieTableView reloadData];
	//subclass must impl this to show the image
}

-(NTESMBUserModel *)getUserModelFromIndexPath:(NSIndexPath *)indexPath
{
	return nil;
	//subclass must impl this to return user model for icon upate
}
-(id)getStatusModelFromIndexPath:(NSIndexPath *)indexPath{
	return nil;
}

#endif
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
-(void)scrollViewDidScrollToTop:(UIScrollView*)scrollView{
	//[self scrollViewDidScrollToTop:scrollView];
	NE_LOG(@"kkk");
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
	
}

#pragma mark setRightRetunHomeBtn
-(id)setRightRetunHomeBtn
{
	UIImage* homeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"homepage.png" ofType:@""]];
	UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithImage:homeImage
																	style:UIBarButtonItemStylePlain 
																   target:self 
																   action:@selector(backButtonPressed)]autorelease];
	[self.navigationItem setRightBarButtonItem:backButton];
	return backButton;
}
-(void)backButtonPressed{
	[self.navigationController popToRootViewControllerAnimated:YES];
}
@end
