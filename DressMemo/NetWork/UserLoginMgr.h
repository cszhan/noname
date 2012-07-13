//
//  UserLoginMgr.h
//  NEFlyTicket
//
//  Created by cszhan on 11-11-12.
//  Copyright 2011 Netease(hangzhou) Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLoginMgr : NSObject {
	BOOL isShowLogin;
	UIAlertRandomCodeView *loginUI;
}
@property(nonatomic,retain)id delegate;
+(id)getSigleton;
@end
