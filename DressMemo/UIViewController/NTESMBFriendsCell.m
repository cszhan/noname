//
//  NTESMBFriendsCell.m
//  网易微博iPhone客户端
//
//  Created by Yonghui on 10-6-17.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBFriendsCell.h"


@implementation NTESMBFriendsCell
//@synthesize nameLabel;
//@synthesize relationLabel;
//@synthesize relationImgView;
//@synthesize userIconView;
//@synthesize followedImgView;
//@synthesize iTagView;
@synthesize detailLabel;
@synthesize messageLabel;
@synthesize followButton;
@synthesize isFollowing;
@synthesize isFollowBy;
@synthesize userName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
    {
        // Initialization code
		//self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
		
		//userIconView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 48, 48)];
		/*
		userIconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 40, 40)];
		[self.contentView addSubview:userIconView];
		
		UIImage* iManIcon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iMan.png" ofType:@""]];
		iTagView = [[UIImageView alloc] initWithFrame:CGRectMake(34, 34, iManIcon.size.width, iManIcon.size.height)];
		[iTagView setImage:iManIcon];
		[iTagView setHidden:YES];
		[self.contentView addSubview:iTagView];

		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 160, 20)];
		nameLabel.textAlignment = UITextAlignmentLeft;
		nameLabel.font = [UIFont boldSystemFontOfSize:18];
		nameLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:nameLabel];
	*/	
		detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 160, 12)];
		detailLabel.textAlignment = UITextAlignmentLeft;
		detailLabel.font = [UIFont systemFontOfSize:12];
		detailLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:detailLabel];
        
		messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 47, 160, 15)];
		messageLabel.textAlignment = UITextAlignmentLeft;
		messageLabel.font = [UIFont systemFontOfSize:12];
		messageLabel.backgroundColor = [UIColor clearColor];
		messageLabel.textColor = [UIColor grayColor];
		[self.contentView addSubview:messageLabel];
		
		relationLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 15, 80, 15)];
		relationLabel.textAlignment = UITextAlignmentLeft;
		relationLabel.font = [UIFont systemFontOfSize:13];
		relationLabel.backgroundColor = [UIColor clearColor];
		relationLabel.textColor = [UIColor grayColor];
		[self.contentView addSubview:relationLabel];
		
		followButton = [[UIButton alloc] init];
		UIImage *buttonBG = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"followButton.png" ofType:@""]];
		UIImage *buttonPressedBG = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"followButtonPressed.png" ofType:@""]];
		[followButton setBackgroundImage:buttonBG forState:UIControlStateNormal];
		[followButton setBackgroundImage:buttonPressedBG forState:UIControlStateHighlighted];
		[followButton setFrame:CGRectMake(230, 35, buttonBG.size.width, buttonBG.size.height)];
		[followButton setTitle:@"" forState:UIControlStateNormal];
		[followButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[followButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
		followButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
		[self.contentView addSubview:followButton];
		
	//	UIImage *img1 = [UIImage imageNamed:@"followed_.png"];
	//	followedImgView = [[UIImageView alloc] initWithFrame:CGRectMake(235, 5, 25, 21)];
	//	[followedImgView setImage:img1];
	//	followedImgView.hidden = YES;
	//	[self.contentView addSubview:followedImgView];
		
	//	relationLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 5, 50, 20)];
	//	relationLabel.textAlignment = UITextAlignmentRight;
	//	relationLabel.font = [UIFont boldSystemFontOfSize:16];
	//	relationLabel.backgroundColor = [UIColor clearColor];
	//	[self.contentView addSubview:relationLabel];
		
	//	UIImage *img2 = [UIImage imageNamed:@"mutual.png"];
	//	relationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(240, 35, 38, 15)];
	//	relationImgView.hidden = YES;
	//	[relationImgView setImage:img2];
	//	[self.contentView addSubview:relationImgView];
    }
	
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
//	[nameLabel release];
//	[relationLabel release];
//	[relationImgView release];
//	[userIconView release];
//	[followedImgView release];
//	[iTagView release];
	[detailLabel release];
	[messageLabel release];
	[isFollowing release];
	[isFollowBy release];
	[followButton release];
	[userName release];
    [super dealloc];
}


@end
