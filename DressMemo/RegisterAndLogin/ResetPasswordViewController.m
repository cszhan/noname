//
//  ResetPasswordViewController.m
//  DressMemo
//
//  Created by  on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "LoginAndSignupConfig.h"
#import "ZCSNetClientDataMgr.h"
@interface ResetPasswordViewController ()
@property(nonatomic,retain)UITextField *subClassInputTextField;
@end

@implementation ResetPasswordViewController
@synthesize subClassInputTextField;
- (void)dealloc
{
    self.subClassInputTextField = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView{
    [super loadView];
    //
    //change the background
	//self.view = mainView;
    //mainView.backgroundColor = kLoginAndSignupCellImageBGColor;

}
- (void)viewDidLoad
{
    //[super viewDidLoad];
    [self addObservers];
    [self setNavgationBarTitle:NSLocalizedString(@"Reset Password", @"")];
    
    [self setRightTextContent:NSLocalizedString(@"Send", @"")];
    
    self.subClassInputTextField = [[[UITextField alloc]initWithFrame:CGRectMake(KLoginAndResignPendingX,KLoginAndResignPendingX+kMBAppTopToolBarHeight,kDeviceScreenWidth-2*KLoginAndResignPendingX,44.f)]autorelease];
    subClassInputTextField.borderStyle = UITextBorderStyleRoundedRect;
    subClassInputTextField.delegate = self;
    subClassInputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    subClassInputTextField.font = kAppTextSystemFont(16);//[UIFont systemFontOfSize:40];
    subClassInputTextField.textColor = kLoginAndSignupInputTextColor;
    subClassInputTextField.adjustsFontSizeToFitWidth = NO;
    subClassInputTextField.text = @"";
    subClassInputTextField.placeholder = NSLocalizedString(@"Please input resign email", @"");
    subClassInputTextField.returnKeyType = UIReturnKeyDone;
    UIImage *bgImage = nil;
    //UIImageWithFileName(bgImage, @"inputboxL.png");
    UIImageWithFileName(bgImage, @"inputboxL.png");
#if 1
    UIEdgeInsets resizeEdgeInset = UIEdgeInsetsMake(10.f,10.f,10.f,10.f);
    if([bgImage respondsToSelector:@selector(resizableImageWithCapInsets:)]&&1)
    {
        bgImage =[bgImage resizableImageWithCapInsets:resizeEdgeInset];
        
    }
    else 
    {
        bgImage = [bgImage stretchableImageWithLeftCapWidth:10.f topCapHeight:10.f];
    }
#endif
    //self.view = subClassInputTextField;
    [self.view addSubview:subClassInputTextField];
    [subClassInputTextField becomeFirstResponder];

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
#pragma mark nav item selector
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
            [self startRestPassword];
			break;
		}
	}
    
}
-(void)startRestPassword{

    if([subClassInputTextField.text isEqualToString:@""])
    {
        [subClassInputTextField becomeFirstResponder];
        return;
    }
    [SVProgressHUD showWithStatus:NSLocalizedString(@"", @"") networkIndicator:YES];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           subClassInputTextField.text,@"email",
                           nil];
    ZCSNetClientDataMgr *netClientMgr = [ZCSNetClientDataMgr getSingleTone];
    [netClientMgr  startUserResetPassword:param];
    //[self ];
}
-(void)didLoginOK:(NSNotification*)ntf
{
    //save use name and passwor;
    [SVProgressHUD dismiss];
    id obj = [ntf object];
    id request = [obj objectForKey:@"request"];
    id data = [obj objectForKey:@"data"];
    NSString *resKey = [request resourceKey];
    if([resKey isEqualToString:@"forgetpwd"])
    {
        
        kUIAlertView(@"邮件已经发送，请稍候查看您的邮箱");
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)didLoginFailed:(NSNotification*)ntf
{
    [SVProgressHUD dismissWithError:@""];
}
@end
