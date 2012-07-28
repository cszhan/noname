//
//  LrcNetClient.m
//  MP3Player
//
//  Created by cszhan on 12-2-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ZCSNetClient.h"
//#import "NEDebugTool.h"
//#import "ZCSNetClient.h"




static ZCSNetClient *gNetClient = nil;
static NSString  *gEpaySid = nil;
//static NSString  *gNetCookie = nil;
static NSString  *gLoginUrl = nil;
static NSString *gNetCookie = @"dressmemo_sess=0a0bf3fd0dd62a28b39a614e73585c652269604097";
static NSArray *gNetCookieArray = nil;
@implementation ZCSNetClient

@synthesize requestParam;
@synthesize inputParam;
@synthesize delegate = _delegate;
@synthesize request = _request;
@synthesize paserDataType = _pdataType;
@synthesize requestKey;
@synthesize followRequest;
@synthesize resourceKey;
@synthesize isPostData;
@synthesize isWaitting;
@synthesize otherRequest;
@synthesize respDataEncode=_respDataEncode;
@synthesize respondData;
@synthesize filePath;
@synthesize reqEngType;

+(NSString*)sharedNetCookie{
	return gNetCookie;
}
+(NSArray*)shardNetCookieArray{
    return gNetCookieArray;
}
+(id)getSigleton{
	@synchronized(self)
    {
		if(gNetClient == nil){
			gNetClient = [[self alloc]init];
		}
	}
	return gNetClient;
}
-(id)initWithDelegate:(id)delegateParam withAction:(SEL)action{
	if(self  = [super init]){
		self.delegate = delegateParam;
		_action = action;
		_request = nil; 
		_requestType = NTC_UNKNOW;
		//_pdataType = 0;
		_respDataEncode =  NSASCIIStringEncoding;
        followRequest = nil;
        isWaitting = YES;
	}
	return self;
}
-(void)cancelRequest
{
	[_request.connection cancel];
    _request.delegate = nil;
	_delegate = nil;
}
-(void)reloadRequest
{
	if([self.request loading])
		return;
	[self.request connect:self.request.hasPostData];
}

-(void)startAnRequestByUrl:(NSString*)url withParam:(NSDictionary*)params 
withMethod:(NSString*)method
{

    NSMutableDictionary *toParams = [NSMutableDictionary dictionaryWithDictionary:params];
    self.request = [NERequest getRequestWithParams:toParams
                                        httpMethod:method
                                          delegate:self
                                        requestURL:url
                    ];
	_request.isNeedCookie = YES;
    self.request.rsTxType = JSON;
    self.requestParam = params;
	//_requestType = NTC_GETSESSION;
	
	[_request connect:isPostData];
	//[toParams release]
}
-(void)composeRequsestByUrl:(NSString*)url withParam:(NSDictionary*)params 
                 withMethod:(NSString*)method
{
    NSMutableDictionary *toParams = [NSMutableDictionary dictionaryWithDictionary:params];
    self.request = [NERequest getRequestWithParams:toParams
                                        httpMethod:method
                                          delegate:self
                                        requestURL:url
                    ];
    self.requestParam = params;
	_request.isNeedCookie = YES;
    self.request.rsTxType = JSON;
}
-(void)startRequest
{
    [_request connect:isPostData];
    isWaitting = NO;
}
-(void)startRequest:(BOOL)isNeedCookie
{
    
    if(isNeedCookie) 
    {
        _request.cookie = gNetCookie;
       
    }
    else 
    {
         _request.isNeedCookie = NO;
    }
    [_request connect:isPostData];
    isWaitting = NO;
}
-(void)reComposetRequestAddParam:(NSDictionary*)param
{
    NSMutableDictionary *postParam = [NSMutableDictionary dictionaryWithDictionary:_request.params];
    [postParam addEntriesFromDictionary:param];
    NERequest *newRequest =[NERequest getRequestWithParams:postParam
                                                httpMethod:_request.httpMethod
                                                  delegate:self
                                                requestURL:_request.url
                            ];
    newRequest.isNeedCookie = _request.isNeedCookie;
    //newRequest.responseText = _request.responseText;
    newRequest.rsTxType = _request.rsTxType;
    self.request = newRequest;
}
#pragma mark  net client
- (void)request:(NERequest *)request didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse *httpRsp = (NSHTTPURLResponse*)response;
	NSDictionary *respondDict = [httpRsp allHeaderFields];
	NSLog(@"%@",[respondDict description]);
	NSString *contentType = [respondDict objectForKey:@"Content-Type"];
	NSArray *contentTypeArr = [contentType componentsSeparatedByString:@";"];
	for(NSString *item in contentTypeArr)
    {
		if([item hasPrefix:@"charset"]||[item hasPrefix:@"CHARSET"])
        {
			NSLog(@"%@",item);
			NSString *encodStr = [[item componentsSeparatedByString:@"="] objectAtIndex:1];
			if ([encodStr rangeOfString:@"GBK" options:NSCaseInsensitiveSearch].length||[encodStr rangeOfString:@"ZH-CN" options:NSCaseInsensitiveSearch].length) {
				_respDataEncode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
			}
			if([encodStr rangeOfString:@"UTF-8" options:NSCaseInsensitiveSearch].length){
				_respDataEncode = NSUTF8StringEncoding;
			}
		}
	}
    //for cookie
    NE_LOG(@"respond cookie head:%@", [respondDict objectForKey:@"Set-Cookie"]);
    NSArray *cookieArr = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://api.iclub7.com"]];
    gNetCookieArray = [cookieArr retain];
    /*
    for(id item in cookieArr){
        NE_LOG(@"%@",[item description]);
    }
    */
    NSString *cookie = [respondDict objectForKey:@"Set-Cookie"];
    // item = [respondDict objectForKey:@"Set-Cookie"];
    //NE_LOG(@"%@",[[item class]description]);
    if(cookie)
    {
        
        if(gNetCookie == nil)
        {
            gNetCookie = [[NSString alloc] initWithString:cookie];
        }
        else 
        {
            [gNetCookie release];
            gNetCookie = [[NSString alloc] initWithString:cookie];
        }
        /*
         NE_LOG(@"login failed");
         NSError *error = [NSError errorWithDomain:@"LOGINDOMAIN" 
         code:-1 userInfo:
         [NSDictionary setObject:@"登录错误，请重试" forKey:@"error_msg"]];
         
         [self request:request didFailWithError:error];
         
         return;
         */
    }
    
}
#pragma mark  data delegate
- (void)request:(NERequest *)request didLoad:(id)result{
	NE_LOG(@"net respond data ok");
	if([result isKindOfClass:[NSError class]])
    {
        NE_LOG(@"net respond data error");
		NE_LOG(@"%@",[result description]);
        [self request:request didFailWithError:result];
		return;
	}
	if([self.delegate respondsToSelector:_action])
    {
		NSDictionary *resultDict = [NSDictionary dictionaryWithObjectsAndKeys:
									self, @"sender",
									result,@"data",
									nil];
		[self.delegate performSelector:_action withObject:resultDict];
	}
	//[self autorelease];
}
- (void)request:(NERequest *)request didFailWithError:(NSError *)error
{
    NE_LOG(@"net respond failed");
	if(error)
    {
		NSLog(@"%@",[error description]);
		//return;
	}
	if([self.delegate respondsToSelector:_action])
    {
        
		NSDictionary *resultDict = [NSDictionary dictionaryWithObjectsAndKeys:
									self, @"sender",
									error,@"data",
									nil];
        
		[self.delegate performSelector:_action withObject:resultDict];
        
	}

}
-(void)dealloc
{
	//[sel release];
    NE_LOG(@"ZCSNetClient dealloc");
    self.inputParam = nil;
    self.delegate = nil;
    self.request.delegate = nil;
	self.request = nil;
	self.requestKey = nil;
    self.otherRequest = nil;
    self.followRequest = nil;
    self.resourceKey = nil;
    self.respondData = nil;
    self.filePath = nil;
	[super dealloc];
}
@end
