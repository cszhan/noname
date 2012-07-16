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
//for test only
#import "LoginViewController.h"
#import "LoginAndResignMainViewController.h"
#import "RegisterViewController.h"

@interface DressWhatViewController ()

@end

@implementation DressWhatViewController

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
    [self startLoadNetData];
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
#pragma mark
#pragma mark net work
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

            MemoDescriptionViewController *desVc = [[MemoDescriptionViewController alloc]initWithNibName:@"MemoDescriptionViewController" bundle:nil];
            
            //[self.navigationController pushViewController:playMenuVc animated:YES];
            //[[NSNotificationCenter defaultCenter] postNotificationName: object:playMenuVc];
#if 0
            [ZCSNotficationMgr postMSG:kPushNewViewController obj:desVc];
#else
            [self.navigationController pushViewController:desVc animated:YES];
#endif  
            [desVc release];
        }
             
    }
}
@end
