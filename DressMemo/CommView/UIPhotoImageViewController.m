//
//  UIPhotoImageViewController.m
//  DressMemo
//
//  Created by cszhan on 12-8-7.
//
//

#import "UIPhotoImageViewController.h"
#import "DressMemoPhotoCache.h"
#import "MemoPhotoDownloader.h"
@interface UIPhotoImageViewController ()

@end

@implementation UIPhotoImageViewController
-(void)dealloc
{
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
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
    NSString *userIconPath = [self.iconDataSouce userIconNameForIndexPath:indexPath];
    //has no set image
    assert(userIconPath);
    if([userIconPath isEqualToString:@""])
        return;
    UIImage *userIcon = [[DressMemoPhotoCache getInstance] getImageWithTinyImagePath:userIconPath];
	if (userIcon != nil)
	{
		/*
         [cell.photoButton setImage:userIcon forState:UIControlStateNormal];
         [cell.photoButton setNeedsDisplay];
         */
        [self.iconDelegate setCell:cell withImageData:userIcon withIndexPath:indexPath];
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
-(void)startuserCustomLoadCellImageData:(NSIndexPath*)indexPath
{
    NSLog(@"warning not implement the cust loade cell image data");
    [self didStartLoadCellImageData:indexPath];
}
#pragma mark
-(void)startloadVisibleCellImageData:(NSIndexPath*)indexPath
{
    //NE_LOG(@"warning load visibleCellImagedata not implementation");
    [self startuserCustomLoadCellImageData:(NSIndexPath*)indexPath];
}

-(void)didStartLoadCellImageData:(NSIndexPath*)indexPath
{
    NSString *userIconPath = [self.iconDataSouce userIconNameForIndexPath:indexPath];
    assert(userIconPath);
    if([userIconPath isEqualToString:@""])
        return;
#if 1
    UIImage *userIcon = [[DressMemoPhotoCache getInstance] getImageWithTinyImagePath:userIconPath];
	if (userIcon != nil)
	{
		/*
         [cell.photoButton setImage:userIcon forState:UIControlStateNormal];
         [cell.photoButton setNeedsDisplay];
         */
        [self.iconDelegate setCellUserIcon:userIcon withIndexPath:indexPath];
	}
	else
	{
        [self startDownloadImageUrl:userIconPath withIndexPath:indexPath];
	}
#endif
    
}
-(void)startDownloadImageUrl:(NSString*)imagePath withIndexPath:(NSIndexPath*)indexPath
{
    
    MemoPhotoDownloader *downloader = [allIconDownloaders objectForKey:indexPath];
    if (downloader == nil )
    {
        downloader = [[MemoPhotoDownloader alloc] initWithUserIconUrl:imagePath indexPath:indexPath];
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
	if([request isKindOfClass:[MemoPhotoDownloader class]])
    {
		MemoPhotoDownloader *d = (MemoPhotoDownloader *)request;
		if(request.receiveData)
        {
			[[NTESMBLocalImageStorage getInstance] saveImageDataToTinyDir:request.receiveData urlString:request.urlString];
		}
		NSIndexPath *indexPath = d.indexPath;
        if(request.receiveData)
        {
			[[NTESMBLocalImageStorage getInstance] saveImageDataToIconDir:request.receiveData urlString:request.urlString];
		}
        UIImage *image = [UIImage imageWithData:request.receiveData];
        [self.iconDelegate setCellUserIcon:image withIndexPath:indexPath];
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
