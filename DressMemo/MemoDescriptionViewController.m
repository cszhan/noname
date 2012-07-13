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
@property(nonatomic,assign)NSArray *data;
@property(nonatomic,assign) UIButton *classBtn;
@property(nonatomic,assign)BOOL isFromViewUnload;
@property(nonatomic,retain)NSDictionary *imageDataInfor;
@property(nonatomic,assign)BOOL isShowPickView;
@property(nonatomic,assign)int preSelect;
@property(nonatomic,assign)UIButton *preSelectBtn;
@property(nonatomic,retain)UIScrollView *bgScrollerView;
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
-(void)dealloc
{
    self.leftBtn = nil;
    self.rightBtn = nil;
    self.leftText = nil;
    self.rightText = nil;
    self.alldataDict = nil;
    self.bgScrollerView = nil;
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
	UILabel *btnTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, btn.frame.size.width,btn.frame.size.height)];
    btnTextLabel.backgroundColor = [UIColor clearColor];
    //btnTextLabel.center = 
    btnTextLabel.text = NSLocalizedString(@"Return", @"");
    btnTextLabel.textColor = [UIColor whiteColor];
    btnTextLabel.font = kNavgationItemButtonTextFont;
    btnTextLabel.textAlignment = UITextAlignmentCenter;
	
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
	
    
    btnTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, btn.frame.size.width,btn.frame.size.height)];
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
    
    /*
     @"getOccasions",
     @"getEmotions", 
     @"getCountries",
     */
    despTextView.placeholder = NSLocalizedString(@"Description", @"");
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
    UIImageView *bgView = [[UIImageView alloc]initWithImage:bgImage];
    bgView.frame = despTextView.frame;
    bgView.clipsToBounds = YES;
    despTextView.layer.masksToBounds = YES;
    [mainFrameView insertSubview:bgView belowSubview:despTextView];
    //despTextView.layer.contents = (id)bgImage;
    
    pickDataSource = [[UIPickViewDataSourceBase alloc]init];
    
    //pickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = pickDataSource;
    
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
    
    UIScrollView *scrollerView = [[UIScrollView alloc]initWithFrame:
                                  CGRectMake(0.f,kMBAppTopToolBarHeight,kDeviceScreenWidth, kMBAppRealViewHeight)];
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
    btn.titleEdgeInsets = UIEdgeInsetsMake(0.f, 10, 0,0.f);

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
    NSString *selText = [data objectAtIndex:row];
    [setClassBtn setTitle:selText forState:UIControlStateNormal];
    [setClassBtn setTitleColor:kUploadChooseTextColor forState:UIControlStateNormal];
}
-(void)savePrePickViewData
{
    //[preSelectBtn setTitle:selText forState:UIControlStateNormal];
    int selectIndex = [pickerView selectedRowInComponent:0];
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
    switch (index) 
    {
        case 0:
            //[self pickerCountryView];
            data = [[alldataDict objectForKey:@"getCountries"]allKeys];
            //classBtn = 
            break;
        case 1:
            data = [[alldataDict objectForKey:@"getEmotions"]allKeys];
            break;
        case 2:
            data = [[alldataDict objectForKey:@"getOccasions"]allKeys];
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
    [pickDataSource setSourceData:data];
    [pickerView reloadAllComponents];
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
    return [data  objectAtIndex:row];
    
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

            
            NSString *countryValue = nil;
            countryValue = [[self.alldataDict objectForKey:@"getCountries"] objectForKey:self.AddressBtn.titleLabel.text];
            NSString *senceValue = [[self.alldataDict objectForKey:@"getOccasions"] objectForKey:self.senceBtn.titleLabel.text];
            NSString *motionValue = [[self.alldataDict objectForKey:@"getEmotions"] objectForKey:self.motionBtn.titleLabel.text];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  subAddressTextFied.text,@"location",
                                  countryValue,@"countryid",
                                  senceValue,@"occasionid",
                                  motionValue,@"emotionid",
                                  self.despTextView.text,@"desc",
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
@end
