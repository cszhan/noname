//
//  FriendInvitationViewController.m
//  DressMemo
//
//  Created by  on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FriendInvitationViewController.h"

@interface FriendInvitationViewController ()

@end

@implementation FriendInvitationViewController

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
    [self setRightTextContent:@"Send"];
    [self setNavgationBarTitle:NSLocalizedString(@"Invite Friends", @""
                                                 )];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *LabelTextFieldCell = @"LabelTextFieldCell";
	
	UITableViewCell *cell = nil;
    
	cell = [tableView dequeueReusableCellWithIdentifier:LabelTextFieldCell];
	
    
    if (cell == nil) 
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LabelTextFieldCell];
	}
 
    cell.textLabel.text = @"短信邀请";

    cell.accessoryType = UITableViewCellAccessoryNone;
	return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //看看我每天穿什么，下载iPhone版DressMemo，到｛下载地址｝
    Class msgClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (msgClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([msgClass canSendText])
		{
			MFMessageComposeViewController *msgVc = [[msgClass alloc]init];
            msgVc.body = @"看看我每天穿什么，下载iPhone版DressMemo，到｛下载地址｝";
            msgVc.messageComposeDelegate = self;
            [self.navigationController presentModalViewController:msgVc animated:YES];
            [msgVc release];
		}
		else {
			
					
		}
    }
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
@end
