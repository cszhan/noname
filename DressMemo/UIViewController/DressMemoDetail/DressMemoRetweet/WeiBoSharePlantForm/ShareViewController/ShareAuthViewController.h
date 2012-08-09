//
//  ShareAuthViewController.h
//  UMSNSDemo
//
//  Created by Fengfeng Pan on 11-12-13.
//  Copyright (c) 2011年 Realcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoBaseEngine.h"
#import "UIBaseViewController.h"

@class WeiBoBaseEngine;

@interface ShareAuthViewController :UIBaseViewController  <UIWebViewDelegate, WeiBoEngineAuthDelegate>{
    UIWebView *_authWeb;
    WeiBoBaseEngine *_baseEngine;
	
}
@property(nonatomic,assign)NSInteger type;
-(id)initWithEngine:(WeiBoBaseEngine *)_baseEngine;

@end
