//
//  UICommentView.m
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UICommentView.h"

#pragma mark -
#pragma mark UIAsistView
@implementation UIAsistView 
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _asistLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _asistLabel.backgroundColor = [UIColor clearColor];
        _asistLabel.font = [UIFont systemFontOfSize:14];
        _asistLabel.textColor = [UIColor darkGrayColor];
        _asistLabel.text = @"剩余字数  140";
        [self addSubview:_asistLabel];
        
        UIImage *img = nil;
        UIImageWithFileName(img, @"BG-message.png");
        self.backgroundColor = [UIColor colorWithPatternImage:img];
    }
    
    return self;
}

- (void)dealloc{
    Safe_Release(_asistLabel)
    
    [super dealloc];
}

#define kUIAsistViewLeftPadding 15
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = [NTESMBUtility getSizeForText:_asistLabel.text font:_asistLabel.font];
    _asistLabel.bounds = CGRectMake(0, 0, size.width, size.height);
    _asistLabel.center = CGPointMake(ceil(self.bounds.size.width-kUIAsistViewLeftPadding-_asistLabel.bounds.size.width/2), 
                                     ceil(self.bounds.size.height/2));
    
}

- (void)setLeftCount:(NSInteger)count{
    _asistLabel.text = [NSString stringWithFormat:@"剩余字数  %d", count];
}

@end


#pragma mark -
#pragma mark UICommentView
@implementation UICommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _inputView = [[UITextView alloc] initWithFrame:CGRectZero];
        _inputView.font = [UIFont systemFontOfSize:16];
//        _inputView.contentInset = UIEdgeInsetsMake(18, 18, 18, 18);
        [self addSubview:_inputView];
        
        _asistView = [[UIAsistView alloc] initWithFrame:CGRectZero];
        [self addSubview:_asistView];
        
        _inputView.delegate = self;
    }
    return self;
}

- (void)dealloc{    
    Safe_Release(_inputView)
    Safe_Release(_asistView)
    
    [super dealloc];
}

#define kUICommentViewAsistViewHeight 36
- (void)layoutSubviews{
    [super layoutSubviews];
    
    _asistView.frame = CGRectMake(0, self.bounds.size.height-kUICommentViewAsistViewHeight, 
                                  self.bounds.size.width, kUICommentViewAsistViewHeight);
    
    _inputView.frame = CGRectMake(0, 0, self.bounds.size.width, 
                                  self.bounds.size.height-kUICommentViewAsistViewHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)becomeFirstResponder{
    return [_inputView becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
    return [_inputView resignFirstResponder];
}

#pragma mark -UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSMutableString *string = [NSMutableString stringWithString:textView.text];
//    
//    if (range.location >= string.length) {
//        [string appendString:text];
//    }else if(range.location < string.length && range.location+range.length > string.length){
//        
//    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    [_asistView setLeftCount:140-[_inputView.text length]];
}

@end
