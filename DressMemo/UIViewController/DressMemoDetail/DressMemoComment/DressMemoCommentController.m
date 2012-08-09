//
//  DressMemoCommentController.m
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DressMemoCommentController.h"
#import "ZCSNetClientDataMgr.h"
@interface DressMemoCommentController ()

@end

@implementation DressMemoCommentController
@synthesize type;
- (void)loadView{
    [super loadView];
    
    [self setRightTextContent:@"发送"];
   _commentView = [[UICommentView alloc] initWithFrame:CGRectMake(0, 44, 320, 460-44-216)];
    [self.view addSubview:_commentView];

    switch (self.type) {
        case 0:
             [self setNavgationBarTitle:@"评 论"];
            break;
        case 1:
            [self setNavgationBarTitle:@"回复"];
            break;
        default:
            break;
    }
   
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
            [self starPostData];
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

- (void)dismiss
{
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark net work
-(void)didNetDataOK:(NSNotification*)ntf
{
    //kNetEnd(self.view);
    
   
    id obj = [ntf object];
    id respRequest = [obj objectForKey:@"request"];
    id data = [obj objectForKey:@"data"];
    NSString *resKey = [respRequest resourceKey];
    if(self.request ==respRequest && [resKey isEqualToString:@"addcomment"])
    {
        kNetEndSuccStr(@"评论成功",self.view);
    }
    if(self.request ==respRequest && [resKey isEqualToString:@"addreply"])
    {
        kNetEndSuccStr(@"回复成功",self.view);
    }
    [self dismissModalViewControllerAnimated:YES];
    //self.view.userInteractionEnabled = YES;
}
-(void)didNetDataFailed:(NSNotification*)ntf
{
    kNetEnd(self.view);
    //NE_LOG(@"warning not implemetation net respond");
}
-(void)starPostData
{
     NSString *contentText = _commentView.inputView.text;
    if(contentText == nil || [contentText isEqualToString:@""])
        return;
    switch (self.type)
    {
        case 0:
            [self addMemoComment];
            break;
        case 1:
            [self addCommentReply];
            break;
        default:
            break;
    }
    kNetStartShow(@"发送数据中...", self.view);
}
#pragma mark for comment
-(void)addMemoComment
{
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    NSString *contentText = _commentView.inputView.text;
   
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [self.data objectForKey:@"memoid"] ,@"memoid",
                                  contentText,@"comment",
                                  nil];
    self.request = [netMgr addMemoComment:param];
    
}
-(void)addCommentReply
{
    
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    NSString *contentText = _commentView.inputView.text;
   
    
    NSString *replyId = [self.data objectForKey:@"commentid"];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  replyId ,@"commentid",
                                  contentText,@"comment",
                                  nil];
    self.request = [netMgr addCommentReply:param];
}
@end
