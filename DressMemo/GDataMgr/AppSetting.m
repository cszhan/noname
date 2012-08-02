//
//  AppSetting.m
//  MP3Player
//
//  Created by cszhan on 12-1-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AppSetting.h"


@implementation AppSetting

+(void)setLoginUserId:(NSString*)userId
{

    NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
    [usrDefaults setValue:userId forKey:@"userId"];
    [usrDefaults synchronize];
}
+(NSString*)getLoginUserId
{
    NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
    return [usrDefaults objectForKey:@"userId"];
}
+(void)setLoginUserInfo:(NSDictionary*)data withUserKey:(NSString*)userId
{
    NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
    [usrDefaults setValue:data forKey:userId];
    [usrDefaults synchronize];

}
+(NSDictionary*)getLoginUserInfo:(NSString*)userId
{
    NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
    return [usrDefaults objectForKey:userId];
    
}
+(void)setLoginUserDetailInfo:(NSDictionary*)data userId:(NSString*)userId
{
    NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
    [usrDefaults setValue:data forKey:userId];
    [usrDefaults synchronize];
}
+(NSDictionary*)getLoginUserDetailInfo:(NSString*)userId
{
    NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
    return [usrDefaults objectForKey:userId];
}
+(NSString*)getCurrentLoginUser
{
    
    NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
    return [usrDefaults objectForKey:kCurrentLoginUser];
    
}
+(void)setCurrentLoginUser:(NSString*)currUserId{

    NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
    [usrDefaults setValue:currUserId forKey:kCurrentLoginUser];
    [usrDefaults synchronize];
}
+(void)clearCurrentLoginUser{
     
}
+(BOOL)getStopPlayTimerStatus:(NSString*)time{
	return [[[NSUserDefaults standardUserDefaults]objectForKey:time]boolValue];
}
+(void)setStopPlayTimer:(NSString*)time status:(BOOL)status{
	NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
	[usrDefaults setValue:[NSNumber numberWithBool:status] forKey:time];
	[usrDefaults synchronize];
}
+(id)getStopPlayTimer{
	NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
	/*
	[usrDefaults setValue:[NSNumber numberWithBool:status] forKey:@];
	[usrDefaults synchronize];
	*/
	return [usrDefaults objectForKey:@"stopTimer"];
}
+(void)setStopPlayTimer:(id)minuteNum{
	NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
	[usrDefaults setValue:minuteNum forKey:@"stopTimer"];
	[usrDefaults synchronize];
}

@end
