//
//  NTESMBTimelineViewController.m
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-26.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBTimelineViewController.h"
#import "NTESMBTimelineCell.h"
#import "NTESMBStatusModel.h"
#import "NTESMBUserModel.h"
#import "NTESMBIconDownloader.h"
#import "NTESMBDB.h"
#import "NSData+Ex.h"
#import "NTESMBStatusDetailViewController.h"
#import "NTESMBPostViewController.h"
#import "NTESMBUserIconCache.h"
#import "NTESMBUserInfoViewController.h"
#import "NSString+Ex.h"
#import "NTESMBWebBrowser.h"
#import "NTESMBWebPhotoViewer.h"
#import "NTESMBUserTabBarFactory.h"
#import "NTESMBHomePageTimelineViewController.h"
#import "UIParamsCfg.h"
#import "NTESMBPostViewController.h"
#import "NTESMBMainMenuController.h"
@class NETopNavMainMenuController;

@implementation NTESMBTimelineViewController

@synthesize actionIndexPath;
@synthesize timelineDataSource;
@synthesize currentUser;
@synthesize detailIndexPath;
@synthesize currentStatusAttachmentImageUrl;
@synthesize currentStatusAttachmentCommonUrl;
@synthesize numberOfNewStatuses;
@synthesize maxID;
@synthesize sinceID;
@synthesize dataArray;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/
-(void)loadView{
	[super loadView];
}
#pragma mark scrollToTop
-(void)scrollToTop{
	NSArray *visibleCellArr = [tweetieTableView indexPathsForVisibleRows];
	for (NSIndexPath *item in visibleCellArr) {
		if (item.row == 1 ) {
			scrollTopReflush = NO;
			[self doReflushAction];
			//break;
			return ;
		}
	}
	if([dataArray count] == 0)
		return;
	[tweetieTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	scrollTopReflush = YES;
	//	[self goRefresh];
	//tweetieTableView.contentOffset = CGPointMake(0,-44.f);
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
	if(!isRefreshing&&scrollTopReflush){
		[self doReflushAction];
		scrollTopReflush = NO;
	}	
}
-(void)scrollToTopNoReflush{
	if([dataArray count] == 0)
		return;
	[tweetieTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	
	//	[self goRefresh];
	//tweetieTableView.contentOffset = CGPointMake(0,-44.f);
}
#pragma mark -
#pragma mark View lifecycle

- (void) setRightButton:(UIBarButtonItem *)button{
	[self.navigationItem setRightBarButtonItem:button];
	//[self.tabBarController.navigationItem setRightBarButtonItem:button];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	isDownReflush = YES;
	tweetieTableView.tweetieTableViewDelegate = self;
	tweetieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	isShowActionCell = NO;
	actionCell = [[NTESMBTimelineActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"actionCell"];
	refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(goRefresh)];
	[self setRightButton:refreshButton];
	UIActivityIndicatorView *refreshing = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[refreshing startAnimating];
	refreshingButton = [[UIBarButtonItem alloc] initWithCustomView:refreshing];
	[refreshing release];
	//[self.navigationItem setRightBarButtonItem:refreshButton];
	//	dataArray = [[NSMutableArray alloc] init];
	//CGPoint startPoint ;
//	startPoint.x = self.view.frame.origin.x;
//	startPoint.y = self.view.frame.origin.y-k
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotMessageError:) name:HTTP_REQUEST_ERROR object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goRefresh) name:DEVICE_SHAKEN object:nil];
	updateBlockView = [[NTESMBUpdateBlockView alloc] initWithFrame:CGRectMake(0, -kMBAppDownAlertViewHeight+kMBAppUITabBarViewOffset, self.view.frame.size.width, kMBAppDownAlertViewHeight)];
	[self.view addSubview:updateBlockView];
	soundEffect = [[NTESMBSoundEffect alloc] init];
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)doReflushAction{
	[self setRightButton:refreshingButton];
	if(isDownReflush){
		CGPoint point = CGPointMake(0, -101);
		tweetieTableView.contentOffset = point;
		[tweetieTableView tableViewDidEndDragging];
	}
	else {
		[timelineDataSource getNewData];
	}
}							
- (void) goRefresh
{
	[self doReflushAction];
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	//初始设置偏移量

	if (tweetieTableView.contentOffset.y<0) {
		tweetieTableView.contentOffset = CGPointMake(0, 0);
	}
	[tweetieTableView reloadData];
	//[tweetieTableView reloadRowsAtIndexPaths:[tweetieTableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
	
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotMessage:) name:HTTP_REQUEST_COMPLETE object:nil];
	
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goRefresh) name:DEVICE_SHAKEN object:nil];
	
	//[[NSNotificationCenter defaultCenter] addObserver:tweetieTableView selector:@selector(reloadData) name:UI_SHOULD_REFRESH_FOR_FAIL object:nil];
	
}




- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//[tweetieTableView reloadData];
	disappearLock = NO;
	//不要在基础类里面调用刷新，因为各个子界面已经写了刷新逻辑
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[self closeToolBarIfNeeded];
//	//记录偏移量，便于下次观看
//	tablePosition = tweetieTableView.contentOffset.y;
	
	//这个只有在in memory的timeline上是停止监听的
	//[[NSNotificationCenter defaultCenter] removeObserver:self name:HTTP_REQUEST_COMPLETE object:nil];
	/*
	[[NSNotificationCenter defaultCenter] removeObserver:self name:HTTP_REQUEST_ERROR object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:DEVICE_SHAKEN object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:tweetieTableView name:UI_SHOULD_REFRESH_FOR_FAIL object:nil];
*/
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//	NSUInteger count = [dataArray count];
	NSUInteger count = [timelineDataSource numberOfStatusInSection:section];
	if (isShowActionCell == YES)
	{
		count++;
	}
    return count;
}


- (UITableViewCell *) getCell: (UITableView *) tableView indexPath:(NSIndexPath *)indexPath  {
	static NSString *CellIdentifier = @"TimelineCell";
	NTESMBTimelineCell *cell = (NTESMBTimelineCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[NTESMBTimelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	return cell;
}
-(void)getUserIconImage:(NTESMBStatusModel *)statusModel withCell:(NTESMBTimelineCell*)cell withIndexPath:(NSIndexPath*)tempIndexPath{
	cell.statusModel = statusModel;
	NTESMBUserModel *userModel = statusModel.user;
	UIImage *userIcon = [[NTESMBUserIconCache getInstance] getImageWithUserModel:userModel];
	if (userIcon != nil)
	{
		[cell.photoButton setImage:userIcon forState:UIControlStateNormal];
		[cell.photoButton setNeedsDisplay];
	}
	else
	{
		if (tweetieTableView.dragging == NO && tweetieTableView.decelerating == NO)
		{
			
			int type = [[NTESMBUserSettingsCenter getInstance] skimTimelineCellViewType];
			if(type!= 2)
			[self startDownloadIcons:userModel indexPath:tempIndexPath];
		}
		// if a download is deferred or in progress, return a placeholder image               
		[cell.photoButton setImage:[NTESMBUserIconCache getPlaceHolderImage] forState:UIControlStateNormal];
	}
	
	//判断是否要带三角
	//if (isShowActionCell && actionIndexPath.row==indexPath.row+1) {
//		cell.isShowBottomTriangle = YES;
//	}else {
//		cell.isShowBottomTriangle = NO;
//	}	
}
-(void)getTimelineSkipPhoto:(NTESMBStatusModel *)statusModel withCell:(NTESMBTimelineCell*)cell withIndexPath:(NSIndexPath*)tempIndexPath{
	if(![statusModel.hasPhoto boolValue]||[[NTESMBUserSettingsCenter getInstance]skimTimelineCellViewType] != Skim_Default)//defaul is photo
		return;
	UIImage *skipPhoto = [[NTESMBUserIconCache getInstance] getImageWithStatusModel:statusModel];
	if (skipPhoto != nil)
	{
		[cell.skipPhotoBtn setImage:skipPhoto forState:UIControlStateNormal];
	}
	else
	{
		if (tweetieTableView.dragging == NO && tweetieTableView.decelerating == NO)
		{
			[self startDownloadStatusImage:statusModel indexPath:tempIndexPath];
		}
		// if a download is deferred or in progress, return a placeholder image               
		[cell.skipPhotoBtn setImage:[NTESMBUserIconCache getStatusImageDefault] forState:UIControlStateNormal];
	}

}
/*
-(void)getPhoto:(NTESMBStatusModel*)statusModel{
	NSString *imageURLString = [statusModel getNeteaseThumbImageUrl];
	//NSString *imageFilePath = [self imageFilePath:imageURLString];
	NSString *rootImageURLString = [statusModel getRootThumbImageUrl];
	//NSString *rootImageFilePath = [self imageFilePath:rootImageURLString];
	
	NSFileManager *fileManeger = [NSFileManager defaultManager];
	NSString *imageFilePath = nil;
	if (imageURLString)
	{
		imageFilePath = [[NTESMBLocalImageStorage getInstance] smallFilePathWithUrlString:imageURLString];
		if ([fileManeger fileExistsAtPath:imageFilePath] == NO)
		{
#ifdef DEBUG
			NE_LOG(@"load remote image");
#endif
			//下载图片
			self.imageDownloader = [[[NTESMBRequest alloc] initWithUrlString:imageURLString]autorelease];
			
			//[[NTESMBServer getInstance] performSelector:@selector(addRequest:) withObject:imageDownloader afterDelay:0.4];
			imageFilePath = @"";//空字符串表示等待下载
		}
	}
	NSString *rootImageFilePath = nil;
	if (rootImageURLString) 
	{
		rootImageFilePath = [[NTESMBLocalImageStorage getInstance] smallFilePathWithUrlString:rootImageURLString];
		if ([fileManeger fileExistsAtPath:rootImageFilePath] == NO)
		{
			
#ifdef DEBUG
			NE_LOG(@"load remote image");
#endif
			//下载图片
			self.rootImageDownloader = [[NTESMBRequest alloc] initWithUrlString:rootImageURLString];
			
			//[[NTESMBServer getInstance] performSelector:@selector(addRequest:) withObject:rootImageDownloader afterDelay:0.5];
			rootImageFilePath = @"";//空字符串表示等待下载
		}
	}

}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	NE_LOG(@"headerforsection");
	return 0.f;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	
	if (isShowActionCell == YES && indexPath.row == actionIndexPath.row)
	{
		NTESMBStatusModel *statusModel = [timelineDataSource statusModelAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
		actionCell.statusModel = statusModel;
		actionCell.delegate = self;
		return actionCell;
	}
	NSIndexPath *tempIndexPath = nil;
	if (isShowActionCell == YES && indexPath.row > actionIndexPath.row)
	{
		tempIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
	}
	else
	{
		tempIndexPath = indexPath;
	}
	
	UITableViewCell *_cell = [self getCell: tableView indexPath:tempIndexPath];
	
	
	if ([_cell isKindOfClass:[NTESMBTimelineCell class]] ) {
		NTESMBTimelineCell *cell = (NTESMBTimelineCell *)_cell;
		NTESMBStatusModel *statusModel = [timelineDataSource statusModelAtIndexPath:tempIndexPath];
		[self getUserIconImage:statusModel withCell:cell withIndexPath:tempIndexPath];
		[self getTimelineSkipPhoto:statusModel withCell:cell withIndexPath:tempIndexPath];
#ifdef TABLE_PERFORMQUICK
		if(tableView.decelerating){
			NE_LOG(@"decelerating");
			cell.needUpdateContent = NO;
		}
		else {
			if(tableView.dragging){
			NE_LOG(@"dragging");
			}
			cell.needUpdateContent = YES;
		}
#else
		cell.needUpdateContent = YES;
#endif
		cell.delegate = self;
		cell.fromTableView = tweetieTableView;
		//新的status的背景图片
		cell.isNew = tempIndexPath.row < numberOfNewStatuses;
		cell.isShowBottomTriangle = NO;
		//[self getTimelineSkipPhoto:statusModel withCell:cell withIndexPath:tempIndexPath];
	}	
	return _cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//BOOL needTableMove = NO;
	
	[tweetieTableView deselectRowAtIndexPath:indexPath animated:NO];
	//点击默认cell不做动作
	if ([timelineDataSource numberOfStatusInSection:indexPath.section]==0) {
		return;
	}
	
	//点工具条不做动作
	if (isShowActionCell == YES && indexPath.row == actionIndexPath.row)
	{
		return;
	}
	
	//点击工具条对应的推会收起工具条 - 暂时屏蔽，点击就进入单条
	/*if (isShowActionCell == YES && indexPath.row==actionIndexPath.row -1) {
		[self willShowToolBarAtIndexPath:indexPath];
		return;
	}*/
	
	[self willEnterStatusAtIndexPath:indexPath];
	
}

- (void) willShowToolBarAtIndexPath:(NSIndexPath *)indexPath{
	BOOL t = isShowActionCell;
	//当前点击的cell
	[self switchActionCellStateAtIndexPath:indexPath];
	//当原来又一个已经展开的cell 并且 原来展开的cell不是工具条的上面一个
	//if ( indexPath.row != actionIndexPath.row && indexPath.row != actionIndexPath.row - 1 )
	
	if(t&&indexPath.row!=actionIndexPath.row -1)
	{
		if (indexPath.row < actionIndexPath.row - 1)
		{
			[self performSelector:@selector(switchActionCellStateAtIndexPath:) withObject:indexPath afterDelay:0.8];
		}
		else
		{
			NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
			[self performSelector:@selector(switchActionCellStateAtIndexPath:) withObject:tempIndexPath afterDelay:0.8];
			//[self switchActionCellStateAtIndexPath:tempIndexPath];
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{ 	//static int i =0;
//	NE_LOG(@"cellForRowAtIndexPath %d",i++);
	if (isShowActionCell == YES && indexPath.row == actionIndexPath.row)
	{
		return 60.0;
	}
	NSIndexPath *tempIndexPath = nil;
	if (isShowActionCell == YES && indexPath.row > actionIndexPath.row)
	{
		tempIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
	}
	else
	{
		tempIndexPath = indexPath;
	}
	NTESMBStatusModel *statusModel = [timelineDataSource statusModelAtIndexPath:tempIndexPath];
	return [statusModel cellHeight];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	[detailIndexPath release];
	[actionIndexPath release];
	[actionCell release];
	[dataArray release];
	[timelineDataSource release];
	[currentUser release];
	[currentStatusAttachmentImageUrl release];
	[currentStatusAttachmentCommonUrl release];
	[soundEffect release];
	[refreshButton release];
	[refreshingButton release];
	
	[updateBlockView release];
	
	[maxID release];
	[sinceID release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark MarkNewStatus

- (void) changeNumberOfNewStatus:(NSNotification *) notification
{
	NSArray *newStatuses = (NSArray *)[notification object];
	self.numberOfNewStatuses = [newStatuses count];
	if (numberOfNewStatuses>0) {
		[self showNewTimelineNotify];
	}
	//[tweetieTableView reloadData];
	[self scrollToTopNoReflush];
	//self.detailIndexPath = [NSIndexPath indexPathForRow:detailIndexPath.row+newStatuses.count inSection:0];
}

	//提示新推条数
- (void) showNewTimelineNotify
{
	[UIView beginAnimations:@"ShowUpdateBlockAnimation" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	CGPoint oldCenter = CGPointMake(160,  (-kMBAppDownAlertViewHeight+kMBAppUITabBarViewOffset)/2.f);
	CGPoint newCenter = CGPointMake(oldCenter.x, oldCenter.y + 40);
	updateBlockView.center = newCenter;
	updateBlockView.newStatusCount = numberOfNewStatuses;
	[UIView commitAnimations];
	
	if ([[NTESMBUserSettingsCenter getInstance] soundNotice] == YES) {
		[soundEffect playSoundNamed:@"NewTweet" ofType:@"wav"];
	}
	
}

 - (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"ShowUpdateBlockAnimation"])
	{
		[self performSelector:@selector(hideUpdateBlockAnimation) withObject:nil afterDelay:0.5];
	}
}

- (void) hideUpdateBlockAnimation
{
	[UIView beginAnimations:@"HideUpdateBlockAnimation" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	CGPoint oldCenter = CGPointMake(160,  (-kMBAppDownAlertViewHeight+kMBAppUITabBarViewOffset)/2);
	CGPoint newCenter = CGPointMake(oldCenter.x, oldCenter.y - 40);
	updateBlockView.center = newCenter;
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark TweetieTableViewDelegate

- (void) shouldLoadNewerData:(NTESMBTweetieTableView *) _tweetieTableView
{
	//[self.navigationItem setRightBarButtonItem:refreshingButton];
	[self setRightButton:refreshingButton];
	[self cancelAllIconDownloads];
	[timelineDataSource getNewData];
}

- (void) shouldLoadOlderData:(NTESMBTweetieTableView *) _tweetieTableView
{
	//[self.navigationItem setRightBarButtonItem:refreshingButton];
	[self setRightButton:refreshingButton];
	[self cancelAllIconDownloads];
	[timelineDataSource getOldData];
}

#pragma mark -
#pragma mark private

- (void) closeToolBarIfNeeded{
	if (isShowActionCell) {
		[self switchActionCellStateAtIndexPath:[NSIndexPath indexPathForRow: self.actionIndexPath.row -1 inSection:0]];
	}
}

- (void) switchActionCellStateAtIndexPath:(NSIndexPath *) indexPath
{
	if (isShowActionCell == NO)
	{
		isShowActionCell = YES;
		self.actionIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];		
		[tweetieTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:actionIndexPath] withRowAnimation:UITableViewRowAnimationNone];
		NSIndexPath *tempPath = [NSIndexPath indexPathForRow:actionIndexPath.row - 1 inSection:actionIndexPath.section];
		NTESMBTimelineCell *cell = (NTESMBTimelineCell *)[tweetieTableView cellForRowAtIndexPath:tempPath];
		cell.isShowBottomTriangle = YES;
		cell.needUpdateContent = YES;
		[cell layoutSubviews];
//		[cell layoutBottomBackground];
		
		
		CGRect newRect = [tweetieTableView.window convertRect:[tweetieTableView rectForRowAtIndexPath:self.actionIndexPath] fromView:tweetieTableView];
		if (newRect.origin.y + newRect.size.height  >  HOMETIMELINE_AUTO_SCROLL_HEIGHT )
		{
			[tweetieTableView scrollToRowAtIndexPath:actionIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
		}
	}
	else
	{
		isShowActionCell = NO;
		[tweetieTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:actionIndexPath] withRowAnimation:UITableViewRowAnimationNone];
		NSIndexPath *tempPath = [NSIndexPath indexPathForRow:actionIndexPath.row - 1 inSection:actionIndexPath.section];
		NTESMBTimelineCell *cell = (NTESMBTimelineCell *)[tweetieTableView cellForRowAtIndexPath:tempPath];
		cell.isShowBottomTriangle = NO;
		cell.needUpdateContent = YES;
		[cell layoutSubviews];
//		[cell layoutBottomBackground];
	}
}



- (void) gotMessageError:(NSNotification *) notification
{
	id object = [notification object];
	//不处理icon类
	if ([object isKindOfClass:[NTESMBIconDownloader class]]) {
		return;
	}
	if( [object isKindOfClass:[NTESMBAPIUser class]]){
	
		return;
	}
	if([object	 isKindOfClass:[NTESMBAPIStatusUpdate class]] && [object apiType] == Status_Post){
		return;
	}
	if([object isKindOfClass:[NTESMBAPIStatusUpdateImage class]]){
		return;
	}
	//if ([object isKindOfClass:[APIStatus class]])
	//{
	[tweetieTableView closeInfoViewWhenError];
	[tweetieTableView closeBottomViewWhenError];
	[self setRightButton:refreshButton];
	if([object isAuthFailed]){
			/*
			UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"INFOR"
														   message:@"授权失败" delegate:nil
												 cancelButtonTitle:@"OK" otherButtonTitles:nil]autorelease];
			[alert show];
			*/
		if ([object isKindOfClass:[NTESMBAPILogin class]]) {
			return;
		}
		[[[[UIApplication sharedApplication]delegate]tabBarController] startPresentLoginViewController];
		return ;
	}
//	[self setGetMessageErrorStatus];	
	

}


- (void) gotMessage:(NSNotification *) notification
{
	//id object = [notification object];


	/*if (object == addFavorite){
		addFavorite.status.favorited = [NSNumber numberWithBool:YES];
		Status *dbStatus = [[NTESMBDB getInstance] getStatus:addFavorite.status];
		if (dbStatus!=nil) {
			dbStatus.favorited = [NSNumber numberWithBool:YES];
		}
		

		[tweetieTableView reloadData];
		[addFavorite release];
		addFavorite  = nil;
	}else if(object == removeFavorite)
	{		
		removeFavorite.status.favorited = [NSNumber numberWithBool:NO];
		Status *dbStatus = [[NTESMBDB getInstance] getStatus:removeFavorite.status];
		if (dbStatus!=nil) {
			dbStatus.favorited = [NSNumber numberWithBool:NO];
		}

		[tweetieTableView reloadData];
		[removeFavorite release];
		removeFavorite = nil;
	}else if (object==retweet) {
		retweet.status.retweeted = [NSNumber numberWithBool:YES];
		Status *dbStatus = [[NTESMBDB getInstance] getStatus:retweet.status];
		if (dbStatus!=nil) {
			dbStatus.retweeted = [NSNumber numberWithBool:YES];
		}

		[tweetieTableView reloadData];
		[retweet release];
		retweet =nil;
	}*/
}

#pragma mark -
#pragma mark navigate the status
//显示当前的导航条目和总数
- (NSString *)getNavTitle{
	return [NSString stringWithFormat:@"%d / %d",detailIndexPath.row+1,[tweetieTableView numberOfRowsInSection:0]];
}


- (BOOL) hasPrevStatus
{
	if (detailIndexPath.row == 0)
	{
		return NO;
	}
	NSIndexPath *prevIndexPath = [NSIndexPath indexPathForRow:detailIndexPath.row - 1 inSection:detailIndexPath.section];
	NTESMBStatusModel *model = [timelineDataSource statusModelAtIndexPath:prevIndexPath];
	if (model.isSeparator) {
		return NO;
	}
	return YES;
}

- (BOOL) hasNextStatus
{
	if (detailIndexPath.row == [tweetieTableView numberOfRowsInSection:0] - 1)
	{
		return NO;
	}
	NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:detailIndexPath.row + 1 inSection:detailIndexPath.section];
	NTESMBStatusModel *nextStatus = [timelineDataSource statusModelAtIndexPath:nextIndexPath];
	if (nextStatus.isSeparator) {
		return NO;
	}
	return YES;
}

- (NTESMBStatusModel *) getPrevStatus
{
	NSIndexPath *prevIndexPath = [[NSIndexPath indexPathForRow:detailIndexPath.row - 1 inSection:detailIndexPath.section] retain];
	NTESMBStatusModel *prevStatus = [timelineDataSource statusModelAtIndexPath:prevIndexPath];
	self.detailIndexPath = prevIndexPath;
	/*更新偏移量*/
	CGFloat cellHeight = [self tableView:tweetieTableView heightForRowAtIndexPath:prevIndexPath];
	
	tweetieTableView.contentOffset = CGPointMake(0, tweetieTableView.contentOffset.y-cellHeight);
	
	[prevIndexPath release];
	
	return prevStatus;
}

- (NTESMBStatusModel *) getNextStatus
{
	NSIndexPath *nextIndexPath = [[NSIndexPath indexPathForRow:detailIndexPath.row + 1 inSection:detailIndexPath.section] retain];
	NTESMBStatusModel *nextStatus = [timelineDataSource statusModelAtIndexPath:nextIndexPath];
	self.detailIndexPath = nextIndexPath;
	/*更新偏移量*/
	CGFloat cellHeight = [self tableView:tweetieTableView heightForRowAtIndexPath:nextIndexPath];
	tweetieTableView.contentOffset = CGPointMake(0, tweetieTableView.contentOffset.y+cellHeight);

	[nextIndexPath release];
	return nextStatus;
}

#pragma mark -
#pragma mark TimelineCellDelegate

- (void) willEnterStatusAtIndexPath:(NSIndexPath *) indexPath
{
	if (disappearLock) {
		return;
	}else {
		disappearLock=YES;
	}

	//[tweetieTableView deselectRowAtIndexPath:indexPath animated:NO];
		//获取一条微博
	NSIndexPath *tempIndexPath = nil;
	if (isShowActionCell == YES && actionIndexPath.row < indexPath.row)
	{
		tempIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
		//[self switchActionCellStateAtIndexPath:tempIndexPath];
	}
	else
	{
		tempIndexPath = indexPath;
	}
#ifdef DEBUG
	NE_LOG(@"will enter : %d", tempIndexPath.row);
#endif	
	
	
	
	self.detailIndexPath = tempIndexPath;
	NTESMBStatusModel *status = [timelineDataSource statusModelAtIndexPath:tempIndexPath];
	
	NTESMBStatusDetailViewController *statusDetailViewController = [[NTESMBStatusDetailViewController alloc] initWithNibName:@"NTESMBStatusDetailViewController" bundle:[NSBundle mainBundle]];
	statusDetailViewController.delegate = self;
	statusDetailViewController.hidesBottomBarWhenPushed = YES;
	statusDetailViewController.statusModel = status;
	statusDetailViewController.isShowNavigatorButton = YES;
	statusDetailViewController.previousViewController = self;
	statusDetailViewController.rootNavigationController = self.navigationController;
	UINavigationController *nav =nil;
	nav = self.navigationController;
	//nav = [NETopNavMainMenuController sharedAppNavigationController];
	//nav = [NTESMBMainMenuController sharedAppNavigationController];
	[nav pushViewController:statusDetailViewController animated:YES];
	[statusDetailViewController release];
}

#pragma mark -
#pragma mark TimelineActionCellDelegate
	//删除装推的数组的动作，交由子类实现
- (void) deleteStatus:(NTESMBStatusModel *) statusModel
{
	//	[self performSelectorOnMainThread:@selector(deleteCell:) withObject:statusModel waitUntilDone:YES];
//	isShowActionCell = NO;
//	[tweetieTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:actionIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	
	
	//NE_LOG("delete status model\ntext:'%@'\nuser:'%@'", statusModel.text, statusModel.user.name);
	[[NTESMBDB getInstance] deleteStatusWithStatusModel:statusModel];
	
//	NSIndexPath  * cellindexpath = [NSIndexPath indexPathForRow:0 inSection:0];
//	if (isShowActionCell == YES )	
//	{
//		//		[self switchActionCellStateAtIndexPath:actionIndexPath];
//	}
//	//	NSIndexPath  * cellindexpath = [NSIndexPath indexPathForRow:[actionIndexPath row]-1 inSection:[actionIndexPath section]];
//	//	[tweetieTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:actionIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//	//	NSIndexPath *indexPath_account = [NSIndexPath indexPathForRow:i inSection:1];
//	
//	NSArray *indexpaths = [[NSArray alloc] initWithObjects:cellindexpath , nil];
//	[tweetieTableView deleteRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];
//	[indexpaths release] ;
}

- (void) addFavorite:(NTESMBStatusModel *) status
{
	[NTESMBRemoteActionHelper addFavorite:status];
	[tweetieTableView reloadData];
}

- (void) removeFavorite:(NTESMBStatusModel *) status
{
	[NTESMBRemoteActionHelper removeFavorite:status];
	[tweetieTableView reloadData];
}


- (void) retweetTimeline:(NTESMBStatusModel *) status
{
	NTESMBPostViewController *editViewController=[[NTESMBPostViewController alloc] init];
	editViewController.hidesBottomBarWhenPushed = YES;
	NSString *tweetString = @"";
	if(status.rootTweetId){
		tweetString = [NSString stringWithFormat:@" ||@%@:%@", status.user.name, status.text];
	}
	editViewController.initialString = tweetString;
	editViewController.statusID = status.idn;
	editViewController.statusType = StatusTypeRetweet;
	editViewController.usersCommentToArray = [NSArray arrayWithObjects:status.user.name,status.rootUsername,nil];	
	//	self.title=@"取消";
	
	[self.navigationController pushViewController:editViewController animated:YES];
	[editViewController release];	
//	[NTESMBRemoteActionHelper retweet:status];
	[tweetieTableView reloadData];
}

- (void) unretweetTimeline:(NTESMBStatusModel *) status
{
	[NTESMBRemoteActionHelper unretweet:status];
	[tweetieTableView reloadData];
}

- (void) replyTimeline:(NSObject *) status
{
	NTESMBStatusModel *_status = (NTESMBStatusModel *)status;

	NTESMBPostViewController *editViewController=[[NTESMBPostViewController alloc] init];
	editViewController.hidesBottomBarWhenPushed = YES;
	if (_status.replyID) {
		NSString *tweetString = [NSString stringWithFormat:@" ||@%@:%@", _status.user.name, _status.text];
		editViewController.initialString = tweetString;
	}

	editViewController.statusID = _status.idn;
	editViewController.statusType = StatusTypeReply;
		//	self.title=@"取消";
	[self.navigationController pushViewController:editViewController animated:YES];
	[editViewController release];
}

- (void) showAttachment:(NTESMBStatusModel *) status
{
	NE_LOG(@"show att");
	NSString *imageUrl = [status getNeteaseImageUrl];
	NSString *otherUrl = [status getNeteaseCommonUrl];
	self.currentStatusAttachmentImageUrl = imageUrl;
	self.currentStatusAttachmentCommonUrl = otherUrl;
	if (self.currentStatusAttachmentImageUrl != nil
		&& self.currentStatusAttachmentCommonUrl !=nil )
	{
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"打开图片" otherButtonTitles:@"打开网址",@"单条模式", nil];
		[actionSheet showInView:self.view.window];
		[actionSheet release];
	}
	else if ( self.currentStatusAttachmentImageUrl !=nil
			 && self.currentStatusAttachmentCommonUrl ==nil )
	{
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"打开图片" otherButtonTitles:@"单条模式",nil];
		[actionSheet showInView:self.view.window];
		[actionSheet release];
	}
	else if (self.currentStatusAttachmentImageUrl ==nil
			 && self.currentStatusAttachmentCommonUrl !=nil)
	{
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"打开网址" otherButtonTitles:@"单条模式",nil];
		[actionSheet showInView:self.view.window];
		[actionSheet release];
	}else{
		[self willEnterStatusAtIndexPath: [NSIndexPath indexPathForRow:self.actionIndexPath.row -1 inSection:0]];
	}
}

- (void) showUserInfo:(NTESMBStatusModel *) status
{
	if (disappearLock) {
		return;
	}else {
		disappearLock=YES;
	}
	
	//NTESMBUserModel *userModel = status.user;
	/*
	UITabBarController *tabBar = [NTESMBUserTabBarFactory newUserTabBar:userModel];
	tabBar.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:tabBar animated:YES];

	[tabBar release];
	*/
	NTESMBUserInfoViewController *usrInforController = [[NTESMBUserInfoViewController alloc]init];
	usrInforController.userModel = status.user;
	usrInforController.statuses = [NSNumber numberWithInt:-1];
	usrInforController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:usrInforController animated:YES];	
	[usrInforController release];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	BOOL usePhotoBrowser = NO;
	BOOL enter = NO;
	NSURLRequest *urlRequest = nil;
	if (currentStatusAttachmentImageUrl != nil
		&& currentStatusAttachmentCommonUrl !=nil)
	{
		if (buttonIndex == 0)
		{
			//urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.currentStatusAttachmentImageUrl]];
			usePhotoBrowser = YES;
		}
		else if (buttonIndex == 1)
		{
			urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.currentStatusAttachmentCommonUrl]];
		}else if (buttonIndex == 2) {
			enter = YES;
		}

	}
	else if (currentStatusAttachmentImageUrl !=nil
			 && currentStatusAttachmentCommonUrl==nil)
	{
		if (buttonIndex == 0)
		{
			//urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.currentStatusAttachmentImageUrl]];
			usePhotoBrowser = YES;
		}else if (buttonIndex == 1) {
			enter = YES;
		}
	}
	else if (currentStatusAttachmentImageUrl == nil
			 && self.currentStatusAttachmentCommonUrl !=nil)
	{
		if (buttonIndex == 0)
		{
			urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.currentStatusAttachmentCommonUrl]];
		}else if (buttonIndex == 1) {
			enter = YES;
		}
	}
	
	if (usePhotoBrowser == YES)
	{
		NTESMBWebPhotoViewer *photoBrowser = [[NTESMBWebPhotoViewer alloc] initWithUrl:self.currentStatusAttachmentImageUrl];
		//photoBrowser.hidesBottomBarWhenPushed = YES;
		//[self.navigationController pushViewController:photoBrowser animated:YES];
		[self.navigationController presentModalViewController:photoBrowser animated:YES];
		[photoBrowser release];
		return;
	}
	
	if (urlRequest != nil)
	{
		NTESMBWebBrowser *browser = [[NTESMBWebBrowser alloc] initWithNibName:@"NTESMBWebBrowser" bundle:[NSBundle mainBundle]];
		browser.request = urlRequest;
		[self.navigationController presentModalViewController:browser animated:YES];
		[browser release];
	}
	if (enter) {
		[self willEnterStatusAtIndexPath: [NSIndexPath indexPathForRow:self.actionIndexPath.row -1 inSection:0]];
	}

}

#pragma mark -
#pragma mark icon download
- (void) updateIconAfterDownload:(UIImage *) iconImage withIndexPath:(NSIndexPath *)indexPath{

	 ///if (isShowActionCell == YES && indexPath.row > actionIndexPath.row)
	 //{
	 //indexPath = [NSIndexPath indexPathForRow:indexPath.row +1 inSection:indexPath.section];
	 //}
	 
	 NTESMBTimelineCell *cell = (NTESMBTimelineCell *)[tweetieTableView cellForRowAtIndexPath:indexPath];
	 if ([cell isKindOfClass:[NTESMBTimelineCell class]])
	 {
	 [cell.photoButton setImage:iconImage forState:UIControlStateNormal];
	 }	
	
}

-(NTESMBUserModel *)getUserModelFromIndexPath:(NSIndexPath *)indexPath{
	if ([timelineDataSource numberOfStatusInSection:indexPath.section]==0 ) {
		return nil;
	}
	
	if (isShowActionCell == YES && indexPath.row == actionIndexPath.row)
	 {
		 return nil;
	 }
	 NSIndexPath *tempIndexPath = indexPath;
	 if (isShowActionCell == YES && indexPath.row > actionIndexPath.row)
	 {
	 tempIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
	 }
	 //		NTESMBStatusModel *statusModel = [dataArray objectAtIndex:indexPath.row];
	 NTESMBStatusModel *statusModel = [timelineDataSource statusModelAtIndexPath:tempIndexPath];
	 NTESMBUserModel *userModel = statusModel.user;
	 return userModel;
}
-(NTESMBStatusModel *)getStatusModelFromIndexPath:(NSIndexPath *)indexPath{
	if ([timelineDataSource numberOfStatusInSection:indexPath.section]==0 ) {
		return nil;
	}
	
	if (isShowActionCell == YES && indexPath.row == actionIndexPath.row)
	{
		return nil;
	}
	NSIndexPath *tempIndexPath = indexPath;
	if (isShowActionCell == YES && indexPath.row > actionIndexPath.row)
	{
		tempIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
	}
	//		NTESMBStatusModel *statusModel = [dataArray objectAtIndex:indexPath.row];
	NTESMBStatusModel *statusModel = [timelineDataSource statusModelAtIndexPath:tempIndexPath];
	return statusModel;
}
- (void) showEditView
{
	NTESMBPostViewController *editViewController=[[NTESMBPostViewController alloc] init];
	editViewController.hidesBottomBarWhenPushed = YES;
	editViewController.initialString = @"";
	editViewController.statusType = StatusTypeNormal;
	//self.title=@"取消";
	[self.navigationController pushViewController:editViewController animated:YES];
	[editViewController release];
}

@end

