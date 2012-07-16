//
//  ZCSNetClientMgr.h
//  DressMemo
//
//  Created by  on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCSNetClientDataMgr : NSObject
+(id)getSingleTone;
-(void)startUserLogin:(NSDictionary*)param;
@end
