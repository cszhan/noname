//
//  PhotoUploadStartViewController.m
//  DressMemo
//
//  Created by  on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoUploadStartViewController.h"
#import "BSPreviewScrollView.h"
#import "TapImage.h"
#import "PhotoUploadXY.h"
#import "AppMSGDef.h"
#import "ZCSNotficationMgr.h"
#import "AppMainUIViewManage.h"
#import "PhotoPickTool.h"
#import "UIImage+Extend.h"
#import "PhotoUploadMarkTagViewController.h"
#import "ZCSDataArchiveMgr.h"
#import "DBManage.h"

#import "SVProgressHUD.h"
//#import <libkern/OSMemoryNotification.h>
static DBManage   *dbMgr = nil;
@interface PhotoUploadStartViewController ()
@end
//static NSArray *defaultImagesArr =nil;
@implementation PhotoUploadStartViewController
@synthesize scrollPages;
@synthesize scrollViewPreview;
@synthesize isNeedToScroller;
@synthesize fileNameArr;
@synthesize chooseImageIndex;
//@synthesize fileNameArr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        [self initData];
    }
    return self;
}
- (void)initData
{
    dbMgr =[DBManage getSingleTone];
    //self.pageArr
    fileNameArr = [dbMgr imageFileNameArr];
    scrollPages = [[NSMutableArray alloc]init];
    
    [ZCSNotficationMgr addObserver:self call:@selector(UploadPhotoDone:) msgName:kUploadProcessEnd];
}
-(void)initSubViews
{
    
    //upload bg image
    UIImage *bgImage = nil;
    UIImageView *bgImageView = nil;
    
    //clothe background
    
    
}
-(void)loadView
{
	[super loadView];
    //return;
    //tabCtrl.tabBar.frame = CGRectMake(0,0,40,32);
	//topBarViewNavItemArr = [[NSMutableArray alloc]init];
	/*
     mainView = [[NEAppFrameView alloc]
     //initWithFrame:[[UIScreen mainScreen]bounds]];
     initWithFrame:[[UIScreen mainScreen]bounds]withImageDict:nil withImageDefault:YES];
     */
    /*
	mainView = [[NEAppFrameView alloc]initWithFrame:[[UIScreen mainScreen]bounds] style:NEAppFrameViewDefault|NEAppFrameViewBottomBarNone];
	//self.view = mainView;
    */
	UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"BG-mask.png");
	//assert(bgImage);
	mainView.bgImage = bgImage;
    
	[self initSubViews];
    
     //self.view = mainView;
    
	//[mainView release];
	//[self.view addSubview:mainView];
	//NE_LOGRECT(self.view.frame);
	//NE_LOGRECT(mainView.topBarView.frame);
	//self.view.frame =CGRectOffset(self.view.frame, 0.f, -40.f);
	//[self.view addSubview:mainView];
	//[mainView release];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.isNeedToScroller&&0)
    {
        [scrollViewPreview scrollerRightTonextPageNum:1];
        self.isNeedToScroller = NO;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(isFromViewUnload)
    {
        self.scrollPages = [NSMutableArray array];
        for(NSString *fileName in fileNameArr)
        {
            CGSize imageSize = CGSizeMake(kPhotoUploadStartImageW, kPhotoUploadStartImageH);
            UIImage *cropImageData = [UIImage_Extend imageCroppedToFitSizeII:imageSize withFileName:fileName];
            [self.scrollPages addObject:cropImageData];
        }
        /*
        self.scrollPages = [[ZCSDataArchiveMgr getSingleTone] archiveObjectDataFetch:objIDKey];
        */
        isFromViewUnload = NO;
    }
    scrollViewPreview = [[BSPreviewScrollView alloc]initWithFrame:CGRectMake(kPhotoUploadStartImageBGX, kPhotoUploadStartImageBGY-20,kPhotoUploadStartScrollerW,kPhotoUploadStartScrollerH+40.f)];
    NE_LOGRECT(scrollViewPreview.frame);
    [scrollViewPreview setBackgroundColor:[UIColor clearColor]];
	scrollViewPreview.pageSize = CGSizeMake(kPhotoUploadStartScrollerW, kPhotoUploadStartScrollerH);
	// Important to listen to the delegate methods.
	scrollViewPreview.delegate = self;
#if 0   
    UIImage *bgImage= nil;
    UIImageWithFileName(bgImage,@"BG-mask.png");

    UIImageView *bgImageView = [[UIImageView alloc ]initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0.f,15.f,bgImage.size.width/kScale, bgImage.size.height/kScale);
    //scrollViewPreview.bgView = bgImageView;
    //CGPoint size = self.frame.size;
    //_bgView.center = CGPointMake(size.width/2.f,size.height/2.f);
    //[scrollViewPreview add:_bgView belowSubview:zoomView];];
    [scrollViewPreview setInsertBgView:YES];
    [bgImageView addSubview:scrollViewPreview];
    
    [self.view addSubview:bgImageView];
    [bgImageView release];
#else
    UIImage *bgImage= nil;
    UIImageWithFileName(bgImage,@"BG-mask.png");
    
    UIImageView *bgImageView = [[UIImageView alloc ]initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0.f,15.f,bgImage.size.width/kScale, bgImage.size.height/kScale);
    //scrollViewPreview.bgView = bgImageView;
    //CGPoint size = self.frame.size;
    //_bgView.center = CGPointMake(size.width/2.f,size.height/2.f);
    //[scrollViewPreview add:_bgView belowSubview:zoomView];];
    
    [scrollViewPreview setInsertBgView:YES];
    
    [scrollViewPreview setPageViewPendingWidth:kPhotoUploadScrollerPagePendingX];
   // [bgImageView addSubview:scrollViewPreview];
    
    //[mainView.mainFramView addSubview:bgImageView];
    [bgImageView release];
    //scrollViewPreview.backgroundColor = [UIColor colorWithPatternImage:bgImage];
  
	[self.view addSubview:scrollViewPreview];
#endif
    
    
    [scrollViewPreview release];
    	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [scrollViewPreview release];
    isFromViewUnload = YES;
    self.scrollPages = nil;
    // Release any retained subviews of the main view.
}
- (void)didReceiveMemoryWarning
{
    
    //OSMemoryNotificationCurrentLevel()
#if 0
    ZCSDataArchiveMgr *gArchiveMgr = [ZCSDataArchiveMgr getSingleTone];
    
    if([gArchiveMgr archiveObjectData:self.scrollPages forKey:objIDKey])
    {
        //NE_LOG(@"archive ok");
        self.scrollPages = nil;
    }
#endif  
  
    [super didReceiveMemoryWarning];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark TapImage image data operation
-(void)replaceImageDataIndex:(NSInteger)index
{
    
}
#pragma mark -
#pragma mark TapImage delegate method
static int chooseActionType = -1;

-(void)didTouchView:(TapImage*)sender
{
   
    chooseImageIndex = sender.tag;
    isNeedToScroller = NO;
    //[ZCSNotficationMgr postMSG:kUploadActionSheetViewAlertMSG obj:gnv.view];
    if(!sender.hasImageData)
    {
        chooseActionType = 0;
        [self shouldActionSheetChoose:0];//
        
    }
    else
    {
        chooseActionType = 1;
        [self shouldActionSheetChoose:1];
    }
    
    
}
-(void)shouldActionSheetChoose:(NSInteger)type
{
   // id obj = [ntf object];
    UINavigationController *gnv =  [AppMainUIViewManage sharedAppNavigationController];
    switch (type) 
    {
        case 0:{
        
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" 
                                                                    delegate:self 
                                                           cancelButtonTitle:NSLocalizedString(@"Cancel",@"")
                                                      destructiveButtonTitle:nil otherButtonTitles:
                                                            NSLocalizedString(@"From Camera",@""),
                                                        NSLocalizedString(@"From Album" ,@"")
                                                ,nil];
            actionSheet.delegate = self;
            actionSheet.backgroundColor= [UIColor clearColor];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            //[actionSheet addButtonWithTitle:NSLocalizedString(@"From Camera",@"")];
            //[actionSheet addButtonWithTitle:NSLocalizedString(@"From Album" ,@"")];
            //[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel",@"")];
            [actionSheet showInView:gnv.view];
            [actionSheet autorelease];
        }
            break;
        case 1:
        {
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" 
                                                                    delegate:self 
                                                           cancelButtonTitle:NSLocalizedString(@"Cancel",@"")
                                                      destructiveButtonTitle:NSLocalizedString(@"Delete",@"") otherButtonTitles:nil,nil];
            actionSheet.delegate = self;
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            //[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel",@"")];
            [actionSheet showInView:gnv.view];
            [actionSheet autorelease];
        }
        default:
            break;
    }

    
}
#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(chooseActionType == 0)
    {
        if (buttonIndex == 2) 
            return;
   
        [self startPhotoPick:buttonIndex];
    }
    else 
    {
        if (buttonIndex == 0)
            [self deletePhotoImage];
        
    }
    //UIPickerView
}
-(void)startPhotoPick:(NSInteger)index{
    PhotoPickTool *picktool = [PhotoPickTool getSingleTone] ;
    [picktool setControllerDelegate:[AppMainUIViewManage sharedAppNavigationController]];
    [picktool setDelegate:self];
    //0 for camera 1 for alblum
    [ZCSNotficationMgr postMSG:kUploadPhotoPickChooseMSG obj:[NSNumber numberWithInt:index]];

}
-(void)deletePhotoImage
{

    switch (chooseImageIndex) 
    {
        case 0:
            //[self reRangeImageTwo];
            break;
        case 1:
            //[self reRangeImage
        default:
            break;
    }
    [self removeImageDataByIndex:chooseImageIndex];
    //UIFont
    //self.scrollPages = pageArr;
    //rearrange the index
  
   
}

#pragma mark -
#pragma mark 
#pragma mark photopick  delegate
//@class PhotoUploadStartViewController;
-(void)didGetImageData:(id)data
{
    //NE_LOG(@"%@",[data description]);
    
    NSString *fileName = [NSString generateNonce];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           data,@"data",
                           fileName,@"path",nil];
    //[self saveimageData:param];
    [self performSelectorInBackground:@selector(saveimageData:) withObject:param];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Data Processing", @"") networkIndicator:NO];
    //NSData *saveData = UIImageJPEGRepresentation(data,0.9);
#if 0
    CGSize imageSize = CGSizeMake(kPhotoUploadStartImageW, kPhotoUploadStartImageH);
    UIImage *cropImageData = [UIImage_Extend imageCroppedToFitSizeII:imageSize withData:data];
    
    [self replaceScrollerImageViewAtIndex:chooseImageIndex withImageData:cropImageData];
#endif
    
    /*
    PhotoUploadStartViewController *phUpStartVC = [[PhotoUploadStartViewController alloc]init];
    phUpStartVC.scrollPages = [NSArray arrayWithObject:cropImageData];
    [self.navigationController pushViewController:phUpStartVC animated:YES];
    [phUpStartVC release];
    */
}
-(void)saveimageData:(NSDictionary*)param
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    //ZCSDataArchiveMgr *dataArchive = [[ZCSDataArchiveMgr alloc]init];// [ZCSDataArchiveMgr getSingleTone];

    NSString *fileName = [param objectForKey:@"path"];
    BOOL saveOK = [dbMgr  saveUploadImageTolocalPath:[param objectForKey:@"data"] 
                                        withFileName:fileName];
    if(saveOK)
        [self performSelectorOnMainThread:@selector(didSaveImagePath:) withObject:fileName waitUntilDone:YES];
    [pool    release];
}
-(void)didSaveImagePath:(NSString*)fileName
{
     NSString *filePath = [NTESMBUtility filePathInDocumentsDirectoryForFileName:fileName];
    [self replaceScrollerImageViewAtIndex:chooseImageIndex withImageDataFileName:filePath];
    [SVProgressHUD dismiss];
}
#pragma mark -
#pragma mark Image data add replace or delete
-(void)replaceScrollerImageViewAtIndex:(NSInteger)num withImageData:(UIImage*)data
{
    
    NSMutableArray *pageArr = [NSMutableArray arrayWithArray:self.scrollPages];
    if(num>=[self.scrollPages count])
    {
        [pageArr addObject:data];
        num = [pageArr count]-1;
    }
    else 
    {
         [pageArr replaceObjectAtIndex:num withObject:data];
    }
    self.scrollPages = pageArr;
    [scrollViewPreview reloadScrollerPageViewNum:num];
   
    if(chooseImageIndex+1<3)
    {
         self.isNeedToScroller = YES;
    }
    
}
-(void)replaceScrollerImageViewAtIndex:(NSInteger)num withImageDataFileName:(NSString*)fileName
{
   
    //NSMutableArray *pageArr = [NSMutableArray arrayWithArray:self.scrollPages];
    CGSize imageSize = CGSizeMake(kPhotoUploadStartImageW, kPhotoUploadStartImageH);
    UIImage *cropImageData = [UIImage_Extend imageCroppedToFitSizeII:imageSize withFileName:fileName];
    //update 
    if(num>=[self.scrollPages count])
    {
        [self.scrollPages addObject:cropImageData];
        [fileNameArr addObject:fileName];
        num = [self.scrollPages count]-1;
    }
    else 
    {
        [self.scrollPages  replaceObjectAtIndex:num withObject:cropImageData];
        [fileNameArr replaceObjectAtIndex:num withObject:fileName];
    }
    //self.scrollPages = pageArr;
    [scrollViewPreview reloadScrollerPageViewNum:num];
    if(chooseImageIndex+1<3)
        self.isNeedToScroller = YES;

}

-(void)removeImageDataByIndex:(NSInteger)_chooseImageIndex
{
    // NSMutableArray *pageArr = [NSMutableArray arrayWithArray:self.scrollPages];
    int totall = [self.scrollPages count];
    
    //delete same time 
    [self.scrollPages removeObjectAtIndex:chooseImageIndex];
    

    NSString *fileName = [fileNameArr objectAtIndex:chooseImageIndex];
    //remove file
    [dbMgr removeImageByFileName:fileName];
    
    [fileNameArr removeObjectAtIndex:chooseImageIndex];
    
    int i = chooseImageIndex;
#if 0
    
    while (i<totall)
    { 
        [scrollViewPreview reloadScrollerPageViewNum:i++];
        if(i == totall)
        {
        [scrollViewPreview scrollerRightTonextPageNum:1];
        }
    }
    
#else
    [scrollViewPreview  reloadScrollerPageViewAnimation:i];
    NSArray *pageViews = [scrollViewPreview getScrollerPageViews];
    for(int j = 0;j<[pageViews count];j++)
    {
        UIView *item = [pageViews objectAtIndex:j];
        if((NSNull*)item!= [NSNull null])
        {
            item.tag = j;
        }
    }
    
#endif
}
-(void)addOrReplaceImageDataByIndex:(NSInteger)num
{
  
}
#pragma mark -
#pragma mark BSPreviewScrollViewDelegate methods
-(UIView*)viewForItemAtIndex:(BSPreviewScrollView*)scrollView index:(int)index
{
	// Note that the images are actually smaller than the image view frame, each image
	// is 210x280. Images are centered and because they are smaller than the actual 
	// view it creates a padding between each image. 
    UIImage *imageData= nil;
    UIImageWithFileName(imageData, kPhotoUploadStartDefaultImageName);
	CGRect imageViewFrame = CGRectMake(kPhotoUploadStartImageBGX,kPhotoUploadStartImageBGY, imageData.size.width/kScale+kPhotoUploadScrollerPagePendingX*2,imageData.size.height/kScale);
	// TapImage is a subclassed UIImageView that catch touch/tap events 
	TapImage *imageView = [[[TapImage alloc] initWithFrame:imageViewFrame] autorelease];
	imageView.userInteractionEnabled = YES;
    imageView.delegate = self;
   
    //has the 
    imageView.image = imageData;//[UIImage imageNamed:[self.scrollPages objectAtIndex:index]];
    //imageView.frame = 
    imageView.tag = index;
    NE_LOGRECT(imageView.frame);
    
    if(index <[self.scrollPages count])
    {
        id imageData = [self.scrollPages objectAtIndex:index];
        UIImageView *photoImageView =nil;
        if([imageData isKindOfClass:[UIImage class]])
        {
            photoImageView = [[UIImageView alloc]initWithImage:imageData];
        }
        else if([imageData isKindOfClass:[NSString class]])
        {
            UIImage *realImageData = [UIImage imageNamed:imageData];
            photoImageView = [[UIImageView alloc]initWithImage:realImageData];
        }
        CGRect rect;
        rect.origin = CGPointMake(kPhotoUploadStartImageX, kPhotoUploadStartImageY);
        rect.size = CGSizeMake(kPhotoUploadStartImageW,kPhotoUploadStartImageH);
        photoImageView.frame = rect;
        [imageView addSubview:photoImageView];
        photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        [photoImageView release];
        imageView.hasImageData = YES;
    }
    //add mask
    UIImage *bgImage = nil;
    UIImageWithFileName(bgImage, @"pic-mask.png");
#if 0
    UIEdgeInsets resizeEdgeInset = UIEdgeInsetsMake(12.f,12.f,12.f,12.f);
    if([bgImage respondsToSelector:@selector(resizableImageWithCapInsets:)]&&1)
    {
        bgImage =[bgImage resizableImageWithCapInsets:resizeEdgeInset];
        
    }
    else 
    {
        bgImage = [bgImage stretchableImageWithLeftCapWidth:12.f topCapHeight:12.f];
    }
#endif
    UIImageView *maskView =[[UIImageView alloc]initWithImage:bgImage];
    // maskView.frame =  
    maskView.frame = CGRectMake(0.f, 0.f,bgImage.size.width/kScale, bgImage.size.height/kScale);
    [imageView addSubview:maskView];
    maskView.hidden = YES;
    [maskView release];
    //maskView.alpha = 1.f;
	imageView.contentMode = UIViewContentModeScaleToFill;
	return imageView;
}

-(int)itemCount:(BSPreviewScrollView*)scrollView
{
	// Return the number of pages we intend to display
	return kPhotoUploadStartMaxPicCount; //[self.scrollPages count];
}
#pragma mark nav item selector
-(void)didSelectorTopNavItem:(id)navObj
{
	NE_LOG(@"select item:%d",[navObj tag]);
    
	switch ([navObj tag])
	{
		case 0:
        {
            //clear all data
            [dbMgr clearAllUploadImageData];
            [self.navigationController popViewControllerAnimated:YES];// animated:<#(BOOL)animated#>
        }
			break;
		case 1:
		{
            
			
            //return;
            

             PhotoUploadMarkTagViewController *tagVc = [[PhotoUploadMarkTagViewController alloc]init];
             //[self.navigationController pushViewController:playMenuVc animated:YES];
             //[[NSNotificationCenter defaultCenter] postNotificationName: object:playMenuVc];
#if 1
             [ZCSNotficationMgr postMSG:kPushNewViewController obj:tagVc];
#else
            [self.navigationController pushViewController:tagVc animated:YES];
#endif  
            [tagVc release];
           
            
			break;
		}
	}
    if(delegate&&[delegate respondsToSelector:@selector(didSelectorTopNavigationBarItem:)])
    {
        
        [delegate didSelectorTopNavigationBarItem:navObj];
    }
}
#pragma mark upload photo
-(void)UploadPhotoDone:(NSNotification*)ntf
{
    //self.view = nil;
    //[ZCSNotficationMgr postMSG: obj:<#(id)#>
    [ZCSNotficationMgr postMSG:kPopAllViewController obj:[NSNumber numberWithBool:NO]];
    [delegate UploadPhotoDone:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)dealloc{
    self.scrollPages = nil;
    //self.scrollViewPreview = nil;
    [super dealloc];
}
@end
