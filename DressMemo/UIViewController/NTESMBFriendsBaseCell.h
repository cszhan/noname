//
//  NTESMBFriendsBaseCell.h
//  NeteaseMicroblog
//
//  Created by libaoquan on 11-4-18.
//  Copyright 2011 NetEase.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NTESMBFriendsBaseCell : UITableViewCell {
	UILabel *nameLabel;
	UILabel *relationLabel;
	UIImageView *relationImgView;
	UIImageView *userIconView;
	UIImageView *followedImgView;
	UIImageView *iTagView;
}


@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) UILabel *relationLabel;
@property(nonatomic, retain) UIImageView *relationImgView;
@property(nonatomic, retain) UIImageView *userIconView;
@property(nonatomic, retain) UIImageView *followedImgView;
@property(nonatomic, retain) UIImageView *iTagView;


@end
