//
//  APIStatusUpdateImage.m
//  网易微博iPhone客户端
//
//  Created by Wang Cong on 10-5-31.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBAPIStatusUpdateImage.h"


@implementation NTESMBAPIStatusUpdateImage



- (id) initUpdateImageRequestWithData:(NSData *) data andScreenName:(NSString *) screenName
{
    self = [super initWithUrlString:@"http://img.bbs.163.com/t_upload.jsp"];
    self.postArguments = [NSDictionary dictionaryWithObjectsAndKeys:
                          screenName, @"screen_name",
                          nil];
	self.dataArguments = [NSDictionary dictionaryWithObjectsAndKeys:
                          data, @"picture",
                          nil];
    return self;
}

- (id) initUpdateImageRequestWithFilePath:(NSString *) path andScreenName:(NSString *) screenName
{
    //self = [super initWithUrlString:@"http://img.bbs.163.com/t_upload.jsp"];
    //self.postArguments = [NSDictionary dictionaryWithObjectsAndKeys:
    //                      screenName, @"screen_name",
    //                      nil];
	
	self = [super initWithUrlString:@"http://upload.buzz.163.com/upload"];
	self.postArguments = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"http://t.163.com/%@" ,screenName], @"watermark",
                          nil];
	uploadFilePath = [path copy];
	self.timeoutSeconds = 120;
    return self;
}
- (id) initUpdateImageRequestWithFilePath:(NSString *) path withtoken:(NSString*)token
{
    //self = [super initWithUrlString:@"http://img.bbs.163.com/t_upload.jsp"];
    //self.postArguments = [NSDictionary dictionaryWithObjectsAndKeys:
    //                      screenName, @"screen_name",
    //                      nil];
	
	self = [super initWithUrlString:@"http://api.iclub7.com/memo/uploadpic"];
	self.postArguments = [NSDictionary dictionaryWithObjectsAndKeys:
                          token,@"token",
                          nil];
	uploadFilePath = [path copy];
	self.timeoutSeconds = 120;
    return self;
}

- (NSString*) imageUrl
{
	@try {
		NSString *image_url = [self getTextWithEncoding:NSUTF8StringEncoding];
		
		NE_LOG(@"%@",image_url);
		return [[image_url JSONValue] objectForKey:@"originalURL"];
	}
	@catch (NSException * e)
    {
		
	}
	return nil;
	/*NSRange iStart  = [image_url rangeOfString :@"http://126.fm"];
	NSRange iEnd  = [image_url rangeOfString :@"\");"];
	if (iStart.location == NSNotFound || iEnd.location == NSNotFound) {
		return nil;
	}
	int  iLength     = iEnd.location - iStart.location;
	return [image_url substringWithRange: NSMakeRange( iStart.location, iLength ) ];*/
}

@end
