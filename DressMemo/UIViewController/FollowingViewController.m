//
//  FollowingViewController.m
//  DressMemo
//
//  Created by  on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FollowingViewController.h"
#import "ZCSNetClientDataMgr.h"
#import "UserConfig.h"
#import "FriendItemCell.h"
#import "DBManage.h"
#import "ZCSNetClient.h"
#import "MyProfileViewController.h"
static DBManage *dbMgr = nil;
@interface FollowingViewController ()
@end

@implementation FollowingViewController
@synthesize itemCount;
@synthesize friendList;
@synthesize headBgView;
- (void)dealloc{
    self.friendList = nil;
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
- (void)loadView
{
    [super loadView];
}
- (void)setEmptyDataUI
{
  
    
    //NSString *defaultBGStr = @"";
    NSString *firstString = @"你关注任何人";
    NSString *secondString = @"点击,";
    NSString *thirdString = @"就可以关注你喜欢的人!";
    NSString *imageFileName = @"icon-info-like.png";// [NSString stringWithFormat:@"%@/icon-info-takephoto.png", [[NSBundle mainBundle]bundlePath]];
    NSString *cssText = @"<style type='text/css'>html,body {margin: 0;padding: 0;width: 100%;height: 100%;}html {display: table;}body {display: table-cell;vertical-align: middle;padding: 20px;text-align: center;-webkit-text-size-adjust: none;}</style>";
    //upload bg image
    UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"textblock.png");
    UIImageView *bgImageView = [[UIImageView alloc ]initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0,(404-40)/2.f,bgImage.size.width/kScale, bgImage.size.height/kScale);
    NE_LOGRECT(bgImageView.frame);
    UIWebView *tWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,bgImageView.frame.size.height)];
	NSString *htmlStr = [NSString stringWithFormat:@"<html><head>%@</head><body><p class=\"className\"><font style=\"font-size:13px;color:#000000\">%@<br/>%@<img src=\"%@\"height=\"24\" width=\"24\"/>%@</p></body></html>",cssText,firstString,secondString,@"icon-info-takephoto.png",thirdString];
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
        [self setNavgationBarTitle:NSLocalizedString(@"My Following", @"")];
      
    }
    else 
    {
        [self setNavgationBarTitle:NSLocalizedString(@"Following", @"")];
    }
    dbMgr = [DBManage getSingleTone];
    
    currentPageNum = 1;
    tweetieTableView.separatorStyle = UITableViewCellAccessoryNone;
#if 1
    [self  shouldLoadOlderData:tweetieTableView];
#else
    
#endif
    self.headBgView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headBgView.backgroundColor = kUserHeadBackGroundColor;
    self.headBgView.frame = CGRectMake(0,(122.f-40.f)/2.f, kDeviceScreenWidth,64.f/2.f);
    
    self.headBgView.titleLabel.textAlignment = UITextAlignmentCenter;
    self.headBgView.enabled = NO;
    [self.view addSubview:self.headBgView];
    
    NSString *headViewTitle = @"";
    if(!self.isVisitOther)
    {
        //[self setNavgationBarTitle:NSLocalizedString(@"My Following", @"")];
        headViewTitle = [NSString stringWithFormat:NSLocalizedString(@"You following %d users", @""),self.itemCount];
        
       
        
    }
    else
    {
         headViewTitle = [NSString stringWithFormat:NSLocalizedString(@"共关注了%d个用户", @""),self.itemCount];
    }
    [self.headBgView setTitle:headViewTitle forState:UIControlStateNormal];
    UIImage *bgImage = nil;
    UIImageWithFileName(bgImage,@"BG-user.png");
    //assert(bgImage);
    mainView.bgImage = bgImage;
    tweetieTableView.hidden = NO;
    tweetieTableView.frame = CGRectMake(0,(122.f-40.f)/2.f+64.f/2.f,kDeviceScreenWidth, kMBAppRealViewHeight-64/2.f);
   
	//[htmlStr release];
	// Do any additional setup after loading the view.
}
- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
//	if ([friendList count]==0)
//    {
//		[self refreshNewData];
//        
//	}
}
- (void)refreshNewData
{
    [self getFollowingUserList];
    
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
#pragma mark -
#pragma mark load data

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
    [self getFollowingUserList];
    //[self getPostMemos];
    //[memoTimelineDataSource getOldData];
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    static NSString *CellIdentifier = @"FriendCell";
    
    FriendItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [FriendItemCell getFromNibFile];
    }
	//cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    [self setItemCell:cell withIndex:indexPath];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 124.f/2.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    NSDictionary *itemData= [self.dataArray objectAtIndex:indexPath.row];
    if([[itemData objectForKey:@"uid"] isEqualToString:[AppSetting getLoginUserId]])
    {
        return;
    }
    MyProfileViewController *userProfileVc = [[MyProfileViewController alloc]init];
    userProfileVc.userId = [itemData objectForKey:@"uid"];
    userProfileVc.userData = itemData;
    userProfileVc.isVisitOther = YES;
    assert(userProfileVc.userId);
    [self.navigationController pushViewController:userProfileVc animated:YES];
    [userProfileVc release];
    
}
-(void)setItemCell:(FriendItemCell*)cell  withIndex:(NSIndexPath*)indexPath
{
    NSDictionary *itemData = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.nickNameLabel.text = [itemData objectForKey:@"uname"];
    cell.locationLabel.text = [itemData objectForKey:@"city"];
    NSString *iconUrl = [itemData objectForKey:@"avatar"];
    if(iconUrl == nil||[iconUrl isEqualToString:@""])
    {
        [cell.userIconImageView setImage:[dbMgr getItemCellUserIconImageDefault]];
    }
    if(!self.isVisitOther)
    {
        NSString *followTag = [itemData objectForKey:@"status"];
        UIImage *bgImage = nil;
        int relationTag = [followTag intValue];
        if([followTag isEqualToString:@"1"])//followed
        {
            
            UIImageWithFileName(bgImage, @"btn-followedS.png");
            [cell.relationBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
            //cell.relationBtn.tag = relationTag
        }
        if([followTag isEqualToString:@"0"])
        {
            UIImageWithFileName(bgImage, @"btn-followS.png");
            [cell.relationBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
        }
        cell.relationBtn.tag = relationTag;
        cell.relationBtn.rowIndex = indexPath.row;
        [cell.relationBtn addTarget:self action:@selector(relationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    }

}
#pragma mark follow and unfollow user action
-(void)relationButtonAction:(id)sender{

    switch ([sender tag]) {
        case 1:
            [self unfollowUserAction:sender];
            break;
        case 0:
            [self followUserAction:sender];
            break;
        default:
            break;
    }


}
-(void)unfollowUserAction:(id)sender
{   
    int rowIndex = [sender rowIndex];
    NSDictionary *itemData = [self.dataArray objectAtIndex:rowIndex];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [itemData objectForKey:@"uid"] ,@"fuid",
                           nil];
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    ZCSNetClient  *request = [netMgr unfollowUser:param];
    //NSString *stringIndexRow = [NSString stringWithFormat:@"%d",[sender tag]];
    request.inputParam = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSIndexPath indexPathForRow:rowIndex inSection:0],@"rowIndex",
                          itemData ,@"rowData",
                          nil];
    [sender startNetActive];
    //[self.requestDict setValue:request forKey:stringIndexRow]; 
}
-(void)followUserAction:(id)sender
{
    int rowIndex = [sender rowIndex];
    NSDictionary *itemData = [self.dataArray objectAtIndex:rowIndex];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [itemData objectForKey:@"uid"] ,@"fuid",
                           nil];
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
   // [self.requestDict setValue:[netMgr followUser:param] forKey:[NSString stringWithFormat:@"%d",[sender tag]]]; 
    ZCSNetClient  *request = [netMgr followUser:param];
    //NSString *stringIndexRow = [NSString stringWithFormat:@"%d",[sender tag]];
    request.inputParam = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSIndexPath indexPathForRow:rowIndex inSection:0],@"rowIndex",
                          itemData,@"rowData",
                          nil];

    [sender startNetActive];
    //[sender startNetActive];
}
#pragma mark -
#pragma mark net work 
-(void)getFollowingUserList
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
    self.request = [netMgr getFollowingUserList:param];
    
}
-(void)didNetDataOK:(NSNotification*)ntf
{
    id obj = [ntf object];
    id respRequest = [obj objectForKey:@"request"];
    id data = [obj objectForKey:@"data"];
    NSString *resKey = [respRequest resourceKey];
    if(self.request == respRequest)
    {
        [self stopShowLoadingView];
        [self processReturnData:data];
        currentPageNum++;
        [self reloadAllData];
        
    }
    if([resKey isEqualToString:@"dofollow"])
    {
        NSDictionary *inputData = [respRequest inputParam];
        if(inputData)
        {
            NSIndexPath *indexPath = [inputData objectForKey:@"rowIndex"];
            NSDictionary *data = [inputData objectForKey:@"rowData"];
            [data setValue:@"1" forKey:@"status"];
            FriendItemCell *cell = [tweetieTableView  cellForRowAtIndexPath:indexPath];
            cell.relationBtn.tag = 1;
            UIImage *bgImage = nil;
            UIImageWithFileName(bgImage, @"btn-followedS.png");
            [self setItemCell:cell withImage:bgImage withActive:NO];
        }
    }
    if([resKey isEqualToString:@"docancel"])
    {
        NSDictionary *inputData = [respRequest inputParam];
        if(inputData)
        {
            NSIndexPath *indexPath = [inputData objectForKey:@"rowIndex"];
            NSDictionary *data = [inputData objectForKey:@"rowData"];
            [data setValue:@"0" forKey:@"status"];
            
            FriendItemCell *cell = [tweetieTableView  cellForRowAtIndexPath:indexPath];
            cell.relationBtn.tag  = 0;
            UIImage *bgImage = nil;
            UIImageWithFileName(bgImage, @"btn-followS.png");
            [self setItemCell:cell withImage:bgImage withActive:NO];
        }
    }
    
}
-(void)setItemCell:(FriendItemCell*)cell withImage:(UIImage*)bgImage withActive:(BOOL)activeTag
{
    [cell.relationBtn setImage:bgImage forState:UIControlStateNormal];
    if(activeTag)
    {   
        [cell.relationBtn startNetActive];
    }
    else {
        [cell.relationBtn stopNetActive];
    }
}
/*
 *{"memoid":"101","uid":"2","addtime":"1343109729","emotionid":"2","occasionid":"1","countryid":"1","location":"kkk","picid":"289","picpath":"\/memo\/2012\/07\/24\/20120724140209_6mSq_e955570c.jpg","isrecommend":"0"}
 */
-(void)processReturnData:(id)data
{
   /*
    NSArray *addData = nil;
    if([data isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *result = [data objectForKey:@"results"];
        addData = [result allValues];
    }
    else if([data isKindOfClass:[NSArray class]])
    {
        addData = data;
    }
    [self.dataArray addObjectsFromArray:addData]; 
    */
    [super processReturnData:data];
}
-(void)didNetDataFailed:(NSNotification*)ntf
{
    id obj = [ntf object];
    ZCSNetClient *respRequest = [obj objectForKey:@"request"];
    /*
     id data = [obj objectForKey:@"data"];
    */
     NSString *resKey = [respRequest resourceKey];
   
    if(respRequest.followRequest == self.request||self.request == respRequest)
    {
        [self stopShowLoadingView];
    }
    if([resKey isEqualToString:@"dofollow"]||[resKey isEqualToString:@"docancel"])
    {
    
        NSDictionary *inputData = [respRequest inputParam];
        if(inputData)
        {
            NSIndexPath *indexPath = [inputData objectForKey:@"rowIndex"];
            
            FriendItemCell *cell = [tweetieTableView  cellForRowAtIndexPath:indexPath];
            [cell.relationBtn stopNetActive];
        }
    }
    //
    //NE_LOG(@"warning not implemetation net respond");
}
@end
