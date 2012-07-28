//
//  UserIconDownloader.m
//  DressMemo
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserIconDownloader.h"
@implementation UserIconDownloader
- (id) initWithUserIconUrl:(NSString*)iconUrl indexPath:(NSIndexPath *) _indexPath
{
	//self = [super initWithUrlString:[_user.userImageURL YoudaoImageUrlWithWidth:48 AndHeight:48] ];
    NSString *realUrl = [NSString stringWithFormat:@"%@%@",kDressMemoUserIconUrlRoot,iconUrl];
	self = [super initWithUrlString:realUrl];
	if (self != nil) 
    {
		indexPath = [_indexPath retain];
		//user = [_user retain];
		isNeedAuthRequest = NO;
	}
	return self;
}
@end
