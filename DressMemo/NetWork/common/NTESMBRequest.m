//
//  Request.m
//
//  Created by Xu Hanjie on 10-5-11.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBRequest.h"
#import "RequestCfg.h"
//#import "NeteaseMicroblogAppDelegate.h"
#import "NTESMBActivityView.h"
#import "JSON.h"
static NSMutableArray *cookies;
@implementation NTESMBRequest
#define kNTESApiRoot			@"http://api.t.163.com"
#define kNTESTestApiRoot			@"http://new.api.t.163.com"
#define kNTESInerApiRoot		@"http://api.t.netease.com"
@synthesize requestMethod;
@synthesize delegate;
@synthesize urlString;
@synthesize postArguments;
@synthesize dataArguments;
@synthesize getArguments;
@synthesize receiveData;
@synthesize uploadFilePath;
@synthesize timeoutSeconds;
@synthesize needSignon;
@synthesize isNeedAuthRequest;
@synthesize isAuthFailed;
//server内部调用时的标示
@synthesize initByServer;
@synthesize objId;
@synthesize isAuthHeader;
- (id) initWithUrlString:(NSString *) url
{
    self = [super init];
#ifdef TEST
	if([url hasPrefix:kNTESApiRoot]){
		url = [url stringByReplacingOccurrencesOfString:kNTESApiRoot withString:kNTESTestApiRoot];
		NE_LOG(@"test url:%@",url);
	}
#endif
#if 0
	if([NeteaseMicroblogAppDelegate shareApplication].isInerRequest)
    {
		if([url hasPrefix:kNTESApiRoot])
			url = [url stringByReplacingOccurrencesOfString:kNTESApiRoot withString:kNTESInerApiRoot];
			#ifdef DEBUG_API
			NE_LOG(@"InerRequest url:%@",url);
			#endif
	}
#endif
    if (self != nil) {
        urlString = [url copy];
        postArguments = nil;
        getArguments = nil;
        receiveData = [[NSMutableData alloc] init];
        self.requestMethod = @"GET";
		isAuthHeader = NO;
    }
	needSignon = YES;
	isNeedAuthRequest = YES;
    return self;
}


- (void) dealloc
{
	//NE_LOG(@"request dealloc[%@]",urlString);
	[urlString release];
	[uploadFilePath release];
	[postArguments release];
	[getArguments release];
	[receiveData release];
	[requestMethod release];
	[super dealloc];
}


- (NSString *) getTextWithEncoding:(NSStringEncoding) encoding
{
    
    NSString *result = [[NSString alloc] initWithData:receiveData encoding:encoding];
#ifdef REQUEST_DATA_DEBUG
    NE_LOG(@"REQUEST_DATA:%@",result);
#endif
    return [result autorelease];
}
- (id)getJsonObj{
	NSString *resp = [self getTextWithEncoding:NSUTF8StringEncoding];
	return [resp JSONValue];
}

- (void)alertNetConnectFailed:(NSString*)msg{
	
	NTESMBActivityView *warningMessage = [[[NTESMBActivityView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)]autorelease];
	warningMessage.text = msg;//;
	[warningMessage stopAnimatingWithCross];
	UIWindow *topWindow = [[[UIApplication sharedApplication] windows] lastObject];
	//[self.view.window performSelector:@selector(addSubview:) withObject:warningMessage afterDelay:0.5];
	[topWindow performSelectorOnMainThread:@selector(addSubview:)  withObject:warningMessage waitUntilDone:YES];
	[warningMessage performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.5];
	
	//停止右边按钮旋转
	//[self.navigationItem setRightBarButtonItem:refreshButton];
	//CGFontGetGlyphsForUnichars
	//CGContextShowGlyphs
}
-(void)setRespondError:(ASIHTTPRequest*)request{
	NSString *msg = nil;
	if([request.error code] == 1)
    {//ASIConnectionFailureErrorType 1
		msg = kMBNetWorkFailedAlert;
		[self alertNetConnectFailed:msg];
		//return
	}
	else 
    {
		/*
		msg = [NSString stringWithFormat:@"服务端返回出错:[errorModel:%@ errorclass:%@ respondCode:%d ],",[self description],[request description],[request responseStatusCode]];
		UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"错误" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil]autorelease];
		[alert show];
		*/
	}
	
}
@end
