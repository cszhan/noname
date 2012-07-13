//
//  RegisterViewController.m
//  DressMemo
//
//  Created by  on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "LabelFieldCell.h"
#import "LabelImageCell.h"
#import "LoginAndSignupConfig.h"


@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    [self setNavgationBarTitle:NSLocalizedString(@"Register", @"")];
}
- (void)viewDidLoad
{
    //[super viewDidLoad];
    logInfo = [[UITableView alloc] initWithFrame:CGRectMake(0.f, kMBAppTopToolBarHeight-2.f, kDeviceScreenWidth, kLoginCellItemHeight*2+20.f)
                                           style:UITableViewStyleGrouped];
	//logInfo.contentInset
    
	logInfo.allowsSelectionDuringEditing = NO;
	logInfo.backgroundColor = [UIColor clearColor];
	logInfo.delegate = self;
	logInfo.dataSource = self;
	logInfo.scrollEnabled = NO;
	logInfo.allowsSelection = YES;
    logInfo.clipsToBounds   = YES;
	logInfo.separatorColor = kLoginAndSignupCellLineColor;
    
	[self.view addSubview:logInfo];
    //UITextField *resetTextFiled = [[UITextField alloc]initWithCoder:nil];
    self.reSetPwdcell.hidden = YES;
    CGRect rect = logInfo.frame;
    logInfo.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+100.f);
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
#pragma mark -
#pragma mark tableView dataSource
//- (NSInteger)tableView:(UITableView *)tableView section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 0)
        return 4;
    else 
    {
        return 1;
    }
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *LabelTextFieldCell = @"LabelTextFieldCell";
	
	UITableViewCell *cell = nil;
    
	cell = [tableView dequeueReusableCellWithIdentifier:LabelTextFieldCell];
	
    
    if (cell == nil) 
    {
		cell = [[LabelFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LabelTextFieldCell];
	}
	int index = [indexPath row];
	switch (index)
    {
        case 0:
			[(LabelFieldCell *)cell setLabelTextFont:kLoginAndSignupHintTextFont];
			[(LabelFieldCell *)cell setLabelTextColor:kLoginAndSignupHintTextColor];
			[(LabelFieldCell *)cell setLabelName:NSLocalizedString(@"Email", @"")];
			[(LabelFieldCell *)cell setFieldTextFont:kLoginAndSignupInputTextFont];
            [(LabelFieldCell *)cell setFieldTextColor:kLoginAndSignupInputTextColor];
			
			((LabelFieldCell *)cell).cellField.keyboardType = UIKeyboardTypeEmailAddress;
			((LabelFieldCell *)cell).cellField.returnKeyType = UIReturnKeyNext;
			((LabelFieldCell *)cell).cellField.tag = //kLoginAccountCell;
			((LabelFieldCell *)cell).cellField.placeholder = @"如 name@163.com";
			((LabelFieldCell *)cell).cellField.text = @"";
			break;
		case 1:
			[(LabelFieldCell *)cell setLabelTextFont:kLoginAndSignupHintTextFont];
			[(LabelFieldCell *)cell setLabelTextColor:kLoginAndSignupHintTextColor];
			[(LabelFieldCell *)cell setLabelName:NSLocalizedString(@"Password", @"")];
			[(LabelFieldCell *)cell setFieldTextFont:kLoginAndSignupInputTextFont];
            [(LabelFieldCell *)cell setFieldTextColor:kLoginAndSignupInputTextColor];
			
			((LabelFieldCell *)cell).cellField.keyboardType = UIKeyboardTypeDefault;
			((LabelFieldCell *)cell).cellField.returnKeyType = UIReturnKeyGo;
			((LabelFieldCell *)cell).cellField.secureTextEntry = YES;
			((LabelFieldCell *)cell).cellField.tag = //kLoginPasswordCell;
			((LabelFieldCell *)cell).cellField.text = @"";
			break;
        case 2:
			[(LabelFieldCell *)cell setLabelTextFont:kLoginAndSignupHintTextFont];
			[(LabelFieldCell *)cell setLabelTextColor:kLoginAndSignupHintTextColor];
			[(LabelFieldCell *)cell setLabelName:NSLocalizedString(@"Password", @"")];
			[(LabelFieldCell *)cell setFieldTextFont:kLoginAndSignupInputTextFont];
            [(LabelFieldCell *)cell setFieldTextColor:kLoginAndSignupInputTextColor];
			
			((LabelFieldCell *)cell).cellField.keyboardType = UIKeyboardTypeDefault;
			((LabelFieldCell *)cell).cellField.returnKeyType = UIReturnKeyGo;
			((LabelFieldCell *)cell).cellField.secureTextEntry = YES;
			((LabelFieldCell *)cell).cellField.tag = //kLoginPasswordCell;
			((LabelFieldCell *)cell).cellField.text = @"";
			break;
            default:
			break;
	}
    /*
	((LabelFieldCell *)cell).cellField.delegate = self;
    
     [(LabelFieldCell *)cell setLabelTextSize:14];
     [(LabelFieldCell *)cell setLabelTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
     [(LabelFieldCell *)cell setFieldTextSize:14];
     [(LabelFieldCell *)cell setFieldTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
     */
    if(indexPath.row == 3)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"imageLabelCell"];
        
        
        if (cell == nil) 
        {
            cell = [[[LabelImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LabelTextFieldCell]autorelease];
        }
        
    }
    cell.selectionStyle  =UITableViewCellSelectionStyleNone;
	return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 3)
    {
        return kRegisterCellImageItemHeight;
    
    }
    else 
    {
        return kLoginCellItemHeight;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3)
    {
        /*
        ResetPasswordViewController *resetPwdVc = [[ResetPasswordViewController alloc]init];
        
        [self.navigationController pushViewController:resetPwdVc animated:YES];
        [resetPwdVc release];
        */
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //for (UITouch *touch in touches) 
    return;
    UITouch *touch = [[touches allObjects]objectAtIndex:0];
    // {
    CGPoint point = [touch locationInView:[touch view]];
    point = [[touch view] convertPoint:point toView:self.view];
    NE_LOG(@"%lf,%lf",point.x,point.y);
    // }
    UITableViewCell *imageCell = [logInfo cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if(CGRectContainsPoint(imageCell.frame,point))
    {
        /*
        ResetPasswordViewController *resetPwdVc = [[ResetPasswordViewController alloc]init];
        
        [self.navigationController pushViewController:resetPwdVc animated:YES];
        [resetPwdVc release];
        */
        NSLog(@"cell View touch");
        
    }
}

@end
