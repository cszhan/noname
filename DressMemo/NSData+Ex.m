//
//  NSData+Ex.m
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-24.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NSData+Ex.h"
#define TIMELINE_CELL_PHOTO_SIZE 50.f

@implementation NSData (Netease)

- (UIImage *) getNeteaseIcon
{
	UIImage *icon = nil;
	UIImage *image = [[UIImage alloc] initWithData:self];    
	if (image.size.width != TIMELINE_CELL_PHOTO_SIZE || image.size.height != TIMELINE_CELL_PHOTO_SIZE)
	{
		CGSize itemSize = CGSizeMake(TIMELINE_CELL_PHOTO_SIZE, TIMELINE_CELL_PHOTO_SIZE);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		icon = [NTESMBUtility roundCornersOfImage:UIGraphicsGetImageFromCurrentImageContext()];
		UIGraphicsEndImageContext();
	}
	else
	{
		icon = [NTESMBUtility roundCornersOfImage:image];
	}    
	[image release];
	return icon;
}




@end
