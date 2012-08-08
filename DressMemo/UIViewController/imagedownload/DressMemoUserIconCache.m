//
//  DressMemoUserIconCache.m
//  DressMemo
//
//  Created by cszhan on 12-8-6.
//
//

#import "DressMemoUserIconCache.h"
#import "NTESMBLocalImageStorage.h"
static DressMemoUserIconCache *sharedInstance = nil;
@implementation DressMemoUserIconCache
+ (DressMemoUserIconCache *) getInstance
{
	@synchronized(self)
    {
		if (sharedInstance == nil)
		{
			sharedInstance = [[DressMemoUserIconCache alloc] init];
			UIImageWithFileName(sharedInstance.statusImageDefault,@"pic-user.png");
		}
	}
	return sharedInstance;
}
- (BOOL) hasCacheWithUserImageKey:(NSString*)userImagekey
{
    return [cache objectForKey:userImagekey]!=nil;
}
- (UIImage *) getImageWithUserIconPath:(NSString*)userIconFileName
{
	//首先看userModel里是不是已经有数据
	UIImage *image  = nil;
	//or 在cache中找
	image = [cache objectForKey:userIconFileName];
	//totalRequest++;
	if (image == nil)
	{
		notHitCount++;
		image = [self getImageFromDBWithUserIconPath:userIconFileName];//from file data base
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
-(UIImage*)getImageFromDBWithUserIconPath:(NSString*)userIconFileName
{
    
    NSString *imageURLString = [self getDresMemoAvatarUrl:userIconFileName];
    NSFileManager *fileManeger = [NSFileManager defaultManager];
	NSString *imageFilePath = nil;
	if (imageURLString)
	{
		imageFilePath = [[NTESMBLocalImageStorage getInstance] iconFilePathWithUrlString:imageURLString];
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
			UIImage *image = [[NTESMBLocalImageStorage getInstance] getIconImageWithUrl:imageURLString];
			return image;
		}
        
	}

}

-(NSString*)getDresMemoAvatarUrl:(NSString*)userIconFileName
{
    NSString *realUrl = [NSString stringWithFormat:@"%@%@%@",kDressMemoImageUrlRoot,userIconFileName,kDressMemoUserIconScaleSize];
    NSLog(@"icon url:%@",realUrl);
    return realUrl;
}
@end
