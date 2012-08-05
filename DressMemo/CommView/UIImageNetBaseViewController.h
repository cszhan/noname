//
//  UIDataNetBaseViewController.h
//  DressMemo
//
//  Created by  on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIBaseViewController.h"
#import "NTESMBTweetieTableView.h"
#import "NTESMBServer.h"
#import "ZCSNetClientDataMgr.h"
//#import ""
#define LOADING_VIEW
#ifdef LOADING_VIEW
@class ZCSAlertInforView;
#endif
@protocol MemoTimelineDataSource <NSObject>

- (void) getNewData;
- (void) getOldData;
- (NSInteger) numberOfStatusInSection:(NSInteger) section;

@end

@interface UIImageNetBaseViewController : UIBaseViewController<UITableViewDelegate, UITableViewDataSource,RequestDelegate> {
	NTESMBTweetieTableView *tweetieTableView;
	BOOL isRefreshing;
	BOOL noDragEffect;
	BOOL hasSearchBar;
	//是否要将新发现的用户存储到数据库中
	BOOL doNotSaveUser;
    //use page to load data
    NSInteger currentPageNum;
	NSMutableDictionary *allIconDownloaders;
    
    id<MemoTimelineDataSource> memoTimelineDataSource;
}
@property(nonatomic,retain)UIImageView  *myEmptyBgView;
@property(nonatomic,retain)NSDictionary *requestDict;
@property(nonatomic,assign)BOOL   isVisitOther;
@property(nonatomic,retain)NSString *userId;
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,retain)NSDictionary *data;
@property(nonatomic,assign)id request;
@property(nonatomic, assign) BOOL isRefreshing;
@property(nonatomic,assign)id<MemoTimelineDataSource> memoTimelineDataSource;
#ifdef LOADING_VIEW
@property(nonatomic,assign)ZCSAlertInforView *animationView;
-(void)startShowLoadingView;
-(void)stopShowLoadingView;
#endif
- (void) cancelAllIconDownloads;
- (void) loadImagesForOnscreenRows;
- (void) reloadAllData;
@end
