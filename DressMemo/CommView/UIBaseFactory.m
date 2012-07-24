//
//  UIBaseFactory.m
//  DressMemo
//
//  Created by  on 12-6-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIBaseFactory.h"
#import "ZCSAlertInforView.h"
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
    UIButton  *classBtn = [[[UIButton alloc ]initWithFrame:rect]autorelease];
    [classBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [classBtn setTitle:text forState:UIControlStateNormal];
    [classBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    classBtn.titleLabel.textAlignment = UITextAlignmentLeft;
    //CGRect newRect = CGRectOffset(classBtn.frame,-40.f,0);
    //[classBtn titleRectForContentRect:newRect];
    classBtn.frame = rect;
    return classBtn;
}
static  ZCSAlertInforView *naimationView = nil;
+(ZCSAlertInforView*)forkNetLoadingImageAnimationView
{
    
    if(naimationView == nil)
    {
        CGRect rect =  CGRectMake(kDeviceScreenWidth-182.f/2.f,kMBAppRealViewHeight,182.f/2.f,84.f/2.f);
        NSMutableArray *imageArr = [NSMutableArray array];
        UIImage *bgImage = nil;
        NSString *fileName = nil;
        for(int i = 1;i<=25;i++)
        {
        
            fileName = [NSString stringWithFormat:@"loadingexport00%02d.png",i];
            assert(fileName);
            UIImageWithFileName(bgImage,fileName);
            [imageArr addObject:bgImage];
            
        }
        naimationView = [[ZCSAlertInforView alloc]initWithFrame:rect withText:@"加载中..." withImages:imageArr];
    }
    NE_LOGRECT(naimationView.frame);
    return naimationView;
}
@end
