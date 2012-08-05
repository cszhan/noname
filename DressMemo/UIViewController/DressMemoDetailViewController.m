//
//  DressMemoDetailViewController.m
//  DressMemo
//
//  Created by cszhan on 12-8-1.
//
//

#import "DressMemoDetailViewController.h"
#import "ZCSNetClientDataMgr.h"
#import "ZCSNetClient.h"
#import "MemoLikeUserViewController.h"
@interface DressMemoDetailViewController ()

@end

@implementation DressMemoDetailViewController

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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"喜欢" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20.f, 100.f, 80.f, 40.f);
    btn.tag  = 0;
    [btn addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
   

    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //btn.titleLabel.text = @"不喜欢";
      [btn setTitle:@"不喜欢" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20.f, 100.f+60.f*1, 80.f, 40.f);
    btn.tag  = 1;
    [btn addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //btn.titleLabel.text = @"不喜欢";
    [btn setTitle:@"添加评论" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20.f, 100.f+60.f*2, 80.f, 40.f);
    btn.tag  = 1;
    [btn addTarget:self action:@selector(addMemoComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //btn.titleLabel.text = @"不喜欢";
    [btn setTitle:@"回复评论" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20.f, 100.f+60.f*3, 80.f, 40.f);
    btn.tag  = 1;
    [btn addTarget:self action:@selector(addCommentReply) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //btn.titleLabel.text = @"不喜欢";
    [btn setTitle:@"喜欢人的列表" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20.f, 100.f+60.f*4, 80.f, 40.f);
    btn.tag  = 1;
    [btn addTarget:self action:@selector(likeMemoUserList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    //[self getFavMemoUsers];
    [self getMemoDetail];
    [self getMemoComments];
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
-(void)didTouchBtn:(id)sender
{
    switch ([sender tag])
    {
        case 0:
            [self doFavorMemoAction];
            break;
        case 1:
            [self unDoFavorMemoAction];
            break;
        default:
            break;
    }
}
#pragma mark -
#pragma mark network
/*
 * 
 @"/comment/addcomment",@"addcomment",
 @"/comment/addreply",@"addreply",
 @"/comment/getmemocomments",@"getmemocomments",
 */

-(void)doFavorMemoAction
{
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [self.data objectForKey:@"memoid"] ,@"memoid",
                                  nil];
    self.request = [netMgr doFavorMemo:param];


}
-(void)unDoFavorMemoAction
{

    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [self.data objectForKey:@"memoid"] ,@"memoid",
                                  nil];
    self.request = [netMgr unDoFavorMemo:param];
    
}
-(void)getMemoDetail
{
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [self.data objectForKey:@"memoid"] ,@"memoid",
                                  nil];
    self.request = [netMgr getMemoDetail:param];

}
-(void)addMemoComment
{
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    NSString *contentText = @"这个是一个测试评论，哈哈！！";
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [self.data objectForKey:@"memoid"] ,@"memoid",
                                  contentText,@"comment",
                                  nil];
    self.request = [netMgr addMemoComment:param];

}
-(void)addCommentReply
{

    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    NSString *contentText = @"这个是一个回复评论测试，哈哈！！";
    NSString *replyId = @"6";
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  replyId ,@"commentid",
                                  contentText,@"comment",
                                  nil];
    self.request = [netMgr addCommentReply:param];
}
-(void)likeMemoUserList:(id)sender
{
    MemoLikeUserViewController *memoLikeUserVc = [[MemoLikeUserViewController alloc]init];
    memoLikeUserVc.data = self.data;
    [self.navigationController pushViewController:memoLikeUserVc animated:YES];
    [memoLikeUserVc release];
}
#pragma mark net list data
-(void)getMemoComments
{
    //ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    
    NSString *pageNumStr = [NSString stringWithFormat:@"%d",currentPageNum];
    
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  pageNumStr    ,@"pageno",
                                  @"15",@"pagesize",
                                  [self.data objectForKey:@"memoid"] ,@"memoid",
                                  nil];
    self.request = [netMgr getMemoComments:param];
    
    
}
#pragma mark net respond
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
    if([resKey isEqualToString:@"dofavorCancel"])
    {
       /*
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
       */
    }
    if([resKey isEqualToString:@"dofavor"])
    {
//        NSDictionary *inputData = [respRequest inputParam];
//        if(inputData)
//        {
//            NSIndexPath *indexPath = [inputData objectForKey:@"rowIndex"];
//            NSDictionary *data = [inputData objectForKey:@"rowData"];
//            [data setValue:@"0" forKey:@"status"];
//            
//            FriendItemCell *cell = [tweetieTableView  cellForRowAtIndexPath:indexPath];
//            cell.relationBtn.tag  = 0;
//            UIImage *bgImage = nil;
//            UIImageWithFileName(bgImage, @"btn-followS.png");
//            [self setItemCell:cell withImage:bgImage withActive:NO];
//        }
    }
    
}
-(void)setItemCell:(id)cell withImage:(UIImage*)bgImage withActive:(BOOL)activeTag
{
//    [cell.relationBtn setImage:bgImage forState:UIControlStateNormal];
//    if(activeTag)
//    {
//        [cell.relationBtn startNetActive];
//    }
//    else {
//        [cell.relationBtn stopNetActive];
//    }
    
}
/*
 comment type:
 {
 "commentid":"7",
 "comment":"这个是一个测试评论，哈哈！！",
 "memoid":"103",
 "addtime":"1344089288",
 "uid":"6",
 "uname":"kkzhan",
 "replyid":"0",
 "ruid":"0",
 "runame":""
 },
 reply comment type:
 
 "8":
 {
 "commentid":"8",
 "comment":"这个是一个回复评论测试，哈哈！！",
 "memoid":"103",
 "addtime":"1344090765",
 "uid":"6",
 "uname":"kkzhan",
 "replyid":"6",
 "ruid":"2",
 "runame":"cszhan"
 }
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
        
        /*
        NSDictionary *inputData = [respRequest inputParam];
        if(inputData)
        {
            NSIndexPath *indexPath = [inputData objectForKey:@"rowIndex"];
            
            FriendItemCell *cell = [tweetieTableView  cellForRowAtIndexPath:indexPath];
            [cell.relationBtn stopNetActive];
        }
        */
    }
    //
    //NE_LOG(@"warning not implemetation net respond");
}
@end
