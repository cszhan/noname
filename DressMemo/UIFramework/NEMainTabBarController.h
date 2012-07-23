//
//  NEMainTabBarController.h
//  NeteaseMicroblog
//
//  Created by cszhan on 3/9/11.
//  Copyright 2011 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NENavItemController.h"

@interface NEMainTabBarController : NENavItemController {

}
-(id)initMainTabBarController:(NSArray*)viewControllers;
-(void)didSelectorTabItem:(NSInteger)index;
@end
