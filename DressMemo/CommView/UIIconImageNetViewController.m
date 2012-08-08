//
//  UIIconImageNetViewController.m
//  DressMemo
//
//  Created by cszhan on 12-8-6.
//
//

#import "UIIconImageNetViewController.h"
#import "DressMemoUserIconDownloader.h"
#import "DressMemoUserIconCache.h"
#import "RequestCfg.h"
@interface UIIconImageNetViewController ()

@end

@implementation UIIconImageNetViewController
@synthesize iconDataSouce;
@synthesize iconDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.iconDataSouce  = self;
        self.iconDelegate = self;
        [ZCSNotficationMgr addObserver:self call:@selector(requestCompleted:) msgName:HTTP_REQUEST_COMPLETE];
        [ZCSNotficationMgr addObserver:self call:@selector(requestFailed:) msgName:HTTP_REQUEST_ERROR];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
- (void)startloadInitCell:(id)cell withIndexPath:(NSIndexPath*)indexPath
{
    NSString *userIconPath = [iconDataSouce userIconNameForIndexPath:indexPath];
    //has no set image
    assert(userIconPath);
    if([userIconPath isEqualToString:@""])
        return;
    UIImage *userIcon = [[DressMemoUserIconCache getInstance] getImageWithUserIconPath:userIconPath];
	if (userIcon != nil)
	{
		/*
         [cell.photoButton setImage:userIcon forState:UIControlStateNormal];
         [cell.photoButton setNeedsDisplay];
         */
        [iconDelegate setCell:cell withImageData:userIcon withIndexPath:indexPath];
	}
    else
    {
        if (tweetieTableView.dragging == NO && tweetieTableView.decelerating == NO)
        {
            //[self startloadVisibleCellImageData:indexPath];
            [self startDownloadImageUrl:userIconPath withIndexPath:indexPath];
        }
    }
}
#pragma mark
-(void)startloadVisibleCellImageData:(NSIndexPath*)indexPath
{
    //NE_LOG(@"warning load visibleCellImagedata not implementation");
    NSString *userIconPath = [iconDataSouce userIconNameForIndexPath:indexPath];
    assert(userIconPath);
    if([userIconPath isEqualToString:@""])
        return;
#if 1
    UIImage *userIcon = [[DressMemoUserIconCache getInstance] getImageWithUserIconPath:userIconPath];
	if (userIcon != nil)
	{
		/*
        [cell.photoButton setImage:userIcon forState:UIControlStateNormal];
		[cell.photoButton setNeedsDisplay];
        */
        [iconDelegate setCellUserIcon:userIcon withIndexPath:indexPath];
	}
	else
	{
        [self startDownloadImageUrl:userIconPath withIndexPath:indexPath];
	}
#endif
}
-(void)startDownloadImageUrl:(NSString*)imagePath withIndexPath:(NSIndexPath*)indexPath
{
    
    DressMemoUserIconDownloader *downloader = [allIconDownloaders objectForKey:indexPath];
    if (downloader == nil )
    {
        downloader = [[DressMemoUserIconDownloader alloc] initWithUserIconUrl:imagePath indexPath:indexPath];
        [allIconDownloaders setObject:downloader forKey:indexPath];
        downloader.delegate = self;
        [[NTESMBServer getInstance] addRequest:downloader];
        [downloader release];
    }
}
#pragma mark -
#pragma mark RequestDelegate
- (void) requestCompleted:(NTESMBRequest *) request
{
	if([request isKindOfClass:[NESkipPhotoDownloader class]])
    {
		NESkipPhotoDownloader *d = (NESkipPhotoDownloader *)request;
		if(request.receiveData)
        {
			[[NTESMBLocalImageStorage getInstance] saveImageDataToTinyDir:request.receiveData urlString:request.urlString];
		}
		UIImage *image = [UIImage imageWithData:request.receiveData];
		NSIndexPath *indexPath = d.indexPath;
	}
	if ([request isKindOfClass:[DressMemoUserIconDownloader class]])
	{
		DressMemoUserIconDownloader *d = (DressMemoUserIconDownloader *)request;
		
		NSIndexPath *indexPath = d.indexPath;
        if(request.receiveData)
        {
			[[NTESMBLocalImageStorage getInstance] saveImageDataToIconDir:request.receiveData urlString:request.urlString];
		}
        UIImage *image = [UIImage imageWithData:request.receiveData];
        [iconDelegate setCellUserIcon:image withIndexPath:indexPath];
		[allIconDownloaders removeObjectForKey:indexPath];
	}
	//[self updatesegmentTitle:2];
}
- (void) requestFailed:(NTESMBRequest *) request
{
	NTESMBIconDownloader *d = (NTESMBIconDownloader *)request;
	[allIconDownloaders removeObjectForKey:d.indexPath];
}
@end
