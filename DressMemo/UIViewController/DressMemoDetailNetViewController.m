//
//  DressMemoDetailViewController.m
//  DressMemo
//
//  Created by cszhan on 12-8-1.
//
//

#import "DressMemoDetailNetViewController.h"
#import "ZCSNetClientDataMgr.h"
#import "ZCSNetClient.h"
#import "MemoLikeUserViewController.h"
#import "DressMemoDetailDataModel.h"
@interface DressMemoDetailNetViewController ()
@property(nonatomic,assign)ZCSNetClient *dofavorRequest;
@property(nonatomic,assign)ZCSNetClient *unDofavorRequest;
@property(nonatomic,assign)ZCSNetClient *getMemoDetailRequest;

@end

@implementation DressMemoDetailNetViewController
@synthesize dofavorRequest;
@synthesize unDofavorRequest;
@synthesize getMemoDetailRequest;
@synthesize memoDetailData;
- (void)dealloc
{
    self.memoDetailData = nil;
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
//    [super viewDidLoad];
//    
//    
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btn setTitle:@"喜欢" forState:UIControlStateNormal];
//    btn.frame = CGRectMake(20.f, 100.f, 80.f, 40.f);
//    btn.tag  = 0;
//    [btn addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//   
//
//    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    //btn.titleLabel.text = @"不喜欢";
//      [btn setTitle:@"不喜欢" forState:UIControlStateNormal];
//    btn.frame = CGRectMake(20.f, 100.f+60.f*1, 80.f, 40.f);
//    btn.tag  = 1;
//    [btn addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchUpInside];
//     [self.view addSubview:btn];
//    
//    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    //btn.titleLabel.text = @"不喜欢";
//    [btn setTitle:@"添加评论" forState:UIControlStateNormal];
//    btn.frame = CGRectMake(20.f, 100.f+60.f*2, 80.f, 40.f);
//    btn.tag  = 1;
//    [btn addTarget:self action:@selector(addMemoComment) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    
//    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    //btn.titleLabel.text = @"不喜欢";
//    [btn setTitle:@"回复评论" forState:UIControlStateNormal];
//    btn.frame = CGRectMake(20.f, 100.f+60.f*3, 80.f, 40.f);
//    btn.tag  = 1;
//    [btn addTarget:self action:@selector(addCommentReply) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    
//    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    //btn.titleLabel.text = @"不喜欢";
//    [btn setTitle:@"喜欢人的列表" forState:UIControlStateNormal];
//    btn.frame = CGRectMake(20.f, 100.f+60.f*4, 80.f, 40.f);
//    btn.tag  = 1;
//    [btn addTarget:self action:@selector(likeMemoUserList:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
    [self getMemoDetail];
    [self getMemoComments];
    //[self getFavMemoUsers];
   
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
    self.dofavorRequest = [netMgr doFavorMemo:param];


}
-(void)unDoFavorMemoAction
{

    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [self.data objectForKey:@"memoid"] ,@"memoid",
                                  nil];
    self.unDofavorRequest = [netMgr unDoFavorMemo:param];
    
}
-(void)getMemoDetail
{
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [self.data objectForKey:@"memoid"] ,@"memoid",
                                  nil];
    self.getMemoDetailRequest = [netMgr getMemoDetail:param];

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
    //the dofavorCancel
    if(self.dofavorRequest == respRequest &&[resKey isEqualToString:@"dofavorCancel"])
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
    if(self.unDofavorRequest == respRequest &&[resKey isEqualToString:@"dofavor"])
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
    if(self.getMemoDetailRequest == respRequest)
    {
        [self performSelectorInBackground:@selector(parserMemoDetailToModel:) withObject:data];

    }
    
}
/*
 *memo detail data
 {
 "ret":"success",
 "code":"200",
 "info":{
 "memoid":"103",
 "uid":"2",
 "addtime":"1343751316",
 "emotionid":"41",
 "occasionid":"20",
 "prov":"0",
 "city":"0",
 "location":"",
 "picid":"292",
 "picpath":"/memo/2012/08/01/20120801001516_jbLU_3daabfa0.jpg",
 "isrecommend":"0",
 "favornum":"1",
 "commentnum":"4",
 "user":{
 "uid":"2",
 "uname":"cszhan",
 "avatar":"/avatar/20120803152024_lY52_ebe8dd2f.png"
 },
 "pic":{
 "292":{
 "picid":"292",
 "memoid":"103",
 "uid":"2",
 "addtime":"1343751316",
 "path":"/memo/2012/08/01/20120801001516_jbLU_3daabfa0.jpg",
 "tags":[
 {
 "picid":"292",
 "tagid":"429",
 "catid":"103",
 "brandid":"31",
 "x":"56995",
 "y":"8154"
 }
 ]
 }
 }
 }
 }
 
 */
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
    //[super processReturnData:data];
    [self performSelectorInBackground:@selector(parserCommentJsonDataToTargetModel:) withObject:data];
}
#pragma mark parser comment list
-(void)parserCommentJsonDataToTargetModel:(id)data
{
    NSArray *addData = nil;
    if([data isKindOfClass:[NSDictionary class]])
    {
        id result = [data objectForKey:@"results"];
        if([result isKindOfClass:[NSDictionary class]])
        {
            addData = [result allValues];
        }
        if([result  isKindOfClass:[NSArray class]])
        {
            addData = result;
        }
    }
    else if([data isKindOfClass:[NSArray class]])
    {
        addData = data;
    }
    for(id item in addData)
    {
        DressMemoCommentModel *memoComentItem = [[DressMemoCommentModel alloc] initWithDictionary:item];
        
        [self.dataArray addObject:memoComentItem];
        [memoComentItem release];
    }
    //[self.dataArray addObjectsFromArray:addData];

}
#pragma mark -
#pragma mark parser memo detail to model
-(void)parserMemoDetailToModel:(id)data
{
    //NSArray *addData = nil;
    if([data isKindOfClass:[NSDictionary class]])
    {
        DressMemoDetailDataModel *memoDetail  = [[DressMemoDetailDataModel alloc]initWithDictionary:data];
        self.memoDetailData = memoDetail;
        [memoDetail release];
    }
  
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
