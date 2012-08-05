//
//  NTESMBMainMenuController.m
//  NeteaseMicroblog
//
//  Created by cszhan on 1/27/11.
//  Copyright 2011 NetEase.com, Inc. All rights reserved.
//

#import "UIFramework.h"
#import "NEMainTabBarController.h"
#import "NTESMBMainMenuController.h"
@class AppMainUIViewManage;
@class PlayingMenuViewController;
/*
#import "NTESMBHomePageTimelineViewController.h"
#import "NTESMBMyNearbyTimeViewController.h"
*/
#import "NEDebugTool.h"
#import "UIParamsCfg.h"
#import "NETabNavBar.h"
#import <QuartzCore/QuartzCore.h>
static UINavigationController  *gnavViewController = nil;
//static int  tabCount = 0;
@interface NTESMBMainMenuController(privateMethod)
- (void)initMainPageTopNavBarViews;
- (void)initMainPageTabNav;

- (void)initHomePageTimelineNavBar:(CGRect)rect withIndex:(NSInteger)index;
- (void)initMyNewByTimelineNavBar:(CGRect)rect withIndex:(NSInteger)index;
- (void)initMessageBoxTimelineNavBar:(CGRect)rect withIndex:(NSInteger)index;
- (void)initMicroLifteTimelineNavBar:(CGRect)rect withIndex:(NSInteger)inde;
- (void)initMoreNavBar:(CGRect)rect withIndex:(NSInteger)index;

- (void)homePageNavItemPressAction:(id)sender;
- (void)myNearByPageNavItemPressAction:(id)sender;
- (void)messagePageNavItemPressAction:(id)sender;
- (void)microLifePageNavItemPressAction:(id)sender;
- (void)morePageNavItemPressAction:(id)sender;
- (void)updateWithUserDictionary:(NSDictionary *) userDictionary;
@end
BOOL isFromLowMemory = NO;
@implementation NTESMBMainMenuController
//@synthesize mainFramView;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
@synthesize curSelTopNavBar;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {// Custom initialization.
		//[self initView];
       
    }
    return self;
}
-(void)initView{
	/*
	NSString  *imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"mainbtn%d",i] ofType:@"png"];
	assert(imgPath);
	defaultStatusImg =  [UIImage imageWithContentsOfFile:imgPath];
	 */
	/*
	mainView = [[NEAppFrameView alloc]
				//initWithFrame:[[UIScreen mainScreen]bounds]];
				initWithFrame:[[UIScreen mainScreen]bounds]withImageDict:nil withImageDefault:YES];
	 */
	mainView = [[NEAppFrameView alloc]initWithFrame:[[UIScreen mainScreen]bounds] style:NEAppFrameViewDefault|NEAppFrameViewTopBarNone];
	/*
	UIWindow *window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
	[window addSubview:mainView];
	*/
	//self.view = mainView;
	UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"Background.png");
	mainView.bgImage = bgImage;
    mainView.backgroundColor = [UIColor clearColor];
	curSelNavIndex = -1;
	isGbShowTabBar = YES;
	//[self.view addSubview:mainView];
	self.view = mainView;
	//[mainView release];
	//[[UIApplication sharedApplication].keyWindow addSubview:mainView];
}
-(void)loadView{
    
    [super loadView];
    //[self initArchiveData];
    if(topBarViewNavItemArr==nil)
       topBarViewNavItemArr = [[NSMutableArray alloc]init];
	gnavViewController = self.navigationController;
	//NE_LOG(@"%x",gnavViewController);
    if(isFromLowMemory && 0)
    {
        self.view = [self retriveArchiveData];
         //[self initMainMenuControllerUI];
        return;
    }
	[self initView];
    
#if 1
    [self initMainMenuControllerUI];
#endif
}

+(id)sharedAppNavigationController{
	@synchronized(self){
		/*
	if(gnavViewController == nil)
		gnavViewController = [[UINavigationController alloc]init];
		 */
	return  gnavViewController;
	}
}
#pragma mark viewload
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
    
    return;

	mainView.mainFramView.layer.cornerRadius = kMBAppRealViewRadius;
	mainView.mainFramView.layer.masksToBounds = YES;
#ifdef SYSTABBAR
	[mainView.mainFramView addSubview:tabController.view];
#else
	//UIView *subMainView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kDeviceScreenWidth, kDeviceScreenHeight-20.f-kMBAppBottomToolBarHeght)];
    if(mainTabBarVC == nil)
    {
        //mainTabBarVC = [[NEMainTabBarController alloc]initWithNibName:nil bundle:nil];
        NSArray *vcControllers = nil;
        if(delegate && [delegate respondsToSelector:@selector(viewcontrollersForTabBarController:)])
        {
            vcControllers = [delegate viewcontrollersForTabBarController:self];
        
        }
        mainTabBarVC = [[NEMainTabBarController alloc]initMainTabBarController:vcControllers];
    }
	//UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mainTabBarVC];
	//gnavViewController = navController;
	//navController.navigationBarHidden = YES;
	//[subMainView addSubview:navController.view];
	mainTabBarVC.view.frame = CGRectMake(0.f, 0.f, kDeviceScreenWidth, kDeviceScreenHeight);
	[mainView.mainFramView addSubview:mainTabBarVC.view];
	
	/*
	mainView.frame = CGRectOffset(mainView.frame, 0.,-44.f); //(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
	mainView.mainFramView.frame = CGRectOffset(mainView.mainFramView.frame, 0., -44.f);
	*/
	NE_LOGRECT(self.view.frame);
	NE_LOGRECT(mainView.frame);
	NE_LOGRECT(mainView.mainFramView.frame);
#endif

	[self initMainPageTopNavBarViews];
	[self initMainPageTabNav:2];

    
	/*
	UIViewController *test = [[NTESMBLoginViewController alloc] initWithNibName:@"NTESMBLoginViewController" bundle:nil];
	[self.navigationController presentModalViewController:test  animated:YES];
	 */
	// CGRect startusBarFrame = [[UIApplication sharedApplication]statusBarFrame];
	// NE_LOG(@"AppStatusBar");
	// NE_LOGRECT(startusBarFrame);
	//CGFloat appStartY = startusBarFrame.size.height;
	//CGRect appScreenBounds =  [[UIScreen mainScreen]bounds];
	//NE_LOGRECT(appScreenBounds);
	//self.view.frame = CGRectMake(0.f,appStartY, appScreenBounds.size.width, appScreenBounds.size.height-appStartY);
	//NE_LOGRECT(self.view.frame);
      //viewcontrollerArr = [[NSMutableArray alloc]init];
	//[mainView.mainFramView setNeedsDisplay];
    /*
    NTESMBHomePageTimelineViewController *homePageViewController = [[NTESMBHomePageTimelineViewController alloc]init]; 
    [viewcontrollerArr addObject:homePageViewController];
    [homePageViewController release];
    //[self menuNavItemPress:btn];
   */
}
-(void)initMainMenuControllerUI{

    mainView.mainFramView.layer.cornerRadius = kMBAppRealViewRadius;
	mainView.mainFramView.layer.masksToBounds = YES;
#ifdef SYSTABBAR
	[mainView.mainFramView addSubview:tabController.view];
#else
	//UIView *subMainView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kDeviceScreenWidth, kDeviceScreenHeight-20.f-kMBAppBottomToolBarHeght)];
    int tabSelIndex = -1;
   if(mainTabBarVC == nil )
    {
        NSArray *vcControllers = nil;
        if(delegate && [delegate respondsToSelector:@selector(viewcontrollersForTabBarController:)])
        {
            vcControllers = [delegate viewcontrollersForTabBarController:self];
            
        }
        mainTabBarVC = [[NEMainTabBarController alloc]initMainTabBarController:vcControllers];
        tabSelIndex = 0;
        //mainTabBarVC.view = 
    }
   else 
   {
       tabSelIndex = [[mainTabBarVC getTabNavBar]getTabNavSelectIndex];
   }
	//UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mainTabBarVC];
	//gnavViewController = navController;
	//navController.navigationBarHidden = YES;
	//[subMainView addSubview:navController.view];
	mainTabBarVC.view.frame = CGRectMake(0.f, 0.f, kDeviceScreenWidth, kDeviceScreenHeight);
	[mainView.mainFramView addSubview:mainTabBarVC.view];
	
	/*
     mainView.frame = CGRectOffset(mainView.frame, 0.,-44.f); //(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
     mainView.mainFramView.frame = CGRectOffset(mainView.mainFramView.frame, 0., -44.f);
     */
	NE_LOGRECT(self.view.frame);
	NE_LOGRECT(mainView.frame);
	NE_LOGRECT(mainView.mainFramView.frame);
#endif
    //init top nav
    //if(isFromLowMemory)
    {
        //[self initMainPageTopNavBarViews];
        
        [self initMainPageTabNav:kTabCountMax];
        /*
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[topBarViewNavItemArr objectAtIndex:tabSelIndex] forKey:@"topitem"];
        */
        [self didSelectorTabItem:tabSelIndex];
    }
}
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[mainTabBarVC viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    isFromLowMemory = YES;
    //[self saveViewData:self.view];
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark  mainTabNavview
-(void)initMainPageTabNav:(NSInteger)tabCount
{
	NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];

	UIImage  *defaultStatusImg = nil;
	UIImage  *selectStatusImg  = nil;
	NSString *imgPath = nil;
    NSArray *textArr = [kTabAllItemText componentsSeparatedByString:@","];
    NSArray *textOffsetXArr = [kTabAllItemTextCenterXOffset componentsSeparatedByString:@","];
    NSArray *textOffsetYArr = [kTabAllItemTextCenterYOffset componentsSeparatedByString:@","];
	for(int i = 0; i<tabCount;i++)
	{
		UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
		/*
		 imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"mainpagebtn%d",i] ofType:@"png"];
		 bgImag =  [UIImage imageWithContentsOfFile:imgPath];
		 */
		imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:kTabItemNarmalImageFileNameFormart,i] ofType:kTabItemImageSubfix];
		assert(imgPath);
		defaultStatusImg =  [UIImage imageWithContentsOfFile:imgPath];
		imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:kTabItemSelectImageFileNameFormart,i] ofType:kTabItemImageSubfix];
		assert(imgPath);
		selectStatusImg =  [UIImage imageWithContentsOfFile:imgPath];
		//[btn setBackgroundImage:bgImag forState:UIControlStateNormal];
		[btn setImage:defaultStatusImg forState:UIControlStateNormal];
		[btn setImage:selectStatusImg forState:UIControlStateSelected];
		//[btn setBackgroundImage:statusImg forState:UIControlStateNormal];
		btn.frame = CGRectMake(0.f,0.f,defaultStatusImg.size.width/kScale, defaultStatusImg.size.height/kScale);
		//[mainView.mainFramView addSubview:btn];
		NE_LOG(@"btn frame");
		NE_LOGRECT(btn.frame);
        //add text label
        UILabel *btnTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0., btn.frame.size.height-kTabItemTextHeight, btn.frame.size.width, kTabItemTextHeight)];
        btnTextLabel.backgroundColor = [UIColor clearColor];
        //btnTextLabel.center = 
        btnTextLabel.text = NSLocalizedString([textArr objectAtIndex:i],@"");
        btnTextLabel.textColor = [UIColor whiteColor];
        btnTextLabel.font = kTabItemTextFont;
        btnTextLabel.textAlignment = UITextAlignmentCenter;
        btnTextLabel.frame = CGRectOffset(btnTextLabel.frame,[[textOffsetXArr objectAtIndex:i]floatValue], [[textOffsetYArr objectAtIndex:i]floatValue]);
        [btn addSubview:btnTextLabel];
        [btnTextLabel release];
		[arr addObject:btn];
		//[mainView.bottomBarView addSubview:testView];
		//UIImage  *selectStatusImg = [UIImage imageWithContentsOfFile:imgPath];
	}
	//	mainView.bottomBarView = [[NETabNavBar alloc]
	//							  initWithFrame:CGRectMake(0.f, 0.f, kDeviceScreenWidth, mainView.bottomBarView.frame.size.height)
	//													withNavItem:arr withSplitTag:nil];
#if 1
	UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,kTabBarViewBGImageFileName);
	NETabNavBar *tabView = [[NETabNavBar alloc]
							initWithFrame:CGRectMake(0.f,kTabBarViewOffsetY, kDeviceScreenWidth,kMBAppBottomToolBarHeght-kTabBarViewOffsetY)
							withNavItem:arr withSplitTag:nil];
	tabView.backgroundColor = [UIColor clearColor];
    [tabView setBgImage:bgImage];
    //tabView.frame = CGRectOffset(tabView.o, <#CGFloat dx#>, <#CGFloat dy#>)
#if 1
    // 增加渐变图    
    bgImage = nil;
    CGFloat height = 0.f;
    CGFloat width = 0.f;
	UIImageWithFileName(bgImage,kTabBarAndViewControllerSepratorImageFileName);
    if(bgImage)
    {
        UIImageView *splitView = [[UIImageView alloc]initWithImage:bgImage];
        height = bgImage.size.height/kScale;
        width = bgImage.size.width/kScale;
        [tabView addSubview:splitView];
        splitView.frame = CGRectMake(0.f,-height,width,height);
        //UITabBar
        [splitView release];
    }
    bgImage = nil;
	UIImageWithFileName(bgImage,kTabBarItemMaskImageFileName);
    //tab item mask
    if(bgImage)
    {
        tabItemMaskView = [[UIImageView alloc]initWithImage:bgImage];
        height = bgImage.size.height/kScale;
        width = bgImage.size.width/kScale;
        //the start Y offset of the tab bar 
        CGFloat offsetY = bgImage.size.height/kScale - tabView.frame.size.height;
        [tabView addSubview:tabItemMaskView];
        tabItemMaskView.frame = CGRectMake(0.f,-offsetY,width,height);
        tabItemMaskView.hidden = YES;
        [tabItemMaskView release];
    }
#endif 
	[mainTabBarVC setTabNavBar:tabView];
	tabView.tabNavBarcontroller = nil;
	//tabView.navItemVc = 
	NE_LOG(@"%@",[tabView description]);
	//associate the top nav item
	tabView.topBarViewArr = topBarViewNavItemArr;
	tabView.delegate = self;
	if(isGbShowTabBar && 0)
	{
		AppMainUIViewManage *appUIMgr= [AppMainUIViewManage getSingleTone];
		[appUIMgr setCurrentTabBar:tabView];
		tabView.frame = CGRectMake(0.f , kMBAppStatusBar+kMBAppTopToolBarHeight+kMBAppRealViewHeight, kMBAppRealViewWidth, kMBAppBottomToolBarHeght);
		[[appUIMgr window] addSubview:tabView];
	}
	else
	{
		
		[mainView.bottomBarView addSubview:tabView];
        [tabView release];
        //[mainView.bottomBarView setNeedsDisplay];
	}
	
#else
	NETabNavBar *tabView =  [NETopNavMainMenuController sharedTabNavBar];
	tabView.backgroundColor = [UIColor clearColor];
	tabView.tabNavBarcontroller = tabController;
	//associate the top nav item
	tabView.topBarViewArr = topBarViewNavItemArr;
	tabView.delegate = self;
	tabView.frame = CGRectMake(0.f,0.f, kMBAppRealViewWidth, kMBAppBottomToolBarHeght);
	NE_LOGRECT(tabView.frame);
	[[UIApplication sharedApplication].keyWindow addSubview:tabView];
#endif
}
#pragma mark tab navigation item select delegate
-(void)didSelectorNavBarItem:(NSDictionary*)navObj{
    
    NSInteger selIndex = [[navObj objectForKey:@"navitem"]tag];
#if 1   
	NE_LOG(@"subviews:%d",[[mainView.topBarView subviews] count]);
	for(UIView *subview in [mainView.topBarView subviews])
    {
		[subview removeFromSuperview];
	}
	//UITabBarController
	if(isGbShowTabBar && 0)
	{
		for(UIView *subView in [mainView.mainFramView subviews]){
			[subView removeFromSuperview];
		}
		//need to return home page
		if(selIndex == curSelNavIndex){
			[gnavViewController popToRootViewControllerAnimated:YES];
		}
		else {
			for(UIView *subView in [UIApplication sharedApplication].keyWindow.subviews){
				if([subView isKindOfClass:[NETopNavBar class]]){
				}
                else if([subView isKindOfClass:[NEAppFrameView class]]){
					
					
                }
                else if([subView isKindOfClass:[NETabNavBar class]]){
					
                }
                else{
                    [subView removeFromSuperview];
                }
				//NE_LOG(@"%d",[[UIApplication sharedApplication].keyWindow.subviews count]);
			}
			
		}
		//for(UIView *subView in [UIApplication sharedApplication].keyWindow
		//UIViewController *selectvc = nil; 
		[mainTabBarVC didNavItemSelect:[NSNumber numberWithInt:selIndex]];
		UIViewController *nav = mainTabBarVC.currentViewController;
		nav.view.frame = CGRectMake(0.f,44.f,kDeviceScreenWidth, kMBAppRealViewHeight);
		[[UIApplication sharedApplication].keyWindow addSubview:nav.view];
		//[mainTabBarVC didNavItemSelect:[NSNumber numberWithInt:selIndex]];
		
	}
	curSelTopNavBar = [topBarViewNavItemArr objectAtIndex:[[navObj objectForKey:@"navitem"]tag]];
	curSelTopNavBar = [navObj objectForKey:@"topitem"];
	[mainView.topBarView addSubview:curSelTopNavBar];
	NE_LOG(@"select item:%d",[[navObj objectForKey:@"navitem"]tag]);
#endif  
	[mainTabBarVC didNavItemSelect:[NSNumber numberWithInt:selIndex]];
}
-(void)didSelectorNavBarItemIndex:(NSInteger)index
{
    [self didSelectorTabItem:index];
    
}
-(void)didSelectorTabItem:(NSInteger)index
{
    
    NETabNavBar *tabBar = [mainTabBarVC getTabNavBar];
    UIView *item = [tabBar getCurrentSelItem];
    CGPoint newcenter = [item center];
    CGPoint oldCenter = tabItemMaskView.center;
    oldCenter.x = newcenter.x;
    tabItemMaskView.center = oldCenter;
    tabItemMaskView.hidden = NO;
    [mainTabBarVC didNavItemSelect:[NSNumber numberWithInt:index]];
    [tabBar didNavItemSelect:[NSNumber numberWithInt:index]];
    
}
- (void)dealloc 
{
	[gnavViewController release];
	[mainTabBarVC release];
	[super dealloc];
}
#pragma mark ====================================================

#if 0
#pragma mark tabBarItem
/*
 * 
 */
-(void)initMainPageTopNavBarViews{
	//hometimeline navigation Bar 
	tabCount  = 0;
	[self initHomePageTimelineNavBar:CGRectMake(0.f, 0.f, kDeviceScreenWidth, kMBAppTopToolBarHeight) withIndex:tabCount++];
	//[self 
	/*
	//[self initMyNewByTimelineNavBar:CGRectMake(0.f, 0.f, kDeviceScreenWidth, kMBAppTopToolBarHeight) withIndex:1];
	[self initMessageBoxTimelineNavBar:CGRectMake(0.f, 0.f, kDeviceScreenWidth, kMBAppTopToolBarHeight) withIndex:2];
	[self initMicroLifteTimelineNavBar:CGRectMake(0.f, 0.f, kDeviceScreenWidth, kMBAppTopToolBarHeight) withIndex:3];
	*/
	[self initMoreNavBar:CGRectMake(0.f, 0.f, kDeviceScreenWidth, kMBAppTopToolBarHeight) withIndex:tabCount++];
	

}
-(void)initHomePageTimelineNavBar:(CGRect)rect withIndex:(NSInteger)index{
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
	UIImageWithFileName(bgImage,@"Btn_back.png");
	//UIImage *bgImageS = nil;
	//UIImageWithFileName(bg
	[btn setBackgroundImage:bgImage forState:UIControlStateNormal];
	UIImageWithFileName(bgImage,@"Btn_back_s.png");
	[btn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
	//|UIControlStateHighlighted|UIControlStateSelected
	btn.frame = CGRectMake(kMBAppTopToolYPending,kMBAppTopToolYPending,bgImage.size.width/2.0, bgImage.size.height/2.0);
	//[mainView.mainFramView addSubview:btn];
	NE_LOG(@"btn frame");
	NE_LOGRECT(btn.frame);
	btn.hidden = YES;
	[arr addObject:btn];
	
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
	UIImageWithFileName(bgImage,@"Btn_playing.png");
	[btn setBackgroundImage:bgImage forState:UIControlStateNormal];
	
	UIImageWithFileName(bgImage,@"Btn_playing_s.png");
	[btn setBackgroundImage:bgImage forState:UIControlStateSelected];
	
	//|UIControlStateHighlighted|UIControlStateSelected
	btn.frame = CGRectMake(kDeviceScreenWidth-bgImage.size.width/2.0,kMBAppTopToolYPending,bgImage.size.width/2.0, bgImage.size.height/2.0);
	[arr addObject:btn];
	//CGRect rect = CGRectMake(0.f, 0.f, kDeviceScreenWidth, kMBAppTopToolBarHeight);
	
	UIImageWithFileName(bgImage,@"Bar_top.png");
	NETopNavBar  *tempNavBar= [[NETopNavBar alloc]
							   initWithFrame:rect withBgImage:bgImage withBtnArray:arr selIndex:-1];
	
	//tempNavBar.navTitle = ;
	tempNavBar.delegate = self;
	tempNavBar.navTitle = @"天天动听"; 
	[topBarViewNavItemArr insertObject:tempNavBar atIndex:index];
	[tempNavBar release]; 
	
}
-(void)initMyNewByTimelineNavBar:(CGRect)rect withIndex:(NSInteger)index{
	/*
	NETopNavBar  *tempNavBar= [[NETopNavBar alloc]
							   initWithFrame:rect withBtnArray:arr isEqualSplit:YES];
	*/
	NSMutableArray *arr = [NSMutableArray arrayWithCapacity:3];
	UIImage *bgImage = nil;
	UIImage  *defaultStatusImg = nil;
	UIImage  *selectStatusImg  = nil;
	NSString *imgPath = nil;
	CGFloat startx = 0.f;
	
	UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
	/*
	 imgPath = [[NSBundle mainBundle] pathForResource:@"postblog" ofType:@"png"];
	 assert(imgPath);
	 bgImage =  [UIImage imageWithContentsOfFile:imgPath];
	 */
	UIImageWithFileName(bgImage,@"postblog.png");
	[btn setBackgroundImage:bgImage forState:UIControlStateNormal];
	//|UIControlStateHighlighted|UIControlStateSelected
	btn.frame = CGRectMake(kMBAppTopToolYPending,kMBAppTopToolYPending,bgImage.size.width, bgImage.size.height);
	[arr addObject:btn];
	
	for(int i = 0; i<2;i++)
	{
		UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
		/*
		 imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"mainpagebtn%d",i] ofType:@"png"];
		 bgImag =  [UIImage imageWithContentsOfFile:imgPath];
		 */
		imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"nearby%d",i] ofType:@"png"];
		assert(imgPath);
		defaultStatusImg =  [UIImage imageWithContentsOfFile:imgPath];
		imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"nearbysel%d",i] ofType:@"png"];
		assert(imgPath);
		selectStatusImg =  [UIImage imageWithContentsOfFile:imgPath];
		if(i == 0){
			startx = kDeviceScreenWidth/2.f-defaultStatusImg.size.width;
		}
		//[btn setBackgroundImage:bgImag forState:UIControlStateNormal];
		[btn setImage:defaultStatusImg forState:UIControlStateNormal];
		[btn setImage:selectStatusImg forState:UIControlStateSelected];
		//[btn setBackgroundImage:statusImg forState:UIControlStateNormal];
		btn.frame = CGRectMake(startx,0.f,defaultStatusImg.size.width, defaultStatusImg.size.height);
		startx = startx + defaultStatusImg.size.width;
		//[mainView.mainFramView addSubview:btn];
		NE_LOG(@"btn frame");
		NE_LOGRECT(btn.frame);
		[arr addObject:btn];
		//[mainView.bottomBarView addSubview:testView];
		//UIImage  *selectStatusImg = [UIImage imageWithContentsOfFile:imgPath];
	}
	UIImageWithFileName(bgImage,@"header-bg.png");
	NETopNavBar  *tempNavBar= [[NETopNavBar alloc]
							   initWithFrame:rect  withBgImage:bgImage withBtnArray:arr selIndex:1];
	tempNavBar.delegate = self;
	[topBarViewNavItemArr insertObject:tempNavBar atIndex:index];
	[tempNavBar release]; 
}
- (void)initMessageBoxTimelineNavBar:(CGRect)rect withIndex:(NSInteger)index{
	NSMutableArray *arr = [NSMutableArray arrayWithCapacity:3];
	
	UIImage  *defaultStatusImg = nil;
	UIImage  *selectStatusImg  = nil;
	NSString *imgPath = nil;
	CGFloat startx = 0.f;	for(int i = 0; i<3;i++)
	{
		UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
		/*
		 imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"mainpagebtn%d",i] ofType:@"png"];
		 bgImag =  [UIImage imageWithContentsOfFile:imgPath];
		 */
		imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"private%d",i] ofType:@"png"];
		assert(imgPath);
		defaultStatusImg =  [UIImage imageWithContentsOfFile:imgPath];
		imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"privatesel%d",i] ofType:@"png"];
		assert(imgPath);
		selectStatusImg =  [UIImage imageWithContentsOfFile:imgPath];
		//[btn setBackgroundImage:bgImag forState:UIControlStateNormal];
		[btn setImage:defaultStatusImg forState:UIControlStateNormal];
		[btn setImage:selectStatusImg forState:UIControlStateSelected];
		//[btn setBackgroundImage:statusImg forState:UIControlStateNormal];
		btn.frame = CGRectMake(startx,0.f,defaultStatusImg.size.width, defaultStatusImg.size.height);
		startx = startx + defaultStatusImg.size.width;
		//[mainView.mainFramView addSubview:btn];
		NE_LOG(@"btn frame");
		NE_LOGRECT(btn.frame);
		[arr addObject:btn];
		//[mainView.bottomBarView addSubview:testView];
		//UIImage  *selectStatusImg = [UIImage imageWithContentsOfFile:imgPath];
	}
	NETopNavBar  *tempNavBar= [[NETopNavBar alloc]
							   initWithFrame:rect  withBgImage:nil withBtnArray:arr selIndex:0];
	tempNavBar.delegate = self;
	[topBarViewNavItemArr insertObject:tempNavBar atIndex:index];
	[tempNavBar release]; 
}

- (void)initMicroLifteTimelineNavBar:(CGRect)rect withIndex:(NSInteger)index{
	NSMutableArray *arr = [NSMutableArray arrayWithCapacity:3];
	UIImage *bgImage = nil;
	UIImage  *defaultStatusImg = nil;
	UIImage  *selectStatusImg  = nil;
	NSString *imgPath = nil;
	CGFloat startx = 0.f;
	for(int i = 0; i<3;i++)
	{
		UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
		/*
		 imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"mainpagebtn%d",i] ofType:@"png"];
		 bgImag =  [UIImage imageWithContentsOfFile:imgPath];
		 */
		imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"microlife%d",i] ofType:@"png"];
		assert(imgPath);
		defaultStatusImg =  [UIImage imageWithContentsOfFile:imgPath];
		imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"microlifesel%d",i] ofType:@"png"];
		assert(imgPath);
		selectStatusImg =  [UIImage imageWithContentsOfFile:imgPath];
		//[btn setBackgroundImage:bgImag forState:UIControlStateNormal];
		[btn setImage:defaultStatusImg forState:UIControlStateNormal];
		[btn setImage:selectStatusImg forState:UIControlStateSelected];
		//[btn setBackgroundImage:statusImg forState:UIControlStateNormal];
		btn.frame = CGRectMake(startx,0.f,defaultStatusImg.size.width/2.0, defaultStatusImg.size.height/2.0);
		startx = startx + defaultStatusImg.size.width;
		//[mainView.mainFramView addSubview:btn];
		NE_LOG(@"btn frame");
		NE_LOGRECT(btn.frame);
		[arr addObject:btn];
		//[mainView.bottomBarView addSubview:testView];
		//UIImage  *selectStatusImg = [UIImage imageWithContentsOfFile:imgPath];
	}
	UIImageWithFileName(bgImage,@"header-bg.png");
	NETopNavBar  *tempNavBar= [[NETopNavBar alloc]
							   initWithFrame:rect  withBgImage:bgImage withBtnArray:arr selIndex:0];
	[topBarViewNavItemArr insertObject:tempNavBar atIndex:index];
	tempNavBar.delegate = self;
	[tempNavBar release]; 
	
}
- (void)initMoreNavBar:(CGRect)rect withIndex:(NSInteger)index{
	NSMutableArray *arr = [NSMutableArray array];
	UIImage  *bgImage = nil;
	UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
	/*
	 imgPath = [[NSBundle mainBundle] pathForResource:@"postblog" ofType:@"png"];
	 assert(imgPath);
	 bgImage =  [UIImage imageWithContentsOfFile:imgPath];
	 */
	UIImageWithFileName(bgImage,@"Btn_back.png");
	//UIImage *bgImageS = nil;
	//UIImageWithFileName(bg
	[btn setBackgroundImage:bgImage forState:UIControlStateNormal];
	UIImageWithFileName(bgImage,@"Btn_back_s.png");
	[btn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
	//|UIControlStateHighlighted|UIControlStateSelected
	btn.frame = CGRectMake(kMBAppTopToolYPending,kMBAppTopToolYPending,bgImage.size.width/2.0, bgImage.size.height/2.0);
	//[mainView.mainFramView addSubview:btn];
	NE_LOG(@"btn frame");
	NE_LOGRECT(btn.frame);
	[arr addObject:btn];
	btn.hidden = YES;
	btn = [UIButton buttonWithType:UIButtonTypeCustom];
	/*
	 imgPath = [[NSBundle mainBundle] pathForResource:@"camera" ofType:@"png"];
	 assert(imgPath);
	 bgImag =  [UIImage imageWithContentsOfFile:imgPath];
	 */
	//UIImageScaleWithFileName(bgImage,@"camera");
	UIImageWithFileName(bgImage,@"Btn_playing.png");
	[btn setBackgroundImage:bgImage forState:UIControlStateNormal];
	
	UIImageWithFileName(bgImage,@"Btn_playing_s.png");
	[btn setBackgroundImage:bgImage forState:UIControlStateSelected];
	
	//|UIControlStateHighlighted|UIControlStateSelected
	btn.frame = CGRectMake(kDeviceScreenWidth-bgImage.size.width/2.0,kMBAppTopToolYPending,bgImage.size.width/2.0, bgImage.size.height/2.0);
	[arr addObject:btn];
	
	//UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"Bar_top.png");
	NETopNavBar  *tempNavBar= [[NETopNavBar alloc]
							   initWithFrame:rect  withBgImage:bgImage withBtnArray:arr selIndex:-1];
	[topBarViewNavItemArr insertObject:tempNavBar atIndex:index];
	tempNavBar.navTitle = @"设置";
	tempNavBar.delegate = self;
	[tempNavBar release]; 
  
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark top item  select delegate
-(void)didSelectorTopNavItem:(id)navObj{
	NE_LOG(@"select item:%d",[navObj tag]);
	//NE_LOG(@"subviews:%d",[[mainView.topBarView subviews] count]);
	UIButton *btn = (UIButton*)navObj;
	switch (curSelNavIndex) 
    {
		case 0://main page
			[self homePageNavItemPressAction:btn];
			break;
		case 1://my nearby
			[self myNearByPageNavItemPressAction:btn];
			break;
		case 2://messagebox
			[self messagePageNavItemPressAction:btn];
			break;
		case 3://micro life
			[self microLifePageNavItemPressAction:btn];
			break;
		case 4://more
			[self morePageNavItemPressAction:btn];
			break;
		default:
			break;
	}

}
#pragma mark mainMenu nav Item press action
/*
 * home page two button action
 * post		blog
 * camera		blog
 */
- (void) homePageNavItemPressAction:(id)sender
{
#if 0
    AppMainUIViewManage *appUIMgr = [AppMainUIViewManage getSingleTone];
	PlayingMenuViewController *playingMenuVc = [[PlayingMenuViewController alloc]init];
	[appUIMgr setIsShouldHiddenTabBarWhenPush:YES];
	[appUIMgr pushNewViewController:playingMenuVc];
	[playingMenuVc release];
#endif

}
-(void)setMyNearByNavItemStatus:(NSInteger)index{
	//don't need to chang the post blog button status
	NSArray *btnarr = curSelTopNavBar.navBtnArray;
	//NSArray *btnarr = curSelTopNavBar.navBtnArray;
	for(int i = 1;i<[btnarr count];i++){
		UIButton *item  = [btnarr objectAtIndex:i];
		if(i == index){
			item.selected = YES;
		}
		else {
			item.selected = NO;
		}
	}
}
- (void)myNearByPageNavItemPressAction:(id)sender{
	NE_LOG(@"my nearbypage item press");
	if([sender tag] == 0) 
    {
		//post blog
	}
	else {
		
	}

}
-(void)changeNavItemStatus:(NSInteger)index{
	//don't need to chang the post blog button status
	NSArray *btnarr = curSelTopNavBar.navBtnArray;
	//NSArray *btnarr = curSelTopNavBar.navBtnArray;
	for(int i = 0;i<[btnarr count];i++){
		UIButton *item  = [btnarr objectAtIndex:i];
		if(i == index){
			item.selected = YES;
		}
		else {
			item.selected = NO;
		}
		
	}
}
-(void)switchMessagePageView:(id)sender{
	
}
- (void)messagePageNavItemPressAction:(id)sender{
	NE_LOG(@"my message item press");
	[self changeNavItemStatus:[sender tag]]; 
	[self switchMessagePageView:sender];
	/*
	NTESMBMyNearbyTimeViewController *nearbycontroller = (NTESMBMyNearbyTimeViewController *)[[navigationController viewControllers] objectAtIndex:0];
	[nearbycontroller handleNavItemClick:sender];
	switch ([sender tag]) {
		case 0://post blog
			break;
		case 1:// list timelie view
			//[self messagePageNavItemStatus:[sender tag]]; 
			break;
		case 2:// map view
			//[self messagePageNavItemStatus:[sender tag]]; 
			break;
		default:
			break;
	}
	*/
}
- (void)microLifePageNavItemPressAction:(id)sender{
	NE_LOG(@"microLife item press");
	[self changeNavItemStatus:[sender tag]];  
	switch ([sender tag]) {
		case 0://post blog
			break;
		case 1:// list timelie view
			//[self messagePageNavItemStatus:[sender tag]]; 
			break;
		case 2:// map view
			//[self messagePageNavItemStatus:[sender tag]]; 
			break;
		default:
			break;
	}
}
- (void) morePageNavItemPressAction:(id)sender
{
	
}
#pragma mark mainMenu contentView push action
-(void)willMFContentViewPushViewController:(UIViewController*)viewController withTopNavBar:(NETopNavBar*)topNavBar animated:(BOOL)animated{
	
}
-(void)willMFContentViewPopViewController:(UIViewController*)viewController withTopNavBar:(NETopNavBar*)topNavBar{
	
	
}
-(IBAction)menuNavItemPress:(id)sender
{
	//int curIndex = tabController.selectedIndex;
	int index = [sender tag];
	//mainTabBarVC.selectedIndex = index;
	//UIViewController * selviewcontroller = [viewcontrollerArr objectAtIndex:index	];
//	[navViewController popToRootViewControllerAnimated:NO];
//	[navViewController pushViewController:selviewcontroller animated:NO];
	//switch (index) {
//		case 0:{
//			//[[mainFramView.subviews objectAtIndex:0] removeFromSuperview];
//			
//			break;
//		}
//		default:
//			break;
//	}

}
/*
#pragma mark mainMenu content item press action 
-(void)
*/

/*
#pragma mark -
#pragma mark RequestDelegate
- (void) requestCompleted:(NTESMBRequest *) request{
	@try {
		NSArray * notices = [[request getTextWithEncoding:NSGBKStringEncoding] JSONValue];
		//get notice version
		NSInteger version = [[NSUserDefaults standardUserDefaults] integerForKey:K_NOTICE_VERSION];
		//NE_LOG(@"[version][%d]",version);
		for (NSDictionary * dict in notices) {
			NSInteger noticeVersion = [[dict objectForKey:@"version"] integerValue];
			if (noticeVersion<version) {
				continue;
			}
			if (noticeVersion==version) {
				NSInteger times = [[dict objectForKey:@"times"] integerValue];
				if (times!=0) {
					continue;
				}
			}
			
			NSString *appVersion = [dict objectForKey:@"app_version"];
			if (appVersion!=nil) {
				NSString *myVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
				if (![appVersion isEqualToString:myVersion]&&[appVersion rangeOfString:myVersion].location == NSNotFound) {
					continue;
				}
			}
			
			//if we arrive here, we will notice user
			NTESMBDialog *dialog = [[NTESMBDialog alloc] initWithDictionary:dict];
			NE_LOG(@"show notice[%d]",noticeVersion);
			[dialog show];
			[[NSUserDefaults standardUserDefaults] setInteger:noticeVersion forKey:K_NOTICE_VERSION];
			[[NSUserDefaults standardUserDefaults] synchronize];
			break;
			
		}
	}
	@catch (NSException * e) {
		
	}
}
- (void) requestFailed:(NTESMBRequest *) request{
}
*/
#endif
@end
