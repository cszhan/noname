//
//  UINetActiveIndicatorButton.m
//  DressMemo
//
//  Created by  on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UINetActiveIndicatorButton.h"

@implementation UINetActiveIndicatorButton
@synthesize activeView;
@synthesize delegate;
@synthesize rowIndex;
-(void)awakeFromNib
{//[self addObservers];
    [self initSubView];
}
- (void)addObservers
{
    [ZCSNotficationMgr addObserver:self call:@selector(didNetWorkOK:) msgName:kZCSNetWorkOK];
    [ZCSNotficationMgr addObserver:self call:@selector(didNetWorkFailed:) msgName:
     kZCSNetWorkRespondFailed];
    [ZCSNotficationMgr addObserver:self call:@selector(didNetWorkFailed:) msgName:kZCSNetWorkRequestFailed];
}
-(void)dealloc
{
    
    self.delegate = nil;
    self.activeView = nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        //[self addTarget:@selector(;) action:<#(SEL)#> forControlEvents:<#(UIControlEvents)#>
        //[self addObservers];
        [self initSubView];
    }
    return self;
}
+(id)buttonWithType:(UIButtonType)buttonType
{
    self = [super buttonWithType:buttonType];
    if (self) 
    {
        // Initialization code
        //[self addTarget:@selector(;) action:<#(SEL)#> forControlEvents:<#(UIControlEvents)#>
        //[self addObservers];
        [self initSubView];
    }
    return self;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)initSubView
{
    UIActivityIndicatorView *_activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self addSubview:_activeView];
    [_activeView release];
    self.activeView = _activeView;
    _activeView.hidden = YES;
}
-(void)startNetActive
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.enabled = NO;
    self.activeView.hidden = NO;
    [self.activeView startAnimating];
}
-(void)stopNetActive
{
    self.enabled = YES;
    [self.activeView stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.activeView.hidden = YES;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.activeView.center = CGPointMake(self.frame.size.width/2.f, self.frame.size.height/2.f);
}
@end
