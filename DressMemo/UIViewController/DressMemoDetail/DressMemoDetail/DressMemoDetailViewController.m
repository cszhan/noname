//
//  DressMemoDetailViewController.m
//  DressMemo
//
//  Created by cszhan on 12-8-1.
//
//

#import "DressMemoDetailViewController.h"
#import "DressMemoCommentController.h"
#import "DressMemoRetweetController.h"
#import "MyProfileViewController.h"

#define NoThisSection -1

@interface DressMemoDetailViewController ()

- (NSInteger)sectionOfAppendInfo;
- (NSInteger)sectionOfCollectedUsers;
- (NSInteger)sectionOfComments;

- (void)refreshDetailData;
- (void)refreshComments;

@end

@implementation DressMemoDetailViewController


#pragma mark -
#pragma mark init & delloc
- (id)init{
    self = [super init];
    
    if (self)
    {
       
    }
    
    return self;
}

- (void)dealloc{
    //[_likeBtn removeFromSuperview];
    Safe_Release(_likeBtn)
    
    //[_retweetBtn removeFromSuperview];
    Safe_Release(_retweetBtn)
    
    //[_commentBtn removeFromSuperview];
    Safe_Release(_commentBtn)
    
    Safe_Release(_detailView)
    
    [super dealloc];
}

#pragma mark -
#pragma mark -View

#define kBtnWidth 24
#define kBtnHeight 21

#define kBtnsPadding 25
#define kBtnRightPadding 18

- (void)loadView{
    [super loadView];
    
    _detailView = [[DressMemoDetailView alloc] initWithFrame:CGRectMake(0, 44, 320, 460-44-50)];
    _detailView.tableView.dataSource = self;
    _detailView.tableView.delegate = self;
    _detailView.detailHeader.tagsView.datasource = self;
    [self.view addSubview:_detailView];
    
    _likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-kBtnWidth-kBtnRightPadding, 
                                                          0, 
                                                          kBtnWidth, kBtnHeight)];
    [_likeBtn addTarget:self action:@selector(pressedBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *img = nil;
    UIImageWithFileName(img, @"icon-like.png");
    [_likeBtn setImage:img forState:UIControlStateNormal];
    UIImageWithFileName(img, @"icon-liked.png");
    [_likeBtn setImage:img forState:UIControlStateSelected];
    
    _retweetBtn = [[UIButton alloc] initWithFrame:CGRectMake(_likeBtn.frame.origin.x-kBtnWidth-kBtnsPadding, 
                                                          0, 
                                                          kBtnWidth, kBtnHeight)];
    [_retweetBtn addTarget:self action:@selector(pressedBtn:) forControlEvents:UIControlEventTouchUpInside];
    img = nil;
    UIImageWithFileName(img, @"icon-share.png");
    [_retweetBtn setImage:img forState:UIControlStateNormal];
    
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(_retweetBtn.frame.origin.x-kBtnWidth-kBtnsPadding, 
                                                          0, 
                                                          kBtnWidth, kBtnHeight)];
    [_commentBtn addTarget:self action:@selector(pressedBtn:) forControlEvents:UIControlEventTouchUpInside];
    img = nil;
    UIImageWithFileName(img, @"icon-coment.png");
    [_commentBtn setImage:img forState:UIControlStateNormal];
    
    _likeBtn.center = CGPointMake(_likeBtn.center.x, self.mainView.topBarView.bounds.size.height/2);
    _retweetBtn.center = CGPointMake(_retweetBtn.center.x, self.mainView.topBarView.bounds.size.height/2);
    _commentBtn.center = CGPointMake(_commentBtn.center.x, self.mainView.topBarView.bounds.size.height/2);
    
    [self.mainView.topBarView addSubview:_commentBtn];
    [self.mainView.topBarView addSubview:_retweetBtn];
    [self.mainView.topBarView addSubview:_likeBtn];
    
    [_detailView.detailHeader reloadData:self.memoDetailData];
    
    [self setHiddenRightBtn:YES];
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
    Safe_Release(_detailView)
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Private API
- (NSInteger)sectionOfAppendInfo{
    if ([[self.memoDetailData.appendInfoDic allValues] count]) {
        return 0;
    }
    
    return NoThisSection;
}

- (NSInteger)sectionOfCollectedUsers{
    if (![self.memoDetailData.favUsers count]) {
        return NoThisSection;
    }
    
    return [self sectionOfAppendInfo] + 1;
}

- (NSInteger)sectionOfComments{
    if ([self sectionOfCollectedUsers] != NoThisSection) {
        return [self sectionOfCollectedUsers] + 1;
    }else {
        return [self sectionOfAppendInfo] + 1;
    }
}

- (void)refreshDetailData{
    [_detailView reloadData:self.memoDetailData];
}

- (void)refreshComments{
    [_detailView.tableView reloadData];
}

- (NSDictionary *)dataDicForKey:(NSString *)key{
    if ([[self.memoDetailData.appendInfoDic objectForKey:key] length]) {
        return  [NSDictionary dictionaryWithObject:[self.memoDetailData.appendInfoDic objectForKey:key] forKey:key];
    }
    return nil;
}

- (NSArray *)arrayForAppendData{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    if ([self dataDicForKey:kAppendInfoLocationKey]) {
        [array addObject:[self dataDicForKey:kAppendInfoLocationKey]];
    }
    
    if ([self dataDicForKey:kAppendInfoEmotionKey]) {
        [array addObject:[self dataDicForKey:kAppendInfoEmotionKey]];
    }
    
    if ([self dataDicForKey:kAppendInfoOccasionKey]) {
        [array addObject:[self dataDicForKey:kAppendInfoOccasionKey]];
    }
    
    if ([self dataDicForKey:kAppendInfoDiscriptionKey]) {
        [array addObject:[self dataDicForKey:kAppendInfoDiscriptionKey]];
    }
    
    return array;
}

- (void)pressedBtn:(id)sender{
    if (sender == _likeBtn) {
        
    }else if(sender == _retweetBtn){
        DressMemoRetweetController *tc = [[DressMemoRetweetController alloc] init];
        
        [self.navigationController pushViewController:tc animated:YES];
        [tc release];
    }else if(sender == _commentBtn)
    {
        DressMemoCommentController *tc = [[DressMemoCommentController alloc] init];
        tc.type = 0;//for comment;
        tc.data = [NSDictionary dictionaryWithObjectsAndKeys:
                   self.memoDetailData.memoId, @"memoid",
                   //commentModel.idn ,@"commentid",
                   nil];
        [tc showWithController:self];
        [tc release];
    }
}

#pragma mark -
#pragma mark UITableView Datasoure & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionNum = 0;
    
    if ([self sectionOfAppendInfo] != NoThisSection) 
        sectionNum++;
    
    if ([self sectionOfCollectedUsers] != NoThisSection) 
        sectionNum++;
    
    if ([self sectionOfComments] != NoThisSection)
        sectionNum++;
    
    return sectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == [self sectionOfAppendInfo]) {
        return 1;
    }else if(section == [self sectionOfCollectedUsers]){
        return 1;
    }else if(section == [self sectionOfComments]){
        return [self.dataArray count];
    }
    
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == [self sectionOfAppendInfo]) {
        static NSString *appendInfoCell = @"appendInfoCell";
        UIAppendInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:appendInfoCell];
            
        if (![cell isKindOfClass:[UIAppendInfoCell class]]) {
            cell = [[UIAppendInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:appendInfoCell];
            [cell autorelease];
        }
            
                
        [cell reloadData:[self arrayForAppendData]];
            
        return cell;
        
    }else if(indexPath.section == [self sectionOfCollectedUsers]){
        static NSString *collectUserCell = @"collectUserCell";
        UICollectedUserCell *cell = [tableView dequeueReusableCellWithIdentifier:collectUserCell];
        
        if (![cell isKindOfClass:[UICollectedUserCell class]]) {
            cell = [[UICollectedUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:collectUserCell];
            [cell autorelease];
        }
        
        [cell reloadData:self.memoDetailData.favUsers];
        return cell;
    
    }else if(indexPath.section == [self sectionOfComments]){
        static NSString *commentCell = @"commentCell";
        
        UICommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
        
        if (![cell isKindOfClass:[UICommentCell class]]) {
            cell = [[UICommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCell];
            [cell autorelease];
        }
        
        DressMemoCommentModel *comment = [self.dataArray objectAtIndex:indexPath.row];
        [cell reloadData:comment];
        cell.delegate = self;
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == [self sectionOfAppendInfo]) {
        return [UIAppendInfoCell cellHeight:[self arrayForAppendData] withCellWidth:self.view.bounds.size.width];
    }else if(indexPath.section == [self sectionOfCollectedUsers]){
        return [UICollectedUserCell cellHeight];
    }else if(indexPath.section == [self sectionOfComments]){
        DressMemoCommentModel *comment = [self.dataArray objectAtIndex:indexPath.row];
        return [UICommentCell cellHeight:comment withCellWidth:self.view.bounds.size.width];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark -Tag Datasource
- (NSInteger)countOfTagInTagsView:(DressMemoDetailTagsView *)tagsView{
//    return 1;
    return [self.memoDetailData.tagArray count];
    return 0;
}
- (DressMemoTagCell *)tagsView:(DressMemoDetailTagsView *)tagsView cellWithIndex:(NSInteger)index{
    DressMemoTagCell *cell = [[[DressMemoTagCell alloc] initWithFrame:CGRectZero] autorelease];
    
    DressMemoTagModel *tag = [self.memoDetailData.tagArray objectAtIndex:index];
    [cell reloadData:tag];
    
    return cell;
}


#pragma mark -
#pragma mark just For test
-(void)didSelectorTopNavItem:(id)navObj
{
	NE_LOG(@"select item:%d",[navObj tag]);
    
	switch ([navObj tag])
	{
		case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];// animated:
        }
			break;
		case 1:
		{
//            DressMemoCommentController *tc = [[DressMemoCommentController alloc] init];
//            [tc showWithController:self];
//            [tc release];
            
            DressMemoRetweetController *tc = [[DressMemoRetweetController alloc] init];
            [self.navigationController pushViewController:tc animated:YES];
            [tc release];
			break;
		}
	}
    
}

#pragma mark -
#pragma mark Override Super Function
#pragma mark parser comment list
-(void)parserCommentJsonDataToTargetModel:(id)data {
    [super parserCommentJsonDataToTargetModel:data];
    
    [self performSelectorOnMainThread:@selector(refreshComments) withObject:nil waitUntilDone:NO];
    
}
#pragma mark -
#pragma mark parser memo detail to model
-(void)parserMemoDetailToModel:(id)data {
    [super parserMemoDetailToModel:data];
    
    [self performSelectorOnMainThread:@selector(refreshDetailData) withObject:nil waitUntilDone:NO];
}


#pragma mark -
#pragma mark UICommentCellDelegate
- (void)commentBtnPressedOnCommentCell:(UICommentCell *)cell{
    NSIndexPath *indexPath = [_detailView.tableView indexPathForCell:cell];
    
    DressMemoCommentModel *commentModel = [self.dataArray objectAtIndex:indexPath.row];
    
    if (![commentModel isKindOfClass:[DressMemoCommentModel class]]) {
        return;
    }
    DressMemoCommentController *tc = [[DressMemoCommentController alloc] init];
    tc.type = 1;
    tc.data = [NSDictionary dictionaryWithObjectsAndKeys:
                //commentModel.memoId, @"memoid",
                commentModel.idn ,@"commentid",
               nil];
    [tc showWithController:self];
    [tc release];
}

- (void)commentCreatorUserPressedOnCommentCell:(UICommentCell *)cell{
    
    int index = [_detailView.tableView indexPathForCell:cell].row;
    DressMemoCommentModel *commentModel = [self.dataArray objectAtIndex:index];

    MyProfileViewController *userProfileVc = [[MyProfileViewController alloc]init];
    userProfileVc.userId = commentModel.uid;
    userProfileVc.isVisitOther = YES;
    assert(userProfileVc.userId);
    [self.navigationController pushViewController:userProfileVc animated:YES];
    [userProfileVc release];
     
}

- (void)commentedUserPressedOnCommentCell:(UICommentCell *)cell{
    int index = [_detailView.tableView indexPathForCell:cell].row;
    DressMemoCommentModel *commentModel = [self.dataArray objectAtIndex:index];
    
    MyProfileViewController *userProfileVc = [[MyProfileViewController alloc]init];
    userProfileVc.userId = commentModel.replyUserId;
    userProfileVc.isVisitOther = YES;
    assert(userProfileVc.userId);
    [self.navigationController pushViewController:userProfileVc animated:YES];
    [userProfileVc release];
}

@end
