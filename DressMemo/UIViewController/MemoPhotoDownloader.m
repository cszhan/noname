//
//  MemoPhotoDownloader.m
//  DressMemo
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MemoPhotoDownloader.h"

@implementation MemoPhotoDownloader
@synthesize cellIndex;
- (id) initWithUserIconUrl:(NSString*)iconUrl indexPath:(NSIndexPath *) _indexPath
{
	//self = [super initWithUrlString:[_user.userImageURL YoudaoImageUrlWithWidth:48 AndHeight:48] ];
    iconUrl = [self getDresMemoImageUrl:iconUrl];
	self = [super initWithUrlString:iconUrl];
	if (self != nil)
    {
		indexPath = [_indexPath retain];
		//user = [_user retain];
		isNeedAuthRequest = NO;
	}
	return self;
}
- (id) initWithImageUrl:(NSString*)imageUrl indexPath:(NSIndexPath *) _indexPath cellIndex:(NSInteger)subIndex
{
	//self = [super initWithUrlString:[_user.userImageURL YoudaoImageUrlWithWidth:48 AndHeight:48] ];
    NSString *realUrl = [NSString stringWithFormat:@"%@%@",kDressMemoImageUrlRoot,imageUrl];
	self = [super initWithUrlString:realUrl];
	if (self != nil) 
    {
		indexPath = [_indexPath retain];
        self.cellIndex = subIndex;
		//user = [_user retain];
		isNeedAuthRequest = NO;
	}
	return self;
}
-(NSString*)getDresMemoImageUrl:(NSString*)userIconFileName
{
    NSString *realUrl = [NSString stringWithFormat:@"%@%@%@",kDressMemoImageUrlRoot,userIconFileName,kDressMemoPhotoTinyScaleSize];
    NSLog(@"icon url:%@",realUrl);
    return realUrl;
}
@end
