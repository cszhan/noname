//
//  WeiBoTencentEngine.h
//  Tester
//
//  Created by Fengfeng Pan on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiBoBaseEngine.h"

#define VERIFY_URL @"https://open.t.qq.com/cgi-bin/authorize?oauth_token="

#define User_NickName_Tencent_Key @"nick"

@interface WeiBoTencentEngine : WeiBoBaseEngine {
    NSString *verifier;
	NSString *response;
    
    NSString *tmpTokenKey;
    NSString *tmpTokenSecret;

}

@property (nonatomic, copy) NSString *verifier;
@property (nonatomic, copy) NSString *response;

@property (nonatomic, copy) NSString *tmpTokenKey;
@property (nonatomic, copy) NSString *tmpTokenSecret;



@end
