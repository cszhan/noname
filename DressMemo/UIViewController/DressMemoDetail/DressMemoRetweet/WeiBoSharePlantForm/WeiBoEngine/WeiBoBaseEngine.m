//
//  WeiBoBaseEngin.m
//  Tester
//
//  Created by Fengfeng Pan on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "WeiBoBaseEngine.h"

@implementation WeiBoBaseEngine

@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize appId = _appId;

@synthesize tokenKey;
@synthesize tokenSecret;

@synthesize authDelegate;
@synthesize dataDelegate;

@synthesize authRequest = _authRequest;

-(id)initWithAppKey:(NSString *)appKey AppSecret:(NSString *)appSecret{
    self = [self init];
    
    if (self) {
        _appKey = [appKey copy];
        _appSecret = [appSecret copy];
    }
    
    return self;
}
-(id)initWithAppKey:(NSString *)appKey AppSecret:(NSString *)appSecret appId:(NSString*)appId{
    self = [self init];
    
    if (self) {
        _appKey = [appKey copy];
        _appSecret = [appSecret copy];
        _appId = [appId copy];
    }
    
    return self;

}
-(void)setTokenKey:(NSString *)ttokenKey{
    if (tokenKey) {
        [tokenKey release];
    }
    
    tokenKey = [ttokenKey retain];
}

-(void)setTokenSecret:(NSString *)ttokenSecret{
    if (tokenSecret) {
        [tokenSecret release];
    }
    
    tokenSecret = [ttokenSecret retain];
}

-(BOOL)isAuth{
    return (self.tokenKey != nil && self.tokenSecret != nil);
}

-(NSURLRequest *)auth{
    return nil;
}

-(NSString*) valueForKey:(NSString *)key ofQuery:(NSString*)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	for(NSString *aPair in pairs){
		NSArray *keyAndValue = [aPair componentsSeparatedByString:@"="];
		if([keyAndValue count] != 2) continue;
		if([[keyAndValue objectAtIndex:0] isEqualToString:key]){
			return [keyAndValue objectAtIndex:1];
		}
	}
	return nil;
}

-(BOOL)parseQueryAndRedirect:(NSString *)query{
    return YES;
}

-(void)canceAuth{
    self.tokenKey = nil;
    self.tokenSecret = nil;
    
    self.authRequest = nil;
}

-(void)sendStatus:(NSString *)str Image:(NSData *)imageData{

}

-(void)dealloc{
    [_appKey release];
    _appKey = nil;
    
    [_appSecret release];
    _appSecret = nil;
    [_appId release];
    _appId = nil;
    self.tokenSecret = nil;
    self.tokenKey = nil;
    
    self.authRequest = nil;
    
    [super dealloc];
}

@end
