//
//  UserIconDownloader.m
//  DressMemo
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DressMemoUserIconDownloader.h"
@implementation DressMemoUserIconDownloader
- (id) initWithUserIconUrl:(NSString*)iconUrl indexPath:(NSIndexPath *) _indexPath
{
	//self = [super initWithUrlString:[_user.userImageURL YoudaoImageUrlWithWidth:48 AndHeight:48] ];
    iconUrl = [self getDresMemoAvatarUrl:iconUrl];
	self = [super initWithUrlString:iconUrl];
	if (self != nil) 
    {
		indexPath = [_indexPath retain];
		//user = [_user retain];
		isNeedAuthRequest = NO;
	}
	return self;
}
-(NSString*)getDresMemoAvatarUrl:(NSString*)userIconFileName
{
    NSString *realUrl = [NSString stringWithFormat:@"%@%@%@",kDressMemoImageUrlRoot,userIconFileName,kDressMemoUserIconScaleSize];
    NSLog(@"download icon url:%@",realUrl);
    return realUrl;
}
@end
