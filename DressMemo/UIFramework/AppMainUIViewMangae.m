//
//  untitled.m
//  MP3Player
//
//  Created by cszhan on 12-1-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AppMainUIViewManage.h"
#import "UIFrameworkMSG.h"
#import "NTESMBMainMenuController.h"
#import "NETabNavBar.h"
#import "UIParamsCfg.h"

#import "DressWhatViewController.h"
#import "PhotoUploadViewController.h"
#import "MyProfileViewController.h"

#define USER_LOGIN

#ifdef  USER_LOGIN
#import "LoginAndResignMainViewController.h"
#import "AppSetting.h"
#endif
@class GMusicPlayMgr;

static AppMainUIViewManage *sharedObj = nil;
static NETabNavBar *currentTabBar = nil;
static NTESMBMainMenuController *mainVC = nil;
static UINavigationController *currentNavgationController = nil;
@implementation AppMainUIViewManage
@synthesize isShouldHiddenTabBarWhenPush;
@synthesize window;

#if 1
-(void)addObserveMsg
{
	//[[GMusicPlayMgr getSingleTone] startRegisterBackGroundPlay];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNewViewControllerFromMsg:) name:kPushNewViewController object:nil];
    [ZCSNotficationMgr addObserver:self call:@selector(popAllViewControllerFromMsg:) msgName:kPopAllViewController];
    [ZCSNotficationMgr addObserver:self call:@selector(presentViewControllerFromMsg:) msgName:kPresentModelViewController];
    [ZCSNotficationMgr addObserver:self call:@selector(dismissViewControllerFromMsg:) msgName:kDisMissModelViewController]; 
    //addObserver:s forKeyPath:<#(NSString *)keyPath#> options:<#(NSKeyValueObservingOptions)options#> context:<#(void *)context#> ]
	[ZCSNotficationMgr addObserver:self call:@selector(didUserLoginOkFromMsg:) msgName:kUserDidLoginOk];
    [ZCSNotficationMgr addObserver:self call:@selector(didUserResignOkFromMsg:) msgName:kUserDidResignOK];
}
#endif
+(id)getSingleTone{
	@synchronized(self){
		if(sharedObj == nil){
			sharedObj = [[self alloc]init];
			[sharedObj addObserveMsg];
		}
		return sharedObj;
	}
}
-(void)addMainViewUI{
	/*
	NSNotificationCenter *ntfCenter = [NSNotificationCenter defaultCenter];
	[ntfCenter addObserver:self selector:@selector(change name:@"" object:];
	 */
	//UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kDeviceScreenWidth, kDeviceScreenHeight)];

	mainVC = [[NTESMBMainMenuController alloc]init];
    mainVC.delegate = self;
    
#if 1
	UINavigationController *navCtrl = [[UINavigationController alloc]initWithRootViewController:mainVC];
    navCtrl.navigationBar.tintColor = [UIColor redColor];//[UIColor colorWithPatternImage:];
	navCtrl.navigationBarHidden = YES;
	currentNavgationController = navCtrl;
	//navCtrl.delegate = self;
    [self.window addSubview:navCtrl.view];
#else
	[self.window addSubview:mainVC.view];
#endif
    NSString *loginUser = [AppSetting getCurrentLoginUser];
    NSString *loginUserId = [AppSetting getLoginUserId];
    NSDictionary *loginUserData = nil;
    if(loginUser)
    {
        loginUserData = [AppSetting getLoginUserInfo:loginUser];
    }
    if(loginUser == nil ||loginUserData == nil||loginUserId== nil)
    {
        LoginAndResignMainViewController *loginMainVc = [[LoginAndResignMainViewController alloc]init];
        UINavigationController *navCtrl = [[UINavigationController alloc]initWithRootViewController:loginMainVc];
        //navCtrl.navigationBar.tintColor = [UIColor redColor];//[UIColor colorWithPatternImage:];
        [loginMainVc release];
        navCtrl.navigationBarHidden = YES;
        [ZCSNotficationMgr postMSG:kPresentModelViewController obj:navCtrl];
         
    }
    
  
	//[mainView addSubview:navCtrl.view];
	
}
#pragma mark create tabBar viewcontrollers delegate
-(NSArray*)viewcontrollersForTabBarController:(NTESMBMainMenuController*)controller;
{

    //return 0;
    NSMutableArray *_navControllersArr = [NSMutableArray arrayWithCapacity:100];
    UIViewController *vcontroller1 = [[DressWhatViewController alloc]init];
    //[vcontroller1 setNavgationBarTitle:kPlayListVCTitle];
    
#if 1
    UINavigationController *navCtrl1 = [[UINavigationController alloc]initWithRootViewController:vcontroller1];
    
    navCtrl1.navigationBarHidden = YES;
    //navCtrl1.delegate = self;
    navCtrl1.view.frame = CGRectMake(0.f, 0.f, kDeviceScreenWidth, kDeviceScreenHeight);
    [_navControllersArr addObject:navCtrl1];
    
    [vcontroller1 release];
    [navCtrl1 release];
#endif
    UIViewController *vcontroller2 = [[PhotoUploadViewController alloc]init];
    UINavigationController *navCtrl2 = [[UINavigationController alloc]initWithRootViewController:vcontroller2];
    navCtrl2.navigationBarHidden = YES;
    //navCtrl2.delegate = self;
    navCtrl2.view.frame = CGRectMake(0.f, 0.f, kDeviceScreenWidth, kDeviceScreenHeight);
    [_navControllersArr addObject:navCtrl2];
    
    [navCtrl2 release];
    [vcontroller2 release];
    
    UIViewController *vcontroller3 = [[MyProfileViewController alloc]init];
    UINavigationController *navCtrl3 = [[UINavigationController alloc]initWithRootViewController:vcontroller3];
    navCtrl3.navigationBarHidden = YES;
    //navCtrl2.delegate = self;
    navCtrl3.view.frame = CGRectMake(0.f, 0.f, kDeviceScreenWidth, kDeviceScreenHeight);
    [_navControllersArr addObject:navCtrl3];
    
    [navCtrl3 release];
    [vcontroller3 release];
    
    return _navControllersArr;
 
}
-(void)changeMainViewUI:(id)Vc
{
	
}
-(void)setCurrentTabBar:(NETabNavBar*)tabBar{
	currentTabBar = tabBar;
}
-(id)getCurrentTabBar{
	return currentTabBar;
}
-(void)pushNewViewController:(id)viewController{
	
	//UINavigationController
	if(isShouldHiddenTabBarWhenPush)
	{
		currentTabBar.hidden = YES;
	}
	if([viewController isKindOfClass:[UIViewController class]])
	{
		[[[self class] sharedAppNavigationController] pushViewController:viewController animated:YES];
		//[[[self class] sharedAppNavigationController] setDelegate:self];
	}

}
#ifdef USER_LOGIN
#pragma mark user login and resign
-(void)didUserLoginOkFromMsg:(NSNotification*)ntf
{
    [self dismissViewControllerFromMsg:nil];
}
-(void)didUserResignOkFromMsg:(NSNotification*)ntf{
    [mainVC didSelectorTabItem:2];
    [self dismissViewControllerFromMsg:nil];
}
#endif  
#pragma mark -
#pragma mark navgation

-(void)pushNewViewControllerFromMsg:(NSNotification*)ntfObj
{
	id obj = [ntfObj object];
	[self pushNewViewController:obj];
}
-(void)popAllViewControllerFromMsg:(NSNotification*)ntfObj
{
    id obj = [ntfObj object];
    if(obj == nil)
    {
        obj =[NSNumber numberWithBool:YES];
    }
    [currentNavgationController popToRootViewControllerAnimated:[obj boolValue]];
}
-(void)presentViewControllerFromMsg:(NSNotification*)ntfObj
{
    id obj = [ntfObj object];
    [currentNavgationController presentModalViewController:obj animated:YES];
}
-(void)dismissViewControllerFromMsg:(NSNotification*)ntfOjb
{
    BOOL animation = NO;
    if(ntfOjb)
    {
        if([ntfOjb isKindOfClass:[NSNumber class]])
        {
            animation = [ntfOjb boolValue];
        }
    }
    [currentNavgationController dismissModalViewControllerAnimated:animation];
}
+(UINavigationController*)sharedAppNavigationController{
	return currentNavgationController;
}
#pragma mark navigationBarHidden

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
#if 0
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if([viewController isKindOfClass:[PlayingMenuViewController class]])
	{
		if(isShouldHiddenTabBarWhenPush)
		{
			currentTabBar.hidden = YES; 
		}
	}
	else {
		currentTabBar.hidden = NO;
	}
	/*
	NSInteger count = [navigationController.viewControllers count];
	
	UIViewController *topVC = [navigationController.viewControllers objectAtIndex:count-1];
	NE_LOG(@"ssss:%@",[topVC description]);
	*/
	[viewController viewDidAppear:animated];
	[viewController viewDidAppear:animated];
}
#endif
@end
