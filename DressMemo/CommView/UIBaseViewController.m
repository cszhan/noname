//
//  UIBarBase.m
//  MP3Player
//
//  Created by cszhan on 12-1-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "UIParamsCfg.h"
#import "ZCSNotficationMgr.h"
#import "UIBaseViewController.h"
#import "NEDebugTool.h"
#import <QuartzCore/QuartzCore.h>
#import "NEAppFrameView.h"
#import "NETopNavBar.h"

//#import "PlayingMenuViewController.h"
@class PlayingMenuViewController;
static NSInteger tabCount;

#define USE_LABEL

@interface UIBaseViewController()
-(void)initTopNavBarViews;
-(void)initHomePageTimelineNavBar:(CGRect)rect withIndex:(NSInteger)index;
@property(nonatomic,assign) UIButton *leftBtn;
@property(nonatomic,assign) UIButton *rightBtn;
@property(nonatomic,assign) UILabel *leftText;
@property(nonatomic,assign) UILabel *rightText;
@end
@implementation UIBaseViewController
@synthesize mainView;
@synthesize delegate;
@synthesize leftBtn;
@synthesize rightBtn;
@synthesize leftText;
@synthesize rightText;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [self addObservers];
    }   
    return self;
}
-(void)initTopNavBarViews
{
	//hometimeline navigation Bar 
	[self initHomePageTimelineNavBar:CGRectMake(0.f,0.f, kDeviceScreenWidth, kMBAppTopToolBarHeight) withIndex:tabCount++];
	
}
-(void)initHomePageTimelineNavBar:(CGRect)rect withIndex:(NSInteger)index
{
	//self draw
	NSMutableArray *arr = [NSMutableArray array];
	UIImage  *bgImage = nil;
	//NSString *imgPath = nil;
	/*
	 ＊post blog
	 */
	UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
	/*
	 imgPath = [[NSBundle mainBundle] pathForResource:@"postblog" ofType:@"png"];
	 assert(imgPath);
	 bgImage =  [UIImage imageWithContentsOfFile:imgPath];
	 */
	UIImageWithFileName(bgImage,@"btn-red-back.png");
	//UIImage *bgImageS = nil;
	//UIImageWithFileName(bg
	[btn setBackgroundImage:bgImage forState:UIControlStateNormal];
	UIImageWithFileName(bgImage,@"btn-red-back.png");
	[btn setBackgroundImage:bgImage forState:UIControlStateSelected];
	//|UIControlStateHighlighted|UIControlStateSelected
	btn.frame = CGRectMake(kMBAppTopToolXPending,kMBAppTopToolYPending,bgImage.size.width/kScale, bgImage.size.height/kScale);
	//[mainView.mainFramView addSubview:btn];
	NE_LOG(@"btn frame");
	NE_LOGRECT(btn.frame);
	//btn.hidden = YES;
    UILabel *btnTextLabel  = nil;
#ifdef USE_LABEL
	btnTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(kTopNavItemLabelOffsetX,kTopNavItemLabelOffSetY, btn.frame.size.width,btn.frame.size.height)];
    btnTextLabel.backgroundColor = [UIColor clearColor];
    //btnTextLabel.center = 
    btnTextLabel.text = NSLocalizedString(@"Return", @"");
    btnTextLabel.textColor = [UIColor whiteColor];
    btnTextLabel.font = kNavgationItemButtonTextFont;
    btnTextLabel.textAlignment = UITextAlignmentLeft;
    leftText = btnTextLabel;
    [btn addSubview:btnTextLabel];
	[btnTextLabel release];

#else
    [btn setTitle:NSLocalizedString(@"Return", @"") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0.f,13, 0,0.f);
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    leftText = btn.titleLabel;
    leftText.font = kNavgationItemButtonTextFont;
#endif
	[arr addObject:btn];
	self.leftBtn = btn;
	/*
	 * camera
	 */
	btn = [UIButton buttonWithType:UIButtonTypeCustom];
	/*
	 imgPath = [[NSBundle mainBundle] pathForResource:@"camera" ofType:@"png"];
	 assert(imgPath);
	 bgImag =  [UIImage imageWithContentsOfFile:imgPath];
	 */
	//UIImageScaleWithFileName(bgImage,@"camera");
	UIImageWithFileName(bgImage,@"btn-red.png");
	[btn setBackgroundImage:bgImage forState:UIControlStateNormal];
	
	UIImageWithFileName(bgImage,@"btn-red.png");
	[btn setBackgroundImage:bgImage forState:UIControlStateSelected];
	
	//|UIControlStateHighlighted|UIControlStateSelected
	btn.frame = CGRectMake(kDeviceScreenWidth-bgImage.size.width/kScale-kMBAppTopToolXPending,kMBAppTopToolYPending,bgImage.size.width/kScale, bgImage.size.height/kScale);
	[arr addObject:btn];
	rightBtn = btn;
	//CGRect rect = CGRectMake(0.f, 0.f, kDeviceScreenWidth, kMBAppTopToolBarHeight);
	
    
    btnTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f,kTopNavItemLabelOffSetY, btn.frame.size.width,btn.frame.size.height)];
    btnTextLabel.backgroundColor = [UIColor clearColor];
    //btnTextLabel.center = 
    btnTextLabel.text = NSLocalizedString(@"Next", @"");
    btnTextLabel.textColor = [UIColor whiteColor];
    btnTextLabel.font = kNavgationItemButtonTextFont;
    btnTextLabel.textAlignment = UITextAlignmentCenter;
    
    rightText = btnTextLabel;
    
    [btn addSubview:btnTextLabel];
    [btnTextLabel release];
    
    
    
	UIImageWithFileName(bgImage,@"titlebar.png");
	NETopNavBar  *tempNavBar= [[NETopNavBar alloc]
							   initWithFrame:rect withBgImage:bgImage withBtnArray:arr selIndex:-1];
	
	//tempNavBar.navTitle = ;
	tempNavBar.delegate = self;
	tempNavBar.navTitle = navBarTitle;
	NE_LOGRECT(tempNavBar.frame);
	//[mainView.topBarView addSubview:tempNavBar];
	//NE_LOG(@"tt:%0x",mainView.topBarView);
	mainView.topBarView = tempNavBar;
	//NE_LOG(@"tt:%0x",tempNavBar);
	//[topBarViewNavItemArr insertObject:tempNavBar atIndex:index];
	[tempNavBar release]; 
	
}
-(NETopNavBar*)getTopBarView
{
    return mainView.topBarView;
}
-(void)setTopBarView:(NETopNavBar*)topview;
{
   // [mainView.topBarView release];
    mainView.topBarView = topview;
}
-(void)setTopBarViewLeftButton:(UIView*)btn
{

}
#pragma mark -
#pragma mark top navigation bar item set
-(void)setHiddenLeftBtn:(BOOL)hidden
{
	//if(hidden)
	{
		leftBtn.hidden = hidden;
	}
	//else 
	{
		
	}

}
-(void)setHiddenRightBtn:(BOOL)hidden{
    rightBtn.hidden = hidden;
}
-(void)setRightBtnEnable:(BOOL)enable{
    if(enable)
    {
        rightBtn.enabled = YES;
        rightText.textColor = [UIColor whiteColor];
    }
    else 
    {
        rightBtn.enabled = NO;
        rightText.textColor = [UIColor grayColor];
    }
}
-(void)setRightBtnHidden:(BOOL)enable{
    self.rightBtn.hidden = enable;
}
-(void)setLeftTextContent:(NSString*)text
{
	leftText.text = text;
}
-(void)setRightTextContent:(NSString*)text
{
    rightText.text = text;
}
-(void)setRightTextColor:(UIColor*)color
{
    rightText.textColor = color;
}
-(void)setNavgationBarRightBtnImage:(UIImage*)image forStatus:(UIControlState)status
{
	
	[rightBtn setBackgroundImage:image forState:status];
	/*
	CGRect rect ;
	rect.origin = rightBtn.frame.origin;
	rect.size = CGSizeMake(image.size.width/kScale,image.size.height/kScale);
	*/
	rightBtn.frame = CGRectMake(kDeviceScreenWidth-image.size.width/kScale,kMBAppTopToolYPending,image.size.width/kScale, image.size.height/kScale);;
}
-(void)setNavgationBarTitle:(NSString*)title{
	[navBarTitle release];
	navBarTitle = [title retain];
	[mainView setTopNavBarTitle:title];
}
-(void)setBgImage:(UIImage*)image{
	self.view.layer.contents = (id)image.CGImage;
}
-(void)setContentBgImage:(UIImage*)image{
	mainView.mainFramView.layer.contents = (id)image.CGImage; 
}
#pragma mark did selector top navgation bar item
-(void)didSelectorTopNavItem:(id)navObj
{
	NE_LOG(@"select item:%d",[navObj tag]);
    
	switch ([navObj tag])
	{
		case 0:
			[self.navigationController popViewControllerAnimated:YES];// animated:<#(BOOL)animated#>
			break;
		case 1:
		{
            
			
            //return;
            /*
             PlayingMenuViewController *playMenuVc = [[PlayingMenuViewController alloc]init];
             //[self.navigationController pushViewController:playMenuVc animated:YES];
             //[[NSNotificationCenter defaultCenter] postNotificationName: object:playMenuVc];
             [ZCSNotficationMgr postMSG:kPushNewViewController obj:playMenuVc];
             [playMenuVc release];
             */
			break;
		}
	}
    if(delegate&&[delegate respondsToSelector:@selector(didSelectorTopNavigationBarItem:)])
    {
        
        [delegate didSelectorTopNavigationBarItem:navObj];
    }
}
#pragma mark -
#pragma mark view cycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)loadView
{
	[super loadView];
 
    //tabCtrl.tabBar.frame = CGRectMake(0,0,40,32);
	//topBarViewNavItemArr = [[NSMutableArray alloc]init];
	/*
     mainView = [[NEAppFrameView alloc]
     //initWithFrame:[[UIScreen mainScreen]bounds]];
     initWithFrame:[[UIScreen mainScreen]bounds]withImageDict:nil withImageDefault:YES];
     */
	mainView = [[NEAppFrameView alloc]initWithFrame:[[UIScreen mainScreen]bounds] style:NEAppFrameViewDefault|NEAppFrameViewBottomBarNone];
	//self.view = mainView;
	UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"Background.png");
	//assert(bgImage);
	mainView.bgImage = bgImage;
    
	[self initTopNavBarViews];
	self.view = mainView;
	//[mainView release];
	//[self.view addSubview:mainView];
	NE_LOGRECT(self.view.frame);
	NE_LOGRECT(mainView.frame);
	//self.view.frame =CGRectOffset(self.view.frame, 0.f, -40.f);
	//[self.view addSubview:mainView];
	//[mainView release];
}

-(void)addObservers
{

}
-(void)removeObservers
{

}
-(void)viewDidLoad
{
	[super viewDidLoad];
    //[self initTopNavBarViews];
    if(isFromViewUnload)
    {
        
    }
    else 
    {
        objIDKey = [[NSString generateNonce]retain];
        NSLog(@"%@",objIDKey);
    }
    /*
    CGRect rect = mainView.mainFramView.frame;
    mainView.mainFramView.frame = CGRectMake(rect.origin.x,rect.origin.y,rect.size.width,rect.size.height+10.f);
    */
    
    NE_LOGRECT(mainView.mainFramView.frame);
}
-(void)viewDidUnload
{
    [super viewDidUnload];
    isFromViewUnload = YES;
    //[self removeObservers];
    
}
- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)dealloc 
{
	[self removeObservers];
    if([mainView superview])
    {
		[mainView removeFromSuperview];
	}
	[mainView release];
	//self.view = nil;
	[navBarTitle release];
    [objIDKey release];
    [super dealloc];
}

@end
