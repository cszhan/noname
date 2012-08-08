//
//  FollowingViewController.h
//  DressMemo
//
//  Created by  on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIIconImageNetViewController.h"

@interface FollowingViewController : UIIconImageNetViewController
//@property(nonatomic,assign)BOOL isEmpty;

@property(nonatomic,assign)NSInteger itemCount;
@property(nonatomic,retain)UIButton *headBgView;
@property(nonatomic,retain)NSMutableArray *friendList;
@end
