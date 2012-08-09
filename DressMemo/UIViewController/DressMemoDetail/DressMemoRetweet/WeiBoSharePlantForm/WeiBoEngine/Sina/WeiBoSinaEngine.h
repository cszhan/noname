//
//  WeiBoSinaEngine.h
//  Tester
//
//  Created by Fengfeng Pan on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "WeiBoBaseEngine.h"
#import "WBAuthorize.h"
#import "WeiBo.h"

@interface WeiBoSinaEngine : WeiBoBaseEngine <WBAuthorizeDelegate, WBRequestDelegate>{
    WBAuthorize *_sinaAuth;
    WeiBo *_sinaWeiBo;
    
    WBRequest *_userInfoRequest;
    WBRequest *_sendRequest;
}

@end
