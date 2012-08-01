//
//  MesssageBoxViewController.m
//  DressMemo
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MesssageBoxViewController.h"
#import "ZCSNetClientDataMgr.h"
#import "MessageTableViewCell.h"
#import "DBManage.h"
#import "MyProfileViewController.h"
@interface MesssageBoxViewController ()

@end

@implementation MesssageBoxViewController

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
    UIImageWithFileName(bgImage,@"BG-user.png");
    //assert(bgImage);
    mainView.bgImage = bgImage;
    [self setNavgationBarTitle:NSLocalizedString(@"Message", @""
                                                )];
    [self setRightTextContent:NSLocalizedString(@"Clear", @"")];
    [self shouldLoadOlderData:tweetieTableView];
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
- (void)shouldLoadOlderData:(NTESMBTweetieTableView *) tweetieTableView
{
#if 0 
    if(isRefreshing)
        return;
#endif  
    NSLog(@"loader old data");
    [self startShowLoadingView];
    [self getUserMessageList];
    //[self getPostMemos];
    //[memoTimelineDataSource getOldData];
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.dataArray count];
}
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
    NSString *msgTimeStr = [itemData objectForKey:@"addtime"];
    NSDate  *resignTime = [NSDate  dateWithTimeIntervalSince1970:[msgTimeStr longLongValue]];
    cell.timeLabel.text = [resignTime memoFormatTime:@"YY-MM-dd HH:mm"];
    //cell.timeLabel.text =
    NSString *iconUrl = [itemData objectForKey:@"avatar"];
    
    if(iconUrl == nil||[iconUrl isEqualToString:@""])
    {
        [cell.userIconImageView setImage:[dbMgr getItemCellUserIconImageDefault]];
    }
    if([[itemData objectForKey:@"type"] isEqualToString:@"follow"])
    {
        cell.cellType = 0;
    }
    cell.msgData = itemData;
    cell.userInteractionEnabled = YES;
}
-(void)getUserMessageList
{
    NSString *pageNumStr = [NSString stringWithFormat:@"%d",currentPageNum];
    
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           pageNumStr    ,@"pageno",
                           @"15",@"pagesize",
                           nil];
    self.request = [netMgr getMessageList:param];
    
}
-(void)alterClearConfirm
{
    UIAlertView *alertErr = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", @"")message:NSLocalizedString(@"是否真的要退出",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") otherButtonTitles:NSLocalizedString(@"Ok",@""),nil]autorelease];
    [alertErr show];


}
#pragma mark 
-(void)didSelectorTopNavItem:(id)navObj{
	NE_LOG(@"select item:%d",[navObj tag]);
    
	switch ([navObj tag])
	{
		case 0:
        {
            
            //if(self.isVisitOther)
            {
                [self.navigationController popViewControllerAnimated:YES];// animated:
            }
            
        }
			break;
		case 1:
		{
            
			[self alterClearConfirm];
			break;
		}
	}
}
#pragma mark  -
#pragma mark logout confir delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        
        //[self.navigationController popToRootViewControllerAnimated:NO];
        
    }
}
-(void)didTouchNickNameTitle:(id)sender
{
    int index = [sender tag];
    NSDictionary *itemData = [self.dataArray objectAtIndex:index];
    NSMutableDictionary *newitemData = [NSMutableDictionary dictionaryWithDictionary:itemData];
    [newitemData setValue:@"1" forKey:@"status"];
    MyProfileViewController *userProfileVc = [[MyProfileViewController alloc]init];
    userProfileVc.userId = [itemData objectForKey:@"fuid"];
    
    userProfileVc.userData = newitemData;
    userProfileVc.isVisitOther = YES;
    assert(userProfileVc.userId);
    [self.navigationController pushViewController:userProfileVc animated:YES];
    [userProfileVc release];

}
@end
