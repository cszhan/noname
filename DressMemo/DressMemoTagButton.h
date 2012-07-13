//
//  DressMemoTagButton.h
//  DressMemo
//
//  Created by  on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"
@interface DressMemoTagButton : UIButton
@property(nonatomic,retain)CMPopTipView *tagInforView;
@property(nonatomic,assign)NSInteger imageTag;
@end
