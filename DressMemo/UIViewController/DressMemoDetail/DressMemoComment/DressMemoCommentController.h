//
//  DressMemoCommentController.h
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UISimpleNetBaseViewController.h"
#import "UICommentView.h"
typedef enum commentType
{
    Comment_Default,
    Comment_Relpy,
}CommentType;
@interface DressMemoCommentController : UISimpleNetBaseViewController{
    UICommentView *_commentView;
}
@property(nonatomic,assign)CommentType type;
-(void)setNavgationBarTitle:(NSString*)title;
- (void)showWithController:(UIViewController *)tc;
- (void)dismiss;

@end
