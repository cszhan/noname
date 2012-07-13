//
//  ZCSNetClientMgr.m
//  DressMemo
//
//  Created by  on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZCSNetClientDataMgr.h"
#import "DressMemoNetInterfaceMgr.h"
#import "DBManage.h"
static NSString *tagKeyFormart[] = {@"brand[%@][]",@"x[%@][]",@"y[%@][]",@"cat1[%@][]",@"cat2[%@][]"};

@interface ZCSNetClientDataMgr()
@property(nonatomic,retain)NSMutableDictionary *requestResourceDict;
@end    
static DressMemoNetInterfaceMgr *dressMemoInterfaceMgr = nil;
static ZCSNetClientDataMgr *zcsNetClientDataMgr = nil;
static DBManage *dbMgr = nil;
@implementation ZCSNetClientDataMgr
@synthesize requestResourceDict;
+(id)getSingleTone{
    @synchronized(self)
    {
        if(zcsNetClientDataMgr == nil)
            zcsNetClientDataMgr = [[self alloc] init];
            
    }
    return zcsNetClientDataMgr;
}
-(id)init
{
    if(self = [super init])
    {
        dressMemoInterfaceMgr = [DressMemoNetInterfaceMgr getSingleTone];
        
        requestResourceDict = [[NSMutableDictionary alloc]init];
        [ZCSNotficationMgr addObserver:self call:@selector(didGetDataFromNet:) msgName:kZCSNetWorkOK];
        [ZCSNotficationMgr addObserver:self call:@selector(didGetDataFromNetFailed:) msgName:kZCSNetWorkFailed];
        dbMgr = [DBManage getSingleTone];
    }
    return self;
}
-(id)startMemoImageUpload:(NSDictionary*)paramDict
{
    id request = [dressMemoInterfaceMgr startAnRequestByResKey:@"uploadpic"
                                        needLogIn:YES
                                        withParam:paramDict 
                                       withMethod:@"POST"
                                         withData:YES];
    return  [request requestKey];
}
-(id)startMemoImageUpload:(NSDictionary*)paramDict   withFileName:(NSString*)fileName
{
    id request = [dressMemoInterfaceMgr startAnRequestByResKey:@"uploadpic"
                                                     needLogIn:YES
                                                     withParam:paramDict 
                                                    withMethod:@"POST"
                                                      withData:YES
                                                  withFileName:fileName];
    return  [request requestKey];
}
-(void)makeRealUploadClassData:(NSDictionary*)classAllData withItemData:(NSDictionary*)tempDict
{
    
    NSString *classKey = [tempDict objectForKey:@"Cats1"];
    NSDictionary *classData = [classAllData objectForKey:classKey];
    
    NSString    *realValue = [classData objectForKey:@"catid"];
    [tempDict setValue:realValue forKey:@"Cats1"];
    
    NSString *subclassKey = [tempDict objectForKey:@"Cats2"];
    
    NSDictionary *subClassDict = [classAllData objectForKey:classKey];
    NSDictionary *subClassItem = [subClassDict objectForKey:@"sub"];
    classData = [subClassItem  objectForKey:subclassKey];
    realValue = [classData objectForKey:@"catid"];
    
    [tempDict setValue:realValue forKey:@"Cats2"];
}
-(void)startMemoDataUpload:(NSDictionary*)dict
{
    /**
     */
    /*
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"上海南丹东路161号5#",@"location",
                          @"1",@"countryid",
                          @"1",@"occasionid",
                          @"1",@"emotionid",
                          @"这是一个memo",@"desc",
                          nil];
    */
    NSArray *imageFileArr = dbMgr.imageFileNameArr;
    NSDictionary *imageIdDict = dbMgr.uploadPicIdDict;
    NSDictionary *imageTagDict= dbMgr.uploadImageTagDict;
    NSArray *imageTagItemArr = nil;
    int picCount = [imageFileArr count];
    NSMutableDictionary *toParam = nil;
    toParam = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    DBManage *dbMgr = [DBManage getSingleTone];
    NSDictionary *classAllData    =  [[dbMgr getTagDataById:@"getCats"]retain];
    
    for(int i = 0;i<picCount;i++)
    {
        NSString *key = [imageFileArr objectAtIndex:i];
       
        NSString *picid = [[imageIdDict objectForKey:key]objectForKey:@"picid"];
        NSLog(@"upload pic key:%@ picid:%@",key,picid);
        
        imageTagItemArr = [imageTagDict objectForKey:key];
        
        NSMutableArray *brandValueArr = [NSMutableArray arrayWithObjects:
                                         //@"swatch",
                                         //@"metes",
                                         nil];
        NSMutableArray *pointXValueArr = [NSMutableArray arrayWithObjects:
                                          //@"100.01",@"90.f", 
                                          nil];
        NSMutableArray *pointYValueArr = [NSMutableArray arrayWithObjects:
                                          //@"50.21",@"20.86",
                                          nil];
        
        NSMutableArray *cats1ValueArr = [NSMutableArray arrayWithObjects:
                                        //@"1",@"4",
                                        nil];
        NSMutableArray *cats2ValueArr = [NSMutableArray array];
        for(id tagItem in imageTagItemArr)
        {
            /*
             NSString *brand = [data objectForKey:@"Brand"];
             //NSString *cat = [data objectForKey:@"Cats"];
             NSString *xStr = [data objectForKey:@"PointX"];
             NSString *yStr = [data objectForKey:@"PointY"];
             */
            [self makeRealUploadClassData:classAllData withItemData:tagItem];
            
            [brandValueArr  addObject:[tagItem objectForKey:@"Brand"]];
            [cats1ValueArr addObject:[tagItem objectForKey:@"Cats1"]];
            [cats2ValueArr addObject:[tagItem objectForKey:@"Cats2"]];
            NSString *realX = [dbMgr uploadTagDataPointXMap:[tagItem objectForKey:@"PointX"]];
            [pointXValueArr addObject:realX];
            NSString *realY = [dbMgr uploadTagDataPointYMap:[tagItem objectForKey:@"PointY"] withKey:key];
            [pointYValueArr addObject:realY];
            
        }
    
       
   
        //NSString *picid = [NSString stringWithFormat:@"%d",i];
        //NSDictionary *dict = [NSMutableDictionary dictionary];
        NSString *brandkey= [NSString stringWithFormat:tagKeyFormart[0],picid];
        [toParam setValue:brandValueArr forKey:brandkey];
        
        NSString *pointXKey = [NSString stringWithFormat:tagKeyFormart[1],picid];
        [toParam setValue:pointXValueArr forKey:pointXKey];
        
        NSString *pointYKey = [NSString stringWithFormat:tagKeyFormart[2],picid];
        [toParam setValue:pointYValueArr forKey:pointYKey];
        //for class
        NSString *cat1Key = [NSString stringWithFormat:tagKeyFormart[3],picid];
        [toParam setValue:cats1ValueArr forKey:cat1Key];
        //for sub class
        NSString *cat2Key = [NSString stringWithFormat:tagKeyFormart[4],picid];
        [toParam setValue:cats2ValueArr forKey:cat2Key];

    }
    [classAllData release];
    
    NSLog(@"%@",[toParam description]);
    for(id item in [toParam allKeys])
    {
        
        NSLog(@"key:%@,value:%@",item,[[toParam objectForKey:item]description]);
    }
    [dressMemoInterfaceMgr startAnRequestByResKey:@"add"
                                        needLogIn:YES
                                        withParam:toParam 
                                       withMethod:@"POST"
                                         withData:NO];
    
}

-(void)startMemoImageTagDataSource
{
    
    NSArray *resourceArray = [NSArray arrayWithObjects:
                              @"getOccasions",
                              @"getEmotions", 
                              @"getCountries",
                              @"getCats",
                              nil];
    NSDictionary *param = nil;
    for(NSString* item in resourceArray)
    {
        if([item isEqualToString:@"getCats"])
        {
            param = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"all",nil];
        }
        [requestResourceDict setValue:[NSNumber numberWithBool:YES] forKey:item];
        [dressMemoInterfaceMgr startAnRequestByResKey:item 
                                         needLogIn:NO
                                         withParam:param
                                        withMethod:@"GET"
                                          withData:NO];
    }

}
-(id)getRequestByRequestKey:(NSString*)requestKey
{

    return  nil;
}
#pragma mark  -
#pragma mark net respond msg
-(void)didGetDataFromNet:(NSNotification*)ntf
{
    id obj = [ntf object];
    id request = [obj objectForKey:@"request"];
    id data = [obj objectForKey:@"data"];
    NSString *resKey = [request resourceKey];
    if([requestResourceDict objectForKey:resKey])
    {
        if([data isKindOfClass:[NSDictionary class]])
            [dbMgr saveImageTagDataById:resKey withData:[data objectForKey:@"info"]];
    
    }
    if([resKey isEqualToString:@"add"])
    {
    
        
    }
        
}
-(void)didGetDataFromNetFailed:(NSNotification*)ntf
{

    id obj = [ntf object];
    /*
    id request = [obj objectForKey:@"request"];
    id data = [obj objectForKey:@"data"];
     */
    /*
    [ dismissWithError:(NSString*)errorString afterDelay:(NSTimeInterval)seconds;
     */
    if([obj isKindOfClass:[NSError class]])
    {
        NSString *errMsg = [obj localizedDescription];
        UIAlertView *alertErr = [[[UIAlertView alloc]initWithTitle:@"NetWorkError" message:errMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"Done",nil) otherButtonTitles:nil, nil]autorelease];
        [alertErr show];
    }
}
-(void)dealloc
{
    self.requestResourceDict = nil;
    //self.dressMemoInterfaceMgr = nil;
    [super dealloc];
}
@end
