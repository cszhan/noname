//
//  ZCSTableViewCellBase.m
//  DressMemo
//
//  Created by  on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZCSTableViewCellBase.h"
#import <QuartzCore/QuartzCore.h>
@implementation ZCSTableViewCellBase
@synthesize cellLeftBGView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
        cellLeftBGView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, 82, self.frame.size.height)];
        cellLeftBGView.backgroundColor = [UIColor clearColor];
        cellLeftBGView.layer.masksToBounds = YES;
        [self addSubview:cellLeftBGView];
        [cellLeftBGView release];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc
{
    
    [super dealloc];
}
@end
