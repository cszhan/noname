//
//  NSString+Ex.h
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-6-2.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (HTMLDecode)

- (NSString *)HTMLDecode;
- (NSString *)HTMLencode;
+ (NSString*)stringUrlEncoded:(NSString*)aString;
- (NSString *)YoudaoImageUrlWithWidth:(NSUInteger) maxWidth AndHeight:(NSUInteger)maxHeight ;
+(NSString*)HTMLtoText:(NSString*)string;
+(NSString*)generateNonce;
@end
