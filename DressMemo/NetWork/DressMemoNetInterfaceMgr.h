//
//  DressMemoNetInterfaceMgr.h
//  DressMemo
//
//  Created by  on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DressMemoNetInterfaceMgr : NSObject
+(id)getSingleTone;
-(NSString*)startAnRequestByKey:(NSString*)requestKey withParam:(NSDictionary*)params withMethod:(NSString*)method;
-(NSString*)startAnRequestByResKey:(NSString*)resKey needLogIn:(BOOL)needLogin withParam:(NSDictionary*)params withMethod:(NSString*)method;
@end
