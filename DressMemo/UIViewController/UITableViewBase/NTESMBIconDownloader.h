//
//  IconDownloader.h
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-24.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESMBServer.h"
#import "NTESMBUserModel.h"
#ifdef STATUS_MODEL
#import "NTESMBStatusModel.h"
#endif
@interface NTESMBIconDownloader : NTESMBRequest 
{
	NSIndexPath *indexPath;
	NSString *identifier;

	NTESMBUserModel *user;
}

@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, retain) NTESMBUserModel *user;
- (id) initWithUserModel:(NTESMBUserModel *) _user indexPath:(NSIndexPath *) _indexPath;
#ifdef USE_MODEL
- (id)initWithStatusModel:(NTESMBStatusModel*)status indexPath:(NSIndexPath *) _indexPath;
#endif
@end

@interface NESkipPhotoDownloader: NTESMBIconDownloader
{
	
}
@end

