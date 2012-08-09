//
//  UICommentView.h
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark UIAsistView
@interface UIAsistView : UIView{
    UILabel *_asistLabel;
}

- (void)setLeftCount:(NSInteger)count;

@end

#pragma mark -
#pragma mark UICommentView
@interface UICommentView : UIView <UITextViewDelegate>{
    UITextView  *_inputView;
    UIAsistView *_asistView;
}
@property(nonatomic,retain)UITextView *inputView;
@property(nonatomic,retain)UIAsistView *asistView;
@end
