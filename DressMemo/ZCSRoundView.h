//
//  ZCSRoundView.h
//  DressMemo
//
//  Created by  on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCSRoundView : UIView
@property(nonatomic,assign)BOOL roundUpperLeft;
@property(nonatomic,assign)BOOL roundUpperRight;
@property(nonatomic,assign)BOOL roundLowerRight;
@property(nonatomic,assign)BOOL roundLowerLeft;
@property(nonatomic,assign)CGFloat radius;
@property(nonatomic,assign)UIColor *cornerColor;
@end
