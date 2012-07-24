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
//#import ""
@interface UIImageNetBaseViewController : UIBaseViewController<UITableViewDelegate, UITableViewDataSource,RequestDelegate> {
	NTESMBTweetieTableView *tweetieTableView;
	BOOL isRefreshing;
	BOOL noDragEffect;
    
	BOOL hasSearchBar;
	//是否要将新发现的用户存储到数据库中
	BOOL doNotSaveUser;
	NSMutableDictionary *allIconDownloaders;
	
}
@property(nonatomic,assign)id request;@property (nonatomic, assign) BOOL isRefreshing;
- (void) cancelAllIconDownloads;
- (void) loadImagesForOnscreenRows;

@end
