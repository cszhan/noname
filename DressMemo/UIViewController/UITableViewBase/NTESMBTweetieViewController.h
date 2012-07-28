//
//  TweetieViewController.h
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-26.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESMBTweetieTableView.h"
#import "NTESMBLocalImageStorage.h"
#import "NTESMBServer.h"
#define USER_MODEL_IMAGE
#ifdef  USER_MODEL_IMAGE
#import "NTESMBIconDownloader.h"
#import "NTESMBUserIconCache.h"
#import "NTESMBUserModel.h"
//#import "NTESMBDB.h"
#import "UIBaseViewController.h"

#endif


@interface NTESMBTweetieViewController : UIBaseViewController <UITableViewDelegate, UITableViewDataSource, RequestDelegate> {
	NTESMBTweetieTableView *tweetieTableView;
	BOOL isRefreshing;
	BOOL noDragEffect;

	BOOL hasSearchBar;
	//是否要将新发现的用户存储到数据库中
	BOOL doNotSaveUser;
	NSMutableDictionary *allIconDownloaders;
	
}

@property (nonatomic, assign) BOOL isRefreshing;
- (void) cancelAllIconDownloads;
- (void) loadImagesForOnscreenRows;
#ifdef  USER_MODEL_IMAGE
- (void) startDownloadIcons:(NTESMBUserModel *) u indexPath:(NSIndexPath *) indexPath;
#endif
- (void) setRightRetunHomeBtn;
@end
