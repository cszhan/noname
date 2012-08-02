//
//  LabelRightImageCell.m
//  DressMemo
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LabelRightImageCell.h"

@implementation LabelRightImageCell
@synthesize nickNameTextField;
@synthesize locationTextField;
@synthesize userIconImageView;
@synthesize seperateHLineView;
@synthesize seperateVLineView;
@synthesize userIconEditBtn;
@synthesize cityBtn;
-(void)dealloc{
    self.seperateHLineView = nil;
    self.seperateVLineView = nil;
    self.userIconEditBtn = nil;
    self.nickNameTextField = nil;
    self.locationTextField = nil;
    self.userIconImageView = nil;
    self.cityBtn = nil;
    [super dealloc];
}
+(id)getFromNibFile
{
    NSArray *nibItems = [[NSBundle mainBundle] loadNibNamed:@"LabelRightImageCell" owner:self options:nil];
    LabelRightImageCell *instance = [nibItems objectAtIndex:0];
    return instance;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
