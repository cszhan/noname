//
//  MesssageBoxViewController.m
//  DressMemo
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MesssageBoxViewController.h"
#import "ZCSNetClientDataMgr.h"
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
#if 0
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
-(void)setItemCell:(id)cell  withIndex:(NSIndexPath*)indexPath
{
    NSDictionary *itemData = [self.dataArray objectAtIndex:indexPath.row];
    
//    cell.nickNameLabel.text = [itemData objectForKey:@"uname"];
//    cell.locationLabel.text = [itemData objectForKey:@"city"];
//    NSString *iconUrl = [itemData objectForKey:@"avatar"];
//    if(iconUrl == nil||[iconUrl isEqualToString:@""])
//    {
//        [cell.userIconImageView setImage:[dbMgr getItemCellUserIconImageDefault]];
//    }
    
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
@end
