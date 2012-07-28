//
//  IconDownloader.m
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-24.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBIconDownloader.h"
#import "NTESMBUserModel.h"



@implementation NESkipPhotoDownloader

@end


@implementation NTESMBIconDownloader

@synthesize indexPath;
@synthesize identifier;

@synthesize user;
- (id) initWithUserModel:(NTESMBUserModel *) _user indexPath:(NSIndexPath *) _indexPath
{
	//self = [super initWithUrlString:[_user.userImageURL YoudaoImageUrlWithWidth:48 AndHeight:48] ];
	self = [super initWithUrlString:_user.userImageURL];
	if (self != nil) 
    {
		indexPath = [_indexPath retain];
		user = [_user retain];
		isNeedAuthRequest = NO;
	}
	return self;
}
#ifdef STATUS_MODEL
- (id)initWithStatusModel:(NTESMBStatusModel*)status indexPath:(NSIndexPath *) _indexPath
{
	NSString *imageURLString = [status getStatusTinyImageUrl];
	//NSString *imageFilePath = [self imageFilePath:imageURLString];
	NSString *rootImageURLString = [status getRootTinyImageUrl];
	if (imageURLString)
	{
		self = [super initWithUrlString:imageURLString];
	}
	if (rootImageURLString)
	{
		self = [super initWithUrlString:rootImageURLString];
	}
	if (self != nil) 
    {
		indexPath = [_indexPath retain];
		//user = [_user retain];
	}
	isNeedAuthRequest = NO;
	return self;
}
#endif
- (void) dealloc
{
    [user release];
	[indexPath release];
	[identifier release];
	[super dealloc];
}


//- (UIImage *) getIconImage
//{
//	UIImage *image = [[UIImage alloc] initWithData:self.receiveData];    
//    if (image.size.width != TIMELINE_CELL_PHOTO_SIZE && image.size.height != TIMELINE_CELL_PHOTO_SIZE)
//	{
//        CGSize itemSize = CGSizeMake(TIMELINE_CELL_PHOTO_SIZE, TIMELINE_CELL_PHOTO_SIZE);
//		UIGraphicsBeginImageContext(itemSize);
//		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//		[image drawInRect:imageRect];
//		icon = [UIGraphicsGetImageFromCurrentImageContext() retain];
//		UIGraphicsEndImageContext();
//    }
//    else
//    {
//        icon = [image retain];
//    }    
//    [image release];
//	return icon;
//}

@end
