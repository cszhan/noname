//
//  DressMemoCommentController.m
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DressMemoCommentController.h"

@interface DressMemoCommentController ()

@end

@implementation DressMemoCommentController

- (void)loadView{
    [super loadView];
    
   _commentView = [[UICommentView alloc] initWithFrame:CGRectMake(0, 44, 320, 460-44-216)];
    [self.view addSubview:_commentView];
    [self setNavgationBarTitle:@"评 论"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrame:) 
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [_commentView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    Safe_Release(_commentView)
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    Safe_Release(_commentView)
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)didSelectorTopNavItem:(id)navObj
{
	NE_LOG(@"select item:%d",[navObj tag]);
    
	switch ([navObj tag])
	{
		case 0:
        {
            [self dismiss];
        }
			break;
		case 1:
		{
			break;
		}
	}
    
}

#pragma mark -
#pragma mark Notification
- (void)keyBoardFrame:(NSNotification *)note{
    NSDictionary *dic = [note userInfo];
    CGRect f;
    
    [(NSValue *)[dic objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&f];
    
    _commentView.frame = CGRectMake(0, 44, 320, 460-44-f.size.height);
}

#pragma mark -
#pragma mark Public API
- (void)showWithController:(UIViewController *)tc{    
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [tc presentModalViewController:self animated:YES];
}

- (void)dismiss{
    [self dismissModalViewControllerAnimated:YES];
}

@end
