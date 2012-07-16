//
//  UIButtonLikeCell.m
//  DressMemo
//
//  Created by  on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIButtonLikeCell.h"

@implementation UIButtonLikeCell
@synthesize labelText;
@synthesize touchDelegate;
-(void)dealloc{
    self.labelText = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height)];
        
        [self addSubview:text];
        text.backgroundColor = [UIColor clearColor];
        self.labelText = text;
        [text release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)envent
//{
//#if 0
//    if(CGRectContainsPoint(self.reSetPwdcell.frame,point))
//    {
//        
//    }
//#endif
//    //return nil;
//#if 0
//    if(CGRectContainsPoint(self.frame, point))
//    {
//        if(touchDelegate&&[touchDelegate respondsToSelector:@selector(didTouchEvent:)])
//        {
//            [touchDelegate didTouchEvent:self];
//        }
//        return self;
//    }
//#endif
//    //if(CGRectContainsPoint(self.accessoryView.frame,point))
//       point = [self convertPoint:point  toView:[touchDelegate view]];
//    return [super hitTest:point withEvent:envent];
//   // return [[self superview] hitTest:point withEvent:envent];
//}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   // if(CGRectContainsPoint(self.frame, point))
    {
        if(touchDelegate&&[touchDelegate respondsToSelector:@selector(didTouchEvent:)])
        {
            [touchDelegate didTouchEvent:self];
        }
       // return self;
    }
}
@end
