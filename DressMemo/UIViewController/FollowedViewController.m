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
    
    NSString *headViewTitle = [NSString stringWithFormat:NSLocalizedString(@"You have %d followed", @""),self.itemCount];
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
