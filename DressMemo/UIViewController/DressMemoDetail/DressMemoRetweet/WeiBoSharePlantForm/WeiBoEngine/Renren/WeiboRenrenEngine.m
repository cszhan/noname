//
//  WeiboRenrenEngine.m
//  UMSNSDemo
//
//  Created by cszhan on 11-12-17.
//  Copyright 2011 Realcent. All rights reserved.
//

#import "WeiboRenrenEngine.h"
#import "Renren.h"
#import "ROUtility.h"
#import "ROMacroDef.h"
#import "ROError.h"
#import "ROUserResponseItem.h"
#import "ROPublishPhotoResponseItem.h"
#import "ROPublishFeedRequestParam.h"
@implementation WeiboRenrenEngine
@synthesize webView;
//@synthesize response;
@synthesize accessToken;
@synthesize expirationDate;
-(id)init{
	if(self = [super init]){
		renren = [Renren sharedRenren];
        renren.appId = self.appId;
        renren.appKey = self.appKey;
	}
	return self;
}
-(void)dealloc{
	[renren dealloc];
	[super dealloc];
}
-(id)auth{
	renren = [Renren sharedRenren];
	renren.appId = self.appId;
    renren.appKey = self.appKey;
    
	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* graphCookies = [cookies cookiesForURL:
                             [NSURL URLWithString:@"http://graph.renren.com"]];
	
	for (NSHTTPCookie* cookie in graphCookies) {
		[cookies deleteCookie:cookie];
	}
	NSArray* widgetCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://widget.renren.com"]];
	
	for (NSHTTPCookie* cookie in widgetCookies) {
		[cookies deleteCookie:cookie];
	}
	NSArray *permissions = [NSArray arrayWithObjects:
							@"photo_upload",
							@"publish_feed",
							@"publish_blog",
							nil];
   // if (![self isSessionValid]) 

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:self.appKey forKey:@"client_id"];
        [parameters setValue:kRRSuccessURL forKey:@"redirect_uri"];
        [parameters setValue:@"token" forKey:@"response_type"];
        [parameters setValue:@"touch" forKey:@"display"];
		[parameters setObject:kWidgetDialogUA forKey:@"ua"];
		
        if (permissions) {
            NSString *permissionScope = [permissions componentsJoinedByString:@","];
            [parameters setValue:permissionScope forKey:@"scope"];
        }

	
    NSURL *url = [ROUtility generateURL:kAuthBaseURL params:parameters];
	NSLog(@"start load URL: %@", url);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
	return request;
		//[renren authorizationWithPermisson:nil andDelegate:delegate];
}
-(id)getAuthViewController{
	renren = [Renren sharedRenren];
	renren.appId = self.appId;
    renren.appKey = self.appKey;
	id  retVc= [renren getRenrenAuthV2ViewController:self];
	
	return retVc;
}
-(BOOL)canceAuth{
	[super canceAuth];
	self.accessToken = nil;
	self.expirationDate = nil;
	renren = [Renren sharedRenren];
	[renren delUserSessionInfo];
	return YES;
}
-(BOOL)isAuth
{
    BOOL tag;
	renren = [Renren sharedRenren];
	renren.appId = self.appId;
    renren.appKey = self.appKey;
	return ([renren isSessionValid]);
}
#pragma mark webAuthDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	NSURL *url = request.URL;
    NSString *query = [url fragment]; // url中＃字符后面的部分。
    if (!query) {
        query = [url query];
    }
    NSDictionary *params = [ROUtility parseURLParams:query];
    NSString *accessToken = [params objectForKey:@"access_token"];
    //    NSString *error_desc = [params objectForKey:@"error_description"];
    NSString *errorReason = [params objectForKey:@"error"];
    if(nil != errorReason) {
        [self dialogDidCancel:nil];
        return NO;
    }
    if (navigationType == UIWebViewNavigationTypeLinkClicked)/*点击链接*/{
        BOOL userDidCancel = ((errorReason && [errorReason isEqualToString:@"login_denied"])||[errorReason isEqualToString:@"access_denied"]);
        if(userDidCancel){
            [self dialogDidCancel:url];
        }else {
            NSString *q = [url absoluteString];
            if (![q hasPrefix:kAuthBaseURL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
        }
        return NO;
    }
    if (navigationType == UIWebViewNavigationTypeFormSubmitted) {//提交表单
        NSString *state = [params objectForKey:@"flag"];
        if ((state && [state isEqualToString:@"success"])||accessToken) {
            [self dialogDidSucceed:url];
        }
    }
    return YES;
	
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
        [self dismissWithError:error animated:YES];
    }
}

- (void)updateSubviewOrientation 
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self.webView stringByEvaluatingJavaScriptFromString:
         @"document.body.setAttribute('orientation', 90);"];
    } else {
        [self.webView stringByEvaluatingJavaScriptFromString:
         @"document.body.removeAttribute('orientation');"];
    }
}

- (void)dialogDidSucceed:(NSURL *)url {
	NSString *q = [url absoluteString];
	if([self isAuthDialog]) 
	{
        NSString *token = [ROUtility getValueStringFromUrl:q forParam:@"access_token"];
        NSString *expTime = [ROUtility getValueStringFromUrl:q forParam:@"expires_in"];
        NSDate   *expirationDate = [ROUtility getDateFromString:expTime];
        NSDictionary *responseDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:token,expirationDate,nil]
                                                                forKeys:[NSArray arrayWithObjects:@"token",@"expirationDate",nil]];
        //self.response = [ROResponse responseWithRootObject:responseDic];
        
        if ((token == (NSString *) [NSNull null]) || (token.length == 0)) {
            [self dialogDidCancel:nil];
        } else 
		{
		
			self.accessToken = token;
            self.expirationDate = expirationDate;
            self.tokenSecret=[ROUtility getSecretKeyByToken:token];
            self.tokenKey =[ROUtility getSessionKeyByToken:token];
			
			renren.accessToken = token;
			renren.expirationDate = expirationDate;
			renren.secret = [ROUtility getSecretKeyByToken:token];
			renren.sessionKey = [ROUtility getSessionKeyByToken:token];
			[renren saveUserSessionInfo];
			[self getUserInfor];
			/*
			if ([self.authDelegate respondsToSelector:@selector(authDialog:withOperateType:)])  {
                [self.authDelegate authDialog:self withOperateType:RODialogOperateSuccess];
            }
		    */
			
        }
    }
	else 
	{
        NSString *flag = [ROUtility getValueStringFromUrl:q forParam:@"flag"];	
        if ([flag isEqualToString:@"success"]) {
            NSString *query = [url fragment];
            if (!query) {
                query = [url query];
            }
            NSDictionary *params = [ROUtility parseURLParams:query];
			/*
            self.response = [ROResponse responseWithRootObject:params];
            if ([self.authDelegate respondsToSelector:@selector(widgetDialog:withOperateType:)])
			{
                [self.authDelegate widgetDialog:self withOperateType:RODialogOperateSuccess];
            }
			*/
        }
    }
    
}
#pragma mark getUserInfor 
- (void)getUserInfor{
	requestType = 0;
	ROUserInfoRequestParam *requestParam = [[[ROUserInfoRequestParam alloc] init] autorelease];
	requestParam.fields = [NSString stringWithFormat:@"uid,name,sex,birthday,headurl"];
	[renren getUsersInfo:requestParam andDelegate:self];

}
#pragma mark send phonto
-(void)sendStatus:(NSString *)str Image:(NSData *)imageData
{
	requestType = 1;
    renren = [Renren sharedRenren];
	renren.appId = self.appId;
    renren.appKey = self.appKey;
	if(imageData){
		//first upload
		ROPublishPhotoRequestParam *param = [[ROPublishPhotoRequestParam alloc] init];
		param.imageFile = imageData;
		param.caption = @"";
		param.caption  =  str;
		[renren publishPhoto:param andDelegate:self];
		[param release];
	}
	else {
		
		[self publicFeedWithImageUrl:str urlImage:nil];
		//pbulic feeds
		/*
		sig	string	签名认证。是用当次请求的所有参数计算出来的值。点击此处查看详细算法
		method	string	feed.publishFeed
		v	string	API的版本号，固定值为1.0
		name	string	新鲜事标题 注意：最多30个字符
		description	string	新鲜事主体内容 注意：最多200个字符。
		url	string	新鲜事标题和图片指向的链接。
		*/
		//<#statements#>
	}
}
-(void)publicFeedWithImageUrl:(NSString*)content urlImage:(NSString*)url{
    renren = [Renren sharedRenren];
	renren.appId = self.appId;
    renren.appKey = self.appKey;
	ROPublishFeedRequestParam *param = [[ROPublishFeedRequestParam alloc] init];
	param.text = content;
	//param.imageUrl = @"http://fmn.rrimg.com/fmn057/20111218/1440/p_head_zNJ1_290900019131121a.jpg";
	[renren publishFeed:param andDelegate:self];
	[param release];
}
/**
 * 接口请求成功，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
	switch (requestType) {
		case 0:
			[self didGetUserInfoRespond:response];
			break;
		case 1:
			[self didPublicPhotoRespond:response];
			break;
		default:
			break;
	}
	
		//self.textView.text = outText;
	//[self.indicatorView stopAnimating];
}
-(void)didGetUserInfoRespond:(ROResponse*)response{
	NSArray *usersInfo = (NSArray *)(response.rootObject);
	//NSString *outText = [NSString stringWithFormat:@""];
	for (id item in usersInfo)
	{
		if([item isKindOfClass:[ROUserResponseItem class]]){
			
			//outText = [outText stringByAppendingFormat:@"UserID:%@\n Name:%@\n Sex:%@\n Birthday:%@\n HeadURL:%@\n",item.userId,item.name,item.sex,item.brithday,item.headUrl];
			if([item name]){
				[self.dataDelegate userInfoWithEngine:self resultDic:[NSDictionary dictionaryWithObjectsAndKeys:[item name],@"nick",nil]];
				break;
			}
		}
		
	}
	[self.authDelegate authOKWithEngine:self];
}
-(void)didPublicPhotoRespond:(ROResponse*)response{
	//if([response.rootObject isKindOfClass:[NSDictionary class)
	
	if ([response.rootObject  isKindOfClass:[ROPublishPhotoResponseItem class]])
	{
	}
	if (self.dataDelegate && [self.dataDelegate respondsToSelector:@selector(sendStatusOKWithEngine:)]) 
	{
		[self.dataDelegate sendStatusOKWithEngine:self];
	}
	
}
#pragma mark getrespond
/**
 * 获取
 */
- (void)request:(RORequest *)request didLoadRawResponse:(NSData *)data{

     


}
#pragma mark  getUserInforDelegate
/**
 * 接口请求失败，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
	//[self.indicatorView stopAnimating];
	
	NSString *title = [NSString stringWithFormat:@"Error code:%d", [error code]];
	NSString *description = [NSString stringWithFormat:@"%@", [error.userInfo objectForKey:@"error_msg"]];
	/*
	UIAlertView *alertView =[[[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] autorelease];
	[alertView show];
	*/
	if ([self.dataDelegate respondsToSelector:@selector(sendStatusFailWithEngine:failReason:)]) {
		[self.dataDelegate sendStatusFailWithEngine:self failReason:description];
	}
}
- (void)dismissWithError:(NSError*)error animated:(BOOL)animated {
	/*
    self.response = [ROResponse responseWithError:[ROError errorWithNSError:error]];
    if ([self isAuthDialog]) {
        if ([self.authDelegate respondsToSelector:@selector(authDialog:withOperateType:)]){
            [self.authDelegate authDialog:self withOperateType:RODialogOperateFailure];
        }
    }else {
        if ([self.authDelegate respondsToSelector:@selector(widgetDialog:withOperateType:)]) {
            
            [self.authDelegate widgetDialog:self withOperateType:RODialogOperateFailure];
        }
    }
	*/
	
}

- (void)dialogDidCancel:(NSURL *)url {
	/*
    if ([self isAuthDialog]) {
        if ([self.authDelegate respondsToSelector:@selector(authDialog:withOperateType:)]){
            [self.authDelegate authDialog:self withOperateType:RODialogOperateCancel];
        }
    }else {
        if ([self.authDelegate respondsToSelector:@selector(widgetDialog:withOperateType:)]){
            [self.authDelegate widgetDialog:self withOperateType:RODialogOperateCancel];
        }
    }
	*/
	[self.authDelegate authOKWithEngine:self];
    
}

- (BOOL)isAuthDialog
{
    return YES;
	//return [_serverURL isEqualToString:kAuthBaseURL];
}
@end
