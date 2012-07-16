//
//  PhotoUploadProcess.m
//  DressMemo
//
//  Created by  on 12-6-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoUploadProcess.h"
#import "DDProgressView.h"
#import "ZCSNotficationMgr.h"
#import "UIBaseFactory.h"
#import "PhotoUploadXY.h"
#import "ASIHTTPRequest.h"
#import "RequestCfg.h"
#import "ZCSNetClient.h"
#import "ZCSNetClientDataMgr.h"

#import "DressMemoNetInterfaceMgr.h"
#import "DBManage.h"

//#import "ZCSNotficationMSGDef.h"
@interface PhotoUploadProcess()
@property(nonatomic,retain) NSTimer *progressTimer;
@property(nonatomic,retain) UILabel *progressValueLabel;
@property(nonatomic,retain) DDProgressView  *progressView;
@property(nonatomic,retain) NSMutableArray *requestsArr;
@property(nonatomic,retain) NSMutableArray *picIdArr;
@property(nonatomic,assign) BOOL isStartNetwork;
@end
@implementation PhotoUploadProcess
@synthesize progressTimer;
@synthesize  progressValueLabel;
@synthesize progressView;
@synthesize requestsArr;
@synthesize picIdArr;
@synthesize isStartNetwork;
@synthesize memoPostData;
-(void)addObservers
{
    [ZCSNotficationMgr addObserver:self call:@selector(progressStart:) msgName:kUploadProcessStart];
    [ZCSNotficationMgr addObserver:self call:@selector(getPorecesValueChange:)msgName:kUploadProcessUpdate];
                                                       
    [ZCSNotficationMgr addObserver:self call:@selector(progressEnd:) msgName:kUploadProcessEnd];
    
#if 1
    [ZCSNotficationMgr addObserver:self call:@selector(didNetWorkStart:) msgName:kZCSNetWorkStart];
    [ZCSNotficationMgr addObserver:self call:@selector(didNetWorkEnd:) msgName:kZCSNetWorkOK];
    [ZCSNotficationMgr addObserver:self call:@selector(didNetWorkFailed:) msgName:kZCSNetWorkRequestFailed];
#endif
}
-(void)removeObservers
{
    [ZCSNotficationMgr removeObserver:self];
}
-(void)didNetWorkStart:(NSNotification*)ntf
{
    ZCSNetClient *obj = [ntf object];

    if([obj.resourceKey isEqualToString:@"uploadpic"])
    {
        @synchronized(self)
        {
            if(obj.request)
                [requestsArr addObject:obj.request];
            else 
            {
                [requestsArr addObject:obj.otherRequest];
                isStartNetwork = YES;
            }
        }
    }
#if 1
    
#else
    
    
#endif

}
#pragma mark
-(void)didNetWorkEnd:(NSNotification*)ntf
{
    id obj = [ntf object];
    id request = nil;
    if([obj isKindOfClass:[NSDictionary class]])
    {
        request = [obj objectForKey:@"request"];
    }
    else if ([obj isKindOfClass:[NSError class]]) 
    {
        NSLog(@"network error");
    }
    if([[request resourceKey] isEqualToString:@"uploadpic"])
    {
        
        @synchronized(self)
        {
            if([request request])
            {
            }
            else 
            {
                [requestsArr removeObject:[request otherRequest]];
                if([requestsArr count] ==0)
                {
                    [self startMemoDataNetWork];
                }
                NSLog(@"%d",[requestsArr count]);
            }
            
        }
    }
    if([[request resourceKey] isEqualToString:@"add"])
    {
   
        //progressValue = 1.0;
        [self performSelectorOnMainThread:@selector(doneAllNetWork:) withObject:nil waitUntilDone:YES];
    }
}
#pragma mark -
-(void)didNetWorkFailed:(NSNotification*)ntf
{
    [self.progressTimer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)progressEnd:(NSNotification*)ntf
{
    [self.progressTimer invalidate];
    //self.progressTimer = nil;
    [self.navigationController popToRootViewControllerAnimated:NO];
    //[NSUserDefaults standardUserDefaults];
}
-(void)loadView
{   
	//[super loadView];
    if(requestsArr == nil)
    {
    
        self.requestsArr = [NSMutableArray array];
    }
    
#if 1
    mainView = [[NEAppFrameView alloc]initWithFrame:[[UIScreen mainScreen]bounds] style:NEAppFrameViewDefault|NEAppFrameViewBottomBarNone|NEAppFrameViewTopBarNone];
#endif
	//self.view = mainView;
	UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"BG-chose&update.png");
	//assert(bgImage);
	mainView.bgImage = bgImage;
	self.view = mainView;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self  performSelectorInBackground:@selector(startNetWorkThread) withObject:nil];
}
#pragma mark -
#pragma mark upload memo
- (void)startNetWorkThread
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    DBManage *dbMgr = [DBManage getSingleTone];
    [dbMgr startUploadMemoImages];
    [pool release];
}
- (void)startMemoDataNetWork
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    DBManage *dbMgr = [DBManage getSingleTone];
    [dbMgr startUploadMemoData:self.memoPostData];
    [pool release];
}
-(void)dealloc
{
    self.memoPostData = nil;
    self.progressTimer =nil; 
    self.requestsArr = nil;
    [super dealloc];
}
#pragma mark -
#pragma mark processViewController update Public Methods
- (void)changeProgressValue
{
    
    if(!isStartNetwork&&0)
    {
        //progressView.progress = 0;
        return;
    }
    float progressValue = progressView.progress;
    /*
     progressValue       += 0.1f;
     */
    id request = nil;
    @synchronized(self)
    {
        if([requestsArr count]>0)
        {
            request = [requestsArr objectAtIndex:0];
            
        }
    }
    if([request isKindOfClass:[ASIHTTPRequest class]])
    {
        progressValue = [request totalBytesSent]/(float)[request postLength];
    }
   
#if 1
    [progressValueLabel setText:[NSString stringWithFormat:@"%.0f%%", (progressValue * 100)]];
    [progressView setProgress:progressValue];
#else
    
#endif
}
- (void)doneAllNetWork:(NSNotification*)ntf
{
    [ZCSNotficationMgr postMSG:kUploadProcessEnd obj:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self didNetWorkStart:nil];
    //
    UIImage *bgImage = nil;
    //bandage image view
    UIImageWithFileName(bgImage,@"logo-update.png");
    
   UIImageView *bgImageView = [[UIImageView alloc ]initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0,0,bgImage.size.width/kScale, bgImage.size.height/kScale);
    bgImageView.center = CGPointMake(kDeviceScreenWidth/2,kPhtoUploadProcessBrandViewCenterY);
    [mainView addSubview:bgImageView];
    [bgImageView release];
    // process view
    progressView = [[DDProgressView alloc]initWithFrame:CGRectZero];
    UIImage*image = nil;
    UIImageWithFileName(image,@"processIndicator.png");
    UIColor *innerColor = [UIColor colorWithPatternImage:image];
    
    [progressView setInnerColor:innerColor];
    [progressView setOuterColor:[UIColor clearColor]];
    [progressView setEmptyColor:[UIColor whiteColor]];
    [progressView setProgress:0.f];
    progressView.frame = kPhotoUploadProcessIndicatorRect;
    
    [mainView addSubview:progressView];
    progressView.center = mainView.center;//CGRectMake(, <#CGFloat y#>)
    [progressView release];
    //for test
    if(self.progressTimer == nil)
    {
        NSLog(@"timer create");
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f 
                                                              target:self 
                                                            selector:@selector(changeProgressValue)
                                                            userInfo:nil
                                                             repeats:YES];
    }
#if 0
    CGRect rect = CGRectMake(0.f, 0.f,kDeviceScreenWidth, 50.f);
    progressValueLabel = [UIBaseFactory forkUILabelByRect:rect font:kUploadProcessTextFont textColor:[UIColor whiteColor]];
#endif
}
@end
