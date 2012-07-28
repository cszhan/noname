//
//  UserIconDownloader.h
//  DressMemo
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NTESMBIconDownloader.h"

@interface UserIconDownloader : NTESMBIconDownloader
- (id) initWithUserIconUrl:(NSString*)iconUrl indexPath:(NSIndexPath *) _indexPath;
@end
