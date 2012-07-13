//
//  SongsLrcManage.h
//  MP3Player
//
//  Created by cszhan on 12-2-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DBManage : NSObject {
	NSMutableDictionary *lrcCacheDict;
    
}
@property(nonatomic,retain)NSMutableArray *imageFileNameArr;
@property(nonatomic,retain)NSMutableDictionary *uploadPicIdDict;
//use to map request and image file name ,which use to identify the up load pic
@property(nonatomic,retain)NSMutableDictionary *uploadRequestMapDict;
@property(nonatomic,retain)NSMutableDictionary *uploadImageTagDict;
@property(nonatomic,retain)NSMutableArray *uploadImageTagArr;
+(id)getSingleTone;
-(BOOL)saveUploadImageTolocalPath:(UIImage*)imageData withFileName:(NSString*)fileName;
- (void)saveImageTagDataById:(NSString*)key withData:(id)data;



- (id)getTagDataById:(NSString*)lrcKey;
-(BOOL)isExistFile:(NSString *)fileName;
-(NSString*)getLrcPath:(NSString*)fileName;
-(void)getLrcData:(NSString*)artisName songTitle:(NSString*)songName;
-(CGFloat)getLrcSpeedAdjust:(NSString*)lrcKey;
- (NSArray*)getLrcDataSourceById:(NSString*)lrcKey;

- (NSInteger)getLrcSelectorIndex:(NSString*)lrcKey;
-(BOOL)saveLrcDataSourceSelector:(NSString*)lrcKey withData:(NSNumber*) indexNum;
@end
