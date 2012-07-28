//
//  LocalImageStorage.h
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-27.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NTESMBLocalImageStorage : NSObject {

}

+ (NTESMBLocalImageStorage *) getInstance;

- (UIImage *) getOriginalImageWithUrl:(NSString *) urlString;
- (void) saveImageDataToOriginalDir:(NSData *) imageData urlString:(NSString *) urlString;
- (NSString *) originalFilePathWithUrlString:(NSString *) urlString;
- (NSString *) saveImageDataToCameraDir:(NSData *)imageData;
- (NSString *) smallFilePathWithUrlString:(NSString *) urlString;
- (NSString *) mapFilePathWithLat:(double)lat andLong:(double)lon;
- (void) saveImageDataToSmallDir:(NSData *) imageData urlString:(NSString *) urlString;
- (void) saveImageDataToMapDir:(NSData *) imageData Lat:(double)lat andLong:(double)lon;

@end
