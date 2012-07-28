//
//  NTESMBFriendsCell.h
//  网易微博iPhone客户端
//
//  Created by Yonghui on 10-6-17.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESMBFriendsBaseCell.h"

@interface NTESMBFriendsCell : NTESMBFriendsBaseCell {
	//UILabel *nameLabel;
	//UILabel *relationLabel;
	//UIImageView *relationImgView;
	//UIImageView *userIconView;
	//UIImageView *followedImgView;
	//UIImageView *iTagView;
	NSString *userName;
	UILabel *detailLabel;
	UILabel *messageLabel;
	UIButton *followButton;
	NSNumber *isFollowing;
	NSNumber *isFollowBy;
	
}

//@property(nonatomic, retain) UILabel *nameLabel;
//@property(nonatomic, retain) UILabel *relationLabel;
//@property(nonatomic, retain) UIImageView *relationImgView;
//@property(nonatomic, retain) UIImageView *userIconView;
//@property(nonatomic, retain) UIImageView *followedImgView;
//@property(nonatomic, retain) UIImageView *iTagView;
@property(nonatomic, retain) UIButton *followButton;

@property(nonatomic, retain) UILabel *detailLabel;
@property(nonatomic, retain) UILabel *messageLabel;

@property(nonatomic, copy) NSNumber *isFollowing;
@property(nonatomic, copy) NSNumber *isFollowBy;
@property(nonatomic, retain) NSString *userName;
@end
