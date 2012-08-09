//
//  WeiBoTencentEngine.m
//  Tester
//
//  Created by Fengfeng Pan on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "WeiBoTencentEngine.h"
#import "QWeiboSyncApi.h"
#import "NSURL+QAdditions.h"
#import "QWeiboAsyncApi.h"
#import "NSString+QEncoding.h"
#import "NSString+SBJSON.h"


@implementation WeiBoTencentEngine

@synthesize verifier;
@synthesize response;
@synthesize tmpTokenKey;
@synthesize tmpTokenSecret;

-(void)dealloc{
    self.verifier = nil;
    self.response = nil;
    
    self.tmpTokenSecret = nil;
    self.tmpTokenKey = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark private api
- (void)parseTokenKeyWithResponse:(NSString *)aResponse {
	
	NSDictionary *params = [NSURL parseURLQueryString:aResponse];
	self.tmpTokenKey = [params objectForKey:@"oauth_token"];
	self.tmpTokenSecret = [params objectForKey:@"oauth_token_secret"];
	
}

#pragma mark -
#pragma mark public api

-(NSURLRequest *)auth{
    if (self.authRequest) {
        return  self.authRequest;
    }
    
    QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
    NSString *retString = [api getRequestTokenWithConsumerKey:self.appKey consumerSecret:self.appSecret];
    NSLog(@"Get requestToken:%@", retString);
    
    [self parseTokenKeyWithResponse:retString];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", VERIFY_URL, self.tmpTokenKey];
	NSURL *requestUrl = [NSURL URLWithString:url];
    
    self.authRequest = [NSURLRequest requestWithURL:requestUrl];
	
    return _authRequest;
}

-(void)canceAuth{
    self.verifier = nil;
    self.response = nil;
    self.tmpTokenKey = nil;
    self.tmpTokenSecret = nil;
    
    [super canceAuth];
}

-(BOOL)parseQueryAndRedirect:(NSString *)query{
    NSString *tverifier = [self valueForKey:@"oauth_verifier" ofQuery:query];
    
    if (tverifier && ![tverifier isEqualToString:@""]) {
		
		QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
		NSString *retString = [api getAccessTokenWithConsumerKey:self.appKey
												  consumerSecret:self.appSecret
												 requestTokenKey:self.tmpTokenKey
											  requestTokenSecret:self.tmpTokenSecret
														  verify:tverifier];
        
        NSDictionary *params = [NSURL parseURLQueryString:retString];
        self.tokenKey = [params objectForKey:@"oauth_token"];
        self.tokenSecret = [params objectForKey:@"oauth_token_secret"];
        
        if (self.tokenSecret == nil || self.tokenSecret == nil) {
            if (self.authDelegate && [(NSObject *)self.authDelegate respondsToSelector:@selector(authFailWithEngine:failReason:)]) {
                [self.authDelegate authFailWithEngine:self failReason:retString];
            }
            
            return NO;
        }
        
        if (self.authDelegate && [(NSObject *)self.authDelegate respondsToSelector:@selector(authOKWithEngine:)]) {
            [self.authDelegate authOKWithEngine:self];
        }
        
        NSString *userInfo;
        
        QWeiboSyncApi *tapi = [[[QWeiboSyncApi alloc] init] autorelease];
        
        userInfo = [tapi getUserInfoWithConsumerKey:self.appKey
                                    consumerSecret:self.appSecret
                                    accessTokenKey:self.tokenKey
                                 accessTokenSecret:self.tokenSecret 
                                        resultType:RESULTTYPE_JSON];
        
        NSDictionary *userInfoDic = [userInfo JSONValue];
        
        if ([userInfoDic isKindOfClass:[NSDictionary class]]) {
            if (self.dataDelegate && [(NSObject *)self.dataDelegate respondsToSelector:@selector(userInfoWithEngine:resultDic:)]) {
                [self.dataDelegate userInfoWithEngine:self resultDic:[userInfoDic objectForKey:@"data"]];
            }
        }
        
		return NO;
	}
    
    return YES;

}

-(void)sendStatus:(NSString *)str Image:(NSData *)imageData{
	QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];
    

	
	[api publishMsgWithConsumerKey:self.appKey 
                    consumerSecret:self.appSecret 
					accessTokenKey:self.tokenKey 
                 accessTokenSecret:self.tokenSecret 
                           content:str 
                         imageData:imageData
						resultType:RESULTTYPE_JSON 
                          delegate:self];
}

#pragma mark -
#pragma mark delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    NSLog(@"data: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
    
    NSString *ret = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSDictionary *retObj = [ret JSONValue];
    
    if (![retObj isKindOfClass:[NSDictionary class]]) {
        if ([self.dataDelegate respondsToSelector:@selector(sendStatusFailWithEngine:failReason:)]) {
            [self.dataDelegate sendStatusFailWithEngine:self failReason:@"发送失败，服务器返回错误"];
        }
        
        return;
    }
    
    if ([[retObj objectForKey:@"msg"] isEqualToString:@"ok"]) {
        if (self.dataDelegate && [self.dataDelegate respondsToSelector:@selector(sendStatusOKWithEngine:)]) {
            [self.dataDelegate sendStatusOKWithEngine:self];
        }
    }else{
        if ([self.dataDelegate respondsToSelector:@selector(sendStatusFailWithEngine:failReason:)]) {
            [self.dataDelegate sendStatusFailWithEngine:self failReason:[retObj objectForKey:@"msg"]];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if ([self.dataDelegate respondsToSelector:@selector(sendStatusFailWithEngine:failReason:)]) {
        [self.dataDelegate sendStatusFailWithEngine:self failReason:[error description]];
    }
}

@end
