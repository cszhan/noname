//
//  DressMemoViewController.m
//  DressMemo
//
//  Created by  on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DressMemoViewController.h"
#import "ZCSNetClientDataMgr.h"

#import "MemoImageItemCell.h"
#import "DressMemoDetailNetViewController.h"
#import "AppSetting.h"


@interface DressMemoViewController ()
@property(nonatomic,assign)NSInteger cellEmptyCount;
@property(nonatomic,assign)BOOL isUserLoginStatus;
@end

@implementation DressMemoViewController
@synthesize request;
@synthesize cellEmptyCount;
@synthesize isNeedReflsh;
@synthesize isUserLoginStatus;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        isUserLoginStatus = [AppSetting getUserLoginStatus];
    }
    return self;
}
- (void)setEmptyDataUI
{
    
    
    //NSString *defaultBGStr = @"";
    NSString *firstString = @"你还没有上传任何穿着哦";
    NSString *secondString = @"点击,";
    NSString *thirdString = @"现在就去上传吧";
    NSString *imageFileName = @"icon-info-takephoto.png";//[NSString stringWithFormat:@"%@/icon-info-takephoto.png", [[NSBundle mainBundle]bundlePath]];
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
    UIImage *bgImage = nil;
    UIImageWithFileName(bgImage,@"BG.png");
    //assert(bgImage);
    mainView.bgImage = bgImage;
    currentPageNum = 1;
    if(!self.isVisitOther)
        [self setNavgationBarTitle:NSLocalizedString(@"My Dress", @""
                                               )];
    else 
    {
        [self setNavgationBarTitle:NSLocalizedString(@"Dress", @""
                                                     )];
    }
    tweetieTableView.separatorStyle = UITableViewCellAccessoryNone;
    NSString *loginUserId = [AppSetting getLoginUserId];
    if(loginUserId&&![loginUserId isEqualToString:@""]&&!isFromViewUnload&&isUserLoginStatus)
    {
        [self  shouldLoadOlderData:tweetieTableView];
        
    }
	// Do any additional setup after loading the view.
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];

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
#pragma mark cell image data source
-(NSString*)userIconNameForIndexPath:(NSIndexPath*)indexPath
{
    NSString *iconImageName = @"";
    int index = indexPath.section*kItemCellCount+indexPath.row;
    NSLog(@"cell Item Index:%d",index);
    if([self.dataArray count]>index)
    {
        id cellItem = [self.dataArray objectAtIndex:index];
        iconImageName = [cellItem objectForKey:@"picpath"];
    }
    return iconImageName;
}
-(void)startuserCustomLoadCellImageData:(NSIndexPath*)indexPath
{
    for(int i = 0;i<kItemCellCount;i++)
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:indexPath.row];
        [super didStartLoadCellImageData:index];
    }
    
}
-(void)setCellUserIcon:(UIImage*)iconImage withIndexPath:(NSIndexPath*)indexPath
{
    //NSString *iconUrl = [itemData objectForKey:@"avatar"];
    //if(iconUrl == nil||[iconUrl isEqualToString:@""])
    int row = indexPath.section;
    int subIndex = indexPath.row;
    int realIndex = row*kItemCellCount+subIndex;
    NSIndexPath *realIndexPath  = [NSIndexPath indexPathForRow:row inSection:0];
    MemoImageItemCell *cell = (MemoImageItemCell*)[tweetieTableView cellForRowAtIndexPath:realIndexPath];
    NSDictionary *itemData = [self.dataArray objectAtIndex:realIndex];
    NSString *timeStr = [itemData objectForKey:@"addtime"];
    NSDate  *postTime = [NSDate  dateWithTimeIntervalSince1970:[timeStr longLongValue]];
    
    NSString *displayTimeStr = [postTime getDressMemoImageTimeString];
    if(iconImage)
    {
        [cell  setCellItem:iconImage withTime:displayTimeStr withIndex:subIndex];
        //[cell.userIconImageView setNeedsDisplay];
    }
}
-(void)setCell:(id)cell withImageData:(UIImage*)imageData withIndexPath:(NSIndexPath*)indexPath
{
    
    int row = indexPath.section;
    int subIndex = indexPath.row;
    int realIndex = row*kItemCellCount+subIndex;
    NSDictionary *itemData = [self.dataArray objectAtIndex:realIndex];
    NSString *timeStr = [itemData objectForKey:@"addtime"];
    NSDate  *postTime = [NSDate  dateWithTimeIntervalSince1970:[timeStr longLongValue]];
    NSString *displayTimeStr = [postTime getDressMemoImageTimeString];
    if(imageData)
    {
        [cell  setCellItem:imageData withTime:displayTimeStr withIndex:subIndex];
        //[cell.userIconImageView setNeedsDisplay];
    }
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int row = [self.dataArray count]/kItemCellCount;
    self.cellEmptyCount = [self.dataArray count]%kItemCellCount;
    if([self.dataArray count]%kItemCellCount == 0)
    {
        return row;
    }
    else
    {
        return row +1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    static NSString *CellIdentifier = @"Cell";
    
    MemoImageItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [MemoImageItemCell getFromNibFile];
        
    }
    cell.delegate = self;
    if(indexPath.row ==([self.dataArray count]/kItemCellCount)&&self.cellEmptyCount)
    {
        [cell showCellItemWithNum:self.cellEmptyCount];
        for(int i = 0;i<self.cellEmptyCount;i++)
        {
            //use row as section
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:indexPath.row];
            [self startloadInitCell:cell withIndexPath:index];
        }
    }
    else
    {
        NSLog(@"count:%d,row=%d",[self.dataArray count],indexPath.row);
        [cell showCellItemWithNum:kItemCellCount];
        for(int i = 0;i<kItemCellCount;i++)
        {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:indexPath.row];
            [self startloadInitCell:cell withIndexPath:index];
        }
    }
    //cell
	//cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 134.f;
}
#pragma mark 
-(void)didTouchItemCell:(id)cell subItem:(id)sender
{
    int dataIndex = -1;
    if([cell isKindOfClass:[MemoImageItemCell class]])
    {
        MemoImageItemCell *targetCellItem = (MemoImageItemCell*)cell;
        dataIndex = targetCellItem.indexPath.row*kItemCellCount+[sender tag];
    }
    NSDictionary *cellData = [self.dataArray objectAtIndex:dataIndex];
    NSLog(@"cell data:%@",[cellData description]);
    
    DressMemoDetailNetViewController * dressMemoVc = [[DressMemoDetailNetViewController alloc]init];
    dressMemoVc.data = cellData;
    [self.navigationController pushViewController:dressMemoVc animated:YES];
    [dressMemoVc release];
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
    [self getPostMemos];
    //[memoTimelineDataSource getOldData];
}
#pragma mark net 
- (void)getPostMemos
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
    self.request = [netMgr getPostMemos:param];
    isRefreshing = YES;
}
#pragma mark -reflush 
-(void)didNetDataOK:(NSNotification*)ntf
{
    //kNetEnd(self.view);
    //NE_LOG(@"warning not implemetation net respond");
    //self.view.userInteractionEnabled = YES;
    
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
}
-(void)didUserLogin:(NSNotification*)ntf
{
    isNeedReflsh = YES;
    [self performSelectorOnMainThread:@selector(shouldLoadOlderData:) withObject:nil waitUntilDone:NO];
}
-(void)test{

}

/*{"memoid":"101","uid":"2","addtime":"1343109729","emotionid":"2","occasionid":"1","countryid":"1","location":"kkk","picid":"289","picpath":"\/memo\/2012\/07\/24\/20120724140209_6mSq_e955570c.jpg","isrecommend":"0"}
 */
//-(void)processReturnData:(id)data
//{
////    NSArray *addData = nil;
////    if([data isKindOfClass:[NSDictionary class]])
////    {
////        NSDictionary *result = [data objectForKey:@"results"];
////        addData = [result allValues];
////    }
////    else if([data isKindOfClass:[NSArray class]])
////    {
////        addData = data;
////    }
////    [self.dataArray addObjectsFromArray:addData]; 
//    [super processReturnData:data];
//
//}
-(void)didNetDataFailed:(NSNotification*)ntf
{
    id obj = [ntf object];
    id respRequest = [obj objectForKey:@"request"];
    /*
    id data = [obj objectForKey:@"data"];
    NSString *resKey = [respRequest resourceKey];
    */
    if(self.request == respRequest)
    {
        [self stopShowLoadingView];
    }
    //
    //NE_LOG(@"warning not implemetation net respond");
}
@end
