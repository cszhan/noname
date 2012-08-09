//
//  DressMemoCommentController.h
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIBaseViewController.h"
#import "UICommentView.h"

@interface DressMemoCommentController : UIBaseViewController{
    UICommentView *_commentView;
}
-(void)setNavgationBarTitle:(NSString*)title;
- (void)showWithController:(UIViewController *)tc;
- (void)dismiss;

@end
