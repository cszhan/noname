//
//  ZCSAlertInforView.h
//  DressMemo
//
//  Created by  on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCSAlertInforView : UIView
@property(nonatomic,assign)BOOL isHiddenAuto;
@property(nonatomic,retain)NSString *text;
-(void)setTextFont:(UIFont*)font;
-(id)initWithFrame:(CGRect)frame withText:(NSString*)text isWindow:(BOOL)isWindow;
- (void)setBGContent:(UIImage*)image;
- (void)hiddenAfterDelay:(NSTimeInterval)duration;
- (void)hiddenUpAnimation:(NSTimeInterval)duration;
@end
