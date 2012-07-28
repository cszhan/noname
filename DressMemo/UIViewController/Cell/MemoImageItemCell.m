//
//  MemoImageItemCell.m
//  DressMemo
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MemoImageItemCell.h"

@implementation MemoImageItemCell
@synthesize imageItemBtn0;
@synthesize imageItemBtn1;
@synthesize imageItemBtn2;
@synthesize imageTimeTitleBtn0;
@synthesize imageTimeTitleBtn1;
@synthesize imageTimeTitleBtn2;
-(void)dealloc{
    self.imageItemBtn0 = nil;
    self.imageItemBtn1 = nil;
    self.imageItemBtn2 = nil;
    self.imageTimeTitleBtn0 = nil;
    self.imageTimeTitleBtn1 = nil;
    self.imageTimeTitleBtn2 = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
    }
    return self;
}
+(id)getFromNibFile
{
    NSArray *nibItems = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    MemoImageItemCell *instance = [nibItems objectAtIndex:0];
    instance.imageTimeTitleBtn0.hidden = YES;
    instance.imageTimeTitleBtn1.hidden = YES;
    instance.imageTimeTitleBtn2.hidden = YES;
    return instance;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
