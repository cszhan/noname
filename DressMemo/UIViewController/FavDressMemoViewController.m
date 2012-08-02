//
//  FavDressMemoViewController.m
//  DressMemo
//
//  Created by  on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FavDressMemoViewController.h"
#import "ZCSNetClientDataMgr.h"
@interface FavDressMemoViewController ()

@end

@implementation FavDressMemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setEmptyDataUI
{
    //NSString *defaultBGStr = @"";
    NSString *firstString = @"你还没有收藏任何穿着哦";
    NSString *secondString = @"点击,";
    NSString *thirdString = @"就可以收藏你喜欢的穿着!";
    NSString *imageFileName = @"icon-info-like.png";
    //[NSString stringWithFormat:@"%@/icon-info-takephoto.png", [[NSBundle mainBundle]bundlePath]];
    NSString *cssText = @"<style type='text/css'>html,body {margin: 0;padding: 0;width: 100%;height: 100%;}html {display: table;}body {display: table-cell;vertical-align: middle;padding: 20px;text-align: center;-webkit-text-size-adjust: none;}</style>";
    //upload bg image
    UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"textblock.png");
    UIImageView *bgImageView = [[UIImageView alloc ]initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0,(404-40)/2.f,bgImage.size.width/kScale, bgImage.size.height/kScale);
    NE_LOGRECT(bgImageView.frame);
    UIWebView *tWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,bgImageView.frame.size.height)];
	NSString *htmlStr = [NSString stringWithFormat:@"<html><head>%@</head><body><p class=\"className\"><font style=\"font-size:13px;color:#ffffff\">%@<br/>%@<img src=\"%@\"height=\"24\" width=\"24\"/>%@</p></body></html>",cssText,firstString,secondString,imageFileName,thirdString];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
	tWebView.backgroundColor = [UIColor clearColor];
	[tWebView loadHTMLString:htmlStr baseURL:baseURL];
	for (id subview in tWebView.subviews)
    {
		if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
			((UIScrollView *)subview).bounces = NO;
			((UIScrollView *)subview).scrollEnabled= NO;
		}
	}
	tWebView.opaque = NO;
	
    [bgImageView addSubview:tWebView];
    [tWebView release];
    [mainView addSubview:bgImageView];
    [bgImageView release];
    self.myEmptyBgView = bgImageView;
    self.myEmptyBgView.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *bgImage = nil;
    UIImageWithFileName(bgImage,@"BG.png");
    //assert(bgImage);
    mainView.bgImage = bgImage;
    if(!self.isVisitOther)
        [self setNavgationBarTitle:NSLocalizedString(@"My Favarator", @""
                                                     )];
    else 
    {
        [self setNavgationBarTitle:NSLocalizedString(@"Favarator", @""
                                                     )];
    }
    tweetieTableView.separatorStyle = UITableViewCellAccessoryNone;
#if 1
    [self  shouldLoadOlderData:tweetieTableView];
#else
    self.myEmptyBgView.hidden = NO;
#endif
    //[self getMyFavMemos];
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


#pragma mark start get data
- (void) shouldLoadNewerData:(NTESMBTweetieTableView *) tweetieTableView
{
    NSLog(@"loader new data");
    //    if(isRefreshing)
    //        return;
}

- (void)shouldLoadOlderData:(NTESMBTweetieTableView *) tweetieTableView
{
#if 0 
    if(isRefreshing)
        return;
#endif  
    NSLog(@"loader old data");
    [self startShowLoadingView];
    [self getMyFavMemos];
    //[memoTimelineDataSource getOldData];
}
/*
 *Pageno
 pagesize
 */

-(void)getMyFavMemos
{
    NSString *pageNumStr = [NSString stringWithFormat:@"%d",currentPageNum];
    
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  pageNumStr    ,@"pageno",
                                  @"15",@"pagesize",
                                  nil];
    if(self.isVisitOther)
    {
        
        [param setValue:self.userId forKey:@"uid"];
    }
    if(self.isVisitOther)
    {
        
        [param setValue:self.userId forKey:@"uid"];
    }
   self.request =  [netMgr getFavMemos:param];
}
@end
