//
//  LocalImageStorage.m
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-27.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBLocalImageStorage.h"

static NTESMBLocalImageStorage *instance = nil;
@implementation NTESMBLocalImageStorage

+ (NTESMBLocalImageStorage *) getInstance
{
	@synchronized(self){
		if (instance == nil)
		{
			instance = [[NTESMBLocalImageStorage alloc] init];
		}
	}
	return instance;
}

- (NSString *) originalFilePathWithUrlString:(NSString *) urlString
{
	NSArray *array = [urlString componentsSeparatedByString:@"/"];
	return [NSString stringWithFormat:@"%@/Documents/original_image/%@.png", NSHomeDirectory(), [array lastObject]];
}

- (NSString *) smallFilePathWithUrlString:(NSString *) urlString
{
	NSArray *array = [urlString componentsSeparatedByString:@"/"];
	return [NSString stringWithFormat:@"%@/Documents/small_image/%@.png", NSHomeDirectory(), [array lastObject]];
}
-(NSString *)tinyFilePathWithUrlString:(NSString*)urlString{
	NSArray *array = [urlString componentsSeparatedByString:@"/"];
	return [NSString stringWithFormat:@"%@/Documents/tiny_image/%@.png", NSHomeDirectory(), [array lastObject]];

}
- (NSString *) mapFilePathWithLat:(double)lat andLong:(double)lon{
	return [NSString stringWithFormat:@"%@/Documents/small_image/%.3f_%.3f.png", NSHomeDirectory(), lat,lon];
}
#pragma mark image file to image
- (UIImage *) getOriginalImageWithUrl:(NSString *) urlString
{
	NSString *filePath = [self originalFilePathWithUrlString:urlString];
	UIImage *image = [UIImage imageWithContentsOfFile:filePath];
	return image;
}

- (UIImage *) getSmallImageWithUrl:(NSString *) urlString
{
	NSString *filePath = [self smallFilePathWithUrlString:urlString];
	UIImage *image = [UIImage imageWithContentsOfFile:filePath];
	return image;
}
-(UIImage*) getTinyImageWithUrl:(NSString*)urlString{
	NSString *filePath = [self tinyFilePathWithUrlString:urlString];
	UIImage *image = [UIImage imageWithContentsOfFile:filePath];
	return image;
}
#pragma mark  saveimage to data file
- (void) saveImageDataToOriginalDir:(NSData *) imageData urlString:(NSString *) urlString
{
	NSString *writePath = [self originalFilePathWithUrlString:urlString];
	[imageData writeToFile:writePath atomically:YES];
}

- (void) saveImageDataToSmallDir:(NSData *) imageData urlString:(NSString *) urlString
{
	NSString *writePath = [self smallFilePathWithUrlString:urlString];
	[imageData writeToFile:writePath atomically:YES];
}
-(void)saveImageDataToTinyDir:(NSData*) imageData urlString:(NSString *) urlString
{
	NSString *writePath = [self tinyFilePathWithUrlString:urlString];
	BOOL tag;
	tag = [imageData writeToFile:writePath atomically:YES];
}
- (void) saveImageDataToMapDir:(NSData *) imageData Lat:(double)lat andLong:(double)lon
{
	NSString *writePath = [self mapFilePathWithLat:lat andLong:lon];
	[imageData writeToFile:writePath atomically:YES];
}

- (NSString *)saveImageDataToCameraDir:(NSData *)imageData
{
	//uuid file name
	NSString *filePath = [NSString stringWithFormat:@"%@/Documents/camera_image/%@.jpg", NSHomeDirectory(), [[NSProcessInfo processInfo] globallyUniqueString]];
	[imageData writeToFile:filePath atomically:NO];
	return filePath;
}
@end
