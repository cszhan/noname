//
//  UserInforEditViewController.m
//  DressMemo
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserInforEditViewController.h"
#import "LabelRightImageCell.h"
#import "LabelFieldCell.h"
#import "UITextViewInputCell.h"
#import "UserConfig.h"
#import "ResetPasswordViewController.h"
#import "DBManage.h"
#import "PhotoPickTool.h"
#import "UIImage+Extend.h"
#import "AppMainUIViewManage.h"
#import "ZCSNetClientDataMgr.h"
#import "UIPickViewDataSourceBase.h"
#define TWO_CLASS
@interface UserInforEditViewController ()
@property(nonatomic,retain)UIScrollView *bgScrollerView;
@property(nonatomic,assign)CGSize gMainFrameSize;
@property(nonatomic,retain)NSString *imagePath;
@property(nonatomic,retain)NSMutableDictionary *postData ;
@property(nonatomic,retain)NSArray *data;
@property(nonatomic,retain)NSArray *subData;
@property(nonatomic,retain)UIPickerView *classPickView;
@property(nonatomic,retain)UIPickViewDataSourceBase* pickDataSource;
@property(nonatomic,retain)NSString *province;
@property(nonatomic,retain)NSString *city;
@property(nonatomic,assign)UIButton *classBtn;
@property(nonatomic,retain)NSDictionary *classAllData;
@end

@implementation UserInforEditViewController
@synthesize userData;
@synthesize gMainFrameSize;
@synthesize bgScrollerView;
@synthesize imagePath;
@synthesize postData;
@synthesize data;
@synthesize subData;
@synthesize classPickView;
@synthesize pickDataSource;
@synthesize province;
@synthesize city;
@synthesize classBtn;
@synthesize classAllData;
-(void)dealloc{
    self.data = nil;
    self.subData = nil;
    self.userData = nil;
    self.bgScrollerView = nil;
    self.imagePath = nil;
    self.postData = nil;
    self.pickDataSource = nil;
    self.province = nil;
    self.classAllData = nil;
    self.city = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        [self initData];
    }
    return self;
}
-(void)setInitData:(NSDictionary*)data{
    //self.userData = [NSDictionary dictionary];
    //[self.userData setValue:@"" forKey:@"email"];
}
- (void)initData
{
    DBManage *dbMgr = [DBManage getSingleTone];
    self.classAllData    =  [dbMgr getTagDataById:@"getCountries"];
    self.data           =    [self.classAllData allKeys];
    self.postData = [NSMutableDictionary dictionary];
    //self.tempDict = [NSMutableDictionary dictionary];
}
- (void)addObservers{
    [ZCSNotficationMgr addObserver:self call:@selector(didLoginOK:) msgName:kZCSNetWorkOK];
    [ZCSNotficationMgr addObserver:self call:@selector(didLoginFailed:) msgName:
     kZCSNetWorkRespondFailed];
    [ZCSNotficationMgr addObserver:self call:@selector(didLoginFailed:) msgName:kZCSNetWorkRequestFailed];
    [ZCSNotficationMgr addObserver:self call:@selector(inputKeyBoradViewWillApprear:) msgName:UIKeyboardWillShowNotification];
    //[ZCSNotficationMgr addObserver:self call:@selector(inputTextViewWillEdit:) msgName:UITextViewTextDidBeginEditingNotification];
    [ZCSNotficationMgr addObserver:self call:@selector(inputKeyBoradViewWillDisappear:) msgName:UIKeyboardWillHideNotification];
}

- (void)viewDidLoad
{
    //[super viewDidLoad];
    [self setRightTextContent:NSLocalizedString(@"Save", @"")];
    gnv =  [AppMainUIViewManage sharedAppNavigationController];
    logInfo = [[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceScreenWidth,9.f+45*4+196/2.f)
                                           style:UITableViewStyleGrouped];
	//logInfo.contentInset
  
	logInfo.allowsSelectionDuringEditing = NO;
	logInfo.backgroundColor = [UIColor clearColor];
	logInfo.delegate = self;
	logInfo.dataSource = self;
	logInfo.scrollEnabled = NO;
	logInfo.allowsSelection = NO;
    //logInfo.clipsToBounds = YES;
    logInfo.separatorStyle = UITableViewCellSeparatorStyleNone;
	//logInfo.separatorColor = kLoginAndSignupCellLineColor;
    //logInfo.layer.cornerRadius = kLoginViewRadius;
    //CGPoint origin = bgView.frame.origin;
    //bgView.frame = logInfo.frame;
    //logInfo.contentSize = CGSizeMake(bgWidth,bgHeight);
    
    UIScrollView *scrollerView = [[UIScrollView alloc]initWithFrame:
                                  CGRectMake(0.f,kMBAppTopToolBarHeight,kDeviceScreenWidth, kDeviceScreenHeight-kMBAppTopToolBarHeight-kMBAppStatusBar)];
    [scrollerView addSubview:logInfo];
    scrollerView.contentSize = logInfo.frame.size;
    self.bgScrollerView = scrollerView;
    gMainFrameSize = bgScrollerView.frame.size;
    scrollerView.clipsToBounds = YES;
    [self.view addSubview:scrollerView];
    
    
    
    UIPickViewDataSourceBase    *tempDataSource = [[UIPickViewDataSourceBase alloc]initWithData:self.data];
    
    NSString *key = [self.userData objectForKey:@"prov"];
    
    if([key isEqualToString:@"0"])
    {
        key = [self.data objectAtIndex:0];
    }
    //NSString *key = [self.data objectAtIndex:0];
    
    self.subData = [self getSubDataByKey:key];
    
    [tempDataSource setSubData:self.subData];
    
    self.pickDataSource = tempDataSource;
    [tempDataSource release];
    
    classPickView = [[UIPickerView alloc]initWithFrame:CGRectZero];
    classPickView.delegate = self;
    classPickView.showsSelectionIndicator = YES;
    classPickView.dataSource = pickDataSource;
    
    
    //for selector sub class
    self.city = [self.userData objectForKey:@"city"]; //[self.srcData objectAtIndex:0];
    
    //for selector top class
    self.province = [self.userData objectForKey:@"prov"];
    
    if(![self.province isEqualToString:@"0"]&&![self.city isEqualToString:@"0"])
    {
        
        DBManage *dbMgr = [DBManage getSingleTone];
        NSDictionary *provinceData = [dbMgr getTagDataByIdRaw:@"getCountries"];
        //[self.alldataDict objectForKey:@"getCountries"];
        NSDictionary*proviceItem = [provinceData objectForKey:self.province];
        self.province = [proviceItem objectForKey:@"district"];
        NSDictionary *cityDta =  [proviceItem objectForKey:@"sub"];
        
        self.city = [[cityDta objectForKey:city]objectForKey:@"district"];
       
    }
    
    if([self.city isEqualToString:@"0"])
    {
        [classPickView selectRow:0 inComponent:1 animated:NO];
    }
    else
    {
        for(int i = 0;i<[self.subData count];i++)
        {
            if([city isEqualToString:[self.subData objectAtIndex:i]])
            {
                [classPickView selectRow:i inComponent:1 animated:NO];
                break;
            }
        }
    }
    

    if([self.province isEqualToString:@"0"])
    {
        [classPickView selectRow:0 inComponent:0 animated:NO];
    }
    else
    {
        for(int i = 0;i<[self.data count];i++)
        {
            if([self.province isEqualToString:[self.data objectAtIndex:i]])
            {
                [classPickView selectRow:i inComponent:0 animated:NO];
                break;
            }
        }
    }
    [self.view addSubview:classPickView];
    //[classPickView release]
    [classPickView release];
    classPickView.frame = CGRectOffset(classPickView.frame,0,kDeviceScreenHeight-classPickView.frame.size.height-20.f);
    classPickView.hidden = YES;
    
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
	return 4;
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 90.f;
    if(indexPath.row == 2)
        return 94.f;
    
    return  45.f;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//UITableView *cell = nil;
	int index = [indexPath row];
	switch (index)
    {
        case 0:
        {
            LabelRightImageCell *firstCell = [LabelRightImageCell getFromNibFile];
            firstCell.nickNameTextField.font = kAppTextSystemFont(16);
            firstCell.locationTextField.font = kAppTextSystemFont(16);
            firstCell.nickNameTextField.textColor = kUserIconBtnTextColor;
            firstCell.nickNameTextField.returnKeyType = UIReturnKeyNext;
            firstCell.nickNameTextField.delegate = self;
            firstCell.locationTextField.textColor = kUserIconBtnTextColor;
            firstCell.nickNameTextField.text = [self.userData objectForKey:@"uname"];
            
            if(![self.city isEqualToString:@"0"])
            {
                [firstCell.cityBtn setTitle:self.city forState:UIControlStateNormal];
            }
            self.classBtn = firstCell.cityBtn;
            [firstCell.cityBtn addTarget:self action:@selector(didSelectorClassBtn:) forControlEvents:UIControlEventTouchUpInside];
            //firstCell.locationTextField.text = [self.userData objectForKey:@"city"];
            firstCell.seperateVLineView.backgroundColor = kUserUpdateSeperatorLineColor;
            firstCell.seperateHLineView.backgroundColor = kUserUpdateSeperatorLineColor;
            [firstCell.userIconEditBtn addTarget:self action:@selector(didTouchEditButton:) forControlEvents:UIControlEventTouchUpInside];
            //firstCell.nickNameTextField.placeholder = 
            return firstCell;
        }
        break;
        case 1:
        {
            LabelFieldCell *changePassCell = [LabelFieldCell getLabelOnlyCellFromNibFile];
            CGRect rect = changePassCell.cellName.frame;
            changePassCell.cellName.text = [self.userData objectForKey:@"email"];
            changePassCell.cellName.textColor = kUserIconBtnTextColor;
            changePassCell.cellName.font = kAppTextSystemFont(16);
            changePassCell.cellName.frame = CGRectOffset(rect,20.f, 0.f);
            //changePassCell.frame = CGRectMake(, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
            changePassCell.accessoryType = UITableViewCellAccessoryNone;
            //changePassCell.delegate = self;
            return changePassCell;
        }
        break;
        case 2:
        {
            UITextViewInputCell *desTextView = [UITextViewInputCell getFromNibFile];
            desTextView.inputTextView.placeholder = NSLocalizedString(@"描述(限30个字符)", @"");
            desTextView.userInteractionEnabled = YES;
            desTextView.inputTextView.delegate = self;
            desTextView.inputTextView.text = [self.userData objectForKey:@"desc"];
            desTextView.inputTextView.textColor = kUserIconBtnTextColor;
            desTextView.inputTextView.font = kAppTextSystemFont(16);
            desTextView.inputTextView.backgroundColor = [UIColor clearColor];
            desTextView.backgroundColor = [UIColor whiteColor];
            return desTextView;
        }
            break;
        case 3:
        {
        
            LabelFieldCell *changePassCell = [LabelFieldCell getLabelOnlyCellFromNibFile];
            CGRect rect = changePassCell.cellName.frame;
            changePassCell.cellName.textColor = kUserIconBtnTextColor;
            changePassCell.cellName.text = @"修改密码";
            changePassCell.cellName.font = kAppTextSystemFont(16);
            changePassCell.cellName.frame = CGRectOffset(rect,20.f, 0.f);
            changePassCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            changePassCell.delegate = self;
            return changePassCell;
        }
        break;
            

    }
}
-(void)didTouchEvent:(id)sender
{
    
    
    if([sender isKindOfClass:[LabelFieldCell class]]){
        ResetPasswordViewController *resetPwdVc = [[ResetPasswordViewController alloc]init];
        resetPwdVc.userEmail = [self.userData objectForKey:@"email"];
        [self.navigationController pushViewController:resetPwdVc animated:YES];
        [resetPwdVc release];
    }
}
- (void)textViewDidBeginEditing:(UITextView*)textView
{
    UITableViewCell *cellView = [logInfo cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    CGRect rect = [cellView frame];
    NE_LOGRECT(rect);
    [bgScrollerView scrollRectToVisible:rect animated:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    [textView resignFirstResponder];
    //textView.layer.borderColor = [UIColor blackColor].CGColor;
    //textView.layer.borderWidth = 0.0f;
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
			[self updateNow:nil];
			break;
		}
	}
    
}

- (void)inputKeyBoradViewWillApprear:(NSNotification*)ntf
{
    NSLog(@"%@,%@",[[ntf object] description],[[ntf userInfo]description]);
    //despTextView.text 
    //self.bgScrollerView.contentSize 
    
    [self ChangeScrollerContentSize:-216.f];
}
- (void)inputKeyBoradViewWillDisappear:(NSNotification*)ntf
{
    [self ChangeScrollerContentSize:0.f];
}
-(void)ChangeScrollerContentSize:(CGFloat)dy
{
    CGPoint origin = self.bgScrollerView.frame.origin;
    self.bgScrollerView.frame = CGRectMake(origin.x,origin.y,gMainFrameSize.width,gMainFrameSize.height+dy);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
#pragma mark
#pragma mark  image edit uitableView
-(void)didTouchEditButton:(id)sender
{
    //if([sender isKindOfClass:[LabelRightImageCell class]])
        [self shouldActionSheetChoose:0];

}
-(void)shouldActionSheetChoose:(NSInteger)type
{
    // id obj = [ntf object];
    
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
#pragma mark pickView delegate

- (void)didSelectorClassBtn:(id)sender
{
    //[self initPickView];
    classPickView.hidden = NO;
    //[subClassInputTextField resignFirstResponder];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
#ifdef TWO_CLASS
    if(component == 0)
    {
        return  [self.data objectAtIndex:row];
    }
    else {
        return  [self.subData objectAtIndex:row];
    }
#else
    return [self.data  objectAtIndex:row];
#endif
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
#ifdef TWO_CLASS
    if(component == 0)
    {
        NSString *key = [self.data objectAtIndex:row];
        //[self.tempDict setValue:key forKey:@"Cats1"];
        self.subData = [self  getSubDataByKey:key];
        
        [pickDataSource setSubData:self.subData];
        [pickerView  reloadComponent:1];
    }
    if(component == 1)
    {
        
        NSString *selText = [self.subData objectAtIndex:row];
        
        [classBtn setTitle:selText forState:UIControlStateNormal];
        [classBtn setTitleColor:kUserIconBtnTextColor forState:UIControlStateNormal];
        
        //[subClassInputTextField becomeFirstResponder];
        
    }
#else
    NSString *selText = [data objectAtIndex:row];
    [classBtn setTitle:selText forState:UIControlStateNormal];
    [subClassInputTextField becomeFirstResponder];
#endif
}
-(NSArray*)getSubDataByKey:(NSString*)key
{
    NSDictionary *subClassDict = [self.classAllData objectForKey:key];
    NSDictionary *subClassItem = [subClassDict objectForKey:@"sub"];
    return [subClassItem allKeys];
}

#pragma mark image edit message
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
    
    LabelRightImageCell *cell = (LabelRightImageCell*)[logInfo  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIImage *image = nil;
    UIImageWithFullPathName(image, self.imagePath);
    
    UIImage *scaleImage = [UIImage_Extend imageScaleToFitSize:CGSizeMake(300.f, 300.f) withData:image];
    
    [cell.userIconImageView setImage:scaleImage];
    //[cell.textLabel setText:@""];
    [self.postData setValue:scaleImage forKey:@"avatar"];
    [SVProgressHUD dismiss];
}
#pragma mark request
-(BOOL)checkResignInput
{
    
    LabelRightImageCell *cell = (LabelRightImageCell*)[logInfo  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *uname = cell.nickNameTextField.text;
    if(!uname||[uname isEqualToString:@""])
    {
        [self alertMsg:NSLocalizedString(@"昵称不能为空", @"")]; 
        [cell.nickNameTextField becomeFirstResponder];
        return NO;
    }
    else
    {
        if([uname length]<4)
        {
            
            [self alertMsg:NSLocalizedString(@"昵称太短，最少4个字符", @"")]; 
            [cell.nickNameTextField becomeFirstResponder];
            return NO;
            
        }
        if([uname rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].length)
        {
            
            [self alertMsg:NSLocalizedString(@"昵称不能含有空格", @"")]; 
            [cell.nickNameTextField becomeFirstResponder];
            return NO;
        }
        
    }
    [self.postData setValue:cell.nickNameTextField.text forKey:@"unname"];
    [self.postData setValue:cell.locationTextField.text forKey:@"city"];
    UITextViewInputCell *desCell = (UITextViewInputCell*)[logInfo  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [self.postData setValue:desCell.inputTextView.text forKey:@"desc"];
    return YES;
}
-(void)updateNow:(id)sender
{
   // self.postData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    
                     
    if(![self checkResignInput])
    {
        return;
    }
    [self.postData setValue:[self.userData objectForKey:@"email"] forKey:@"email"];
#if 0
    if([[self.postData objectForKey:@"avatar"]isKindOfClass:[UIImage class]])
    {
        [postData setValue:[self.userData objectForKey:@"avatar"] forKey:@"avatar"];  
    }
#endif
    kNetStartShow(NSLocalizedString(@"资料更新中...", @""),self.view);
    
    ZCSNetClientDataMgr *netClientMgr = [ZCSNetClientDataMgr getSingleTone];
    [netClientMgr  userInforUpdate:self.postData];
    
}

#pragma mark net respond
-(void)didNetOK:(NSNotification*)ntf
{
    
    id obj = [ntf object];
    id request = [obj objectForKey:@"request"];
    id data = [obj objectForKey:@"data"];
    NSString *resKey = [request resourceKey];
    if([resKey isEqualToString:@"update"])
    {
       
        [SVProgressHUD dismissWithStatus:NSLocalizedString(@"资料已更新",@"") error:NO];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}
/*
 *
 3.	邮箱不正确       用语：该用户名尚未注册
 4.	密码不正确       用语：密码不正确
 5。不是正确的email
 */
-(void)didLoginFailed:(NSNotification*)ntf
{
    kNetEnd(self.view);
    //self.view.userInteractionEnabled = YES;
}
@end
