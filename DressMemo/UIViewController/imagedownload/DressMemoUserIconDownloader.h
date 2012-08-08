//
//  UserIconDownloader.h
//  DressMemo
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NTESMBIconDownloader.h"
#define kImageIconScaleSize @"_100x100.jpg"

@interface DressMemoUserIconDownloader : NTESMBIconDownloader
- (id) initWithUserIconUrl:(NSString*)iconUrl indexPath:(NSIndexPath *) _indexPath;
@end
