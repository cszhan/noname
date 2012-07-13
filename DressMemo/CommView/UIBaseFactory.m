//
//  UIBaseFactory.m
//  DressMemo
//
//  Created by  on 12-6-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIBaseFactory.h"

@implementation UIBaseFactory
+(UILabel*)forkUILabelByRect:(CGRect)rect font:(UIFont*)font textColor:(UIColor*)color text:(NSString*)text{
    UILabel *btnTextLabel = [[UILabel alloc]initWithFrame:rect];
    btnTextLabel.backgroundColor = [UIColor clearColor];
    //btnTextLabel.center = 
    btnTextLabel.text = text;
    btnTextLabel.textColor = color;
    btnTextLabel.font = font;
    btnTextLabel.textAlignment = UITextAlignmentCenter;
    return [btnTextLabel autorelease];
}
+(UIButton*)forkUIButtonByRect:(CGRect)rect text:(NSString*)text image:(UIImage*)bgImage 
{
    UIButton  *classBtn = [[UIButton alloc ]initWithFrame:rect];
    [classBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [classBtn setTitle:text forState:UIControlStateNormal];
    [classBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    classBtn.titleLabel.textAlignment = UITextAlignmentLeft;
    //CGRect newRect = CGRectOffset(classBtn.frame,-40.f,0);
    //[classBtn titleRectForContentRect:newRect];
    classBtn.frame = rect;
    return classBtn;
}
@end
