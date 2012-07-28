//
//  UserIconCache.h
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-28.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#define USER_MODEL
#ifdef USER_MODEL
#import "NTESMBUserModel.h"
#endif
#import "NTESMBLocalImageStorage.h"

@interface NTESMBUserIconCache : NSObject {
	NSMutableDictionary *cache;
	int totalRequest;
	int notHitCount;
	UIImage *placeHolderImage;
	UIImage *topRetweetsImage;
	UIImage *statusImageDefault;
}

@property (nonatomic, retain) UIImage *placeHolderImage;
@property (nonatomic, retain) UIImage *topRetweetsImage;
@property (nonatomic, retain) UIImage *statusImageDefault;

+ (NTESMBUserIconCache *) getInstance;
+ (UIImage *)getPlaceHolderImage;
+ (UIImage *)getTopRetweetsImage;
#ifdef USER_MODEL
- (void) removeCacheWithUserModel:(NTESMBUserModel *)userModel;
- (UIImage *) updateCacheWithUserModel:(NTESMBUserModel *)userModel;
- (UIImage *) getImageWithUserModel:(NTESMBUserModel *) userModel;
- (UIImage *) getImageFromDBWithUserModel:(NTESMBUserModel *) userModel;
- (BOOL) hasCacheWithUserModel:(NTESMBUserModel *)userModel;
#endif
@end
