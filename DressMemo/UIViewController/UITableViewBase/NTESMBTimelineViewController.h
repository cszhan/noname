//
//  NTESMBTimelineViewController.h
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-26.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESMBTweetieViewController.h"
#import "NTESMBTimelineActionCell.h"
#import "NTESMBUserModel.h"
#import "NTESMBStatusModel.h"
#import "User.h"
#import "NTESMBIconDownloader.h"
#import "NTESMBStatusDetailViewController.h"
#import "NeteaseMicroblogAPI.h"
#import "NTESMBTimelineCell.h"
#import "NTESMBUpdateBlockView.h"
#import "NTESMBSoundEffect.h"
#import "NTESMBRemoteActionHelper.h"

@protocol NTESMBTimelineDataSource <NSObject>

- (void) getNewData;
- (void) getOldData;
- (NSInteger) numberOfStatusInSection:(NSInteger) section;
- (NTESMBStatusModel *) statusModelAtIndexPath:(NSIndexPath *) indexPath;

@end


@interface NTESMBTimelineViewController : NTESMBTweetieViewController <TweetieTableViewDelegate, NTESMBStatusNavigateDelegate, UISearchDisplayDelegate, TimelineActionCellDelegate, UIActionSheetDelegate, NTESMBTimelineCellDelegate> {
	BOOL isShowActionCell;

	NTESMBTimelineActionCell *actionCell;
	NSIndexPath *actionIndexPath;
	NSMutableArray *dataArray;
	id <NTESMBTimelineDataSource> timelineDataSource;
	
	User *currentUser;
	
	NSIndexPath *detailIndexPath;
	
	
	//NTESMBAPIFav *addFavorite;
	//NTESMBAPIFav *removeFavorite;
	//NTESMBAPIRetweet *retweet;
	
	NSString *currentStatusAttachmentImageUrl;
	NSString *currentStatusAttachmentCommonUrl;
	NSUInteger numberOfNewStatuses;
	
//	//表格的滚动高度
//	CGFloat tablePosition;
	
		//提示更新条数
	NTESMBUpdateBlockView *updateBlockView;
	
	//提示声音
	NTESMBSoundEffect *soundEffect;
	
	//maxid sinceid
	NSString *maxID;
	NSString *sinceID;
	
	//右侧按钮
	UIBarButtonItem *refreshButton;
	UIBarButtonItem *refreshingButton;
	//这个变量是用来解决某些特殊情况下，某人同时点击了头像和单元格造成两个方法被同时调用时的nav bar显示错误
	BOOL disappearLock;
	BOOL isDownReflush;
	BOOL scrollTopReflush;
}

@property (nonatomic, copy) NSString *maxID;
@property (nonatomic, copy) NSString *sinceID;
@property (readonly)NSArray *dataArray;
@property (nonatomic, retain) NSIndexPath *actionIndexPath;
@property (nonatomic, retain) id <NTESMBTimelineDataSource> timelineDataSource;
@property (nonatomic, retain) User *currentUser;
@property (nonatomic, retain) NSIndexPath *detailIndexPath;
@property (nonatomic, copy) NSString *currentStatusAttachmentImageUrl;
@property (nonatomic, copy) NSString *currentStatusAttachmentCommonUrl;
@property (nonatomic, assign) NSUInteger numberOfNewStatuses;

//如果toolbar打开,就关闭toolbar
- (void) closeToolBarIfNeeded;
//toolbar开关
- (void) switchActionCellStateAtIndexPath:(NSIndexPath *) indexPath;
//- (CGFloat) cellHeightWithText:(NSString *) text;

- (UITableViewCell *) getCell: (UITableView *) tableView indexPath:(NSIndexPath *)indexPath;
- (void) deleteStatus:(NTESMBStatusModel *) statusModel;

- (void) showNewTimelineNotify;
- (void) goRefresh;
- (void) gotMessageError:(NSNotification *) notification;
- (void) setRightButton:(UIBarButtonItem *)button;
- (void) showEditView;
@end
