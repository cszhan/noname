//
//  ShareAuthViewController.m
//  UMSNSDemo
//
//  Created by Fengfeng Pan on 11-12-13.
//  Copyright (c) 2011年 Realcent. All rights reserved.
//

#import "ShareAuthViewController.h"
#import "constant.h"
#import "WeiBoTencentEngine.h"

@implementation ShareAuthViewController
@synthesize type;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithEngine:(WeiBoBaseEngine *)tbaseEngine{
    self = [self init];
    
    if (self) {
        _baseEngine = tbaseEngine;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView{
    [super loadView];
    
    _authWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, K_FRAME_WIDTH, K_FRAME_HEIGHT-K_NAVBAR_HEIGHT-50)];
    if(self.type == 3){
		_authWeb.delegate = _baseEngine;
	}
	else {
		_authWeb.delegate = self;

	}
    //_baseEngine.dataDelegate = self;
    [self.view addSubview:_authWeb];
    [_authWeb release];
    NSURLRequest *request = [_baseEngine auth];
    [_authWeb loadRequest:request];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark uiwebviewdelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //if(self.type ==3)//renren
//		return [_baseEngine parseQueryAndRedirect:request URL];
	NSString *query = [[request URL] query];
    return [_baseEngine parseQueryAndRedirect:query];
}
#pragma mark -
#pragma mark RenrenDelegate

#pragma mark -
#pragma mark weibo delegate
-(void)authOKWithEngine:(WeiBoBaseEngine *)engine{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)authFailWithEngine:(WeiBoBaseEngine *)engine failReason:(NSString *)reason{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:reason delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

@end
