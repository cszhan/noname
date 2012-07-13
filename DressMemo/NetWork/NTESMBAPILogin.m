//
//  APILogin.m
//  网易微博iPhone客户端
//
//  Created by Xu Hanjie on 10-5-11.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBAPILogin.h"
#include <arpa/inet.h>
#define kInerLogHttpRoot		@"http://reg.163.com/services/corpmailUserLogin"
#define kLogHttpRoot			@"http://api.iclub7.com/user/login"//@"https://reg.163.com/logins.jsp"
@implementation NTESMBAPILogin
@synthesize isAuthOk;
- (id) initWithUsername:(NSString *) username password:(NSString *) password
{
	/*
	NSString *
	in_addr_t	 inet_addr(const char *);
	char		*inet_ntoa(struct in_addr);
	struct hostent = gethostent();
	 */
	//self.isLogRequest = YES;
	if([username hasSuffix:@"corp.netease.com"]){
		self  = [super initWithUrlString:kInerLogHttpRoot];
		/*username=&password=
		 &userip=&product=&savelogin=&passtype=*/
		self.postArguments = [NSDictionary dictionaryWithObjectsAndKeys:
							  username,@"username",
							  password,@"password",
							  //@"" ,@"userip",
							  @"t_c",@"product",
							  @"1",@"savelogin",
							  @"1",@"passtype",nil];
		
	}
	else
    {
		self = [super initWithUrlString:kLogHttpRoot];
		self.postArguments = [NSDictionary dictionaryWithObjectsAndKeys:
							  username, @"email",
							  password, @"pass",
							  //@"t", @"product",
							  //@"1", @"type",
							  nil];
	}
	self.requestMethod = @"POST";
	return self;
}


- (BOOL) isLoginSuccessful
{
	
    //return YES;
#ifdef XAuth
	return YES;
#endif 
    NSString *data = [self getTextWithEncoding:NSUTF8StringEncoding];
    //NE_LOG(@"%@",data);
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    //在本地cookies上找名字为NTES_SESS, P_INFO, S_INFO的cookie
    NSInteger count = 0;
    NSHTTPCookie * httpCookie = [NSHTTPCookie cookieWithProperties:[NSHTTPCookie requestHeaderFieldsWithCookies:cookies]];
	/*
	NSString *cookieName = [[cookie properties] objectForKey:@"Name"];
        if ([cookieName isEqualToString:@"NTES_SESS"]
            || [cookieName isEqualToString:@"P_INFO"]
            || [cookieName isEqualToString:@"S_INFO"])
	*/
    for(NSHTTPCookie *itemCookie in cookies)
    {
        //NE_LOG(@"%@",itemCookie);
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:itemCookie];
    }
if([urlString isEqualToString:kInerLogHttpRoot]){
		return YES;
   }
    for (NSHTTPCookie *cookie in cookies)
    {
        NSString *cookieName = [[cookie properties] objectForKey:@"Name"];
        if ([cookieName isEqualToString:@"NTES_SESS"]
            || [cookieName isEqualToString:@"P_INFO"]
            || [cookieName isEqualToString:@"S_INFO"])
        {
            count++;
        }
    }
    if (count == 3)
    {
        return YES;
    }
    return NO;
}

@end
