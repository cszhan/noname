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

#define kItemCellCount 3

@interface DressMemoViewController ()

@end

@implementation DressMemoViewController
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
    [self  shouldLoadOlderData:tweetieTableView];
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
#pragma mark -
#pragma mark image download
-(void)startloadVisibleCellImageData:(NSIndexPath*)path
{
    if([self.dataArray count]<=path.row)
    {
        return ;
    }

}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.dataArray count]/kItemCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [MemoImageItemCell getFromNibFile];
    }
	//cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 134.f;
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
/*
 *{"memoid":"101","uid":"2","addtime":"1343109729","emotionid":"2","occasionid":"1","countryid":"1","location":"kkk","picid":"289","picpath":"\/memo\/2012\/07\/24\/20120724140209_6mSq_e955570c.jpg","isrecommend":"0"}
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
