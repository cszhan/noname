//
//  PhotoUploadMarkTagViewController.m
//  DressMemo
//
//  Created by  on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoUploadMarkTagViewController.h"
#import "PhotoUploadProcess.h"
#import "TapImage.h"
#import "MemoDescriptionViewController.h"
#import "TagChooseBrandViewController.h"
//data
#import "DBManage.h"
#import "PhotoUploadXY.h"
#import "UIImage+Extend.h"
#import "SNPopupView.h"
#import "CMPopTipView.h"
#import "ZCSAlertInforView.h"
#import "DressMemoTagButton.h"
@interface PhotoUploadMarkTagViewController()
@property(nonatomic,assign)CGPoint currentPoint;
@property(nonatomic,assign)NSMutableArray *imageTagsArr;
@property(nonatomic,assign)NSMutableDictionary *imageTagsDict;
@property(nonatomic,assign)NSMutableArray *currentImageTagArr;
@property(nonatomic,retain)NSMutableArray *tagBtnArr;
@property(nonatomic,retain)NSMutableArray *inforArr;
@property(nonatomic,retain) ZCSAlertInforView *alterInfoView;
@property(nonatomic,assign)BOOL shouldHidden;
@property(nonatomic,assign)BOOL isNeedInfor;
@end
@implementation PhotoUploadMarkTagViewController
@synthesize newScrollerView;
@synthesize currentPoint;
@synthesize imageTagsArr;
@synthesize imageTagsDict;
@synthesize currentImageTagArr;
@synthesize alterInfoView;
@synthesize shouldHidden;

@synthesize tagBtnArr;
@synthesize inforArr;
@synthesize isNeedInfor;
/*
-(id)initwithPageDataFileName:(NSArray*)array
{
    if(self = [super initWithNibName:nil bundle:nil])
    {
        self.scrollPages = 
    }
    return self;

}
*/
-(void)dealloc
{
    self.alterInfoView = nil;
    self.scrollPages = nil;
    //self.scrollViewPreview = nil;
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.isNeedInfor&&shouldHidden)
    {
        [self.alterInfoView hiddenAfterDelay:0.5];
        shouldHidden = NO;
    
    }
}
- (void)initData
{
    //{
    DBManage *dbMgr =[DBManage getSingleTone];
    //self.pageArr
    self.fileNameArr = [dbMgr imageFileNameArr]; 
    
    //}
    [dbMgr initImageTagData];
    self.imageTagsDict = [dbMgr uploadImageTagDict];
   
   

}
- (void)initViewData{

    //for scroller page view
    self.scrollPages = [NSMutableArray array];
#if 0
    //for tag buttons
    self.tagBtnArr = [NSMutableArray array];
    //for infor views
    self.inforArr = [NSMutableArray array];
#endif

}
- (void)viewDidLoad
{
    //[super viewDidLoad];
    //if(isFromViewUnload)
    //[self initData];
    
    [self initViewData];
    
    isNeedInfor = YES;
    for(NSString *fileName in self.fileNameArr)
    {
        CGSize imageSize = CGSizeMake(kPhotoUploadMarkTagImageMaxW, kPhotoUploadMarkTagImageMaxH);
        UIImage *cropImageData = [UIImage_Extend imageCroppedToFitSizeII:imageSize withFileName:fileName];
        [self.scrollPages addObject:cropImageData];
        //has Tag we don't neew
        if([[imageTagsDict objectForKey:fileName] count])
        {
            isNeedInfor = NO;
            
        }
    }
    self.scrollViewPreview = [[BSPreviewScrollView alloc]initWithFrame:CGRectMake(kPhotoUploadMarkTagImageBGX,kMBAppTopToolBarHeight+41.f,kPhotoUploadMarkScrollerW,kPhotoUploadMarkTagImageMaxH)];
    NE_LOGRECT(self.scrollViewPreview.frame);
    [self.scrollViewPreview setBackgroundColor:[UIColor clearColor]];
	self.scrollViewPreview.pageSize = CGSizeMake(kPhotoUploadMarkScrollerW, kPhotoUploadMarkTagImageMaxH);
	// Important to listen to the delegate methods.
	self.scrollViewPreview.delegate = self;
    
    [self.scrollViewPreview setZoomScale:CGPointMake(kPhotoUploadMarkTagImageScaleW, kPhotoUploadMarkTagImageScaleH)];
    
    [self.scrollViewPreview setInsertBgView:YES];
    //use the mask layer
    //UIImage *maskImage = [UIImage_Extend imageWithColor:HexRGB(0,0,0) withSize:CGSizeMake(kPhotoUploadMarkTagImageNomarlW, kPhotoUploadMarkTagImageNomarlH)];

    //[self.scrollViewPreview setMaskImage:maskImage];

    
    [self.scrollViewPreview setPageViewPendingWidth:kPhotoUploadMarkScrollerPagePendingX];
    [self.scrollViewPreview setPageControlHidden:NO];
    NE_LOGRECT(self.scrollViewPreview.frame);
    StyledPageControl *pageControl = [self.scrollViewPreview getPageControl];
    UIImage *image  = nil;
    UIImageWithFileName(image ,@"point-gray.png");
    pageControl.thumbImage = image;
    UIImageWithFileName(image ,@"point-red.png");
    pageControl.selectedThumbImage = image;
    pageControl.pageControlStyle = PageControlStyleThumb;

    
    CGRect rect = pageControl.frame;
    //[self.scrollViewPreview setPageControlFrame:CGRectMake(0.f,rect.size.height-80.f,kDeviceScreenWidth, 40.f)];
    pageControl.frame = CGRectOffset(rect, 0.f, 10.f);
    NE_LOGRECT([pageControl frame]);
    self.scrollViewPreview.zoomInSize = CGSizeMake(kPhotoUploadMarkTagImageNomarlW,kPhotoUploadMarkTagImageNomarlH);
    self.scrollViewPreview.zoomOutSize = CGSizeMake(kPhotoUploadMarkTagImageMaxW,kPhotoUploadMarkTagImageMaxH);
    [self.scrollViewPreview setScrollerZoom:YES];
    [self.view addSubview:self.scrollViewPreview];
    if(self.isNeedInfor)
    {
        
        UIImage *bgImage = nil;
        UIImageWithFileName(bgImage, @"BG-touchnote.png");
#if 0
        bgImage = [bgImage stretchableImageWithLeftCapWidth: topCapHeight:];
#endif
        ZCSAlertInforView *alertView = [[ZCSAlertInforView alloc]initWithFrame:CGRectMake(0.f,-44.f,bgImage.size.width/kScale, bgImage.size.height/kScale)withText:@"" isWindow:NO];
        [alertView setBGContent:bgImage];
        [alertView setTextFont:kUploadPhotoTextFont_SYS(14)];
        alertView.isHiddenAuto = NO;
        alertView.center = CGPointMake(kPhotoUploadMarkScrollerW/2.f,alertView.center.y);
        self.alterInfoView = alertView;
        alterInfoView.text = NSLocalizedString(@"touch anywhere to add tag view", @"");
        [self.scrollViewPreview insertSubview:alterInfoView belowSubview:mainView.topBarView];
     
        [alertView show];
        [alertView release];
        
    }
       [self.view  bringSubviewToFront:mainView.topBarView];
    //[self.scrollViewPreview release];
    // Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark BSPreviewScrollViewDelegate methods
-(UIView*)viewForItemAtIndex:(BSPreviewScrollView*)scrollView index:(int)index
{
	// Note that the images are actually smaller than the image view frame, each image
	// is 210x280. Images are centered and because they are smaller than the actual 
	// view it creates a padding between each image. 
    UIImage *imageData= nil;
#if 0
    NSString *filePath = [self.scrollPages objectAtIndex:index];
    UIImageWithFullPathName(imageData,filePath);
#endif
	//CGRect imageViewFrame = CGRectMake(0,0,kPhotoUploadMarkTagImageNomarlW+2*kPhotoUploadMarkScrollerPagePendingX,kPhotoUploadMarkTagImageNomarlH);
    CGRect imageViewFrame = CGRectMake(0,0,kPhotoUploadMarkTagImageNomarlW+2*kPhotoUploadMarkScrollerPagePendingX,kPhotoUploadMarkTagImageNomarlH);
	// TapImage is a subclassed UIImageView that catch touch/tap events 
	TapImage *imageView = [[[TapImage alloc] initWithFrame:imageViewFrame] autorelease];
	imageView.userInteractionEnabled = YES;
    imageView.delegate = self;
    
    //has the 
    imageView.image = [self.scrollPages objectAtIndex:index];
    //imageView.frame = 
    imageView.tag = index;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self initTagButton:imageView withIndex:index];

    //HexRGB(0,0,0)
    UIView *maskView =[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f,kPhotoUploadMarkTagImageNomarlW, kPhotoUploadMarkTagImageNomarlH)];
    maskView.backgroundColor = HexRGBA(0, 0, 0,0.7);
    [imageView addSubview:maskView];
    [maskView release];
    maskView.hidden = YES;
    imageView.maskView = maskView;
    return  imageView;//[super viewForItemAtIndex:scrollView index:index];
}
-(void)initTagButton:(UIImageView*)imageView withIndex:(NSInteger)index{
    
    
    //for(int i = 0;i<[self.fileNameArr count];i++)
    {
        NSString *key = [self.fileNameArr objectAtIndex:index];    
        NSArray *imageItemArr = [self.imageTagsDict objectForKey:key];
        NSInteger index = 0;
        for(id item in imageItemArr)
        {
            [self initTagButton:imageView withData:item withIndex:index++];
        
        }
        
    }
   // int countIndex = [currentImageTagArr count];

}
-(void)initTagButton:(UIView*)imageView withData:(NSDictionary*)data withIndex:(NSInteger)index
{
    
    CGPoint point ;
    
    NSString *brand = [data objectForKey:@"Brand"];
    //NSString *cat = [data objectForKey:@"Cats"];
    NSString *xStr = [data objectForKey:@"PointX"];
    NSString *yStr = [data objectForKey:@"PointY"];
    
    point = CGPointMake([xStr floatValue],[yStr floatValue]);
    UIImage *bgImage= nil;
    UIImageWithFileName(bgImage,@"iconclassification.png");
    CGRect rect = CGRectMake(0.,0.f,bgImage.size.width/kScale, bgImage.size.height/kScale);
#if 0
    UIButton *classBtn = [UIBaseFactory forkUIButtonByRect:rect text:@"" image:bgImage];
#else
    DressMemoTagButton *classBtn = [DressMemoTagButton buttonWithType:UIButtonTypeCustom];
    classBtn.frame = rect;
    [classBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
#endif
    classBtn.center = point;
    classBtn.tag = index;
    classBtn.imageTag = imageView.tag;
    [classBtn addTarget:self action:@selector(didTouchTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:classBtn];
    //[self.tagBtnArr addObject:classBtn];
    
    
    
#if 0
    CGPoint newPoint = CGPointMake(point.x, point.y-classBtn.frame.size.height/2);
    SNPopupView *popup = [[SNPopupView alloc] initWithString:brand];
    [popup showAtPoint:newPoint inView:imageView];
    [popup addTarget:self action:@selector(didTouchTagPopupView:)];
    [popup release];
#else
    CMPopTipView *popup = [[CMPopTipView alloc]initWithMessage:brand];
    popup.disableTapToDismiss  = YES;
    popup.hidden = YES;
    [popup presentPointingAtView:classBtn inView:imageView animated:NO];
    [popup release];
    classBtn.tagInforView = popup;
#endif
    //[self.inforArr addObject:popup];

}
-(int)itemCount:(BSPreviewScrollView*)scrollView
{//
	// Return the number of pages we intend to display
	//return  [super itemCount:scrollView];
    return [self.scrollPages count];
}
#pragma mark nav item selector
-(void)didSelectorTopNavItem:(id)navObj
{
	NE_LOG(@"select item:%d",[navObj tag]);
    
	switch ([navObj tag])
	{
		case 0:
			[self.navigationController popViewControllerAnimated:YES];// animated:
			break;
		case 1:
		{
            
            MemoDescriptionViewController *desVc = [[MemoDescriptionViewController alloc]initWithNibName:@"MemoDescriptionViewController" bundle:nil];
            
            //[self.navigationController pushViewController:playMenuVc animated:YES];
            //[[NSNotificationCenter defaultCenter] postNotificationName: object:playMenuVc];
#if 0
            [ZCSNotficationMgr postMSG:kPushNewViewController obj:desVc];
#else
            [self.navigationController pushViewController:desVc animated:YES];
#endif  
            [desVc release];
            
        }
	}
    if(delegate&&[delegate respondsToSelector:@selector(didSelectorTopNavigationBarItem:)])
    {
        
        [delegate didSelectorTopNavigationBarItem:navObj];
    }
}
#pragma mark -
#pragma mark did mark tag 
static int tagType = 0;//0 new ,1 for change
-(void)didChangeTagInfo:(id)sender withData:(id)data 
{
   // NSMutableArray *dataArr = 
    //[self.navigationController popViewControllerAnimated:YES];
    //NSString *brand = [data objectForKey:@"Brand"];
    shouldHidden = YES;
    TapImage *currentView = [self.scrollViewPreview getScrollerPage:self.chooseImageIndex];
    int countIndex = [currentImageTagArr count];
    if(tagType == 0)
    {   
        NSMutableDictionary  *param = [NSMutableDictionary dictionaryWithDictionary:data];
        [param setValue:[NSString stringWithFormat:@"%lf",currentPoint.x] forKey:@"PointX"];
        [param setValue:[NSString stringWithFormat:@"%lf",currentPoint.y] forKey:@"PointY"];
        [currentImageTagArr addObject:param];
        [self initTagButton:currentView withData:param withIndex:countIndex];
        /*
        UIImage *bgImage= nil;
        UIImageWithFileName(bgImage,@"iconclassification.png");
        CGRect rect = CGRectMake(0.,0.f,bgImage.size.width/kScale, bgImage.size.height/kScale);
        UIButton *classBtn = [UIBaseFactory forkUIButtonByRect:rect text:@"" image:bgImage];
        classBtn.center = currentPoint;
        classBtn.tag = countIndex+1; 
        [classBtn addTarget:self action:@selector(didTouchTagBtn:) forControlEvents:UIControlEventTouchUpInside];
        [currentView addSubview:classBtn];
        
        CGPoint newPoint = CGPointMake(currentPoint.x, currentPoint.y-classBtn.frame.size.height/2);
        SNPopupView *popup = [[SNPopupView alloc] initWithString:brand];
		[popup showAtPoint:newPoint inView:currentView];
		[popup addTarget:self action:@selector(didTouchTagPopupView:)];
		[popup release];
        */
        //UIButton *btn = [UIBaseFactory fork ];
        
    }
    else
    {
        //if change we just use the tag information
        
        DressMemoTagButton *tagBtn = (DressMemoTagButton*)sender;
        countIndex = tagBtn.tag;
        [tagBtn removeFromSuperview];
        [tagBtn.tagInforView removeFromSuperview];
        
        [currentImageTagArr replaceObjectAtIndex:countIndex withObject:data];
        //NSLog(@"change:%@",[data objectForKey:@"Brand"]);
        
        [self initTagButton:currentView withData:data withIndex:countIndex];
        /*
        [(CMPopTipView*)tagBtn.tagInforView setMessage:[data objectForKey:@"Brand"]];
        [(CMPopTipView*)tagBtn.tagInforView setNeedsDisplay];
        */
    
    }
    [currentView bringSubviewToFront:currentView.maskView];
    //[self.scrollViewPreview bringSubviewToFront:<#(UIView *)#>
    
}
-(void)didDeleteTagBtn:(DressMemoTagButton*)btn withInforView:(id)inforView
{
    //UIButton *btn = [self.tagBtnArr objectAtIndex:
    int imageTagIndex = btn.tag;
    [currentImageTagArr removeObjectAtIndex:imageTagIndex];
    [btn removeFromSuperview];
    [btn.tagInforView removeFromSuperview];
    
}
-(void)didTouchTagPopupView:(id)sender
{


}
-(void)didTouchTagBtn:(id)sender
{
#if 1
    tagType = 1;//for change;
    DressMemoTagButton *tagBtn = (DressMemoTagButton*)sender;
    TagChooseBrandViewController *tagchooseBrandVc = [[TagChooseBrandViewController alloc]init];
    self.chooseImageIndex = tagBtn.imageTag;
    NSString *imageKey = [self.fileNameArr objectAtIndex:self.chooseImageIndex];
    currentImageTagArr = [self.imageTagsDict objectForKey:imageKey];
    
    NSDictionary *srcTagData = [currentImageTagArr objectAtIndex:tagBtn.tag];
    NSLog(@"src:%@",[srcTagData description]);
    [tagchooseBrandVc setInitSourceData:srcTagData withTagBtn:tagBtn];
    tagchooseBrandVc.delegate = self;
    [self.navigationController pushViewController:tagchooseBrandVc animated:YES];
    [tagchooseBrandVc release];

#endif
    
}
-(void)didTouchView:(TapImage*)sender
{
    
    NSLog(@"frame:%@",NSStringFromCGRect(sender.frame));
    NE_LOGPOINT([sender getTouchPoint]);
    self.chooseImageIndex = sender.tag;
    NSString *imageKey = [self.fileNameArr objectAtIndex:self.chooseImageIndex];
    currentImageTagArr = [self.imageTagsDict objectForKey:imageKey];
    
    tagType = 0;
    currentPoint = [sender getTouchPoint];
    
    TagChooseBrandViewController *tagchooseBrandVc = [[TagChooseBrandViewController alloc]init];
    tagchooseBrandVc.delegate = self;
    [self.navigationController pushViewController:tagchooseBrandVc animated:YES];
    [tagchooseBrandVc release];
    
}


@end
