//
//  FollowedViewController.m
//  DressMemo
//
//  Created by  on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FollowedViewController.h"
#import "ZCSNetClientDataMgr.h"
#import "UserConfig.h"
@interface FollowedViewController ()

@end

@implementation FollowedViewController
@synthesize request;

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
    NSString *firstString = @"暂时还没有人关注您";
    NSString *secondString = @"";
    NSString *thirdString = @"多上传穿着可以提升人气哦";
//NSString *imageFileName = nil;//[NSString stringWithFormat:@"%@/icon-info-takephoto.png", [[NSBundle mainBundle]bundlePath]];
    NSString *cssText = @"<style type='text/css'>html,body {margin: 0;padding: 0;width: 100%;height: 100%;}html {display: table;}body {display: table-cell;vertical-align: middle;padding: 20px;text-align: center;-webkit-text-size-adjust: none;}</style>";
    //upload bg image
    UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"textblock.png");
    UIImageView *bgImageView = [[UIImageView alloc ]initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0,(404-40)/2.f,bgImage.size.width/kScale, bgImage.size.height/kScale);
    NE_LOGRECT(bgImageView.frame);
    UIWebView *tWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,bgImageView.frame.size.height)];
	NSString *htmlStr = [NSString stringWithFormat:@"<html><head>%@</head><body><p class=\"className\"><font style=\"font-size:13px;color:#000000\">%@<br/>%@%@</p></body></html>",cssText,firstString,secondString,thirdString];
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
    if(!self.isVisitOther)
    {
        [self setNavgationBarTitle:NSLocalizedString(@"My Followed", @"")];
        
    }
    else
    {
        [self setNavgationBarTitle:NSLocalizedString(@"Followed", @"")];
        [self setRightBtnEnable:NO];
    }
    
    NSString *headViewTitle = @"";
    if(!self.isVisitOther)
    {
        //[self setNavgationBarTitle:NSLocalizedString(@"My Following", @"")];
        headViewTitle = [NSString stringWithFormat:NSLocalizedString(@"You have %d followed", @""),self.itemCount];
        
    }
    else
    {
        headViewTitle = [NSString stringWithFormat:NSLocalizedString(@"共%d个粉丝", @""),self.itemCount];
    }
    
    [self.headBgView setTitle:headViewTitle forState:UIControlStateNormal];
  
#if 0  
    tweetieTableView.frame = CGRectOffset(tweetieTableView.frame, 0.,(123.f+64.f-40.f-88.f)/2.f);
    tweetieTableView.hidden = NO;
#endif
    //[self  shouldLoadOlderData:tweetieTableView];
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
- (void) shouldLoadNewerData:(NTESMBTweetieTableView *) tweetieTableView
{
    NSLog(@"loader new data");
    //    if(isRefreshing)
    //        return;
}
#pragma mark reflush data
- (void)shouldLoadOlderData:(NTESMBTweetieTableView *) tweetieTableView
{
#if 0 
    if(isRefreshing)
        return;
#endif  
    NSLog(@"loader old data");
    [self startShowLoadingView];
    [self getFollowedUserList];
    //[self getFollowingUserList];
    //[self getPostMemos];
    //[memoTimelineDataSource getOldData];
}
-(void)getFollowedUserList
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
    //self.request = [netMgr getFollowingUserList:param];
    self.request = [netMgr getFollowedUserList:param];
    
}
@end
