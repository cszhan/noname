//
//  TagDescriptionViewController.m
//  DressMemo
//
//  Created by  on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MemoDescriptionViewController.h"
#import "DBManage.h"
#import "UIPickViewDataSourceBase.h"
#import "PhotoUploadProcess.h"
#import "PhotoUploadXY.h"
#import <QuartzCore/QuartzCore.h>
@interface MemoDescriptionViewController ()
@property(nonatomic,retain) UIButton *leftBtn;
@property(nonatomic,retain) UIButton *rightBtn;
@property(nonatomic,retain) UILabel *leftText;
@property(nonatomic,retain) UILabel *rightText;
@property(nonatomic,retain) NSMutableDictionary *alldataDict;
@property(nonatomic,retain)UIPickViewDataSourceBase    *pickDataSource;
@property(nonatomic,retain)NSArray *data;
@property(nonatomic,assign) UIButton *classBtn;
@property(nonatomic,assign)BOOL isFromViewUnload;
@property(nonatomic,retain)NSDictionary *imageDataInfor;
@property(nonatomic,assign)BOOL isShowPickView;
@property(nonatomic,assign)int preSelect;
@property(nonatomic,assign)UIButton *preSelectBtn;
@property(nonatomic,retain)UIScrollView *bgScrollerView;
@property(nonatomic,retain)NSArray *subCityData;
//@property(nonatomic,assign)NSDictionary *allSubCityData;
@property(nonatomic,retain)NSString *province;
@property(nonatomic,retain)NSString *city;
@end

@implementation MemoDescriptionViewController
@synthesize  subAddressTextFied;
@synthesize AddressBtn;
@synthesize motionBtn;
@synthesize senceBtn;
@synthesize despTextView;
@synthesize leftBtn;
@synthesize rightBtn;
@synthesize leftText;
@synthesize rightText;
@synthesize pickerView;
@synthesize alldataDict;
@synthesize pickDataSource;
@synthesize data;
@synthesize classBtn;
@synthesize mainFrameView;
@synthesize isFromViewUnload;
@synthesize imageDataInfor;
@synthesize isShowPickView;
@synthesize preSelect;
@synthesize preSelectBtn;
@synthesize bgScrollerView;
@synthesize  gMainFrameSize;
@synthesize subCityData;
@synthesize province;
@synthesize city;
//@synthesize <#property#>
//@synthesize indicatorTextLabel;
-(void)dealloc
{
    self.leftBtn = nil;
    self.rightBtn = nil;
    self.leftText = nil;
    self.rightText = nil;
    self.alldataDict = nil;
    self.bgScrollerView = nil;
    self.subCityData = nil;
    self.province = nil;
    self.city  = nil;
    //self.indicatorTextLabel = nil;
    [ZCSNotficationMgr removeObserver:self];
    self.pickDataSource = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        [self initPickSourceData];
        [ZCSNotficationMgr addObserver:self call:@selector(inputKeyBoradViewWillApprear:) msgName:UIKeyboardWillShowNotification];
        [ZCSNotficationMgr addObserver:self call:@selector(inputTextViewWillEdit:) msgName:UITextViewTextDidBeginEditingNotification];
        [ZCSNotficationMgr addObserver:self call:@selector(inputKeyBoradViewWillDisappear:) msgName:UIKeyboardWillHideNotification];
    }
    return self;
}
-(void)initPickSourceData
{
    self.alldataDict = [NSMutableDictionary dictionary];
    DBManage *dbMgr = [DBManage getSingleTone]; 
    NSArray *resourceArray = [NSArray arrayWithObjects:
                              @"getOccasions",
                              @"getEmotions", 
                              @"getCountries",
                              //@"getCats",
                              nil];
    for(id key in resourceArray)
    {
        [self.alldataDict setValue:[dbMgr getTagDataById:key]forKey:key];
    }
    //the initData
    self.imageDataInfor =  [NSDictionary dictionaryWithObjectsAndKeys:
                            NSLocalizedString(@"", @""),     @"location",
                            NSLocalizedString(@"China", @""),    @"countryid",
                            NSLocalizedString(@"Choose sence", @""),    @"occasionid",
                            NSLocalizedString(@"Choose emotion", @""),   @"emotionid",
                            NSLocalizedString(@"Descripton", @""),           @"desc",
                            nil];
    
    preSelect = -1;
    
}
-(void)awakeFromNib
{
    //[self initTopNavBarViews];
}

- (void)loadView
{
    [super loadView];
  
}

-(void)initTopNavBarViews
{
	//hometimeline navigation Bar 
	[self initHomePageTimelineNavBar:CGRectMake(0.f, 0.f, kDeviceScreenWidth, kMBAppTopToolBarHeight) withIndex:0];
	
}
-(void)initHomePageTimelineNavBar:(CGRect)rect withIndex:(NSInteger)index
{
	//self draw
	NSMutableArray *arr = [NSMutableArray array];
	UIImage  *bgImage = nil;
	//NSString *imgPath = nil;
	/*
	 ＊post blog
	 */
	UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
	/*
	 imgPath = [[NSBundle mainBundle] pathForResource:@"postblog" ofType:@"png"];
	 assert(imgPath);
	 bgImage =  [UIImage imageWithContentsOfFile:imgPath];
	 */
	UIImageWithFileName(bgImage,@"btn-red-back.png");
	//UIImage *bgImageS = nil;
	//UIImageWithFileName(bg
	[btn setBackgroundImage:bgImage forState:UIControlStateNormal];
	UIImageWithFileName(bgImage,@"btn-red-back.png");
	[btn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
	//|UIControlStateHighlighted|UIControlStateSelected
	btn.frame = CGRectMake(kMBAppTopToolXPending,kMBAppTopToolYPending,bgImage.size.width/kScale, bgImage.size.height/kScale);
	//[mainView.mainFramView addSubview:btn];
	NE_LOG(@"btn frame");
	NE_LOGRECT(btn.frame);
	//btn.hidden = YES;
	UILabel *btnTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(kTopNavItemLabelOffsetX,kTopNavItemLabelOffSetY, btn.frame.size.width,btn.frame.size.height)];
    btnTextLabel.backgroundColor = [UIColor clearColor];
    //btnTextLabel.center = 
    btnTextLabel.text = NSLocalizedString(@"Return", @"");
    btnTextLabel.textColor = [UIColor whiteColor];
    btnTextLabel.font = kNavgationItemButtonTextFont;
    btnTextLabel.textAlignment = UITextAlignmentLeft;
    self.leftText = btnTextLabel;
	
    [btn addSubview:btnTextLabel];
	[btnTextLabel release];
    
	
	
	
	[arr addObject:btn];
	self.leftBtn = btn;
	/*
	 * camera
	 */
	btn = [UIButton buttonWithType:UIButtonTypeCustom];
	/*
	 imgPath = [[NSBundle mainBundle] pathForResource:@"camera" ofType:@"png"];
	 assert(imgPath);
	 bgImag =  [UIImage imageWithContentsOfFile:imgPath];
	 */
	//UIImageScaleWithFileName(bgImage,@"camera");
	UIImageWithFileName(bgImage,@"btn-red.png");
	[btn setBackgroundImage:bgImage forState:UIControlStateNormal];
	
	UIImageWithFileName(bgImage,@"btn-red.png");
	[btn setBackgroundImage:bgImage forState:UIControlStateSelected];
	
	//|UIControlStateHighlighted|UIControlStateSelected
	btn.frame = CGRectMake(kDeviceScreenWidth-bgImage.size.width/kScale-kMBAppTopToolXPending,kMBAppTopToolYPending,bgImage.size.width/kScale, bgImage.size.height/kScale);
	[arr addObject:btn];
	self.rightBtn = btn;
	//CGRect rect = CGRectMake(0.f, 0.f, kDeviceScreenWidth, kMBAppTopToolBarHeight);
	
    
    btnTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f,kTopNavItemLabelOffSetY, btn.frame.size.width,btn.frame.size.height)];
    btnTextLabel.backgroundColor = [UIColor clearColor];
    //btnTextLabel.center = 
    btnTextLabel.text = NSLocalizedString(@"Next", @"");
    btnTextLabel.textColor = [UIColor whiteColor];
    btnTextLabel.font = kNavgationItemButtonTextFont;
    btnTextLabel.textAlignment = UITextAlignmentCenter;
    
    self.rightText = btnTextLabel;
    
    [btn addSubview:btnTextLabel];
    [btnTextLabel release];
    
    
    
	UIImageWithFileName(bgImage,@"titlebar.png");
	NETopNavBar  *tempNavBar= [[NETopNavBar alloc]
							   initWithFrame:rect withBgImage:bgImage withBtnArray:arr selIndex:-1];
	
	//tempNavBar.navTitle = ;
	tempNavBar.delegate = self;
	//tempNavBar.navTitle = navBarTitle;
	NE_LOGRECT(tempNavBar.frame);
	//[mainView.topBarView addSubview:tempNavBar];
	//NE_LOG(@"tt:%0x",mainView.topBarView);
	[self.view addSubview:tempNavBar];
	//NE_LOG(@"tt:%0x",tempNavBar);
	//[topBarViewNavItemArr insertObject:tempNavBar atIndex:index];
	[tempNavBar release]; 
	
}
- (void)viewDidLoad
{
    UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"BG-setting.png");
    [self initTopNavBarViews];
    self.view.layer.contents = (id)bgImage.CGImage;
    //despTextView.layer.cornerRadius = 5.f;
    despTextView.delegate = self;
    [self setRightTextContent:NSLocalizedString(@"Upload", @"")];
    
    self.subAddressTextFied.delegate = self;
    UIView *paddingView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,kInputTextPenndingX,subAddressTextFied.frame.size.height)] autorelease];
    subAddressTextFied.leftView = paddingView;
    subAddressTextFied.leftViewMode = UITextFieldViewModeAlways;
    NSArray *viewArr = [self.mainFrameView subviews];
    for(id subView in viewArr)
    {
        if ([subView isKindOfClass:[UILabel class]]) 
        {
            [(UILabel*)subView setTextColor:kUploadChooseTextColor];
        }
    }
    /*
     @"getOccasions",
     @"getEmotions", 
     @"getCountries",
     */
    despTextView.placeholder = NSLocalizedString(@"Description", @"");
    self.despTextView.text = @"";
    UIImageWithFileName(bgImage, @"inputboxL.png");
#if 1
    UIEdgeInsets resizeEdgeInset = UIEdgeInsetsMake(12.f,12.f,12.f,12.f);
    if([bgImage respondsToSelector:@selector(resizableImageWithCapInsets:)]&&1)
    {
        bgImage =[bgImage resizableImageWithCapInsets:resizeEdgeInset];
        
    }
    else 
    {
        bgImage = [bgImage stretchableImageWithLeftCapWidth:12.f topCapHeight:12.f];
    }
#endif
    UIImageView *bgView = [[UIImageView alloc]initWithImage:bgImage];
    bgView.frame = despTextView.frame;
    //bgView.clipsToBounds = YES;
    //despTextView.layer.masksToBounds = YES;
    [mainFrameView insertSubview:bgView belowSubview:despTextView];
    //despTextView.layer.contents = (id)bgImage;
    
    pickDataSource = [[UIPickViewDataSourceBase alloc]init];
    
    //pickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    
    [self.view addSubview:pickerView];
    //[classPickView release]
    [pickerView release];
    //pickerView.frame = CGRectOffset(pickerView.frame,0,kDeviceScreenHeight-pickerView.frame.size.height);
#ifdef PICK_ANIMATION
    pickerView.hidden = NO;
    self.pickerView.frame = CGRectOffset(self.pickerView.frame, 0.f, self.pickerView.frame.size.height);
#else
    self.pickerView.hidden = YES;
#endif
    NE_LOGRECT(pickerView.frame);
    if (isFromViewUnload) 
    {
        self.subAddressTextFied.text = [imageDataInfor objectForKey:@"location"];
        self.AddressBtn.titleLabel.text = [imageDataInfor objectForKey:@"countryid"];
        self.senceBtn.titleLabel.text = [imageDataInfor objectForKey:@"occasionid"];
        self.motionBtn.titleLabel.text = [imageDataInfor objectForKey:@"emotionid"];
        self.despTextView.text = [imageDataInfor objectForKey:@"desc"];
    }
    // Do any additional setup after loading the view from its nib.
    //set color and font
    [self setButtonAttribute:AddressBtn];
    [self setButtonAttribute:motionBtn];
    [self setButtonAttribute:senceBtn];
    NSString *userId= [AppSetting getLoginUserId];
    NSDictionary *userData = [AppSetting getLoginUserInfo:userId];
    if(userData&&!isFromViewUnload)
    {
#if 1
        self.province = [userData objectForKey:@"prov"];
        self.city = [userData objectForKey:@"city"];
#else
        self.province = @"18";
        self.city = @"268";
        
#endif
        if(![self.province isEqualToString:@"0"]&&![self.city isEqualToString:@"0"])
        {
            
            NSString *countryValue = nil;
            DBManage *dbMgr = [DBManage getSingleTone];
            NSDictionary *provinceData = [dbMgr getTagDataByIdRaw:@"getCountries"];
            //[self.alldataDict objectForKey:@"getCountries"];
            NSDictionary*proviceItem = [provinceData objectForKey:self.province];
            self.province = [proviceItem objectForKey:@"district"];
            NSDictionary *cityDta =  [proviceItem objectForKey:@"sub"];
            
            self.city = [[cityDta objectForKey:city]objectForKey:@"district"];
            
            NSDictionary *allSubCityData = [self.alldataDict objectForKey:@"getCountries"];
            //self.data = [allSubCityData objectForKey:self.province];
            //self.subCityData = [];
            [AddressBtn setTitle:self.city forState:UIControlStateNormal];
            [AddressBtn setTitleColor:kUploadChooseTextColor forState:UIControlStateNormal];
        }
        else
        {
             self.province = @"上海";
             self.city = @"上海";
        }
    }
    UIScrollView *scrollerView = [[UIScrollView alloc]initWithFrame:
                                  CGRectMake(0.f,kMBAppTopToolBarHeight,kDeviceScreenWidth, kDeviceScreenHeight-kMBAppTopToolBarHeight-kMBAppStatusBar)];
    [scrollerView addSubview:mainFrameView];
    [mainFrameView release];
    scrollerView.contentSize = mainFrameView.frame.size;
    self.bgScrollerView = scrollerView;
    //self.view = scrollerView;
    mainFrameView.frame = CGRectOffset(mainFrameView.frame, 0,-kMBAppTopToolBarHeight);
    gMainFrameSize = self.mainFrameView.frame.size;
    [self.view insertSubview:scrollerView belowSubview:pickerView];
}
-(void)setButtonAttribute:(UIButton*)btn
{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //btn.titleLabel.textColor = kUploadDataTextColor;
    [btn setTitleColor:kUploadNoChooseTextColor forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0.f,kInputTextPenndingX, 0,0.f);
}
- (void)viewDidUnload
{
    [super viewDidUnload];

    self.subAddressTextFied = nil;
    self.AddressBtn = nil;
    self.motionBtn = nil;
    self.senceBtn = nil;
    self.despTextView = nil;
    
    isFromViewUnload = YES;
    /*
    @synthesize leftBtn;
    @synthesize rightBtn;
    @synthesize leftText;
    @synthesize rightText;
    @synthesize pickerView;
    @synthesize alldataDict;
    @synthesize pickDataSource;
    @synthesize data;
    @synthesize classBtn;
    @synthesize mainFrameView;
    */
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark textField input
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.subAddressTextFied)
    {
    
        [textField resignFirstResponder];
        return NO;
        
    }
    else
    {
        return YES;
    }
}
-(void)inputTextViewWillEdit:(NSNotification*)ntf
{
    [self showPickView:NO]; 
    NSLog(@"%@,%@",[[ntf object] description],[[ntf userInfo]description]);
}
#pragma mark btn action and pickview
//static BOOL isShowPickView;
-(void)setPickerViewBtnStatus:(UIButton*)setClassBtn withIndex:(NSInteger)row
{
    
    NSString *selText = @"";
    if(classBtn == AddressBtn)
    {
        int provIndex = [self.pickerView selectedRowInComponent:0];
        self.province = [self.data objectAtIndex:provIndex];
        //[self.tempDict setValue:key forKey:@"Cats1"];
        NSDictionary *allSubCityData = [alldataDict objectForKey:@"getCountries"];
        self.subCityData = [self  getSubData:allSubCityData byKey:self.province];
        //[pickDataSource setSubData:self.subData];
        //[pickerView  reloadComponent:1];
        selText = [self.subCityData objectAtIndex:row];
        self.city = selText;
    }
    else
    {
        selText = [data objectAtIndex:row];
    }
    [setClassBtn setTitle:selText forState:UIControlStateNormal];
    [setClassBtn setTitleColor:kUploadChooseTextColor forState:UIControlStateNormal];
}
-(void)savePrePickViewData
{
    //[preSelectBtn setTitle:selText forState:UIControlStateNormal];
    int selectIndex = [pickerView selectedRowInComponent:0];
    if([pickerView numberOfComponents]==2)
    {
        selectIndex = [pickerView selectedRowInComponent:1];
    }
    [self setPickerViewBtnStatus:preSelectBtn withIndex:selectIndex];
}
-(IBAction)didTouchButton:(id)sender
{
    //NSArray *data = nil;
    /*
     @"getOccasions",
     @"getEmotions", 
     @"getCountries",
     */
    if(preSelect!= -1)
    {
        [self savePrePickViewData];
    }
    NSInteger index = [sender tag];
    int provIndex = 0;
    int cityIndex = 0;
    switch (index) 
    {
        case 0:
            //[self pickerCountryView];
            if(![self.province isEqualToString:@"0"])
            {
                self.data = [[alldataDict objectForKey:@"getCountries"]allKeys];
                //int i = 0;
                for( provIndex = 0;provIndex<[data count];provIndex++)
                {
                
                    if([[data objectAtIndex:provIndex] isEqualToString:self.province])
                    {
                        break;
                    }
                }
                
                NSDictionary *allSubCityData = [alldataDict objectForKey:@"getCountries"];
                self.subCityData = [self  getSubData:allSubCityData byKey:self.province];
            }
            if(self.city && ![self.city isEqualToString:@"0"])
            {
                for( cityIndex = 0;cityIndex<[subCityData count];cityIndex++)
                {
                    
                    if([[self.subCityData objectAtIndex:cityIndex]isEqualToString:self.city])
                    {
                        break;
                    }
                }
            
            }
            /*
            else
            {
                data = [[alldataDict objectForKey:@"getCountries"]allKeys];
               
                NSDictionary *allSubCityData = [alldataDict objectForKey:@"getCountries"];
                self.subCityData = [self  getSubData:allSubCityData byKey:self.province];
                //[pickDataSource setSubData:self.subData];
                [pickerView  reloadComponent:1];
                return;
            }
            */
            //classBtn =
            break;
        case 1:
            self.data = [[alldataDict objectForKey:@"getEmotions"]allKeys];
            break;
        case 2:
            self.data = [[alldataDict objectForKey:@"getOccasions"]allKeys];
            break;
        default:
            assert(nil);
            break;
    }
    switch (index) 
    {
    case 0:
        //[self pickerCountryView];
        //data = [alldataDict objectForKey:@"getCountries"];
        //[AddressBtn setTint];
        classBtn = AddressBtn;
        break;
    case 1:
        classBtn = motionBtn;
        //data = [alldataDict objectForKey:@"getEmotions"];
        break;
    case 2:
        classBtn = senceBtn;
        //data = [alldataDict objectForKey:@"getOccasions"];
        break;
    default:
        assert(nil);
        break;
    }
    //[pickDataSource setSourceData:data];
    [pickerView reloadAllComponents];
    if(classBtn == AddressBtn)
    {
        [pickerView selectRow:provIndex inComponent:0 animated:NO];
        [pickerView selectRow:cityIndex inComponent:1 animated:NO];
    }
   
    [self showPickView:YES];
    preSelect = [sender tag];
    preSelectBtn = classBtn;

}
-(void)showPickView:(BOOL)isShow
{
    if(isShow)
    {
        [self.despTextView resignFirstResponder];
        [self.subAddressTextFied   resignFirstResponder];
        
        if(isShowPickView)
            return;
#ifdef PICK_ANIMATION
        [UIView animateWithDuration:0.5 animations:^
         {
             pickerView.frame = CGRectOffset(pickerView.frame,0.f,-pickerView.frame.size.height);
             
         }completion:^(BOOL finished)
         {
             isShowPickView = YES;
         }
         ];
#else
        isShowPickView = YES;
        pickerView.hidden = NO;
        [self ChangeScrollerContentSize:-pickerView.frame.size.height];
#endif
        [subAddressTextFied  resignFirstResponder];
        [despTextView resignFirstResponder];
    }
    else 
    {
        if(!isShowPickView)
        {
            return;
        }
#ifdef PICK_ANIMATION
        [UIView animateWithDuration:0.5 animations:^
         {
             pickerView.frame = CGRectOffset(pickerView.frame,0.f,pickerView.frame.size.height);
             
         }completion:^(BOOL finished)
         {
             isShowPickView = NO;
         }
         ];
#else
        [despTextView becomeFirstResponder];
        isShowPickView = NO;
        pickerView.hidden = YES;
#if USE_FRAME
        [self ChangeScrollerContentSize:0];
#endif
#endif
        
    }
}
-(void)ChangeScrollerContentSize:(CGFloat)dy
{
    CGPoint origin = self.bgScrollerView.frame.origin;
    self.bgScrollerView.frame = CGRectMake(origin.x,origin.y,gMainFrameSize.width,gMainFrameSize.height+dy);
}
-(void)setRightTextContent:(NSString*)text
{
    rightText.text = text;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
#pragma mark pickView delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{   
    if(classBtn == AddressBtn)
    {
        if(component == 0)
        {
        
            return [data objectAtIndex:row];
        }
        if(component == 1)
        {
            /*
            NSString *key = [self.data objectAtIndex:<#(NSUInteger)#>]
            self.subCityData = [self getSubData:data byKey:];
             */
            return [self.subCityData objectAtIndex:row];
        }
    }
    return [data  objectAtIndex:row];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(classBtn ==AddressBtn)
    {
        return 2;
    }
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(classBtn ==AddressBtn)
    {
        if(component == 1)
            return [self.subCityData count];
    }
    return [self.data count];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  
#if 0
    switch () 
    {
        case 0:
            //[self pickerCountryView];
            //data = [alldataDict objectForKey:@"getCountries"];
            //[AddressBtn setTint];
            classBtn = AddressBtn;
            break;
        case 1:
            classBtn = motionBtn;
            //data = [alldataDict objectForKey:@"getEmotions"];
            break;
        case 2:
            classBtn = senceBtn;
            //data = [alldataDict objectForKey:@"getOccasions"];
            break;
        default:
            assert(nil);
            break;
    }
#endif
    if(classBtn == AddressBtn&&component ==0)
    {
        self.province = [self.data objectAtIndex:row];
        //[self.tempDict setValue:key forKey:@"Cats1"];
        NSDictionary *allSubCityData = [alldataDict objectForKey:@"getCountries"];
        self.subCityData = [self  getSubData:allSubCityData byKey:self.province];
        //[pickDataSource setSubData:self.subData];
        [pickerView  reloadComponent:1];
        int cityIndex = [pickerView selectedRowInComponent:1];
        [self setPickerViewBtnStatus:classBtn withIndex:cityIndex];
        return ;
    }
    [self setPickerViewBtnStatus:classBtn withIndex:row];
    if(classBtn == senceBtn)
    {
        [self showPickView:NO];
    }
}

#pragma mark -
#pragma mark top nav item touch event

-(void)didSelectorTopNavItem:(id)navObj
{
    //[super didSelectorTopNavItem:navObj];
    switch ([navObj tag])
	{
		case 0:
			[self.navigationController popViewControllerAnimated:YES];// animated:
			break;
		case 1:
		{
            
            
            /*
            NSDictionary *uploadDataDict = [NSDictionary dictionaryWithObjectsAndKeys:@"", nil];
            */
            /*
             @"getOccasions",
             @"getEmotions", 
             @"getCountries",
             */
            self.imageDataInfor = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.subAddressTextFied.text,     @"location",
                                  self.AddressBtn.titleLabel.text,  @"countryid",
                                  self.senceBtn.titleLabel.text,    @"occasionid",
                                  self.motionBtn.titleLabel.text,   @"emotionid",
                                  self.despTextView.text,           @"desc",
                                  nil];
            
            NSString *provValueId = @"0";
            NSString *cityValueId = @"0";
            NSDictionary *provinceData = [self.alldataDict objectForKey:@"getCountries"];
            NSDictionary*provinceItem = [provinceData objectForKey:self.province];
            if(provinceItem)
            {
                provValueId = [provinceItem objectForKey:@"districtid"];
            }
            NSDictionary*secondCityData = [provinceItem objectForKey:@"sub"];
            if(secondCityData)
            {
                NSDictionary *cityItem = [secondCityData objectForKey:self.AddressBtn.titleLabel.text];
                cityValueId = [cityItem objectForKey:@"districtid"];
            }
            
            NSString *senceValue = [[self.alldataDict objectForKey:@"getOccasions"] objectForKey:self.senceBtn.titleLabel.text];
            if(senceValue==nil)
            {
                senceValue = @"0";
            }
            NSString *motionValue = [[self.alldataDict objectForKey:@"getEmotions"] objectForKey:self.motionBtn.titleLabel.text];
            if(motionValue==nil)
            {
                motionValue = @"0";
            }
            NSString *despValue =  self.despTextView.text;
            if(despValue == nil)
            {
                despValue = @"";
            }
            NSString *addressValue = self.subAddressTextFied.text;
            if(addressValue == nil)
            {
                addressValue = @"";
            }
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  addressValue,@"location",
                                  cityValueId,@"city",
                                  provValueId,@"prov",
                                  senceValue,@"occasionid",
                                  motionValue,@"emotionid",
                                  despValue,@"desc",
                                  nil];
            
            PhotoUploadProcess *tagVc = [[PhotoUploadProcess alloc]initWithNibName:nil bundle:nil];
            tagVc.memoPostData = dict;
            
            //[self.navigationController pushViewController:playMenuVc animated:YES];
            //[[NSNotificationCenter defaultCenter] postNotificationName: object:playMenuVc];
#if 0
            [ZCSNotficationMgr postMSG:kPushNewViewController obj:tagVc];
#else
            [self.navigationController pushViewController:tagVc animated:YES];
#endif  
            [tagVc release];
            
            
					break;
		}
	}
}
#pragma mark -
#pragma mark touch event 
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [subAddressTextFied  resignFirstResponder];
    [despTextView resignFirstResponder];
    [self showPickView:NO]; 
}
#pragma mark -
#pragma mark texView delegate (description)

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(preSelect!= -1)
    {
        [self savePrePickViewData];
    }
#if 0
    [UIView animateWithDuration:0.5 animations:
     ^{
     
         self.mainFrameView.frame = CGRectOffset(self.mainFrameView.frame, 0.f, - pickerView.frame.size.height+36.f);
     }
     ];
#else
    [self.bgScrollerView scrollRectToVisible:textView.frame animated:YES];
#endif
    textView.layer.borderColor = [UIColor blackColor].CGColor;
    textView.layer.borderWidth = 0.0f;
    [self showPickView:NO];

}
- (void)textViewDidEndEditing:(UITextView *)textView
{
#if 0
    [UIView animateWithDuration:0.5 animations:
     ^{
         
         self.mainFrameView.frame = CGRectOffset(self.mainFrameView.frame, 0.f, pickerView.frame.size.height-36.f);
     }
     ];
#else
      [self.bgScrollerView scrollRectToVisible:mainFrameView.frame animated:YES];
#endif
    [textView resignFirstResponder];
    //textView.layer.borderColor = [UIColor blackColor].CGColor;
    textView.layer.borderWidth = 0.0f;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"%@",text);
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    else {
        return  YES;
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
#pragma mark getSubCity data
-(NSArray*)getSubData:(NSDictionary*)srcData byKey:(NSString*)key
{
    NSDictionary *subClassDict = [srcData objectForKey:key];
    NSDictionary *subClassItem = [subClassDict objectForKey:@"sub"];
    return [subClassItem allKeys];
}
@end
