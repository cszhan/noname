//
//  ZCSDataArchiveMgr.h
//  DressMemo
//
//  Created by  on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCSDataArchiveMgr : NSObject
+(id)getSingleTone;
-(BOOL)archiveObjectData:(id)object forKey:(NSString*)key;
-(id)archiveObjectDataFetch:(NSString*)key;
-(BOOL)saveImageToPath:(NSData*)data fileName:(NSString*)fileName;
@end
