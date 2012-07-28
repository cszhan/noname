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
+(BOOL)getStopPlayTimerStatus:(NSString*)time;
+(void)setStopPlayTimer:(NSString*)time status:(BOOL)status;
+(id)getStopPlayTimer;
+(void)setStopPlayTimer:(id)minuteNum;
+(NSString*)getLrcSpeedAdjust:(NSString*)lrcUid;
+(void)setLrcSpeedAdjust:(NSString*)lrcUid value:(NSString*)value;
+(void)setPlayingSelPath:(NSNumber*)num;
+(NSDictionary*)getPlayingSong;
+(NSNumber*)getPlayingSelPath;

+(void)setLoginUserInfo:(NSDictionary*)data withUserKey:(NSString*)userId;
+(NSDictionary*)getLoginUserInfo:(NSString*)usrId;

+(NSString*)getCurrentLoginUser;
+(void)setCurrentLoginUser:(NSString*)currUserId;

+(void)setLoginUserId:(NSString*)userId;
+(NSString*)getLoginUserId;
@end
