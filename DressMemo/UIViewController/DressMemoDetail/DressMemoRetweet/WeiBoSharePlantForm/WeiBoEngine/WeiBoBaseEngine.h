//
//  WeiBoBaseEngin.h
//  Tester
//
//  Created by Fengfeng Pan on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeiBoEngineAuthDelegate;
@protocol WeiBoEngineDataDelegate; 

@interface WeiBoBaseEngine : NSObject{
    NSString *_appKey;
    NSString *_appSecret;
    NSString *_appId;
    NSString *tokenKey;
	NSString *tokenSecret;
    
    NSURLRequest *_authRequest;
    
}

@property (nonatomic, readonly) NSString *appKey;
@property (nonatomic, readonly) NSString *appSecret;
@property (nonatomic, readonly) NSString *appId;
@property (nonatomic, copy) NSString *tokenKey;
@property (nonatomic, copy) NSString *tokenSecret;

@property (nonatomic, retain)NSURLRequest *authRequest;

@property (nonatomic, assign) id<WeiBoEngineAuthDelegate> authDelegate;
@property (nonatomic, assign) id<WeiBoEngineDataDelegate> dataDelegate;

-(id)initWithAppKey:(NSString *)appKey AppSecret:(NSString *)appSecret;
-(BOOL)isAuth;
-(NSURLRequest *)auth;
-(BOOL)parseQueryAndRedirect:(NSString *)query;
-(void)canceAuth;
-(void)sendStatus:(NSString *)str Image:(NSData *)imageData;
-(NSString*) valueForKey:(NSString *)key ofQuery:(NSString*)query;

@end

@protocol WeiBoEngineAuthDelegate <NSObject>

-(void)authOKWithEngine:(WeiBoBaseEngine *)engine;
-(void)authFailWithEngine:(WeiBoBaseEngine *)engine failReason:(NSString *)reason;

@end

@protocol WeiBoEngineDataDelegate <NSObject>

-(void)userInfoWithEngine:(WeiBoBaseEngine *)engine resultDic:(NSDictionary *)dic;
-(void)sendStatusOKWithEngine:(WeiBoBaseEngine *)engine;
-(void)sendStatusFailWithEngine:(WeiBoBaseEngine *)engine failReason:(NSString *)reason;

@end
