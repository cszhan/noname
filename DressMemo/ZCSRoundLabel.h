//
//  ZCSRoundLabel.h
//  DressMemo
//
//  Created by  on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCSRoundLabel : UILabel
@property(nonatomic,assign)BOOL roundUpperLeft;
@property(nonatomic,assign)BOOL roundUpperRight;
@property(nonatomic,assign)BOOL roundLowerRight;
@property(nonatomic,assign)BOOL roundLowerLeft;
@property(nonatomic,assign)CGFloat radius;
@property(nonatomic,assign)CGFloat borderWidth;
@property(nonatomic,retain)UIColor *bgColor;
@property(nonatomic,retain)UIColor *cornerColor;
@property(nonatomic,assign)int roundType;
@end
