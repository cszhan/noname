//
//  UIBaseFactory.h
//  DressMemo
//
//  Created by  on 12-6-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCSAlertInforView.h"
@interface UIBaseFactory : NSObject
+(UILabel*)forkUILabelByRect:(CGRect)rect font:(UIFont*)font textColor:(UIColor*)color text:(NSString*)text;
+(UIButton*)forkUIButtonByRect:(CGRect)rect text:(NSString*)text image:(UIImage*)bgImage;
+(ZCSAlertInforView*)forkNetLoadingImageAnimationtoView:(UIView*)view text:(NSString*)text;
@end
