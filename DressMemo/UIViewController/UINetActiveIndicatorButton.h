//
//  UINetActiveIndicatorButton.h
//  DressMemo
//
//  Created by  on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINetActiveIndicatorButton : UIButton
-(void)stopNetActive;
-(void)startNetActive;
@property(nonatomic,assign)NSInteger rowIndex;
@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)UIActivityIndicatorView *activeView;

@end
