//
//  UIFramework.h
//  DressMemo
//
//  Created by  on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef DressMemo_UIFramework_h
#define DressMemo_UIFramework_h

#import "UIFrameworkMSG.h"

#define HexRGB(x,y,z)  [UIColor colorWithRed:(x/255.f) green:(y/255.f) blue:(z/255.f) alpha:1]

#define HexRGBA(x,y,z,a) [UIColor colorWithRed:x/255.f green:y/255.f blue:z/255.f alpha:a]

//the tabBabview will offset Y ,if we don't offset Y then we should  0,this app we offset 10 ,as the select status
#define kTabBarViewOffsetY                              -10.f
#define kTabItemNarmalImageFileNameFormart              @"tableitem%d"
#define kTabItemSelectImageFileNameFormart              @"tableitemsel%d"
#define kTabBarViewBGImageFileName                      @"none.png"
//if we don't use tabBar view offset ,we can use as follow to implement 

//the image between the tab and content view
#define kTabBarAndViewControllerSepratorImageFileName   @"none.png" //@"tabitemtopsplit.png"
//the select mask image
#define kTabBarItemMaskImageFileName                    @"none.png"//@"tabitemselmask.png"

#endif
