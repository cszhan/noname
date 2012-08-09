//
//  TweetieTableView.h
//  TweetieTableView
//
//  Created by Xu Han Jie on 10-5-20.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESMBDragDownInfoView.h"
#import "NTESMBDragDownBottomInfoView.h"
//#import "NTESMASession.h"

@class NTESMBTweetieTableView;

@protocol TweetieTableViewDelegate <NSObject>

- (void) shouldLoadNewerData:(NTESMBTweetieTableView *) tweetieTableView;
- (void) shouldLoadOlderData:(NTESMBTweetieTableView *) tweetieTableView;

@end


@interface NTESMBTweetieTableView : UITableView {
	NTESMBDragDownInfoView *topInfoView;
	NTESMBDragDownBottomInfoView *bottomInfoView;
	BOOL isRefreshing;
	//控制view是否出现上下的下拉刷新
	BOOL hasDragEffect;
	BOOL hasDownDragEffect;
	BOOL hasUpDragEffect;
	
	//控制是否出现搜索框
	BOOL hasSearchbar;
	UISearchBar *searchBar;
    CGFloat lastContentOffset;
	
	id <TweetieTableViewDelegate> tweetieTableViewDelegate;
}

@property (nonatomic, retain) NTESMBDragDownInfoView *topInfoView;
@property (nonatomic, assign) id <TweetieTableViewDelegate> tweetieTableViewDelegate;
@property (nonatomic, readonly) BOOL isRefreshing;
@property (nonatomic, readonly) UISearchBar *searchBar;
@property (nonatomic,assign)BOOL hasDownDragEffect;
@property (nonatomic,assign)int scrollDirection;
- (id)initWithFrame:(CGRect)frame hasDragEffect:(BOOL)has hasSearchBar:(BOOL) _hasSearchbar;
- (id)initWithFrame:(CGRect)frame hasDragEffect:(BOOL)has hasSearchBar:(BOOL) _hasSearchbar withStyle:(UITableViewStyle)_style;
- (void) tableViewDidScroll;
- (void) tableViewDidEndDragging;
- (void) closeInfoView;
- (void) closeInfoViewWhenError;
- (void) showBottomView;
- (void) closeBottomView;
- (void) closeBottomViewWhenError;

@end
