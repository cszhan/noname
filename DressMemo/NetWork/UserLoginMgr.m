//
//  UserLoginMgr.m
//  NEFlyTicket
//
//  Created by cszhan on 11-11-12.
//  Copyright 2011 Netease(hangzhou) Inc. All rights reserved.
//

#import "UserLoginMgr.h"
//#import "UIAlertRandomCodeView.h"
#import "NetClient.h"

extern LoginStatus gLoginStatus;
#define kRequestApiRoot @"https://dynamic.12306.cn"
static NetClient *gNetClient = nil; 
@implementation UserLoginMgr
@synthesize delegate;
+(NSMutableDictionary*)getLoginParams:(NSDictionary*)params
{
	
	NSMutableDictionary * paramsDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
											  //@"login",@"method",		  
											  @"test2009",@"loginUser.user_name",
											  //@""		 ,@"nameErrorFocus",
											  @"123456",@"user.password",
											  //@"",@"passwordErrorFocus",
											  [params objectForKey:@"randcode"],@"randCode",
											  //@"",@"randErrorFocus",
											  //@"iphone",@"platform",
											  nil];
    return paramsDictionary;
}
+(NSString*)getLoginUrl
{
	return [NSString stringWithFormat:@"%@/otsweb/loginAction.do?method=login",kRequestApiRoot];
}

+(NetClient*)getSigleton{
	@synchronized(self){
		if(gNetClient == nil){
			gNetClient = [[self alloc]init];
		}
	}
	return gNetClient;
}
-(void)syncLogin:(id)request
{
	if(isShowLogin)
		return;
	self.delegate = request;
	//@synthesize(self)
	{
		isShowLogin = YES;
	}
#ifdef LOGINVIEW
	UIAlertRandomCodeView *alertView = [[UIAlertRandomCodeView alloc]init];
	[alertView setDelegate:self];
	[alertView showLoginView];
#endif
	//return YES;
	
}
#ifdef LOGINVIEW
#pragma mark Delegate
-(void)didComfirm:(UIAlertRandomCodeView*)sender with:(NSDictionary*)result
{
	[sender release];
	NetClient *syncLogin = [[self class] getSigleton];
	NSDictionary *params = [[self class] getLoginParams:result];
	NetClient *netClient = [[NetClient alloc] initWithDelegate: self withAction:@selector(didFinshedLogin:)];
	[netClient login:params];
	
}

-(void)didCancel:(UIAlertRandomCodeView*)sender
{
	isShowLogin = NO;	
}
-(void)didDiMissAlertView:(id)sender
{
	isShowLogin = NO;
}
#endif
-(void)didFinshedLogin:(id)obj
{
	isShowLogin = NO;
	gLoginStatus = LS_LoginOK;
	NERequest *request = (NERequest*)delegate;
	[request connect];
}
-(void)dealloc{
	[super dealloc];
}
@end
