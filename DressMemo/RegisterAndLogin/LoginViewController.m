//
//  LoginViewController.m
//  DressMemo
//
//  Created by  on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginAndSignupConfig.h"
//fro cell
#import "LabelFieldCell.h"

#import "ResetPasswordViewController.h"
#import "UIButtonLikeCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MGBox.h"
#import "MGScrollView.h"
#import "MGStyledBox.h"
#import "UIImage+Extend.h"
#define kLoginAccountCell 0
#define kLoginPasswordCell 1


@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize  reSetPwdcell;
-(void)dealloc{
    self.reSetPwdcell = nil;
    [logInfo release];
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
-(void)loadView
{   
    [super loadView];
    //
  
    
    [self setNavgationBarTitle:NSLocalizedString(@"Login", @"")];
    [self setRightTextContent:NSLocalizedString(@"Done", @"")];
    //change the background
	//self.view = mainView;
    mainView.backgroundColor = kLoginAndSignupCellImageBGColor;
    //HexRGB(231,231,231);
    /*
    UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"BG-setting.png");
	//assert(bgImage);
	mainView.bgImage = bgImage;
    */
}
- (void)viewDidLoad
{
    [super viewDidLoad];
#if 1
    //as the 
    CGFloat bgWidth = kDeviceScreenWidth-2*kLoginResetPasswardPending;
    CGFloat bgHeight = 2*kLoginCellItemHeight+kLoginResetPasswardPending*2;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(kLoginResetPasswardPending,kLoginResetPasswardPending+kMBAppTopToolBarHeight,bgWidth,bgHeight-18)];
    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = kLoginViewRadius;
    bgView.backgroundColor = [UIColor whiteColor];
    //bgView.layer.borderColor = kLoginAndSignupCellImageBGColor;
    //初始化用户帐号密码信息输入表格，默认处于视野之外
#if 1
    bgWidth = kDeviceScreenWidth;
#endif
	logInfo = [[UITableView alloc] initWithFrame:CGRectMake(0,kMBAppTopToolBarHeight,bgWidth,bgHeight)
                                           style:UITableViewStyleGrouped];
	//logInfo.contentInset
    
	logInfo.allowsSelectionDuringEditing = NO;
	logInfo.backgroundColor = [UIColor clearColor];
	logInfo.delegate = self;
	logInfo.dataSource = self;
	logInfo.scrollEnabled = NO;
	logInfo.allowsSelection = YES;
    //logInfo.clipsToBounds = YES;
	logInfo.separatorColor = kLoginAndSignupCellLineColor;
    //logInfo.layer.cornerRadius = kLoginViewRadius;
    //CGPoint origin = bgView.frame.origin;
    //bgView.frame = logInfo.frame;
    logInfo.contentSize = CGSizeMake(bgWidth,bgHeight);
    //[bgView addSubview:logInfo];
#endif
#if 1
	[self.view addSubview:logInfo];
#else
    [self.view addSubview:bgView];
#endif
    
#if 0
    UITableViewCell *cell = [[[UIButtonLikeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell" ] autorelease];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = NSLocalizedString(@"Forget password", @"");
    //cell.textLabel.frame = CGRectOffset(cell.textLabel.frame, 40.f, 0);
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.frame = CGRectMake(kLoginResetPasswardPending,kMBAppTopToolBarHeight+logInfo.frame.size.height+20.f,kDeviceScreenWidth-kLoginResetPasswardPending*2,kLoginCellItemHeight);
    
    self.reSetPwdcell = cell;
    [self.view addSubview:cell]; 
#else

    CGRect rect =  CGRectMake(kLoginResetPasswardPending,kMBAppTopToolBarHeight+logInfo.frame.size.height+20.f,kDeviceScreenWidth-kLoginResetPasswardPending*2,kLoginCellItemHeight);
    UIButton *btn = [UIBaseFactory forkUIButtonByRect:rect text: NSLocalizedString(@"Forget password", @"") image:nil];
    [btn addTarget:self action:@selector(didTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

#endif
  
#if 0
    CGRect frame = CGRectMake(0, 0, 320, 460);
    MGScrollView *scroller = [[MGScrollView alloc] initWithFrame:frame];
    
    [self.view addSubview:scroller];
    scroller.alwaysBounceVertical = YES;
    scroller.delegate = self;
    
    MGStyledBox *box3 = [MGStyledBox box];
    box3.clipsToBounds = YES;
    
    MGBoxLine *imgLine = [MGBoxLine lineWithLeft:imgLineLeft right:nil];
    
    [box3.topLines addObject:imgLine];
    
    UIButton* labelView = [UIButton buttonWithType:UIButtonTypeCustom];
    labelView.frame =                CGRectMake(0.f, 0.f, 70, 44.f);
    //labelView.titleLabel.text = @"密码";
    [labelView  setTitle:@"密码" forState:UIControlStateNormal];
    //[labelView setTitle:@"" forState:<#(UIControlState)#>
    //labelView.buttonType = UIButtonTypeCustom;
    labelView.titleLabel.textColor = [UIColor lightGrayColor];
    labelView.backgroundColor  = HexRGB(231,231,231);
    //labelView.backgroundColor = [UIColor clearColor];
    labelView.titleLabel.textAlignment = UITextAlignmentCenter;
    labelView.layer.masksToBounds = YES;
    MGBoxLine *viewLine = [MGBoxLine lineWithLeft:labelView right:nil];
    viewLine.linePadding = 1.f;
    viewLine.itemPadding = 0.f;
    viewLine.height = 44.f;
    [box3.topLines addObject:viewLine];
    
    // draw all the boxes and animate as appropriate
    [scroller drawBoxesWithSpeed:ANIM_SPEED];
    [scroller flashScrollIndicators];
    
#endif   
    
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
    return 2;
    else 
    {
            return 1;
    }

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
			((LabelFieldCell *)cell).cellField.tag = kLoginAccountCell;
			((LabelFieldCell *)cell).cellField.placeholder = @"如 name@163.com";
			((LabelFieldCell *)cell).cellField.text = @"";
              [((LabelFieldCell*)cell).cellName setRoundType:1];
            /*
            CGRect rect = ((LabelFieldCell *)cell).cellName.frame;
            
            UIImage  *image = [UIImage_Extend imageWithColor:kLoginAndSignupCellImageBGColor];
             image = MTDContextCreateRoundedMask(image,5.f,0,0,0);
            [[((LabelFieldCell *)cell) cellLeftBGView]setImage:image];
             */
            [((LabelFieldCell *)cell).cellName setRoundUpperLeft:YES];
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
			((LabelFieldCell *)cell).cellField.tag = kLoginPasswordCell;
			((LabelFieldCell *)cell).cellField.text = @"";
            [((LabelFieldCell*)cell).cellName setRoundType:4];
            /*
            image = [UIImage_Extend imageWithColor:kLoginAndSignupCellImageBGColor];
            image = MTDContextCreateRoundedMask(image,0,5,0,0);
           
            
            [[((LabelFieldCell *)cell) cellLeftBGView]setImage:image];
               */
			break;
            
		default:
			break;
	}
    
	
	((LabelFieldCell *)cell).cellField.delegate = self;
    
    /*
	[(LabelFieldCell *)cell setLabelTextSize:14];
	[(LabelFieldCell *)cell setLabelTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
	[(LabelFieldCell *)cell setFieldTextSize:14];
	[(LabelFieldCell *)cell setFieldTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
	*/
    cell.selectedBackgroundView = nil;
    cell.selectionStyle  =UITableViewCellSelectionStyleNone;
    ((LabelFieldCell *)cell).cellName.layer.masksToBounds = YES;
	return cell;
    
}
-(void)didTouchEvent:(id)sender
{
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        ResetPasswordViewController *resetPwdVc = [[ResetPasswordViewController alloc]init];
        
        [self.navigationController pushViewController:resetPwdVc animated:YES];
        [resetPwdVc release];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (textField.returnKeyType == UIReturnKeyNext)
    {
		NSInteger nextTag = [textField tag] + 1;	
		UIView *textfield = [textField superview];
		UIView *tablecell = [textfield superview];
		UIView *nextTextField = [[tablecell superview] viewWithTag:nextTag];		
		[nextTextField becomeFirstResponder];
	}else if (textField.returnKeyType == UIReturnKeyGo) 
    {
		[self loginNow:nil];
	}
    
	
	return YES;
}
#pragma mark -
#pragma mark 
//-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)envent
//{
//#if 1
//    if(CGRectContainsPoint(self.reSetPwdcell.frame,point))
//    {
//        return self.view;
//    }
//#endif
//    return [super hitTest:point withEvent:envent];
//}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //for (UITouch *touch in touches) 
    UITouch *touch = [[touches allObjects]objectAtIndex:0];
   // {
        CGPoint point = [touch locationInView:[touch view]];
        point = [[touch view] convertPoint:point toView:self.view];
        NE_LOG(@"%lf,%lf",point.x,point.y);
   // }
    
    if(CGRectContainsPoint(self.reSetPwdcell.frame,point))
    {
        ResetPasswordViewController *resetPwdVc = [[ResetPasswordViewController alloc]init];
        
        [self.navigationController pushViewController:resetPwdVc animated:YES];
        [resetPwdVc release];

    
    }
}
@end
