//
//  Request.h
//
//  Created by Xu Hanjie on 10-5-11.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "RequestCfg.h"
#import "ASIHTTPRequest.h"
@class NTESMBRequest;


@protocol RequestDelegate <NSObject>

- (void) requestCompleted:(NTESMBRequest *) request;
- (void) requestFailed:(NTESMBRequest *) request;

@end


@interface NTESMBRequest : NSObject {
	id <RequestDelegate> delegate;
	NSString *urlString;
	NSMutableDictionary *postArguments;
	NSMutableDictionary *dataArguments;
	NSMutableDictionary *getArguments;
	NSMutableData *receiveData;
	NSString *uploadFilePath;
	NSString  *requestMethod;
	NSMutableArray *cookies;
	int timeoutSeconds;
	BOOL initByServer;
	BOOL isNeedAuthRequest;
	BOOL isAuthFailed;
	BOOL isAuthHeader;
	NSString		*objId;
	BOOL needSignon;
}
@property (nonatomic, assign) id <RequestDelegate> delegate;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString		*objId;
@property (nonatomic, retain) NSMutableDictionary *postArguments;
@property (nonatomic, retain) NSMutableDictionary *dataArguments;
@property (nonatomic, retain) NSMutableDictionary *getArguments;
@property (nonatomic, retain) NSMutableData *receiveData;
@property (nonatomic,readonly)NSString *uploadFilePath;
@property (nonatomic) int timeoutSeconds;
@property (nonatomic,assign) BOOL initByServer;
@property (nonatomic,assign) BOOL needSignon;
@property (nonatomic,copy) NSString *requestMethod;
@property (nonatomic,assign) BOOL isNeedAuthRequest;
@property (nonatomic,assign) BOOL isAuthFailed;
@property (nonatomic,assign) BOOL isAuthHeader;

- (id) initWithUrlString:(NSString *) urlString;
- (NSString *) getTextWithEncoding:(NSStringEncoding) encoding;
- (id)getJsonObj;
-(void)setRespondError:(ASIHTTPRequest*)request;
@end
