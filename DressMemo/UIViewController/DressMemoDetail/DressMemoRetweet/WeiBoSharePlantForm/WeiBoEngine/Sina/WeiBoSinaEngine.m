//
//  WeiBoSinaEngine.m
//  Tester
//
//  Created by Fengfeng Pan on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "WeiBoSinaEngine.h"
#import "JSON.h"

@implementation WeiBoSinaEngine

-(id)initWithAppKey:(NSString *)appKey AppSecret:(NSString *)appSecret{
    self = [self init];
    
    if (self) {
        _sinaWeiBo = [[WeiBo alloc] initWithAppKey:appKey withAppSecret:appSecret];
        _sinaAuth = [[WBAuthorize alloc] initWithAppKey:appKey withAppSecret:appSecret withWeiBoInstance:_sinaWeiBo];
    }
    
    return  self;
}

-(void)dealloc{
    [_sinaWeiBo release];
    _sinaWeiBo = nil;
    
    [_sinaAuth release];
    _sinaAuth = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark public api

-(NSURLRequest *)auth{
    if (self.authRequest) {
        return self.authRequest;
    }
    
    NSString *token = [_sinaAuth tmpTokenUsingAppKey];
    
    self.authRequest = [_sinaAuth authRequest:token];
    
    return self.authRequest;
}

-(void)canceAuth{
    [super canceAuth];
}


-(BOOL)parseQueryAndRedirect:(NSString *)query{
    NSString *tverifier = [self valueForKey:@"oauth_verifier" ofQuery:query];
    
    if (tverifier && ![tverifier isEqualToString:@""]) {
        _sinaAuth.delegate = self;
        [_sinaAuth getAccessTokenWithVerifier:tverifier];
		return NO;
	}
    
    return YES;

}

-(void)setTokenKey:(NSString *)ttokenKey{
    [super setTokenKey:ttokenKey];
    
    
    _sinaAuth.requestToken = ttokenKey; 
    _sinaWeiBo.accessToken = ttokenKey;
}

-(void)setTokenSecret:(NSString *)ttokenSecret{
    [super setTokenSecret:ttokenSecret];
    
    _sinaAuth.requestSecret = ttokenSecret;
    _sinaWeiBo.accessTokenSecret = ttokenSecret;
}

-(void)sendStatus:(NSString *)str Image:(NSData *)imageData{
    if (imageData == nil) {
        _sendRequest = [_sinaWeiBo postWeiboRequestWithText:str andImage:nil andDelegate:self];
    }else{
        _sendRequest = [_sinaWeiBo postWeiboRequestWithText:str andImage:[UIImage imageWithData:imageData] andDelegate:self];
    }
    
   
}


#pragma mark -
#pragma mark delegate
- (void)authorizeSuccess:(WBAuthorize*)auth userID:(NSString*)userID oauthToken:(NSString*)token oauthSecret:(NSString*)secret{
    _sinaWeiBo.userID = userID;
//    _sinaWeiBo.accessToken = token;
//    _sinaWeiBo.accessTokenSecret = secret;

    self.tokenKey = token;
    self.tokenSecret = secret;
    
    if ([self.authDelegate respondsToSelector:@selector(authOKWithEngine:)]) {
        [self.authDelegate authOKWithEngine:self];
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:_sinaWeiBo.userID forKey:@"user_id"];
    
    _userInfoRequest = [_sinaWeiBo requestWithMethodName:@"users/show.json"
                                               andParams:dic
                                           andHttpMethod:@"GET" 
                                             andDelegate:self];
    
//    [_sinaWeiBo postWeiboRequestWithText:@"hello sina" andImage:nil andDelegate:self];

    [dic release];
}

- (void)authorizeFailed:(WBAuthorize*)auth withError:(NSError*)error{
    if ([self.authDelegate respondsToSelector:@selector(authFailWithEngine:failReason:)]) {
        [self.authDelegate authFailWithEngine:self failReason:[error description]];
    }
}		

#pragma mark-
#pragma mark wbdelegate
- (void)requestLoading:(WBRequest *)request{

}			

- (void)request:(WBRequest *)request didFailWithError:(NSError *)error{
    if (request == _sendRequest) {
        if ([self.dataDelegate respondsToSelector:@selector(sendStatusFailWithEngine:failReason:)]) {
            [self.dataDelegate sendStatusFailWithEngine:self failReason:[error localizedDescription]];
        }
        
        _sendRequest = nil;
    }
}

- (void)request:(WBRequest *)request didLoadRawResponse:(NSData *)data{
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if (request == _userInfoRequest) {
        NSDictionary *dataDic = [str JSONValue];
        
        if([dataDic isKindOfClass:[NSDictionary class]]){
            if ([self.dataDelegate respondsToSelector:@selector(userInfoWithEngine:resultDic:)]) {
                [self.dataDelegate userInfoWithEngine:self resultDic:dataDic];
            }
        }
        
        _userInfoRequest = nil;
        
    }else if(request == _sendRequest){
        if ([self.dataDelegate respondsToSelector:@selector(sendStatusOKWithEngine:)]) {
            [self.dataDelegate sendStatusOKWithEngine:self];
        }
        
        _sendRequest = nil;
    }
    
    NSLog(@"data: %@", str);

}

- (void)request:(WBRequest *)request didLoad:(id)result{

}

@end
