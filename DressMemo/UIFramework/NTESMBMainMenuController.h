//
//  NTESMBMainMenuController.h
//  NeteaseMicroblog
//
//  Created by cszhan on 1/27/11.
//  Copyright 2011 NetEase.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEAppFrameView.h"

@class NEMainTabBarController;
//#import "NTESMBRequest.h"
#import "NETabNavBar.h"
#import "NETopNavBar.h"
@interface NTESMBMainMenuController :UIViewController<NETabNavBarDelegate,NETopNavBarDelegate>{
	NEAppFrameView					*mainView;
	//IBOutlet UITabBarController		*tabController;
	NEMainTabBarController			*mainTabBarVC;
	NSMutableArray				*topBarViewNavItemArr;
	UINavigationController		*navgationController;
	NSInteger					curSelNavIndex;
	IBOutlet	UIView				*testView;
	NETopNavBar				*curSelTopNavBar;
	id							delegate;
	BOOL							isGbShowTabBar;
    UIImageView                     *tabItemMaskView;
}
@property(nonatomic,retain) UIView *topBarView;
@property(nonatomic,assign) id delegate;
@property(nonatomic,readonly) NETopNavBar	*curSelTopNavBar;
-(IBAction)menuNavItemPress:(id)sender;
+(id)sharedAppNavigationController;
@end

@protocol NTESMBMainMenuControllerDelegate<NSObject>
@required
-(NSInteger)tabBarItemCount:(NTESMBMainMenuController*)controller ;
-(NSArray*)viewcontrollersForTabBarController:(NTESMBMainMenuController*)controller;
-(void)topNavigationBar:(NTESMBMainMenuController*)controller withTabBarIndex:(NSInteger)index;
@optional
@end
