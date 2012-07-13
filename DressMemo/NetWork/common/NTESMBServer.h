//
//  Server.h
//  网易微博iPhone客户端
//
//  Created by Xu Hanjie on 10-5-11.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESMBRequest.h"
#import "ZCSASIRequest.h"
#ifdef Auth
#import "XAuthAPI.h"
#import "XAuth.h"
#endif
@class ASINetworkQueue;
/*
 * this use the object has ass the request key is not right;
 */
@interface NTESMBServer : NSObject {
	ASINetworkQueue *networkQueue;
	//connection table由asirequest做key
	//NSMutableDictionary *connectionTable;
	//requestTable相反，用request做key，获取asirequest，为了线性查找
	NSMutableDictionary *requestTable;
	//是否已经登录的状态
	BOOL logon;
}
@property(readonly)BOOL logon;

+ (NTESMBServer *) getInstance;
- (ASIHTTPRequest*) addRequest:(NTESMBRequest *) request;
- (void) cancelRequest:(NTESMBRequest *) request;
- (void) logout;
- (void) setupLogonInfo;
- (ASIHTTPRequest *) initLogonRequest;


@end
