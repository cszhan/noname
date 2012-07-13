//
//  UIButtonLikeCell.m
//  DressMemo
//
//  Created by  on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIButtonLikeCell.h"

@implementation UIButtonLikeCell

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
-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)envent
{
#if 0
    if(CGRectContainsPoint(self.reSetPwdcell.frame,point))
    {
        
    }
#endif
    //return nil;
    return [[self superview] hitTest:point withEvent:envent];
}
@end
