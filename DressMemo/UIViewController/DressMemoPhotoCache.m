//
//  DressMemoTinyPhotoCache.m
//  DressMemo
//
//  Created by cszhan on 12-8-7.
//
//

#import "DressMemoPhotoCache.h"
static DressMemoPhotoCache *sharedInstance = nil;
@implementation DressMemoPhotoCache
+ (DressMemoUserIconCache *) getInstance
{
	@synchronized(self)
    {
		if (sharedInstance == nil)
		{
			sharedInstance = [[DressMemoPhotoCache alloc] init];
			UIImageWithFileName(sharedInstance.statusImageDefault,@"pic-user.png");
		}
	}
	return sharedInstance;
}
#pragma mark -
#pragma mark from chache
- (UIImage *) getImageWithTinyImagePath:(NSString*)userIconFileName
{
    //首先看userModel里是不是已经有数据
	UIImage *image  = nil;
	//or 在cache中找
	image = [cache objectForKey:userIconFileName];
	//totalRequest++;
	if (image == nil)
	{
		notHitCount++;
		image = [self getImageFromDBWithTinyImagePath:userIconFileName];//from file data base
		if (image == nil)
		{
#ifdef DEBUG
			NE_LOG(@"[cache:not hit][db:not hit][%@]",userIconFileName);
#endif
			return nil;
		}
#ifdef DEBUG
		NE_LOG(@"[cache:not hit][db:hit][%@]",userIconFileName);
#endif
		[cache setObject:image forKey:userIconFileName];
	}
    else
    {
#ifdef DEBUG
		NE_LOG(@"[cache:hit]");
#endif
	}
	return image;

}

-(UIImage *)getImageWithSmallImagePath:(NSString*)userIconFileName
{
    //首先看userModel里是不是已经有数据
	UIImage *image  = nil;
	//or 在cache中找
    image = [self getImageFromDBWithSmallImagePath:userIconFileName];//from file data base
    if (image == nil)
    {
    #ifdef DEBUG
        NE_LOG(@"[cache:not hit][db:not hit][%@]",userIconFileName);
    #endif
        return nil;
    }
	return image;
    
}
-(UIImage *)getImageWithOriginImagePath:(NSString*)userIconFileName
{
    //首先看userModel里是不是已经有数据
	UIImage *image  = nil;
	//or 在cache中找
    image = [self getImageFromDBWithOriginImagePath:userIconFileName];//from file data base
    if (image == nil)
    {
#ifdef DEBUG
        NE_LOG(@"[cache:not hit][db:not hit][%@]",userIconFileName);
#endif
        return nil;
    }
	return image;
    
}

#pragma mark image from file 
-(UIImage*)getImageFromDBWithOriginImagePath:(NSString*)imagePath
{
    
    NSString *imageURLString = [self getDresMemoOriginUrl:imagePath];
    NSFileManager *fileManeger = [NSFileManager defaultManager];
	NSString *imageFilePath = nil;
	if (imageURLString)
	{
		imageFilePath = [[NTESMBLocalImageStorage getInstance] originalFilePathWithUrlString:imageURLString];
		if ([fileManeger fileExistsAtPath:imageFilePath] == NO)
		{
#ifdef DEBUG
			NE_LOG(@"need load remote tiny image");
#endif
			return nil;
		}
		else
        {
			NE_LOG(@"tiny image hit the db file");
			UIImage *image = [[NTESMBLocalImageStorage getInstance] getOriginalImageWithUrl:imageURLString];
			return image;
		}
        
	}
    
}
-(UIImage*)getImageFromDBWithSmallImagePath:(NSString*)imagePath
{
    
    NSString *imageURLString = [self getDresMemoSmallUrl:imagePath];
    NSFileManager *fileManeger = [NSFileManager defaultManager];
	NSString *imageFilePath = nil;
	if (imageURLString)
	{
		imageFilePath = [[NTESMBLocalImageStorage getInstance] smallFilePathWithUrlString:imageURLString];
		if ([fileManeger fileExistsAtPath:imageFilePath] == NO)
		{
#ifdef DEBUG
			NE_LOG(@"need load remote tiny image");
#endif
			return nil;
		}
		else
        {
			NE_LOG(@"tiny image hit the db file");
			UIImage *image = [[NTESMBLocalImageStorage getInstance] getSmallImageWithUrl:imageURLString];
			return image;
		}
        
	}
    
}
-(UIImage*)getImageFromDBWithTinyImagePath:(NSString*)imagePath
{
    
    NSString *imageURLString = [self getDresMemoTinyUrl:imagePath];
    NSFileManager *fileManeger = [NSFileManager defaultManager];
	NSString *imageFilePath = nil;
	if (imageURLString)
	{
		imageFilePath = [[NTESMBLocalImageStorage getInstance] tinyFilePathWithUrlString:imageURLString];
		if ([fileManeger fileExistsAtPath:imageFilePath] == NO)
		{
#ifdef DEBUG
			NE_LOG(@"need load remote tiny image");
#endif
			return nil;
		}
		else
        {
			NE_LOG(@"tiny image hit the db file");
			UIImage *image = [[NTESMBLocalImageStorage getInstance] getTinyImageWithUrl:imageURLString];
			return image;
		}
        
	}
    
}
-(NSString*)getDresMemoTinyUrl:(NSString*)userIconFileName
{
    NSString *realUrl = [NSString stringWithFormat:@"%@%@%@",kDressMemoImageUrlRoot,userIconFileName,kDressMemoPhotoTinyScaleSize];
    NSLog(@"icon url:%@",realUrl);
    return realUrl;
}
-(NSString*)getDresMemoSmallUrl:(NSString*)userIconFileName
{
    NSString *realUrl = [NSString stringWithFormat:@"%@%@%@",kDressMemoImageUrlRoot,userIconFileName,kDressMemoPhotoSmallScaleSize];
    NSLog(@"icon url:%@",realUrl);
    return realUrl;
}
-(NSString*)getDresMemoOriginUrl:(NSString*)userIconFileName
{
    NSString *realUrl = [NSString stringWithFormat:@"%@%@%@",kDressMemoImageUrlRoot,userIconFileName];
    NSLog(@"icon url:%@",realUrl);
    return realUrl;
}
@end
