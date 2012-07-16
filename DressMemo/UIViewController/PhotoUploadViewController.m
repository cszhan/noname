//
//  PhotoUploadViewController.m
//  DressMemo
//
//  Created by  on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoUploadViewController.h"
#import "PhotoPickTool.h"
#import "PhotoUploadXY.h"
#import "AppMainUIViewManage.h"
#import "PhotoUploadStartViewController.h"
#import "UIImage+Extend.h"
#import "DBManage.h"
#import "NTESMBUtility.h"
@interface PhotoUploadViewController ()
@property(nonatomic,assign)BOOL isUpdatedTag;
@end
@implementation PhotoUploadViewController
@synthesize isUpdatedTag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

-(void)initSubViews
{
    
    //upload bg image
    UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"BG-chose&update.png");
    UIImageView *bgImageView = [[UIImageView alloc ]initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0,0,bgImage.size.width/kScale, bgImage.size.height/kScale);
    NE_LOGRECT(bgImageView.frame);
    [mainView addSubview:bgImageView];
    [bgImageView release];
    
    bgImage = nil;
    //clothe background
    UIImageWithFileName(bgImage,@"BG-chose.png");
    
    bgImageView = [[UIImageView alloc ]initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0,0,bgImage.size.width/kScale, bgImage.size.height/kScale);
    
    [mainView addSubview:bgImageView];
    [bgImageView release];
    
	UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImageWithFileName(bgImage,@"fcamera.png");
	//UIImage *bgImageS = nil;
	//UIImageWithFileName(bg
	[btn setBackgroundImage:bgImage forState:UIControlStateNormal];
    //btn.showsTouchWhenHighlighted = YES;
    
	UIImageWithFileName(bgImage,@"fcamerahover.png");
	[btn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
	//|UIControlStateHighlighted|UIControlStateSelected
    
	btn.frame = CGRectMake(kUploadFromCameraX,kUpladFromCameraY,bgImage.size.width/kScale, bgImage.size.height/kScale);
    [btn addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 0;
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(52.f,(572.f-252.f)/2.f, 30.f, 20.f)];
    textLabel.text = NSLocalizedString(@"From Camera", @"");
    textLabel.font = kAppTextSystemFont(15.f);
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor clearColor];
    [btn addSubview:textLabel];
    [textLabel release];
    [mainView addSubview:btn];
	NE_LOGRECT(btn.frame);

    btn = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImageWithFileName(bgImage,@"falbum.png");
	//UIImage *bgImageS = nil;
	//UIImageWithFileName(bg
	//[btn setImage:bgImage forState:UIControlStateNormal];
    [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
    
     UIImageWithFileName(bgImage,@"falbumhover.png");
     [btn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
     //|UIControlStateHighlighted|UIControlStateSelected

	btn.frame = CGRectMake(kUploadFromAlbumX,kUpladFromAlbumY,bgImage.size.width/kScale, bgImage.size.height/kScale);
    //btn.showsTouchWhenHighlighted = YES;
    [btn addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 1;
    
    textLabel = [[UILabel alloc]initWithFrame:CGRectMake((464.f-340.f)/2.f,(572.f-252.f)/2.f, 100.f, 20.f)];
    textLabel.text = NSLocalizedString(@"From Album", @"");
    textLabel.font = kAppTextSystemFont(15.f);
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor clearColor];
    [btn addSubview:textLabel];
    [textLabel release];
    [mainView addSubview:btn];
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
	//[mainView release];
	mainView = [[NEAppFrameView alloc]initWithFrame:[[UIScreen mainScreen]bounds] style:NEAppFrameViewDefault|NEAppFrameViewBottomBarNone];
	//self.view = mainView;
	
	[self initSubViews];
	self.view = mainView;
	//[mainView release];
	//[self.view addSubview:mainView];
	NE_LOGRECT(self.view.frame);
	NE_LOGRECT(mainView.topBarView.frame);
	//self.view.frame =CGRectOffset(self.view.frame, 0.f, -40.f);
	//[self.view addSubview:mainView];
	//[mainView release];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(isUpdatedTag)
    {
        NSArray *subViewsArr = mainView.subviews;
        for(id item in subViewsArr)
        {
            [item removeFromSuperview];
        }
        UIImage *bgImage = nil;
        UIImageWithFileName(bgImage,@"BG-updated.png");
        //assert(bgImage);
        mainView.bgImage = bgImage;
        mainView.alpha = 0.;
        isUpdatedTag = NO;
        [UIView animateWithDuration:0.5 animations:
         ^{
             mainView.alpha = 1.f;
         }
         ];
    }
    
}
-(void)addObservers
{
    //[ZCSNotficationMgr removeObserver:self msgName:kUploadPhotoPickChooseMSG];
    //[ZCSNotficationMgr addObserver:self call:@selector(UploadPhotoDone:) msgName:kUploadProcessEnd];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self registerObserver];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark pick phto from action sheet msg
-(void)pickPhoto:(NSNotification*)ntf
{
    id obj = [ntf object];
    [self didTouchBtn:obj];
}
#pragma mark touch Event
static PhotoPickTool *photoPickTool = nil;
-(void)didTouchBtn:(id)sender
{
    int type = -1;
    if([sender respondsToSelector:@selector(intValue)]){
        type = [sender intValue];
    }
    else 
	if([sender respondsToSelector:@selector(tag)]){
        type = [sender tag];
    }
	UIViewController *vc = [[AppMainUIViewManage sharedAppNavigationController] topViewController];
#if 1
    PhotoPickTool *picktool = [PhotoPickTool getSingleTone] ;
	
    [picktool setControllerDelegate:vc];
    [picktool setDelegate:self];
    //0 for camera 1 for alblum
    [ZCSNotficationMgr postMSG:kUploadPhotoPickChooseMSG obj:[NSNumber numberWithInt:type]];
#else
	NSNotification *ntf = [NSNotification notificationWithName:@"" object:[NSNumber numberWithInt:type]];
						   [self pickPhotoI:ntf];
#endif
}
#pragma mark  UIImagePickerController 
#pragma mark pick phto from action sheet msg
-(void)pickPhotoI:(NSNotification*)ntf
{
    id sender = [ntf object];
    int type = -1;
    if([sender respondsToSelector:@selector(intValue)]){
        type = [sender intValue];
    }
    else if([sender respondsToSelector:@selector(tag)]){
        type = [sender tag];
    }
	switch (type) 
	{
		case 0:
		{
			
			[self  pickPhotoFromCamara];
		}
			break;
		case 1:
			[self  pickPhotoFromLib];
			break;
			
		default:
			break;
	}
	
}
- (BOOL)pickPhotoFromCamara{
	//NE_LOGFUN;
	BOOL hasCamera = NO;
	hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
	if(!hasCamera)
    {
		return NO;
	}
	UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	//picker.postViewController = self;
	picker.delegate = self;
	[self presentModalViewController:picker animated:YES];
    return YES;
}
-(BOOL)pickPhotoFromLib
{
	UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	picker.delegate = self;
	[self presentModalViewController:picker animated:YES];
    return YES;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NE_LOG(@"%@",[info description]);
    [self dismissModalViewControllerAnimated:YES];
	
    UIImage *data = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if([delegate respondsToSelector:@selector(didGetImageData:)]&&delegate)
    {
        [self didGetImageData:data];
    }
    
}
-(void)saveimageData:(NSDictionary*)param
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    //ZCSDataArchiveMgr *dataArchive = [[ZCSDataArchiveMgr alloc]init];// [ZCSDataArchiveMgr getSingleTone];
    DBManage *dbMgr = [DBManage getSingleTone];
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
    PhotoUploadStartViewController *phUpStartVC = [[PhotoUploadStartViewController alloc]init];
    phUpStartVC.delegate = self;
    //phUpStartVC.scrollPages = [NSArray arrayWithObject:cropImageData];
    [phUpStartVC replaceScrollerImageViewAtIndex:0 withImageDataFileName:filePath];
    [self.navigationController pushViewController:phUpStartVC animated:YES];
    [phUpStartVC release];
    [SVProgressHUD dismiss];
}
#pragma mark photopick delegate
//@class PhotoUploadStartViewController;
-(void)didGetImageData:(id)data
{
    NE_LOG(@"%@",[data description]);
#if 0 
    CGSize imageSize = CGSizeMake(kPhotoUploadStartImageW, kPhotoUploadStartImageH);
    UIImage *cropImageData = [UIImage_Extend imageCroppedToFitSizeII:imageSize withData:data];
    PhotoUploadStartViewController *phUpStartVC = [[PhotoUploadStartViewController alloc]init];
    //phUpStartVC.scrollPages = [NSArray arrayWithObject:cropImageData];
    [phUpStartVC replaceScrollerImageViewAtIndex:0 withImageData:cropImageData];
    [self.navigationController pushViewController:phUpStartVC animated:YES];
    
    [phUpStartVC release];
#else
    NSString *fileName = [NSString generateNonce];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           data,@"data",
                           fileName,@"path",nil];
    [self performSelectorInBackground:@selector(saveimageData:) withObject:param];
    //[self saveimageData:param];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Data Processing", @"") networkIndicator:NO];
#endif
   
}
#pragma mark 
-(void)didSelectorTopNavItem:(id)navObj{
	NE_LOG(@"select item:%d",[navObj tag]);
    
	switch ([navObj tag])
	{
		case 0:
			[self.navigationController popViewControllerAnimated:YES];// animated:<#(BOOL)animated#>
			break;
		case 1:
		{
            
			
            //return;
            /*
             PlayingMenuViewController *playMenuVc = [[PlayingMenuViewController alloc]init];
             //[self.navigationController pushViewController:playMenuVc animated:YES];
             //[[NSNotificationCenter defaultCenter] postNotificationName: object:playMenuVc];
             [ZCSNotficationMgr postMSG:kPushNewViewController obj:playMenuVc];
             [playMenuVc release];
             */
			break;
		}
	}
}
-(void)UploadPhotoDone:(NSNotification*)ntf
{
    //self.view = nil;
    //
    [[DBManage getSingleTone] clearAllUploadImageData];
    NSLog(@"upload Done ");
    isUpdatedTag = YES;
    //[self.navigationController popToRootViewControllerAnimated:YES];
	//self.view = mainView;
}
-(void)dealloc
{
    
    [super dealloc];
}
@end
