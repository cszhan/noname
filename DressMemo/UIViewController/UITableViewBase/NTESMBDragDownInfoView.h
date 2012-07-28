//
//  DragDownInfoView.h
//  TweetieTableView
//
//  Created by Xu Han Jie on 10-5-20.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
	DragDownInfoViewStateNormal = 0,
	DragDownInfoViewStateRefresh = 1,
	DragDownInfoViewStateRefreshing = 2
} DragDownInfoViewState;

@interface NTESMBDragDownInfoView : UIView {
	DragDownInfoViewState _state;
	
	UILabel *infoLabel;
	UIImageView *background;
	UIImageView *midBackground;
	CALayer *arrowImage;
	UIActivityIndicatorView *activityView;
	
	NSDate *lastUpdateDate;
}

@property (nonatomic, retain) NSDate *lastUpdateDate;

- (void) setState:(DragDownInfoViewState) state;
- (DragDownInfoViewState) getState;

@end
