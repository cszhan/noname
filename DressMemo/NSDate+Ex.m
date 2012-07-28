//
//  NSDate+Ex.m
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-18.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NSDate+Ex.h"


@implementation NSDate (Netease)


+ (NSDate *) dateFromNeteaseString:(NSString *) dateString
{
	
	NSDateFormatter *parser = nil;
	if (parser == nil) {
		parser = [[NSDateFormatter alloc] init];
		[parser setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
		[parser setDateFormat:@"E MMM dd HH:mm:ss Z yyyy"];
	}
	NSDate *date = [parser dateFromString:dateString];
	return date;
}

- (NSString *) neteaseNormalFormat
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[formatter setLocale:locale];
	[locale release];
	[formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
	NSString *string = [formatter stringFromDate:self];
	[formatter release];
	return string;
}
-(NSString *)neteaseFormat:(NSString*)formartString{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[formatter setLocale:locale];
	[locale release];
	[formatter setDateFormat:formartString];
	NSString *string = [formatter stringFromDate:self];
	[formatter release];
	return string;

}
- (NSString *) timeIntervalStringSinceNow
{
	NSInteger seconds = 0 - (NSInteger)[self timeIntervalSinceNow];

	if (seconds < 60)
	{
		return @"刚刚";
		//return [NSString stringWithFormat:@"%d秒前", seconds];
	}
	else if (seconds >= 60 && seconds < 3600)
	{
		return  [NSString stringWithFormat:@"%d分钟前", seconds / 60];
	}
	else if (seconds >= 3600 && seconds < 86400)
	{
		return [NSString stringWithFormat:@"%d小时前", seconds / 3600];
	}
	else if (seconds >= 86400)
	{
		return [NSString stringWithFormat:@"%d天前", seconds / 86400];
	}
	return @"";
}


@end
