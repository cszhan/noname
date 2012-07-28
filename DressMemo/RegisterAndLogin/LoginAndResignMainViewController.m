//
//  LoginAndResignMainViewController.m
//  DressMemo
//
//  Created by  on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginAndResignMainViewController.h"
#import "LoginAndSignupConfig.h"

#import "LoginViewController.h"
#import "RegisterViewController.h"
@interface LoginAndResignMainViewController ()

@end

@implementation LoginAndResignMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initSubViews
{
    
    //upload bg image
    UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"BG-login.png");
    UIImageView *bgImageView = [[UIImageView alloc ]initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0,0,bgImage.size.width/kScale, bgImage.size.height/kScale);
    NE_LOGRECT(bgImageView.frame);
    [mainView addSubview:bgImageView];
    [bgImageView release];
    
    bgImage = nil;
    //clothe background
    UIImageWithFileName(bgImage,@"logo-login.png");
    
    bgImageView = [[UIImageView alloc ]initWithImage:bgImage];
    bgImageView.frame = CGRectMake(kLoginAndSignupMainLogoStartX,kLoginAndSignupMainLogoStartY,bgImage.size.width/kScale, bgImage.size.height/kScale);
    
    [mainView addSubview:bgImageView];
    [bgImageView release];
    
	
	UIImageWithFileName(bgImage,@"btn-regist&login.png");
	//UIImage *bgImageS = nil;
	//UIImageWithFileName(bg
    UIButton * btn = [UIBaseFactory forkUIButtonByRect:CGRectZero text:NSLocalizedString(@"Login", @"") image:bgImage];
	//[btn setBackgroundImage:bgImage forState:UIControlStateNormal];
    //btn.showsTouchWhenHighlighted = YES;
    /*
     UIImageWithFileName(bgImage,@"Btn_back.png");
     [btn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
     //|UIControlStateHighlighted|UIControlStateSelected
     */
	btn.frame = CGRectMake(kLoginAndSignupMainLogoStartX,kLoginAndSignupMainLoginButtonStartY,bgImage.size.width/kScale, bgImage.size.height/kScale);
    [btn addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 0;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   // btn.titleLabel.textColor = [UIColor whiteColor];
    [mainView addSubview:btn];
	NE_LOGRECT(btn.frame);
    
    //btn = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImageWithFileName(bgImage,@"btn-regist&login.png");
	//UIImage *bgImageS = nil;
	//UIImageWithFileName(bg
	btn = [UIBaseFactory forkUIButtonByRect:CGRectZero text:NSLocalizedString(@"Register", @"") image:bgImage];
    /*
     UIImageWithFileName(bgImage,@"Btn_back.png");
     [btn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
     //|UIControlStateHighlighted|UIControlStateSelected
     */
	btn.frame = CGRectMake(kLoginAndSignupMainLogoStartX,kLoginAndSignupMainSignupButtonStartY,bgImage.size.width/kScale, bgImage.size.height/kScale);
    //btn.showsTouchWhenHighlighted = YES;
    [btn addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchUpInside];
    //btn.titleLabel.textColor = [UIColor whiteColor];
     [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.tag = 1;
    [mainView addSubview:btn];
}
-(void)didTouchBtn:(id)sender
{
int type = -1;
if([sender respondsToSelector:@selector(intValue)])
{
    type = [sender intValue];
}
else 
if([sender respondsToSelector:@selector(tag)])
{
    type = [sender tag];
}
UIViewController *vc = nil ;
#if 1
    
    switch (type) 
    {
        case 0:
            vc = [[LoginViewController alloc]init];
            break;
        case 1:
            vc = [[RegisterViewController alloc]init];
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
//0 for camera 1 for alblum
   
//[ZCSNotficationMgr postMSG:kUploadPhotoPickChooseMSG obj:[NSNumber numberWithInt:type]];
#else
NSNotification *ntf = [NSNotification notificationWithName:@"" object:[NSNumber numberWithInt:type]];
[self pickPhotoI:ntf];
#endif
}
- (void)loadView
{
    [super loadView];
    //return;
    //tabCtrl.tabBar.frame = CGRectMake(0,0,40,32);
	//topBarViewNavItemArr = [[NSMutableArray alloc]init];
	/*
     mainView = [[NEAppFrameView alloc]
     //initWithFrame:[[UIScreen mainScreen]bounds]];
     initWithFrame:[[UIScreen mainScreen]bounds]withImageDict:nil withImageDefault:YES];
     */
	//[mainView release];
	mainView = [[NEAppFrameView alloc]initWithFrame:[[UIScreen mainScreen]bounds] style:NEAppFrameViewDefault|NEAppFrameViewBottomBarNone|NEAppFrameViewTopBarNone];
	//self.view = mainView;
	
	[self initSubViews];
	self.view = mainView;
	//[mainView release];
	//[self.view addSubview:mainView];
	NE_LOGRECT(self.view.frame);
	NE_LOGRECT(mainView.topBarView.frame);

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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
