//
//  DragDownBottomInfoView.h
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-21.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NTESMBDragDownBottomInfoView : UIView {
	UIActivityIndicatorView *activityView;
	BOOL isRefreshing;
}

@property (nonatomic, assign) BOOL isRefreshing;

- (void) startLoading;
- (void) stopLoading;

@end
