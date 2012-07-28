//
//  NTESMBFriendsBaseCell.m
//  NeteaseMicroblog
//
//  Created by libaoquan on 11-4-18.
//  Copyright 2011 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBFriendsBaseCell.h"


@implementation NTESMBFriendsBaseCell

@synthesize nameLabel;
@synthesize relationLabel;
@synthesize relationImgView;
@synthesize userIconView;
@synthesize followedImgView;
@synthesize iTagView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		//self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
		
		//userIconView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 48, 48)];
		userIconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 34, 34)];
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
    }
	
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[nameLabel release];
	[relationLabel release];
	[relationImgView release];
	[userIconView release];
	[followedImgView release];
	[iTagView release];
    [super dealloc];
}


@end
