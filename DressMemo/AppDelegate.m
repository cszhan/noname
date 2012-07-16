//
//  AppDelegate.m
//  DressMemo
//
//  Created by  on 12-6-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "AppMainUIViewManage.h"
#import "UIAlertViewMgr.h"
#import "ZCSDataArchiveMgr.h"
#import "DressMemoNetInterfaceMgr.h"
#import "ZCSNetClientDataMgr.h"
#import "ZCSNetClientErrorMgr.h"
AppMainUIViewManage *appMg = nil;
@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
      [[UIApplication sharedApplication] setStatusBarStyle:UIActionSheetStyleBlackTranslucent animated:YES];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
#if 1
    appMg = [AppMainUIViewManage getSingleTone];
    appMg.window = self.window;
    [appMg addMainViewUI];
    //
    [UIAlertViewMgr getSigleTone];
    [ZCSDataArchiveMgr getSingleTone];
    [DressMemoNetInterfaceMgr getSingleTone];
    [ZCSNetClientErrorMgr getSingleTone];
    ZCSNetClientDataMgr *clientMgr = [ZCSNetClientDataMgr getSingleTone];
    //[clientMgr startMemoImageTagDataSource];
   //[clientMgr startMemoDataUpload:nil];
#ifdef UI_APPEARANCE_SELECTOR
    if([UINavigationBar resolveClassMethod:@selector(appearanceWhenContainedIn:)])
    {
  [[UINavigationBar appearanceWhenContainedIn:[UIImagePickerController class], nil] setTintColor:[UIColor redColor]];
    }
#endif
    
#endif
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
