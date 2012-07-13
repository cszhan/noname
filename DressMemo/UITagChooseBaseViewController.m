//
//  UITagChooseBase.m
//  DressMemo
//
//  Created by  on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UITagChooseBaseViewController.h"

@implementation UITagChooseBaseViewController

-(void)loadView
{   
    [super loadView];
    //
    [self setRightTextContent:NSLocalizedString(@"Ok", @"")];
    //change the background
	//self.view = mainView;
    UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"BG-setting.png");
	//assert(bgImage);
	mainView.bgImage = bgImage;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
   
}
-(void)dealloc
{
    [super dealloc];
}
@end
