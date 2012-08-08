//
//  AppSetting.h
//  MP3Player
//
//  Created by cszhan on 12-1-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppSetting : NSObject {

}

+(void)setLoginUserInfo:(NSDictionary*)data withUserKey:(NSString*)userId;
+(NSDictionary*)getLoginUserInfo:(NSString*)usrId;

+(NSString*)getCurrentLoginUser;
+(void)setCurrentLoginUser:(NSString*)currUserId;

+(void)setLoginUserId:(NSString*)userId;
+(NSString*)getLoginUserId;

+(BOOL)getUserLoginStatus;
+(void)setUserLoginStatus:(BOOL)status;
@end
