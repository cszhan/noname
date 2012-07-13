//
//  ZCSDataArchiveMgr.m
//  DressMemo
//
//  Created by  on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZCSDataArchiveMgr.h"
static ZCSDataArchiveMgr *sharedInstance = nil;
static  NSFileManager *filemgr = nil;
static NSString  *dataFilePath = nil;
@implementation ZCSDataArchiveMgr
+(id)getSingleTone
{
    @synchronized(self)
    {
        if(sharedInstance == nil)
        {
            sharedInstance = [[self alloc]init];
            [sharedInstance initData];
        }
        return sharedInstance;
    }
    
}
-(void)initData
{
   
    NSString *docsDir;
    NSArray *dirPaths;
    filemgr = [[NSFileManager defaultManager]retain];
    
    // Get the documents directory
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the data file
    
    dataFilePath = [[NSString alloc] initWithString:docsDir];
}

-(BOOL)archiveObjectData:(id)object forKey:(NSString*)key
{

    NSMutableData   *data = [NSMutableData data];
#if 0
    if ([filemgr fileExistsAtPath: dataFilePath])
    {   
        NSData *srcData= [NSData dataWithContentsOfFile:dataFilePath];
        [data appendData:srcData];
    }
#endif
     NSLog(@"archive data by key:%@",key);
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    // archive.delegate = self;
    [archive encodeObject:object forKey:key];
    [archive finishEncoding];
    [archive release];
    NSString *path  = [self getDatafullPath:key];
    if([data writeToFile:path atomically:YES])
    {
        return YES;
    }
    else 
    {
        //[archive release];
        return NO;
    }
    //[NSKeyedArchiver archiveRootObject: contactArray toFile:dataFilePath];
   
 
}
-(NSString*)getDatafullPath:(NSString*)key
{
    return  [NSString stringWithFormat:@"%@/%@",dataFilePath,key];
}
-(id)archiveObjectDataFetch:(NSString*)key
{
    //NSArray
    id returnObj = nil;
    NSString *path  = [self getDatafullPath:key];
    NSLog(@"path:%@",path);
    if ([filemgr fileExistsAtPath:path])
    {
        NSLog(@"fetch archive data by key:%@",key);
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver *unArchiver = [[[NSKeyedUnarchiver alloc]initForReadingWithData:data]autorelease];
        returnObj = [unArchiver decodeObjectForKey:key];
    }
    return returnObj;

}
- (void)archiver:(NSKeyedArchiver *)archiver didEncodeObject:(id)object{
    
    //[object release];
    //object = nil;
}
- (void)archiverDidFinish:(NSKeyedArchiver *)archiver;
{
    
    
    
}
-(BOOL)saveImageForIndexKey:(NSString*)key withData:(UIImage*)data
{
   
    return YES;
}
-(BOOL)saveImageToPath:(NSData*)data fileName:(NSString*)fileName
{

    
    // Get the documents directory
    NSLog(@"save start");
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *path = [[[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:fileName]] autorelease];
    if([data writeToFile:path atomically:YES])
    {
        return YES;
    }
    return NO;
    
}

-(NSString*)readImageFileName:(NSString*)fileName
{
    
}
#pragma mark archive view data
- (void)initArchiveData
{
    
    NSFileManager *filemgr;
    NSString *docsDir;
    NSArray *dirPaths;
    
    filemgr = [NSFileManager defaultManager];
    
    // Get the documents directory
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the data file
    if(dataFilePath==nil)
        dataFilePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"data.archive"]];
    NSLog(@"%@",dataFilePath);
}
- (UIView*) retriveArchiveData
{
    
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    id retData = nil;
    if ([filemgr fileExistsAtPath: dataFilePath])
    {
        retData = [NSKeyedUnarchiver unarchiveObjectWithFile: dataFilePath];
        NSLog(@"get data");
    }
    return  retData;
    
}
- (void) saveViewData:(UIView*)viewData
{
    NSArray *arr = [[NSArray alloc]init];
    if([NSKeyedArchiver archiveRootObject: viewData toFile:dataFilePath])
    {
        NSLog(@"save data ok ");
    }
    //[contactArray release];
}
-(void)dealloc
{
    [dataFilePath release];
    [filemgr release];
    [super dealloc];
}
@end
