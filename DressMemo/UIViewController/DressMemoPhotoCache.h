//
//  DressMemoTinyPhotoCache.h
//  DressMemo
//
//  Created by cszhan on 12-8-7.
//
//

#import "DressMemoUserIconCache.h"

@interface DressMemoPhotoCache : DressMemoUserIconCache
- (UIImage *) getImageWithTinyImagePath:(NSString*)userIconFileName;
@end
