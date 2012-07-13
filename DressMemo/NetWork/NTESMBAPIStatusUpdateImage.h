//
//  APIStatusUpdateImage.h
//  网易微博iPhone客户端
//
//  Created by Wang Cong on 10-5-31.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESMBServer.h"

@interface NTESMBAPIStatusUpdateImage : NTESMBRequest {
	
}
- (id) initUpdateImageRequestWithFilePath:(NSString *) path withtoken:(NSString*)token;
- (id) initUpdateImageRequestWithData:(NSData *) data andScreenName:(NSString *) screenName;
- (id) initUpdateImageRequestWithFilePath:(NSString *) path andScreenName:(NSString *) screenName;
- (NSString*) imageUrl;
@end
