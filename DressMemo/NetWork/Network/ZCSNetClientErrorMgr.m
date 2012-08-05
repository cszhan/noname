//
//  ZCSNetClientErrorMgr.m
//  DressMemo
//
//  Created by  on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZCSNetClientErrorMgr.h"
#import "ZCSNotficationMgr.h"
static NSString* mapArr[] = 
{
  
};
static ZCSNetClientErrorMgr *sharedInstance = nil;
@interface ZCSNetClientErrorMgr()
@property(nonatomic,retain)NSMutableDictionary*errorMap;
@end
@implementation ZCSNetClientErrorMgr
@synthesize errorMap;
+(id)getSingleTone
{
	@synchronized(self)
    {
		if(sharedInstance == nil){
			sharedInstance = [[self alloc]init];
            [sharedInstance initErrorMapData];
		}
	}
	return sharedInstance;
}
-(void)initErrorMapData
{
    //if(self = [super init]){
    self.errorMap = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                     @"101",@"访问错误",
                     @"102",@"token错误",
                     @"201",@"不是正确的email",
                     @"202",@"帐号已存在",//@"email已经存在",
                     @"203",@"需要登录",
                     @"204",@"登录用户名，密码不正确",
                     @"205",@"Email为空",
                     @"206",@"该用户名尚未注册",//@"该email尚未注册",
                     @"207",@"密码为空",
                     @"208",@"密码错误",
                     @"209",@"密码太短，最少6个字符",
                     @"210",@"密码支持使用半角数字，字符，符号，区分大小写",
                     @"211",@"昵称为空",
                     @"212",@"昵称太短，最少4个字符",
                     @"213",@"昵称包含用空格",
                     @"214",@"该昵称已被注册",
                     @"215",@"用户不存在",
                     @"316",@"memo上传时未传递图片",
                     @"402",@"邮件发送失败",
                     //@"402	邮件发送失败
                     @"501",@"自己不能操作自己",
                     @"502",@"已经关注过该用户",
                     @"503",@"尚未关注过该用户",
                     
                     @"504",@"memo不存在",
                     @"505",@"自己不能关注自己的memo",
                     @"506",@"已经关注过该memo",
                     @"507",@"尚未关注过该memo",
                     nil];
    /*
    for(int i = 0;i<36;)
    {
        [self.errorMap setValue:mapArr[i+1] forKey:mapArr[i]];
        i = i+2;
    }
    */
    NSMutableDictionary *targetDict  = [NSMutableDictionary dictionary];
    for (id key in self.errorMap)
    {
        [targetDict setValue:key forKey:[self.errorMap objectForKey:key]];
    }
    self.errorMap = targetDict;
    NSLog(@"%@",[self.errorMap description]);
      [ZCSNotficationMgr addObserver:self call:@selector(processError:) msgName:kZCSNetWorkRespondFailed];
}

-(void)processError:(NSNotification*)ntf 
{
    //[SVProgressHUD dismissWithError:@""];
    id obj = [ntf object];
    NSDictionary *resDict = [obj objectForKey:@"data"];
    //int errCode = [[resDict objectForKey:@"code"]intValue];
    NSString *key = [resDict objectForKey:@"code"];
    NSString *msg = [self.errorMap objectForKey:key];
    [self performSelectorOnMainThread:@selector(alertMsg:) withObject:msg waitUntilDone:NO]; //alertMsg:msg];
    
}
-(void)alertMsg:(NSString*)errMsg
{
    //NSString *errMsg = [obj localizedDescription];
    UIAlertView *alertErr = [[[UIAlertView alloc]initWithTitle:@"请求错误" message:errMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil, nil]autorelease];
    [alertErr show];
}
@end
