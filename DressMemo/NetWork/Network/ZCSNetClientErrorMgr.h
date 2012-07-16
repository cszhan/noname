//
//  ZCSNetClientErrorMgr.h
//  DressMemo
//
//  Created by  on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCSNetClientErrorMgr : NSObject
-(void)processError:(NSDictionary*)data;
@end
