//
//  SongsLrcManage.m
//  MP3Player
//
//  Created by cszhan on 12-2-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DBManage.h"
#import "NTESMBUtility.h"
#import "PhotoUploadXY.h"
//#import "LrcNetClient.h"
//#import "EnCodeHelper.h"
//#import "AppSetting.h"
#import "ZCSNotficationMgr.h"
#import "ZCSNetClientDataMgr.h"
#import "UIImage+Extend.h"

#import "NTESMBUserIconCache.h"

#define kLrcRequestMaxCount  5
static DBManage *sharedInstance = nil;
//static LrcNetClient *lrcNetClient;
@interface DBManage()
@property(nonatomic,retain)NSMutableDictionary *uploadimageTagPointMap; 
@end
@implementation DBManage
@synthesize imageFileNameArr;
@synthesize uploadPicIdDict;
@synthesize uploadRequestMapDict;
//use tage dict or arr
@synthesize uploadImageTagDict;
@synthesize uploadImageTagArr;
//@synthesize loginUserData;

@synthesize uploadimageTagPointMap;
-(id)init{
    if(self = [super init])
    {
       // lrcCacheDict = [[NSMutableDictionary alloc]init];
        
        imageFileNameArr = [[NSMutableArray alloc]init];
        uploadPicIdDict = [[NSMutableDictionary alloc]init];
        uploadRequestMapDict = [[NSMutableDictionary alloc]init];
        uploadImageTagDict = [[NSMutableDictionary alloc]init];
        uploadimageTagPointMap = [[NSMutableDictionary alloc]init];
    }
    return self;
}
+(id)getSingleTone{
	@synchronized(self){
		if(sharedInstance == nil){
			sharedInstance = [[self alloc]init];
			//[sharedInstance setPlayerStatus:VoiceInitStatus];
		}
	}
	return sharedInstance;
}
-(BOOL)isExistFile:(NSString*)fileName{
	
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	//UIImage
    //[UIColor colorWithPatternImage
    //get the reallrc name
    NSString *realLrcUid =  [self getRealLrcById:fileName];
    if(realLrcUid== nil)
        return NO;
	NSString *filePath = [self filePathInDocumentsDirectoryForFileName:realLrcUid];
	return [fileMgr fileExistsAtPath:filePath];
	
}
-(NSString*)getLrcPath:(NSString*)fileName
{
	//return [AppSetting getLrcPath:fileName];
    NSString *realLrcUid =  [self getRealLrcById:fileName];
    if(realLrcUid== nil)
        return NO;
	NSString *filePath = [self filePathInDocumentsDirectoryForFileName:realLrcUid];
    return filePath ;
}
#pragma mark save pick photo image
#define TEST 0
-(BOOL)saveUploadImageTolocalPath:(UIImage*)imageData withFileName:(NSString*)fileName
{
    
#if TEST
    NSString *savePath = [NTESMBUtility filePathInDocumentsDirectoryForFileName:@"originPic.jpg"];
    NSData *originData = UIImageJPEGRepresentation(imageData,0.8);
    [originData writeToFile:savePath atomically:YES];
#endif  
    
    CGFloat scaleRatio = imageData.size.width/kPhotoUploadImageSizeX;
    
    CGFloat targetHeight = imageData.size.height/scaleRatio;
    
#if TEST
    UIImage *cropImage = [UIImage_Extend imageCroppedToFitSizeII:CGSizeMake(kPhotoUploadImageSizeX,targetHeight) withData:imageData];
    NSData *cropSaveData = UIImageJPEGRepresentation(cropImage,0.8);
    NSString *cropPath = [NTESMBUtility filePathInDocumentsDirectoryForFileName:@"cropCenterPic.jpg"];
    [cropSaveData writeToFile:cropPath atomically:YES];
#endif  
    
    UIImage *scaleImage = [UIImage_Extend imageScaleToFitSize:CGSizeMake(kPhotoUploadImageSizeX,targetHeight) withData:imageData];
    
    NSData *saveData = UIImageJPEGRepresentation(scaleImage,0.8);
    /*
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [dirPaths objectAtIndex:0];
    */
    NSString *path = [NTESMBUtility filePathInDocumentsDirectoryForFileName:fileName];

    
    [uploadimageTagPointMap setValue:[NSNumber numberWithFloat:targetHeight/kPhotoUploadMarkTagImageMaxH] forKey:path];
    
    if([saveData writeToFile:path atomically:YES])
    {
        return YES;
    }
    return NO;
}
-(BOOL)saveUserImageTolocalPath:(UIImage*)imageData withFileName:(NSString*)fileName
{

    CGFloat scaleRatio = imageData.size.width/kUserPhotoUploadImageSize;
    
    CGFloat targetHeight = imageData.size.height/scaleRatio;
    
    UIImage *scaleImage = [UIImage_Extend imageScaleToFitSize:CGSizeMake(kUserPhotoUploadImageSize,targetHeight) withData:imageData];
    
    NSData *saveData = UIImageJPEGRepresentation(scaleImage,0.8);
    /*
     NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     
     NSString *docsDir = [dirPaths objectAtIndex:0];
     */
    NSString *path = [NTESMBUtility filePathInDocumentsDirectoryForFileName:fileName];
    
    
    [uploadimageTagPointMap setValue:[NSNumber numberWithFloat:targetHeight/kPhotoUploadMarkTagImageMaxH] forKey:path];
    
    if([saveData writeToFile:path atomically:YES])
    {
        return YES;
    }
    return NO;
}

-(void)removeImageByFileName:(NSString*)fileName
{
    NSLog(@"%@",fileName);
    if([NTESMBUtility removeImageDataByfullName:fileName])
    {
        NE_LOG(@"remove ok!!");
    }
}
/**
 save data 
 @"/memo/getEmotions",   @"getEmotions",
 @"/memo/getCountries",  @"getCountries",
 @"/memo/getCats",       @"getCats",
 */
#pragma  mark -
#pragma  mark  save net work imag tag relate infor



- (id)getTagDataById:(NSString*)lrcKey
{
   // NSString *filePath = @"lrcMapkey.plist";
    NSString *filePath = [NSString stringWithFormat:@"%@/ImageTagDataSource.plist",[[NSBundle mainBundle]bundlePath]];
    NSMutableDictionary* plistDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
    
    id value;
    value = [plistDict objectForKey:lrcKey];
#if 1
    if([lrcKey isEqualToString:@"getCats"])
    {
        NSArray *keys = [value allKeys];
        NSDictionary *retData = [NSMutableDictionary dictionary];
        for (id item in keys)
        {
            NSDictionary *valueDict = [value objectForKey:item];
            
            NSString *realClassKey = [valueDict objectForKey:@"catname"];
           
            
            NSDictionary *newSubData = [self switchKeyForDictionary:valueDict];
         
            [retData setValue:newSubData forKey:realClassKey];
        }
        value = retData;
    
    }
    else 
    {
    
        NSArray *keys = [value allKeys];
        NSDictionary *retData = [NSMutableDictionary dictionary];
        for (id item in keys)
        {
            [retData setValue:item forKey:[value objectForKey:item]];
        }
        value = retData;
    }
    
#endif
    
    
    return value;
    /* You could now call the string "value" from somewhere to return the value of the string in the .plist specified, for the specified key. */
}
-(NSDictionary*)switchKeyForDictionary:(NSDictionary*)valueDict
{
    
     NSDictionary *subData = [valueDict objectForKey:@"sub"];
    //create new sub
    NSMutableDictionary *newSubData = [NSMutableDictionary dictionary];
    
    NSArray *subKeys = [subData allKeys];
    for(id item in subKeys)
    {
        NSDictionary *subItemData = [subData objectForKey:item];
        NSString *realSubClassKey = [subItemData objectForKey:@"catname"];
        [newSubData setValue:subItemData forKey:realSubClassKey];
    }
    
    [valueDict setValue:newSubData forKey:@"sub"];
    
    return valueDict;
}
- (void)saveImageTagDataById:(NSString*)key withData:(id)data
{
    //NSString *filePath = @"lrcMapkey.plist";
    NSString *filePath = [NSString stringWithFormat:@"%@/ImageTagDataSource.plist",[[NSBundle mainBundle]bundlePath]];
    NSMutableDictionary* plistDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
    NSLog(@"%@",[data description]);
    [plistDict setValue:data forKey:key];
    if([plistDict writeToFile:filePath atomically: YES])
    {
        NE_LOG(@"saveIamgeTagData succ");
    }
}
#pragma mark -
#pragma mark upload image 
-(void)startUploadMemoImages
{
    ZCSNetClientDataMgr *zcsNetClientDataMgr = [ZCSNetClientDataMgr getSingleTone];
    /*
    NSDictionary  *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                //@"f79fb145a78fc1b8cde3ab47767a9fda",@"token",
                                [UIImage imageNamed:@"test.png"], @"pic",
                                //  @"123456",@"pass",
                                nil];
    */
    UIImage *image = nil;
    for(id item in imageFileNameArr)
    {
        //NSString *fullPath = [];
        NE_LOG(@"%@",item);
        //UIImageWithFullPathName(image, item);
        NSDictionary  *paramDict = [NSDictionary dictionary];
        id requestKey = [zcsNetClientDataMgr startMemoImageUpload:paramDict withFileName:item];
        
        [uploadRequestMapDict setValue:item forKey:requestKey];
        
    }
    NSLog(@"%@",[uploadRequestMapDict description]);
    /*
    id request = [zcsNetClientDataMgr startMemoImageUpload:paramDict];
    [zcsNetClientDataMgr startMemoImageUpload:paramDict];
     */
}
-(void)startUploadMemoData:(NSDictionary*)param
{
     ZCSNetClientDataMgr *zcsNetClientDataMgr = [ZCSNetClientDataMgr getSingleTone];

    id requestKey = [zcsNetClientDataMgr startMemoDataUpload:param];
}
-(void)clearAllUploadImageData
{
    for(id item in imageFileNameArr)
    {
        [self removeImageByFileName:item];
    }
    [imageFileNameArr removeAllObjects];
    //uploadPicIdDict = [[NSMutableDictionary alloc]init];
    [uploadRequestMapDict removeAllObjects];
    [uploadImageTagDict removeAllObjects];
    [uploadPicIdDict removeAllObjects];
}
-(void)addUploadpicObject:(NSDictionary*)dictData withRequestKey:(NSString*)requestKey
{
    NSString *imageKey = [uploadRequestMapDict objectForKey:requestKey];
    @synchronized(self)
    {
        [uploadPicIdDict setValue:dictData forKey:imageKey];
        NSLog(@"requestKey:%@,imageKey:%@,uploadIdinfor:%@",requestKey,imageKey,dictData);
    }
}
-(NSString*)uploadTagDataPointXMap:(NSString*)srcX
{
    CGFloat realX = [srcX floatValue]*kPhotoUploadPointScaleX;
    return  [NSString stringWithFormat:@"%lf",realX];
}
-(NSString*)uploadTagDataPointYMap:(NSString*)srcY  withKey:(NSString*)key
{
    CGFloat scale = [[self.uploadimageTagPointMap objectForKey:key]floatValue];
    CGFloat realX = [srcY floatValue]*scale;
    return  [NSString stringWithFormat:@"%lf",realX];
}
#pragma mark -
#pragma mark tag 
//static BOOL hasInit = NO;
-(void)initImageTagData
{
    for(int i = 0;i<[self.imageFileNameArr count];i++)
    {
       
        NSString *key = [self.imageFileNameArr objectAtIndex:i];
        if(![self.uploadImageTagDict objectForKey:key])
        {
            NSMutableArray *imageItemTagsArr = [NSMutableArray array];
            [self.uploadImageTagDict setValue:imageItemTagsArr forKey:key];  
        }
    }
    //hasInit = YES;
}

#pragma mark -
#pragma mark other

- (NSArray*)getLrcDataSourceById:(NSString*)lrcKey
{
    NSString *filePath = [NSString stringWithFormat:@"%@/ImageTagDataSource.plist",[[NSBundle mainBundle]bundlePath]] ;
    NSMutableDictionary* plistDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
    
    NSArray *value;
    value = [plistDict objectForKey:lrcKey];
    return value;
    /* You could now call the string "value" from somewhere to return the value of the string in the .plist specified, for the specified key. */
}
-(BOOL)saveLrcDataSourceById:(NSString*)lrcKey withDataArray:(NSArray*)item
{
    //NSString *filePath = @"lrcDataSource.plist";
    NSString *filePath = [NSString stringWithFormat:@"%@/ImageTagDataSource.plist",[[NSBundle mainBundle]bundlePath]];
    NSMutableDictionary* plistDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
    
    [plistDict setValue:item forKey:lrcKey];
    if([plistDict writeToFile:filePath atomically: YES])
        return YES;
    else {
        return NO;
    }
    
}
- (NSInteger)getLrcSelectorIndex:(NSString*)lrcKey
{
    //NSString *filePath = @"lrcSelector.plist";
    //NSString *filePath = @"lrcDataSource.plist";
    NSString *filePath = [NSString stringWithFormat:@"%@/lrcSelector.plist",[[NSBundle mainBundle]bundlePath]];
    
    NSMutableDictionary* plistDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
    id value = [plistDict objectForKey:lrcKey];
    if(value == nil)
        return -1;
    return [value intValue];
    /* You could now call the string "value" from somewhere to return the value of the string in the .plist specified, for the specified key. */
}
-(BOOL)saveLrcDataSourceSelector:(NSString*)lrcKey withData:(NSNumber*) indexNum
{
    //NSString *filePath = @"lrcSelector.plist";
    NSString *filePath = [NSString stringWithFormat:@"%@/lrcSelector.plist",[[NSBundle mainBundle]bundlePath]];
    
    NSMutableDictionary* plistDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
    
    [plistDict setValue:indexNum forKey:lrcKey];
    if([plistDict writeToFile:filePath atomically: YES])
        return YES;
    else {
        return NO;
    }
}
#pragma mark -
#pragma mark user icon 
-(UIImage*)getItemCellUserIconImageDefault
{
    NTESMBUserIconCache *iconCacheMgr = [NTESMBUserIconCache getInstance];
    return  [iconCacheMgr statusImageDefault];
}
#pragma  sqlite method
-(void)getLrcDataBy:(NSString*)lrcKey
{
    
}
//
-(void)setLrcDataBy:(NSString*)lrcKey withData:(NSString*)siongName{


}

-(void)dealloc
{
    [uploadimageTagPointMap release];
    [uploadPicIdDict release];
    [lrcCacheDict release];
}
@end
