//
//  NSString+Ex.m
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-6-2.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//


#import "GTMNSString+HTML.h"

@implementation NSString (HTMLDecode)

- (NSString *)HTMLDecode {
    /*const char *source = [self UTF8String];
    char buffer[strlen(source)+1];
    decode_html_entities_utf8(buffer, source);
    NSString *decoded = [NSString stringWithUTF8String:buffer];
    return decoded;*/
	return [self gtm_stringByUnescapingFromHTML];
}

- (NSString *)HTMLencode {
	return [self gtm_stringByEscapingForHTML];
}
+ (NSString*)stringUrlEncoded:(NSString*)aString
{
	NSString *stringEncoded = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
																				 (CFStringRef)aString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
	
	return [stringEncoded autorelease];
}
+ (NSString*)stringAuthUrlEncoded:(NSString*)aString
{
	NSString *stringEncoded = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
																				 (CFStringRef)aString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
	NSString  *string = [NSString stringWithUTF8String:stringEncoded];
	/*
	string = [string stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
	string = [string stringByReplacingOccurrencesOfString:@"*" withString:@"%2A"];
	string = [string stringByReplacingOccurrencesOfString:@"%7E" withString:@"~"];
	*/
	return [stringEncoded autorelease];
}
- (NSString *)YoudaoImageUrlWithWidth:(NSUInteger) maxWidth AndHeight:(NSUInteger)maxHeight {
	
	return [NSString stringWithFormat:@"http://oimageb4.ydstatic.com/image?w=%d&h=%d&url=%@",maxWidth,maxHeight,
			CFURLCreateStringByAddingPercentEscapes(
													NULL,
													(CFStringRef)self,
													NULL,
													(CFStringRef)@"!*'();@&=+$,?%#",																				   
													kCFStringEncodingUTF8 )];
}
+(NSString*)HTMLtoText:(NSString*)string{
	NSArray *levelArr = nil;
	NSInteger count = 0,realLen = 0;
	if(![string hasSuffix:@"</a>"]){
		return string;
	}
	levelArr = [string componentsSeparatedByString:@">"];
	count = [levelArr count];
	if(count<=2)
		return nil;
	levelArr = [ [levelArr objectAtIndex:1] componentsSeparatedByString:@"<"];
	if([levelArr count]<=1)
		return nil;
	return [levelArr objectAtIndex:0];
	/*
	if(![[levelArr objectAtIndex:1] hasSuffix:@"</a>"])
		return nil;
	
	realLen = [[levelArr objectAtIndex:1] length]-4;//</a>len
	return [[levelArr objectAtIndex:1] substringToIndex:realLen] ;
	 */
	
}
+(NSString*)generateNonce
{
	CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
	NSString* nonce = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuid);
	CFRelease(uuid);
	[nonce autorelease];
	return nonce;
}
@end