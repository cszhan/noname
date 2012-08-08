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
            [instance prepareImageFoder];
		}
	}
	return instance;
}
- (void)prepareImageFoder
{
    [self prepareImageDirectoryWithName:@"small_image"];
	[self prepareImageDirectoryWithName:@"original_image"];
	[self prepareImageDirectoryWithName:@"tiny_image"];
    [self prepareImageDirectoryWithName:@"icon_image"];
}
- (NSString *) originalFilePathWithUrlString:(NSString *) urlString
{
	 NSString *picFileName = urlString;
    NSArray *array = [urlString componentsSeparatedByString:@"/"];
    
    if(array)
    {
        picFileName= [array lastObject];
    }
    NSString *picFullPath = nil;
    NSString *fileSuffix = @"";
    if([picFileName hasSuffix:@".png"]||[picFileName hasSuffix:@".jpg"])
    {
        fileSuffix = @".png";
    }
    picFullPath = [NSString stringWithFormat:@"%@/Documents/original_image/%@%@", NSHomeDirectory(),picFileName,fileSuffix];
	return picFullPath;
}

- (NSString *) smallFilePathWithUrlString:(NSString *) urlString
{
    NSString *picFileName = urlString;
    NSArray *array = [urlString componentsSeparatedByString:@"/"];
    if(array)
    {
        picFileName= [array lastObject];
    }
    NSString *picFullPath = nil;
    NSString *fileSuffix = @"";
    if([picFileName hasSuffix:@".png"]||[picFileName hasSuffix:@".jpg"])
    {
        fileSuffix = @".png";
    }
    picFullPath = [NSString stringWithFormat:@"%@/Documents/small_image/%@%@", NSHomeDirectory(),picFileName,fileSuffix];
	return picFullPath;
}
-(NSString *)tinyFilePathWithUrlString:(NSString*)urlString
{
	 NSString *picFileName = urlString;
    NSArray *array = [urlString componentsSeparatedByString:@"/"];
    
    if(array)
    {
        picFileName= [array lastObject];
    }
    NSString *picFullPath = nil;
    NSString *fileSuffix = @"";
    if([picFileName hasSuffix:@".png"]||[picFileName hasSuffix:@".jpg"])
    {
        fileSuffix = @".png";
    }
    picFullPath = [NSString stringWithFormat:@"%@/Documents/tiny_image/%@%@", NSHomeDirectory(),picFileName,fileSuffix];
	return picFullPath;
    

}
- (NSString*)iconFilePathWithUrlString:(NSString*)urlString
{
    NSString *picFileName = urlString;
    NSArray *array = [urlString componentsSeparatedByString:@"/"];
    if(array)
    {
        picFileName= [array lastObject];
    }
    NSString *picFullPath = nil;
    NSString *fileSuffix = @"";
    if(![picFileName hasSuffix:@".png"]&&![picFileName hasSuffix:@".jpg"])
    {
        fileSuffix = @".png";
    }
    picFullPath = [NSString stringWithFormat:@"%@/Documents/icon_image/%@%@", NSHomeDirectory(),picFileName,fileSuffix];
	return picFullPath;
}

- (NSString *) mapFilePathWithLat:(double)lat andLong:(double)lon
{
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
-(UIImage*) getTinyImageWithUrl:(NSString*)urlString
{
	NSString *filePath = [self tinyFilePathWithUrlString:urlString];
	UIImage *image = [UIImage imageWithContentsOfFile:filePath];
	return image;
}

-(UIImage*)getIconImageWithUrl:(NSString*)urlString
{
    
    NSString *filePath = [self iconFilePathWithUrlString:urlString];
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
- (void)saveImageDataToIconDir:(NSData*) imageData urlString:(NSString*)urlString
{
    NSString *writePath = [self iconFilePathWithUrlString:urlString];
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

#pragma mark -
#pragma mark 缓存文件相关

-(void) prepareImageDirectoryWithName:(NSString *) dirName
{
	NSString *imageDir = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), dirName];
	BOOL isDir = NO;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
	if ( !(isDir == YES && existed == YES) )
	{
		[fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
	}
}

-(void) removeImageDirectoryWithName:(NSString *) dirName
{
	NSString *imageDir = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), dirName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:imageDir error:nil];
}

-(void) clearPhotoCache
{
	[self removeImageDirectoryWithName:@"small_image"];
	[self removeImageDirectoryWithName:@"original_image"];
	[self removeImageDirectoryWithName:@"tiny_image"];
	[self removeImageDirectoryWithName:@"icon_image"];
    
	[self prepareImageDirectoryWithName:@"small_image"];
	[self prepareImageDirectoryWithName:@"original_image"];
	[self prepareImageDirectoryWithName:@"tiny_image"];
    [self prepareImageDirectoryWithName:@"icon_image"];
}

@end
