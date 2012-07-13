//
//  UIBarBase.h
//  MP3Player
//
//  Created by cszhan on 12-1-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NETopNavBar.h"
#import "NEAppFrameView.h"
@class NETopNavBar;
@class NEAppFrameView;
//@protocol NETabNavBarDelegate;
@protocol NETopNavBarDelegate;
@protocol UIBaseViewControllerDelegate;
@interface UIBaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NETopNavBarDelegate>
{
@public
		NEAppFrameView	*mainView;
		NSString	 *navBarTitle;
		NSMutableArray	*topBarViewNavItemArr;
        BOOL isFromViewUnload;
    id<UIBaseViewControllerDelegate> delegate;
    NSString                *objIDKey;
}
-(void)setBgImage:(UIImage*)image;

-(void)setRightBtnEnable:(BOOL)enable;
-(void)setRightTextContent:(NSString*)text;
-(void)setRightTextColor:(UIColor*)color;

@property(nonatomic,assign)id<UIBaseViewControllerDelegate> delegate;
@property(nonatomic,readonly)NEAppFrameView *mainView;
-(void)addObservers;
-(void)removeObservers;
@end
@protocol UIBaseViewControllerDelegate <NSObject>
-(void)didSelectorTopNavigationBarItem:(id)sender;
@end