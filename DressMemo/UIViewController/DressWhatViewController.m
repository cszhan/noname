//
//  DressWhatViewController.m
//  DressMemo
//
//  Created by  on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DressWhatViewController.h"
#import "DressMemoNetInterfaceMgr.h"
#import "MemoDescriptionViewController.h"
#import "TagChooseBrandViewController.h"
#import "PhotoUploadProcess.h"
#import "ZCSNetClientDataMgr.h"
//for test only
#import "LoginViewController.h"
#import "LoginAndResignMainViewController.h"
#import "RegisterViewController.h"

@interface DressWhatViewController ()
@property(nonatomic,retain)UIView *navBarBGView;
@end

@implementation DressWhatViewController
@synthesize navBarBGView;
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
    tweetieTableView.hasDownDragEffect = YES;
    [self initSubViews];
    //[self doFollowUser];
    //[self startLoadNetData];
	// Do any additional setup after loading the view.
}
-(void)initSubViews
{
    
    //upload bg image
    UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"title.png");
    UIImageView *bgImageView = [[UIImageView alloc ]initWithImage:bgImage];
    bgImageView.backgroundColor = [UIColor blueColor];
    //bgImageView.frame = CGRectMake(0,0,bgImage.size.width/kScale, bgImage.size.height/kScale);
    bgImageView.frame = CGRectMake(0,0,40.f,30.f);
    bgImageView.center = CGPointMake(mainView.topBarView.frame.size.width/2.f, mainView.topBarView.frame.size.height/2.f);
    NE_LOGRECT(bgImageView.frame);
    [mainView.topBarView addSubview:bgImageView];
    [bgImageView release];
    
    navBarBGView = [[UIView alloc] initWithFrame:CGRectMake(9.f,44.f+8.f,kDeviceScreenWidth-9.f*2,30.f)];
    navBarBGView.backgroundColor = [UIColor redColor];
    [self.view insertSubview:navBarBGView aboveSubview:tweetieTableView];
    [navBarBGView release];
    
   
    [self.view bringSubviewToFront:mainView.topBarView];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[tweetieTableView tableViewDidScroll];
    if(tweetieTableView.contentOffset.y>=0&&tweetieTableView.scrollDirection == 0)//scroll up
    {
        tweetieTableView.contentOffset = CGPointMake(0.f,-44.f);
    }
    NSLog(@"%lf",tweetieTableView.contentOffset.y);
    if(tweetieTableView.contentOffset.y<0)
    {
        NSLog(@"%lf",tweetieTableView.contentOffset.y);
        // tweetieTableView.contentOffset = CGPointMake(0.f,0.f);
        return ;
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

    NSLog(@"test");
}
#pragma mark 
#pragma mark tableCell

#pragma mark net work
#pragma mark start get data
- (void) shouldLoadNewerData:(NTESMBTweetieTableView *) tweetieTableView
{
    NSLog(@"loader new data");
    //    if(isRefreshing)
    //        return;
    [tweetieTableView closeInfoView];
}
-(void)startLoadNetData
{
    DressMemoNetInterfaceMgr *dressMemoInterfaceMgr = [DressMemoNetInterfaceMgr getSingleTone];

    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"cszhan@163.com", @"email",
                               @"123456",@"pass",
                               nil];
#if 0
    [dressMemoInterfaceMgr startAnRequestByResKey:@"login" 
                                     withParam:paramDict 
                                    withMethod:@"POST"
                                      withData:NO];
    /*
    paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"cszhan",@"uname",
                               @"cszhan@163.com", @"email",
                               @"123456",@"pass",
                               nil];
    [dressMemoInterfaceMgr startAnRequestByKey:@"register" 
                                     withParam:paramDict 
                                    withMethod:@"POST"];
    */
 
    paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                 //@"f79fb145a78fc1b8cde3ab47767a9fda",@"token",
                 [UIImage imageNamed:@"test.png"], @"pic",
               //  @"123456",@"pass",
                 nil];
    [dressMemoInterfaceMgr startAnRequestByResKey:@"uploadpic"
                                        needLogIn:YES
                                     withParam:paramDict 
                                    withMethod:@"POST"
                                         withData:YES];
#endif  

}
-(void)didSelectorTopNavItem:(id)navObj
{
	NE_LOG(@"select item:%d",[navObj tag]);
	switch ([navObj tag])
	{
		case 0:
        {
            
            MemoDescriptionViewController *desVc = [[MemoDescriptionViewController alloc]initWithNibName:@"MemoDescriptionViewController" bundle:nil];
            
            //[self.navigationController pushViewController:playMenuVc animated:YES];
            //[[NSNotificationCenter defaultCenter] postNotificationName: object:playMenuVc];
#if 0
            [ZCSNotficationMgr postMSG:kPushNewViewController obj:desVc];
#else
            [self.navigationController pushViewController:desVc animated:YES];
#endif
            [desVc release];
            return;
            
#if 0
            TagChooseBrandViewController *tagchooseBrandVc = [[TagChooseBrandViewController alloc]init];
            
            NSDictionary *srcData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"Zara",@"Brand",
                                     @"帽子",@"Cats1",
                                     @"男帽",@"Cats2",
                                     nil];
            [tagchooseBrandVc setInitSourceData:srcData 
            withTagBtn:nil];
            [self.navigationController pushViewController:tagchooseBrandVc animated:YES];
            [tagchooseBrandVc release];
            
            return ;
#endif
#if 0
            LoginViewController *tagchooseBrandVc = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:tagchooseBrandVc animated:YES];
            [tagchooseBrandVc release];
            
            return ;
#endif
#if 0
            RegisterViewController *tagchooseBrandVc = [[RegisterViewController alloc]init];
            [self.navigationController pushViewController:tagchooseBrandVc animated:YES];
            [tagchooseBrandVc release];
            
            return ;
#endif
#if 1
            {
            LoginAndResignMainViewController *tagchooseBrandVc = [[  LoginAndResignMainViewController alloc]init];
            [self.navigationController pushViewController:tagchooseBrandVc animated:YES];
            [tagchooseBrandVc release];
            
            return ;
            }
#endif    
        }
			//[self.navigationController popViewControllerAnimated:YES];// animated:
			break;
        case 1:
        {
#if 0
            PhotoUploadProcess *process = [[PhotoUploadProcess alloc]init];
            [self.navigationController pushViewController:process animated:YES];
            [process release];
            return ;
#endif

        }
    }
}
- (void)doFollowUser
{
    for(int i = 0;i<20;i++)
    {
        NSString *uid =  [[NSString  alloc ]initWithFormat:@"%d",i];
        ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
        NSDictionary *param = [NSDictionary dictionaryWithObject:uid forKey:@"fuid"];
        [netMgr followUser:param];
        
    }
}
@end
