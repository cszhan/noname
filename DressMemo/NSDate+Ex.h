//
//  NSDate+Ex.h
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-18.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Netease)

//从json中解析时间
+ (NSDate *) dateFromNeteaseString:(NSString *) dateString;

//没有年份和秒的中文时间格式
- (NSString *) neteaseNormalFormat;
//相对时间
- (NSString *) timeIntervalStringSinceNow;
- (NSString *) setDateFormat;

@end
