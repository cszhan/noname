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
#import "PhotoPickTool.h"
#import "AppMainUIViewManage.h"
#import "ZCSNetClientDataMgr.h"
#import "DBManage.h"
#import "UIImage+Extend.h"
static     UINavigationController *gnv = nil;
@interface RegisterViewController ()
@property(nonatomic,retain)NSMutableDictionary *resignData;
@property(nonatomic,retain)NSString *imagePath;
@end

@implementation RegisterViewController
@synthesize resignData;
@synthesize imagePath;
-(void)dealloc{
    self.resignData = nil;
    self.imagePath = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.resignData = [NSMutableDictionary dictionary];
        // Custom initialization
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    [self setNavgationBarTitle:NSLocalizedString(@"Register", @"")];
}
- (void)addObservers{
    [ZCSNotficationMgr addObserver:self call:@selector(didLoginOK:) msgName:kZCSNetWorkOK];
    [ZCSNotficationMgr addObserver:self call:@selector(didLoginFailed:) msgName:
     kZCSNetWorkRespondFailed];
}
- (void)viewDidLoad
{
    //[super viewDidLoad];
    [self addObservers];
    logInfo = [[UITableView alloc] initWithFrame:CGRectMake(0.f, kMBAppTopToolBarHeight-2.f, kDeviceScreenWidth, kLoginCellItemHeight*3+kRegisterCellImageItemHeight)
                                           style:UITableViewStyleGrouped];
	//logInfo.contentInset
    
	logInfo.allowsSelectionDuringEditing = NO;
	logInfo.backgroundColor = [UIColor clearColor];
	logInfo.delegate = self;
	logInfo.dataSource = self;
	logInfo.scrollEnabled = NO;
	logInfo.allowsSelection = NO;
    logInfo.clipsToBounds   = YES;
	logInfo.separatorColor = kLoginAndSignupCellLineColor;
    
	[self.view addSubview:logInfo];
    //UITextField *resetTextFiled = [[UITextField alloc]initWithCoder:nil];
    self.reSetPwdcell.hidden = YES;
    CGRect rect = logInfo.frame;
    logInfo.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+100.f);
    gnv = [AppMainUIViewManage sharedAppNavigationController];//self.navigationController; 
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
	
	 UITableView *cell = nil;
    
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
			[(LabelFieldCell *)cell setLabelName:NSLocalizedString(@"Nickmame", @"")];
			[(LabelFieldCell *)cell setFieldTextFont:kLoginAndSignupInputTextFont];
            [(LabelFieldCell *)cell setFieldTextColor:kLoginAndSignupInputTextColor];
			[((LabelFieldCell*)cell).cellName setRoundType:1];
			((LabelFieldCell *)cell).cellField.keyboardType = UIKeyboardTypeEmailAddress;
			((LabelFieldCell *)cell).cellField.returnKeyType = UIReturnKeyNext;
			((LabelFieldCell *)cell).cellField.tag = //kLoginAccountCell;
			((LabelFieldCell *)cell).cellField.placeholder = NSLocalizedString(@"4to30character", @"");
            NSString *nickname = [self.resignData objectForKey:@"uname"];
            if(!nickname){
                nickname = @"";
            }
			((LabelFieldCell *)cell).cellField.text = nickname;
			break;
		case 1:
			[(LabelFieldCell *)cell setLabelTextFont:kLoginAndSignupHintTextFont];
			[(LabelFieldCell *)cell setLabelTextColor:kLoginAndSignupHintTextColor];
			[(LabelFieldCell *)cell setLabelName:NSLocalizedString(@"Email", @"")];
			[(LabelFieldCell *)cell setFieldTextFont:kLoginAndSignupInputTextFont];
            [(LabelFieldCell *)cell setFieldTextColor:kLoginAndSignupInputTextColor];
			
			((LabelFieldCell *)cell).cellField.keyboardType = UIKeyboardTypeDefault;
			((LabelFieldCell *)cell).cellField.returnKeyType = UIReturnKeyNext;
			((LabelFieldCell *)cell).cellField.secureTextEntry = NO;
			((LabelFieldCell *)cell).cellField.tag = //kLoginPasswordCell;
            ((LabelFieldCell *)cell).cellField.placeholder = @"example@hotmail.com";
            NSString *email = [self.resignData objectForKey:@"email"];
            if(!email){
                email = @"";
            }
			((LabelFieldCell *)cell).cellField.text = email ;
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
			//((LabelFieldCell *)cell).cellField.tag = //kLoginPasswordCell;
            ((LabelFieldCell *)cell).cellField.placeholder = NSLocalizedString(@"6to16character", @"");
            NSString *value = [self.resignData objectForKey:@"pass"];
            if(!value)
            {
                value = @"";
            }
			((LabelFieldCell *)cell).cellField.text = value ;
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
       
       cell = (LabelImageCell*)[tableView dequeueReusableCellWithIdentifier:@"imageLabelCell"];
        if (cell == nil) 
        {
            cell = [[LabelImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LabelTextFieldCell];
            [cell setTouchDelegate:self];
            ((LabelImageCell*)cell).cellLabel.text = NSLocalizedString(@"选择上传你的头像", @"");
            ((LabelImageCell*)cell).cellLabel.textColor = kLoginAndSignupInputTextColor;
        }
        ((LabelImageCell*)cell).cellImage.frame = CGRectOffset([cell cellImage].frame, 8.5, 8.5);
        UIImage *image = [self.resignData objectForKey:@"avatar"];
        if(image)
        {
            [((LabelImageCell*)cell).cellImage setImage:image];
        }
        
    }
    //cell.selectionStyle  =UITableViewCellSelectionStyleNone;
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
#pragma mark
#pragma mark uitableView
-(void)didTouchEvent:(id)sender
{
    [self shouldActionSheetChoose:0];
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
#pragma mark user image pick
-(void)shouldActionSheetChoose:(NSInteger)type
{
// id obj = [ntf object];
//[AppMainUIViewManage sharedAppNavigationController];
switch (type) 
{
    case 0:{
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" 
                                                                delegate:self 
                                                       cancelButtonTitle:NSLocalizedString(@"Cancel",@"")
                                                  destructiveButtonTitle:nil otherButtonTitles:
                                      NSLocalizedString(@"From Camera",@""),
                                      NSLocalizedString(@"From Album" ,@"")
                                      ,nil];
        actionSheet.delegate = self;
        actionSheet.backgroundColor= [UIColor clearColor];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        //[actionSheet addButtonWithTitle:NSLocalizedString(@"From Camera",@"")];
        //[actionSheet addButtonWithTitle:NSLocalizedString(@"From Album" ,@"")];
        //[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel",@"")];
        [actionSheet showInView:gnv.view];
        [actionSheet autorelease];
    }
        break;
    case 1:
    {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" 
                                                                delegate:self 
                                                       cancelButtonTitle:NSLocalizedString(@"Cancel",@"")
                                                  destructiveButtonTitle:NSLocalizedString(@"Delete",@"") otherButtonTitles:nil,nil];
        actionSheet.delegate = self;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        //[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel",@"")];
        [actionSheet showInView:gnv.view];
        [actionSheet autorelease];
    }
    default:
        break;
}


}
#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if(chooseActionType == 0)
    {
        if (buttonIndex == 2) 
            return;
        
        [self startPhotoPick:buttonIndex];
    }
}
-(void)startPhotoPick:(NSInteger)index
{
    PhotoPickTool *picktool = [PhotoPickTool getSingleTone] ;
    [picktool setControllerDelegate:gnv];
    [picktool setDelegate:self];
    //0 for camera 1 for alblum
    [ZCSNotficationMgr postMSG:kUploadPhotoPickChooseEditMSG obj:[NSNumber numberWithInt:index]];
    
}
-(void)didGetImageData:(id)data
{
    //NE_LOG(@"%@",[data description]);
    
    NSString *fileName = [NSString generateNonce];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           data,@"data",
                           fileName,@"path",nil];
    //[self saveimageData:param];
    [self performSelectorInBackground:@selector(saveimageData:) withObject:param];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Data Processing", @"") networkIndicator:NO];
    //NSData *saveData = UIImageJPEGRepresentation(data,0.9);
#if 0
    CGSize imageSize = CGSizeMake(kPhotoUploadStartImageW, kPhotoUploadStartImageH);
    UIImage *cropImageData = [UIImage_Extend imageCroppedToFitSizeII:imageSize withData:data];
    
    [self replaceScrollerImageViewAtIndex:chooseImageIndex withImageData:cropImageData];
#endif
    
    /*
     PhotoUploadStartViewController *phUpStartVC = [[PhotoUploadStartViewController alloc]init];
     phUpStartVC.scrollPages = [NSArray arrayWithObject:cropImageData];
     [self.navigationController pushViewController:phUpStartVC animated:YES];
     [phUpStartVC release];
     */
}
-(void)saveimageData:(NSDictionary*)param
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    //ZCSDataArchiveMgr *dataArchive = [[ZCSDataArchiveMgr alloc]init];// [ZCSDataArchiveMgr getSingleTone];
    DBManage *dbMgr =[DBManage getSingleTone];
    NSString *fileName = [param objectForKey:@"path"];
    BOOL saveOK = [dbMgr  saveUserImageTolocalPath:[param objectForKey:@"data"] 
                                        withFileName:fileName];
    if(saveOK)
        [self performSelectorOnMainThread:@selector(didSaveImagePath:) withObject:fileName waitUntilDone:YES];
    [pool    release];
}
-(void)didSaveImagePath:(NSString*)fileName
{
    self.imagePath = [NTESMBUtility filePathInDocumentsDirectoryForFileName:fileName];
    LabelImageCell *cell = (LabelImageCell*)[logInfo  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    UIImage *image = nil;
    UIImageWithFullPathName(image, self.imagePath);
    /*
    UIImage *scaleImage = [UIImage_Extend imageScaleToFitSize:CGSizeMake(65.f, 65.f) withData:image];
     */
    [cell.cellImage setImage:image];
    [self.resignData setValue:image forKey:@"avatar"];
    [SVProgressHUD dismiss];
}
#pragma mark -
#pragma mark input check 
/**
 1.	提示没有填写昵称      用语：请输入昵称
 2.	提示没有填写邮箱      用语：请输入邮箱
 3.	提示没有设定密码：    用语：请设定密码
 4.	提示昵称太短          用语：昵称太短，最少4个字符
 5.	提示邮箱不符合标准    用语：请输入正确的邮箱地址
 6.	提示密码太短：        用语：密码太短，最少6位
 7.	提示昵称不能包括空格  用语：昵称不包含用空格
 8.	提示密码不能符合规格  用语：密码支持使用半角数字，字符，符号，区分大小写
 */
-(BOOL)checkResignInput
{

    //NSIndex
    /*
     *
     Uname
     Email
     Pass
     Avatar
     */
    LabelFieldCell *cell = (LabelFieldCell*)[logInfo  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *uname = cell.cellField.text;
    if(!uname||[uname isEqualToString:@""])
    {
        [self alertMsg:NSLocalizedString(@"Please input resign nickname", @"")]; 
        [cell.cellField becomeFirstResponder];
        return NO;
    }
    else
    {
        if([uname length]<4)
        {
        
            [self alertMsg:NSLocalizedString(@"昵称太短，最少4个字符", @"")]; 
            [cell.cellField becomeFirstResponder];
            return NO;
        
        }
        if([uname rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].length)
        {
        
            [self alertMsg:NSLocalizedString(@"昵称不能含有空格", @"")]; 
            [cell.cellField becomeFirstResponder];
            return NO;
        }
    
    }
    [self.resignData setValue:uname    forKey:@"uname"];
    
    
    cell = (LabelFieldCell*)[logInfo  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *email = cell.cellField.text;
    if(!email||[email isEqualToString:@""])
    {
        [self alertMsg:NSLocalizedString(@"Please input resign account", @"")];
        [cell.cellField becomeFirstResponder];
        return NO;
    }
    else
    {
        
    }
    [self.resignData setValue:email    forKey:@"email"];
    
    
    cell = (LabelFieldCell*)[logInfo  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *pass = cell.cellField.text;
    if(!pass||[pass isEqualToString:@""])
    {
        [self alertMsg:NSLocalizedString(@"Please input resign password", @"")]; 
        [cell.cellField becomeFirstResponder];
        return NO;
    }
    [self.resignData setValue:pass  forKey:@"pass"];
    
    return YES;
}
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
            
			[self resignNow:nil];
			break;
		}
	}
    
}
-(void)resignNow:(id)sender
{
    if(![self checkResignInput])
    {
        return;
    }
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Resign...", @"") networkIndicator:YES];
    /*
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           
                           self.account,@"email",
                           self.password,@"pass",
                           nil];
    */
    ZCSNetClientDataMgr *netClientMgr = [ZCSNetClientDataMgr getSingleTone];
    [netClientMgr  startUserResign:self.resignData];
}
#
@end
