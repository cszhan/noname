//
//  DressMemoRetweetController.h
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBaseViewController.h"

@class UIRetweetView;

@interface DressMemoRetweetController : UIBaseViewController <UITableViewDelegate, UITableViewDataSource>{
    UIRetweetView *_retweetView;
}


@end
