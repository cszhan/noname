//
//  APILogin.h
//  网易微博iPhone客户端
//
//  Created by Xu Hanjie on 10-5-11.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESMBServer.h"

@interface NTESMBAPILogin : NTESMBRequest {
	BOOL isAuthOk;
}
@property(nonatomic,assign)BOOL isAuthOk;
- (id) initWithUsername:(NSString *) username password:(NSString *) password;
- (BOOL) isLoginSuccessful;

@end
