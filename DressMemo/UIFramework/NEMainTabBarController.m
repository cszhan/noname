//
//  NEMainTabBarController.m
//  NeteaseMicroblog
//
//  Created by cszhan on 3/9/11.
//  Copyright 2011 NetEase.com, Inc. All rights reserved.
//

#import "NEMainTabBarController.h"
/*
#import "MoreViewController.h"
#import "PlayListViewController.h"
*/
#import "DeviceVersion.h"
#import "UIParamsCfg.h"
/*
#import "NTESMBHomePageTimelineViewController.h"
#import "NTESMBMyNearbyTimeViewController.h"
#import "NEMessageNavItemController.h"
#import "NEMicroLifeNavItemController.h"
#import "NTESMBSettingsViewController.h"
*/
@implementation NEMainTabBarController

-(id)initMainTabBarController:(NSArray*)viewControllers
{

    if(self = [super initWithNibName:nil bundle:nil])
    {
        if(_navControllersArr == nil)
        {
            _navControllersArr= [[NSMutableArray alloc]initWithCapacity:5];
        }
        //	UIViewController *vcontroller = nil;
        [_navControllersArr removeAllObjects];
        [_navControllersArr addObjectsFromArray:viewControllers];
    }
    return  self;
    /*
	PlayListViewController *vcontroller1 = [[PlayListViewController alloc]init];
	//[vcontroller1 setNavgationBarTitle:kPlayListVCTitle];
	
#if 1
	UINavigationController *navCtrl1 = [[UINavigationController alloc]initWithRootViewController:vcontroller1];
	navCtrl1.navigationBarHidden = YES;
	//navCtrl1.delegate = self;
	navCtrl1.view.frame = CGRectMake(0.f, 0.f, kDeviceScreenWidth, kDeviceScreenHeight);
	[_navControllersArr addObject:navCtrl1];
#else
    [_navControllersArr addObject:vcontroller1];
#endif
	[vcontroller1 release];
	UIViewController *vcontroller2 = [[MoreViewController alloc]init];
	UINavigationController *navCtrl2 = [[UINavigationController alloc]initWithRootViewController:vcontroller2];
	navCtrl2.navigationBarHidden = YES;
	//navCtrl2.delegate = self;
	navCtrl2.view.frame = CGRectMake(0.f, 0.f, kDeviceScreenWidth, kDeviceScreenHeight);
	[_navControllersArr addObject:navCtrl2];
	[vcontroller2 release];
	
    */
	
}
-(void)initMainTabBarControllers
{


}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
#if 1
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
#else
    self = [super init];
#endif
    if (self) 
    {
		// Custom initialization.
            [self initMainTabBarController];
		//[self.view addSubview:[[_navControllersArr objectAtIndex:0] view]];
		//gNavigationController = self.navigationController;
		//gNavigationController.delegate = self;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    //[[_navControllersArr objectAtIndex:0] viewWillAppear:animated];
	//[[_navControllersArr objectAtIndex:1] viewWillAppear:animated];
	if([self.currentViewController isKindOfClass:[UINavigationController class]])
    {
		UINavigationController *nav = (UINavigationController*)self.currentViewController;
		//UIViewController *Vc = nav.visibleViewController;
        
        if(SYSTEM_VERSION_GREATER_THAN(@"5.0"))
        {
        }
        else 
        {
            //for(UIViewController *item in _navControllersArr)
            NE_LOG(@"below 5.0");
            [self.currentViewController viewWillAppear:animated];
            
            [self.currentViewController viewDidAppear:animated];
        }
            
               
            
        
    }
}
-(void)viewDidAppear:(BOOL)animated{
	//[[_navControllersArr objectAtIndex:0] viewDidAppear:animated];
	//[[_navControllersArr objectAtIndex:1] viewDidAppear:animated];
    [super viewDidAppear:animated];
    if(SYSTEM_VERSION_GREATER_THAN(@"5.0")){
    }
    else{
    //for(UIViewController *item in _navControllersArr)
    [self.currentViewController viewDidAppear:animated];
    }

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)loadView{
	[super loadView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //if(first)
    {
        /*
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 0;
        
        [self didSelectorTopNavItem:btn];
         */
        [self didSelectorTabItem:0];
       // first = NO;
    }
    
    //NE_LOG(@"%d",self.navigationController);
	//gNavigationController = self.navigationController;
	//gNavigationController.delegate = self;
	//_navigationController = self.navigationController;
}
-(void)didSelectorTabItem:(NSInteger)index
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = index;
    [self didSelectorTopNavItem:btn];
}
#pragma mark navigationController delegate
// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	
	[viewController viewWillAppear:animated];
	//[_currentRootViewController viewDidAppear:animated];
	return;
	
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	
	[viewController viewDidAppear:animated];
	//[_currentRootViewController viewDidAppear:animated];
	return;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return NO;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
