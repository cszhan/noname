//
//  UserIconCache.m
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-28.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBUserIconCache.h"
//#import "NTESMBDB.h"
#import "NSData+Ex.h"
#import "NEDebugTool.h"
#import "UIParamsCfg.h"
static NTESMBUserIconCache *instance = nil;
@implementation NTESMBUserIconCache

@synthesize topRetweetsImage;
@synthesize placeHolderImage;
@synthesize statusImageDefault;
+ (NTESMBUserIconCache *) getInstance
{
	@synchronized(self){
		if (instance == nil)
		{
			instance = [[NTESMBUserIconCache alloc] init];
			UIImageWithFileName(instance.statusImageDefault,@"pic-user.png");
		}
	}
	return instance;
}

- (UIImage *) updateCacheWithUserModel:(NTESMBUserModel *)userModel
{
	UIImage *image = nil;
	if (userModel.userImageData!=nil)
    {
		image = [userModel.userImageData getNeteaseIcon];
		[cache setObject:image forKey:userModel.screenName];
	}
	return image;
}

- (void) removeCacheWithUserModel:(NTESMBUserModel *)userModel
{
	[cache removeObjectForKey:userModel.screenName];
}

- (BOOL) hasCacheWithUserModel:(NTESMBUserModel *)userModel{
	return [cache objectForKey:userModel.screenName]!=nil;
}
- (BOOL) hasCacheWithUserImageKey:(NSString*)userImagekey{
    return [cache objectForKey:userImagekey];
}
- (UIImage *) getImageWithUserModel:(NTESMBUserModel *) userModel
{
	//首先看userModel里是不是已经有数据
	UIImage *image  = nil;
#if 0
	UIImage *image = [self updateCacheWithUserModel:userModel];
	if (image!=nil) {
		return image;
	}
#endif
	//or 在cache中找
	image = [cache objectForKey:userModel.screenName];
	totalRequest++;
	if (image == nil)
	{
		notHitCount++;
		image = [self getImageFromDBWithUserModel:userModel];
		if (image == nil)
		{
#ifdef DEBUG
			NE_LOG(@"[cache:not hit][db:not hit][%@]",userModel.screenName);
#endif
			return nil;
		}
#ifdef DEBUG
		NE_LOG(@"[cache:not hit][db:hit][%@]",userModel.screenName);
#endif
		[cache setObject:image forKey:userModel.screenName];
	}else {
#ifdef DEBUG
		NE_LOG(@"[cache:hit]");
#endif
	}
	return image;
}
#if 0
-(UIImage*)getImageWithStatusModel:(NTESMBStatusModel *)status{
	NSString *imageURLString = [status getStatusTinyImageUrl];
	//NSString *imageFilePath = [self imageFilePath:imageURLString];
	NSString *rootImageURLString = [status getRootTinyImageUrl];
	//NSString *rootImageFilePath = [self imageFilePath:rootImageURLString];
	
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
		else {
			NE_LOG(@"tiny image hit the db file");
			UIImage *image = [[NTESMBLocalImageStorage getInstance] getTinyImageWithUrl:imageURLString];
			return image;
		}

	}
	NSString *rootImageFilePath = nil;
	if (rootImageURLString) 
	{
		rootImageFilePath = [[NTESMBLocalImageStorage getInstance] tinyFilePathWithUrlString:rootImageURLString];
		if ([fileManeger fileExistsAtPath:rootImageFilePath] == NO)
			{
#ifdef DEBUG
				NE_LOG(@"need load remote tiny image");
#endif
				return nil;
			}
			else {
				NE_LOG(@"tiny image hit the db file");
				UIImage *image = [[NTESMBLocalImageStorage getInstance] getTinyImageWithUrl:rootImageURLString];
				return image;
			}
			
		
	}
	return nil;
}

- (UIImage *) getImageFromDBWithUserModel:(NTESMBUserModel *) userModel
{
	//BOOL e = NO;
	User *thisUser = [[NTESMBDB getInstance] getUserWithScreenName:userModel.screenName];
	/*
	NE_LOG(@"ttt:%@",thisUser.idn);
	NE_LOG(@"%@",thisUser.screenName);
	NE_LOG(@"%@,%@",thisUser.name,thisUser.userImageURL);
	*/
	//thisUser.userImageURL
	if (thisUser == nil || thisUser.userImageData == nil)
	{
		return nil;
	}
	//return nil;
	if (![userModel.userImageURL isEqualToString:thisUser.userImageURL]) 
    {
		return nil;//这是头像有更新的情况
	}
	UIImage *image = [thisUser.userImageData getNeteaseIcon];
	return image;
}
#endif
+ (UIImage *)getPlaceHolderImage
{
	return [NTESMBUserIconCache getInstance].placeHolderImage;
}
+(UIImage *)getStatusImageDefault
{
	return  [NTESMBUserIconCache getInstance].statusImageDefault;
}
+ (UIImage *)getTopRetweetsImage
{
	return [NTESMBUserIconCache getInstance].topRetweetsImage;
}

- (id) init
{
	self = [super init];
	if (self != nil) 
    {
		cache = [[NSMutableDictionary alloc] init];
		totalRequest = 0;
		notHitCount = 0;
		self.placeHolderImage = [NTESMBUtility roundCornersOfImage:[UIImage imageNamed:@"Placeholder.png"]];
		self.topRetweetsImage = [UIImage imageNamed:@"park.png"];

	}
	return self;
}
-(void)clearUserIconCache
{
	[cache removeAllObjects];
}
- (void) dealloc
{
	[cache release];
	[placeHolderImage release];
	[statusImageDefault release];
	[super dealloc];
}


@end
