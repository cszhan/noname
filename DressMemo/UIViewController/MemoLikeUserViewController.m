//
//  MemoLikeUserViewController.m
//  DressMemo
//
//  Created by cszhan on 12-8-4.
//
//

#import "MemoLikeUserViewController.h"
//#import "FriendItemCell.h"
#import "MessageTableViewCell.h"
#import "MyProfileViewController.h"
#import "DBManage.h"
@interface MemoLikeUserViewController ()

@end

@implementation MemoLikeUserViewController

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
    [self setNavgationBarTitle:NSLocalizedString(@"Like", @"")];
    self.itemCount = [[self.data objectForKey:@"favornum"]intValue];
    NSString *headViewTitle = [NSString stringWithFormat:NSLocalizedString(@"共有%d人喜欢", @""),self.itemCount];
    [self.headBgView setTitle:headViewTitle forState:UIControlStateNormal];
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
#pragma mark uitableView
#if 1
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    static NSString *cellId = @"FriendCell";
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
	//cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    [self setItemCell:cell withIndex:indexPath];
    
    return cell;
}
#endif
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 124.f/2.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     NSDictionary *itemData= [self.dataArray objectAtIndex:indexPath.row];
     MyProfileViewController *userProfileVc = [[MyProfileViewController alloc]init];
     userProfileVc.userId = [itemData objectForKey:@"uid"];
     userProfileVc.isVisitOther = YES;
     assert(userProfileVc.userId);
     [self.navigationController pushViewController:userProfileVc animated:YES];
     [userProfileVc release];
     */
}
-(void)setItemCell:(MessageTableViewCell*)cell  withIndex:(NSIndexPath*)indexPath
{
    DBManage *dbMgr = [DBManage getSingleTone];
    NSDictionary *itemData = [self.dataArray objectAtIndex:indexPath.row];
    [cell.nickNameBtn addTarget:self action:@selector(didTouchNickNameTitle:)  forControlEvents:UIControlEventTouchUpInside];
    cell.nickNameBtn.tag = indexPath.row;
    //cell.locationLabel.text = [itemData objectForKey:@"city"];
    NSString *msgTimeStr = [itemData objectForKey:@"favortime"];
    NSDate  *resignTime = [NSDate  dateWithTimeIntervalSince1970:[msgTimeStr longLongValue]];
    cell.timeLabel.text = [resignTime memoFormatTime:@"YY-MM-dd HH:mm"];
    //cell.timeLabel.text =
    NSString *iconUrl = [itemData objectForKey:@"avatar"];
    
    if(iconUrl == nil||[iconUrl isEqualToString:@""])
    {
        [cell.userIconImageView setImage:[dbMgr getItemCellUserIconImageDefault]];
    }
   // if([[itemData objectForKey:@"type"] isEqualToString:@"follow"])
    {
        cell.cellType = -1;
    }
    cell.msgData = itemData;
    cell.userInteractionEnabled = YES;
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
    [self getFavMemoUsers];
    //[self getPostMemos];
    //[memoTimelineDataSource getOldData];
}
#pragma mark net request
-(void)getFavMemoUsers
{
    
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [self.data objectForKey:@"memoid"] ,@"memoid",
                                  nil];
    self.request = [netMgr getFavorMemoUsers:param];
    //isRefreshing = YES;
}
-(void)didTouchNickNameTitle:(id)sender
{
    int index = [sender tag];
    NSDictionary *itemData = [self.dataArray objectAtIndex:index];
    NSMutableDictionary *newitemData = [NSMutableDictionary dictionaryWithDictionary:itemData];
    //[newitemData setValue:@"1" forKey:@"status"];
    MyProfileViewController *userProfileVc = [[MyProfileViewController alloc]init];
    userProfileVc.userId = [itemData objectForKey:@"uid"];
    
    userProfileVc.userData = newitemData;
    userProfileVc.isVisitOther = YES;
    assert(userProfileVc.userId);
    [self.navigationController pushViewController:userProfileVc animated:YES];
    [userProfileVc release];
    
}
@end
