//
//  DressMemoUserIconCache.h
//  DressMemo
//
//  Created by cszhan on 12-8-6.
//
//

#import <Foundation/Foundation.h>
#import "NTESMBUserIconCache.h"
@interface DressMemoUserIconCache : NTESMBUserIconCache
+ (DressMemoUserIconCache *) getInstance;
- (UIImage *) getImageWithUserIconPath:(NSString*)userIconFileName;

@end
