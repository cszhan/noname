//
//  Server.m
//  网易微博iPhone客户端
//
//  Created by Xu Hanjie on 10-5-11.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//
#define NEEDLOGIN
#import "NTESMBServer.h"
#import "NTESMBRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "RequestCfg.h"
#ifdef NEEDLOGIN
#import "NTESMBAPILogin.h"
#endif
#ifdef XAuth
#import "XAuthAPI.h"
#endif
#import "ZCSNetClient.h"
@class NTESMBAPIUser;
@interface NTESMBServer (ServerPrivate)

- (ASIHTTPRequest *) newLogonRequest;
- (ASIHTTPRequest *) getASIRequest:(NTESMBRequest *)request;
- (void)logonRequestFinished:(ASIHTTPRequest *)request;
- (void)logonRequestFailed:(ASIHTTPRequest *)request;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
@end

static NTESMBServer *instance = nil;

@implementation NTESMBServer
@synthesize logon;

+ (NTESMBServer *) getInstance
{
    @synchronized(self)
    {
		if (instance == nil)
		{
			instance = [[NTESMBServer alloc] init];
		}
    }

    return instance;
}


- (id) init
{
    self = [super init];
    if (self != nil) {
		//60秒超时，图片上传时间较慢的api可以在request级别设置
		[ASIHTTPRequest setDefaultTimeOutSeconds:30];
		//connectionTable = [[NSMutableDictionary alloc] init];
		requestTable = [[NSMutableDictionary alloc] init];
		networkQueue = [[ASINetworkQueue alloc] init];
		[networkQueue setShouldCancelAllRequestsOnFailure:NO];
		[networkQueue setDelegate:self];
		[networkQueue setRequestDidStartSelector:@selector(requestStarted:)];
		[networkQueue setRequestDidFinishSelector:@selector(requestFinished:)];
		[networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
        //[networkQueue setUploadProgressDelegate:self];
		logon = NO;
    }
    return self;
}


- (void) dealloc
{
	[networkQueue release];
	//[connectionTable release];
	[requestTable release];
    [super dealloc];
}


- (ASIHTTPRequest*) addRequest:(NTESMBRequest *) request
{
	//先判断是否登录
	
	if (request.needSignon && !logon && 0) 
    {
		//添加登录request，保证先后执行
		[networkQueue setMaxConcurrentOperationCount:1];
		logon = YES;
		//[networkQueue setShouldCancelAllRequestsOnFailure:YES];
		ASIHTTPRequest *logonRequest = [self initLogonRequest];
		[logonRequest setDidFinishSelector:@selector(logonRequestFinished:)];
		[logonRequest setDidFailSelector:@selector(logonRequestFailed:)];
		[logonRequest setDelegate:self];
		[networkQueue addOperation:logonRequest];

	}

	//avoid the requestTable has the same request
	if ([requestTable objectForKey:[NSString stringWithFormat:@"%d",[request hash]]]!=nil) {
		NE_LOG(@"dup request!");
		return nil;
	}
#ifdef REQUEST_DEBUG
	NE_LOG(@"request arguments : %@", request.postArguments);
#endif
	ASIHTTPRequest  *asiRequest = [self getASIRequest:request];
    
	/*
	 * if use XAuth
	 */
	#ifdef XAuth
	asiRequest.useCookiePersistence = NO;
    #else
#if 1
    asiRequest.useCookiePersistence = NO;
    //NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:<#(NSHTTPCookie *)#>];
    asiRequest.requestCookiesString = [ZCSNetClient sharedNetCookie];
    NSLog(@"%@",asiRequest.requestCookiesString);
    NSArray *cookies = [ZCSNetClient shardNetCookieArray];

    asiRequest.requestCookies = cookies;
     NE_LOG(@"%@",[cookies description]);
#else
    
#endif
    //asiRequest.uploadProgressDelegate  = self;
   
	#endif
	[networkQueue addOperation:asiRequest];
	//[connectionTable setObject:request forKey:[NSString stringWithFormat:@"%d", [asiRequest hash]]];
	[requestTable setObject:asiRequest forKey:[NSString stringWithFormat:@"%d",[request hash]]];
	[networkQueue go];
    return asiRequest;

}
#ifdef NEEDLOGIN
- (ASIHTTPRequest *) initLogonRequest
{
#if 0
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSString *username = [ud stringForKey:K_LOGIN_USERNAME];
	NSString *password = [ud stringForKey:K_LOGIN_PASSWORD];
#endif
    /*
     pass=123456&email=cszhan%40163.com
     */
    NSString *username = @"cszhan@163.com";
    NSString *password = @"123456";
	NTESMBAPILogin *loginRequest = [[NTESMBAPILogin alloc] initWithUsername:username password:password];
	loginRequest.initByServer = NO;
	loginRequest.requestMethod = @"POST";
	ASIHTTPRequest *asiRequest = [self getASIRequest:loginRequest];
	[loginRequest release];
	return asiRequest;
}
#endif
- (ASIHTTPRequest *) getASIRequest:(NTESMBRequest *)request{
	ASIHTTPRequest  *asiRequest;
#ifdef XAuth
	//if(request.postArguments)
#if 0
	if([request isKindOfClass:[NTESMBAPILogin class]])
    {
		if(![[XAuthAPI getSingleton] getAccessTokenStatus])
        {
			XAuthAPI * xauthApi = [XAuthAPI getSingleton];
			xauthApi.x_auth_username = [request.postArguments objectForKey:@"username"];
			xauthApi.x_auth_password = [request.postArguments objectForKey:@"password"];
			if(![xauthApi  accessTokenWithConsumerKey:kAuth_key consumer_secret:kAuth_secret 
												username:[request.postArguments objectForKey:@"username"]
											password:[request.postArguments objectForKey:@"password"]]){
				//NE_LOG(@"accessTokenFailed:");
				[(NTESMBAPILogin*)request setIsAuthOk:NO];
				[XAuthAPI clearSignleton];
				//return;
				//exit(1);
			}
			else {
				[(NTESMBAPILogin*)request  setIsAuthOk:YES];
			}

		}
	}
#endif
	/*
	if(![[XAuthAPI getSingleton] accessTokenWithConsumerKey:kAuth_key consumer_secret:kAuth_secret 
												   username:usernameTextField.text password:passwordTextField.text ])	
	*/
	NSMutableDictionary *requestDict  = nil;
	if ([request.dataArguments count]==0 && [request.postArguments count]==0 && request.uploadFilePath==nil)
    {
		request.requestMethod = @"GET";
	}
	else {
		request.requestMethod = @"POST";
	}

	if([request.requestMethod isEqualToString:@"GET"])
		requestDict =[NSMutableDictionary dictionaryWithDictionary:request.getArguments];
	if([request.requestMethod isEqualToString:@"POST"])
		requestDict = [NSMutableDictionary dictionaryWithDictionary:request.postArguments];
	if(requestDict == nil)
    {
		requestDict = [NSMutableDictionary dictionary];
	}
		//[[XAuthAPI getSingleton] getOAuthRequestParamsByMethod:request.urlString withMethod:request.requestMethod inParams:&request.postArguments];
	//if([request isKindOfClass:[NTESMBAPILogin class])
	if(request.isNeedAuthRequest)
		[[XAuthAPI getSingleton] getOAuthRequestParamsByMethod:request.urlString withMethod:request.requestMethod inParams:&requestDict];
	
	if([request.requestMethod isEqualToString:@"GET"]||request.isAuthHeader)
		request.getArguments = requestDict;
	
	if([request.requestMethod isEqualToString:@"POST"]&& !request.isAuthHeader)
		request.postArguments = requestDict;
	
	for(id key in [requestDict allKeys]){
		//NE_LOG(@"authou param key:%@ value:%@",key,[requestDict objectForKey:key]);
	}
	
#endif 
	//url
	NSMutableString *queryString = [[[NSMutableString alloc] init]autorelease];
	NSArray *getKeys = [request.getArguments allKeys];
	int count = 0;
	for (NSString *aKey in getKeys)
	{
		NSString *aValue = [request.getArguments objectForKey:aKey];
//#ifdef XAuth
		//if([request.requestMethod isEqualToString:@"POST"])
//			aValue = [NSString stringUrlEncoded:aValue];
//#else 
		aValue = [NSString stringUrlEncoded:aValue];
//#endif
		if (count == 0)
		{
			[queryString appendFormat:@"?%@=%@", aKey, aValue];
		}
		else
		{
			[queryString appendFormat:@"&%@=%@", aKey, aValue];
		}
		count++;
	}
	if ([request.dataArguments count]==0 && [request.postArguments count]==0 && request.uploadFilePath==nil) {
		//NE_LOG(@"here!!!");
		asiRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", request.urlString, queryString]]];
	}else{
		//if(!isAuthHeader)
		asiRequest = [ZCSASIRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", request.urlString, queryString]]];
		NSArray *postKeys = [request.postArguments allKeys];
		for (NSString *aKey in postKeys)
		{
			NSString *aValue = [request.postArguments objectForKey:aKey];
			[asiRequest addPostValue:aValue forKey:aKey];
		}
		NSArray *dataKeys = [request.dataArguments allKeys];
		for (NSString *aKey in dataKeys)
		{
			NSData *aValue = [request.dataArguments objectForKey:aKey];
			[asiRequest setData:aValue withFileName:@"test.png" andContentType:nil forKey:aKey];
			//[asiRequest setData:aValue forKey:aKey];
		}
		if (request.uploadFilePath!=nil) {
            
            [asiRequest setFile:request.uploadFilePath forKey:@"pic"];
			//临时的用法，因为目前只有上传图片用了图片上传，因此就没有传递key，而是直接写在这里
#if 0
			if([request isKindOfClass:[NTESMBAPIUser class]])
            {
				//[asiRequest setFile:request.uploadFilePath forKey:@"image"];
				[asiRequest setFile:request.uploadFilePath withFileName:@"test.png" andContentType:nil forKey:@"image"];
			}
			else {
				[asiRequest setFile:request.uploadFilePath forKey:@"picture"];
			}
#endif
		}
	}
	asiRequest.requestMethod = request.requestMethod;
	//是否有自定义的timeout
	if (request.timeoutSeconds>0) {
		[asiRequest setTimeOutSeconds:request.timeoutSeconds];
	}
	//asiRequest.useCookiePersistence = NO;
	//设置一个referer，有些时候需要防盗链
#if 0
    asiRequest.allowCompressedResponse = NO;
	[asiRequest addRequestHeader:@"Accept-Encoding" value:@"plain"];
#endif
	//支持后台
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	asiRequest.shouldContinueWhenAppEntersBackground=YES;
#endif
	[asiRequest setUserInfo:[NSDictionary dictionaryWithObject:request forKey:@"request"]];
	return asiRequest;

}
- (void)setProgress:(float)process
{
    NSLog(@"%lf",process);
}
- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
    NSLog(@"toal:%dK,send:%dK",request.totalBytesSent,bytes);
}
#pragma mark -
#pragma mark ASIHTTPRequest delegation methods
- (void)requestStarted:(ASIHTTPRequest *)request{
#ifdef REQUEST_DEBUG
	NE_LOG(@"request url : %@", request.url);
	NE_LOG(@"request method : %@", request.requestMethod);
#endif
	
}
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
	NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"receive:%@",str);
#ifdef REQUEST_DEBUG
	//NE_LOG(@"request receviedata : %@", str);
	//NE_LOG(@"request method : %@", request.requestMethod);
#endif
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
	// Use when fetching text data
	//NSString *responseString = [request responseString];
	
	// Use when fetching binary data
	//
	int statusCode = [request responseStatusCode];
#ifdef REQUEST_DEBUG
	NE_LOG(@"request finished[%d]",statusCode);
#endif
	NTESMBRequest *r =  [[request userInfo] objectForKey:@"request"];	
	if (r.initByServer)
    {
		return;
	}
	
	[r.receiveData appendData:[request responseData]];
    NSString *str = [[NSString alloc] initWithData:r.receiveData encoding:NSUTF8StringEncoding];
    NSLog(@"receive:%@",str);
	if (statusCode>=400) 
    {
		[self requestFailed:request];
		return;
	}
	if (r.delegate==nil)
    {
		//NE_LOG(@"sssssssssssss");
		[[NSNotificationCenter defaultCenter] postNotificationName:HTTP_REQUEST_COMPLETE object:r];
	}else {
			//[r.delegate performSelectorOnMainThread:@selector(requestCompleted:) withObject:r waitUntilDone:NO];
		[r.delegate requestCompleted:r];
	}
	[requestTable removeObjectForKey:[NSString stringWithFormat:@"%d", [r hash]]];
	//[connectionTable removeObjectForKey:[NSString stringWithFormat:@"%d", [request hash]]];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	//cancel的时候不走这里
	if ([request.error code]== ASIRequestCancelledErrorType)
    {
		return;
	}
	
#ifdef DEBUG
	NE_LOG(@"%@", request.error.localizedDescription);
	for(id key in [request.error.userInfo allKeys])
    {
		NE_LOG(@"key:%@ value:",key,[request.error.userInfo objectForKey:key]);
	}
	NE_LOG(@"request failed");
#endif
	NTESMBRequest *r =  [[request userInfo] objectForKey:@"request"];
	
	if([request responseStatusCode]== 401)
    {
		[r setIsAuthFailed:YES];
	}
	if([request responseStatusCode] != 404)
	{
		[r setRespondError:request];
	}
	if (r==nil && r.initByServer) {
		return;
	}

	if (r.delegate==nil) 
    {
		[[NSNotificationCenter defaultCenter] postNotificationName:HTTP_REQUEST_ERROR object:r];
	}else {
		//[r.delegate performSelectorOnMainThread:@selector(requestFailed:) withObject:r waitUntilDone:NO];
		[r.delegate requestFailed:r];
	}
	[requestTable removeObjectForKey:[NSString stringWithFormat:@"%d", [r hash]]];
	//[connectionTable removeObjectForKey:[NSString stringWithFormat:@"%d", [request hash]]];
}


- (void) cancelRequest:(NTESMBRequest *) request
{
	if(request==nil)return;
	ASIHTTPRequest *asiRequest = [requestTable objectForKey:[NSString stringWithFormat:@"%d",[request hash]]];
	if (asiRequest!=nil) {
		[asiRequest cancel];
		[requestTable removeObjectForKey:[NSString stringWithFormat:@"%d",[request hash]]];
		//[connectionTable removeObjectForKey:[NSString stringWithFormat:@"%d",[asiRequest hash]]];
		NE_LOG(@"canel request success");
	//}else {
		//NE_LOG(@"too late to cancel request");
	}
}
#ifdef NEEDLOGIN
- (void)logonRequestFinished:(ASIHTTPRequest *)request{
	
	NTESMBAPILogin *loginRequest = [request.userInfo objectForKey:@"request"];
	if ([loginRequest isLoginSuccessful])
    {
		[self setupLogonInfo];
		NE_LOG(@"server auto login ok");
	}
	else {
		[self logonRequestFailed:request];
	}
	
}

- (void)logonRequestFailed:(ASIHTTPRequest *)request{
	logon = NO;
	NE_LOG(@"server auto login fail");
	NSArray *all = [requestTable allValues];
	for (ASIHTTPRequest * r in all)
    {
		//NE_LOG(@",,,,,%@",r.url);
		[self requestFailed:r];
	}	
	[networkQueue cancelAllOperations];
    
	//登录失败把现有的request要提示失败
	for (ASIHTTPRequest * r in all) {
		///NE_LOG(@".....%@",r.url);
		[self requestFailed:r];
	}
	[requestTable removeAllObjects];
}
- (void) logout
{
	logon = NO;
	[networkQueue cancelAllOperations];
	NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
	for (NSHTTPCookie *cookie in cookies)
	{
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
	}
}

- (void) setupLogonInfo{
	logon = YES;
	[networkQueue setMaxConcurrentOperationCount:4];
	[networkQueue setShouldCancelAllRequestsOnFailure:NO];
}
#endif
@end
