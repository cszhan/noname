//
//  LrcNetClient.h
//  MP3Player
//
//  Created by cszhan on 12-2-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataTypeDef.h"
#import "NERequest.h"

@protocol NERequestDelegate;
@interface ZCSNetClient : NSObject<NERequestDelegate>{
	NERequest       *_request;
    id              otherRequest;
	NERequest       *cachedRequest;
	NTClientType    _requestType;
	id              _delegate;
	SEL             _action;
	NSInteger       _requestCount;
	//@private
	NSStringEncoding	_respDataEncode;
	PaserDataType		_pdataType;
	NSString            *requestKey;
    ZCSNetClient        *followRequest;
    NSString            *resourceKey;
    BOOL                isPostData;
    id                  respondData;
    NSString            *filePath;
   
}
@property(nonatomic,retain) NERequest *request;
@property(nonatomic,retain) id respondData;
@property(nonatomic,retain) id otherRequest;
@property(nonatomic,retain) NSString *requestKey;
@property(nonatomic,assign) id delegate;
@property(nonatomic,assign) PaserDataType paserDataType;
@property(nonatomic,retain) ZCSNetClient *followRequest;
@property(nonatomic,retain) NSString    *resourceKey;
@property(nonatomic,assign) BOOL isPostData;
@property(nonatomic,readonly)BOOL isWaitting;
@property(nonatomic,readonly)NSStringEncoding respDataEncode;
@property(nonatomic,retain)NSString            *filePath;
+(NSString*)sharedNetCookie;
+(id)getSigleton;
/*
 */
-(void)cancelRequest;
/**
 *like reflush of webview;
 */
-(void)reloadRequest;
/*
 */
-(id)initWithDelegate:(id)_delegate_ withAction:(SEL)_action_;
-(void)startRequest;
-(void)reComposetRequestAddParam:(NSDictionary*)param;
#pragma mark -
#pragma mark net work interfaces

-(void)startAnRequestByUrl:(NSString*)url withParam:(NSDictionary*)params 
                withMethod:(NSString*)method;
@end
