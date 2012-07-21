//
//  TagChooseBrandViewController.m
//  DressMemo
//
//  Created by  on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TagChooseBrandViewController.h"
#import "PhotoUploadXY.h"
#import "UIPickViewDataSourceBase.h"
#import "DBManage.h"
#define kInputTextCount 20
#define TWO_CLASS
static UITextField *subClassInputTextField = nil;
@interface TagChooseBrandViewController ()
@property(nonatomic,retain)UIButton  *classBtn;
@property(nonatomic,retain)UIPickerView *classPickView;
@property(nonatomic,retain)NSArray *data;
@property(nonatomic,retain)NSArray *subData;
@property(nonatomic,retain)NSDictionary *srcData;
@property(nonatomic,retain)NSDictionary *classAllData;
@property(nonatomic,retain)NSString *curentClass;
@property(nonatomic,retain)NSMutableDictionary *tempDict;
@property(nonatomic,assign)BOOL isChangeTag;
@property(nonatomic,retain)UIButton *delBtn;
@property(nonatomic,retain)UIImageView *tagBgView;
@property(nonatomic,retain)UIPickViewDataSourceBase    *pickDataSource;
@property(nonatomic,assign)DressMemoTagButton *srcTagBtn;
//@property(nonatomic,assign)UIView *srcTagInfoView;
//@property(nonatomic,assign)NSString *currentBrand;
@end

@implementation TagChooseBrandViewController
//@synthesize delegate;
@synthesize classBtn;
@synthesize classPickView;
@synthesize data;
@synthesize srcData;
@synthesize curentClass;
@synthesize isChangeTag;
@synthesize tempDict;
@synthesize delBtn;
@synthesize pickDataSource;
@synthesize subData;
@synthesize classAllData;
@synthesize tagBgView;
@synthesize srcTagBtn;
//@synthesize srcTagInfoView;

-(void)dealloc
{
    self.pickDataSource = nil;
    self.tagBgView = nil;
    self.srcData = nil;
    self.data = nil;
    self.delBtn = nil;
    self.tempDict = nil;
    self.classAllData = nil;
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
-(void)setInitSourceData:(NSDictionary*)_srcData
{
    self.srcData = _srcData;
    /*
    self.subData  = [NSMutableArray arrayWithCapacity:[self.srcData count]];
    for(id item in _srcData)
    {
        [self.subData addObject:item];
    }
    */
    
}
-(void)setInitSourceData:(NSDictionary *)_srcData withTagBtn:(DressMemoTagButton*)btn
          // withInforView:(UIView*)view
{
    //self.srcData = _srcData;
    self.tempDict = [NSMutableDictionary dictionaryWithDictionary:_srcData];
    srcTagBtn = btn;
    //srcTagInfoView = view;

}
- (void)initData
{
    DBManage *dbMgr = [DBManage getSingleTone];
    self.classAllData    =  [dbMgr getTagDataById:@"getCats"];
    self.data           =    [self.classAllData allKeys];
    self.tempDict = [NSMutableDictionary dictionary];
}
- (void)addObservers
{
    //UIKeyboardDidHideNotification
    [ZCSNotficationMgr addObserver:self call:@selector(inputKeyBoradViewWillApprear:) msgName:UIKeyboardWillShowNotification];
    [ZCSNotficationMgr addObserver:self call:@selector(inputTextDidChange:) msgName:UITextFieldTextDidChangeNotification];
}
-(void)addKeyValueObserver
{
    [classBtn.titleLabel addObserver:self forKeyPath:@"text" options:0 context:NULL];
    [subClassInputTextField addObserver:self forKeyPath:@"text" options:0 context:NULL];
}
-(void)removeKeyValueObserver
{
    [classBtn.titleLabel removeObserver:self forKeyPath:@"text"];
    [subClassInputTextField removeObserver:self forKeyPath:@"text"];// context:<#(void *)#>
}
- (void)removeObservers{

    [ZCSNotficationMgr removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addKeyValueObserver];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeKeyValueObserver];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRightBtnEnable:NO];
    // Do any additional setup after loading the view.
    CGFloat curHeightY = 0.f;
     UIImage *bgImage= nil;
     UIImageWithFileName(bgImage,@"chosebox.png");
     CGRect rect = CGRectMake(kPhotoUploadBrandChoosePendingX, (102-20.f),bgImage.size.width/kScale, bgImage.size.height/kScale);
     classBtn = [UIBaseFactory forkUIButtonByRect:rect text:NSLocalizedString(@"Choose class",@"") image:bgImage];
    curHeightY = rect.origin.y+classBtn.frame.size.height;
    classBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //classBtn.titleLabel.textColor = ;
    [classBtn setTitleColor:kUploadNoChooseTextColor forState:UIControlStateNormal];
    
    classBtn.titleEdgeInsets = UIEdgeInsetsMake(0.f,kInputTextPenndingX, 0,0.f);
    [classBtn addTarget:self action:@selector(didSelectorClassBtn:) forControlEvents:UIControlEventTouchUpInside];
    classBtn.titleLabel.font =  kUploadPhotoTextFont_SYS_15;
    
 
    NSLog(@"%@",classBtn.titleLabel.text);
    curentClass = classBtn.titleLabel.text;
    
    [self.view addSubview:classBtn];
    
    subClassInputTextField = [[UITextField alloc]initWithFrame:CGRectMake(kPhotoUploadBrandChoosePendingX,curHeightY+kPhotoUploadBrandItemGapH,classBtn.frame.size.width,classBtn.frame.size.height)];
    subClassInputTextField.borderStyle = UITextBorderStyleNone;
    subClassInputTextField.delegate = self;
    subClassInputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    subClassInputTextField.font = kUploadPhotoTextFont_SYS_15;//[UIFont systemFontOfSize:40];
    subClassInputTextField.textColor = kUploadChooseTextColor;
    subClassInputTextField.adjustsFontSizeToFitWidth = NO;
    subClassInputTextField.text = @"";
    subClassInputTextField.returnKeyType = UIReturnKeyDone;
    //UIImage *bgImage = nil;
    UIImageWithFileName(bgImage, @"inputboxL.png");
#if 0
    UIEdgeInsets resizeEdgeInset = UIEdgeInsetsMake(6.f,6.f,0,0);
    if([bgImage respondsToSelector:@selector(resizableImageWithCapInsets:)])
    {
        bgImage =[bgImage resizableImageWithCapInsets:resizeEdgeInset];
        
    }
    else 
    {
        bgImage = [bgImage stretchableImageWithLeftCapWidth:6.f topCapHeight:6.f];
    }
#endif
    subClassInputTextField.background = bgImage;
    UIView *paddingView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,kInputTextPenndingX,bgImage.size.height)] autorelease];
    subClassInputTextField.leftView = paddingView;
    //[paddingView release];
    subClassInputTextField.leftViewMode = UITextFieldViewModeAlways;
    //subClassInputTextField.inputView.bounds = CGRectOffset( subClassInputTextField.inputView.bounds,10.f, 4.f);
    //subClassInputTextField.contentMode = UIViewContentModeCenter;
    subClassInputTextField.placeholder = NSLocalizedString(@"Choose Brand",@"");
    
    //start to init ui from init data
    NSString *selCat = [self.tempDict objectForKey:@"Cats2"];
    if(selCat&&![selCat isEqualToString:@""])
    {
        [classBtn setTitle:selCat forState:UIControlStateNormal];
    }
    else 
    {
        [classBtn setTitle:NSLocalizedString(@"Choose class",@"") forState:UIControlStateNormal];
    }
    NSString *selBrand = [self.tempDict objectForKey:@"Brand"];
    if(selBrand&&![selBrand isEqualToString:@""])
    {
        subClassInputTextField.text = selBrand;
    }
   
    
    [self.view addSubview:subClassInputTextField];
    
    //UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"BG-addtag.png");
    UIImageView *bgImageView = [[UIImageView alloc ]initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0,(534-40)/2.f,bgImage.size.width/kScale, bgImage.size.height/kScale);
    NE_LOGRECT(bgImageView.frame);
    [self.view addSubview:bgImageView];
    [bgImageView release];
    self.tagBgView = bgImageView;
    
    [subClassInputTextField release];
    
    UIImageWithFileName(bgImage,@"delBG.png");
    rect = CGRectMake(kPhotoUploadBrandChoosePendingX,(712.f-40.f)/2.f,bgImage.size.width/kScale, bgImage.size.height/kScale);
    
    self.delBtn = [UIBaseFactory forkUIButtonByRect:rect text:NSLocalizedString(@"Delete", @"") image:bgImage];
    delBtn.titleLabel.font = kAppTextSystemFont(21);
    UIEdgeInsets edgeInset = delBtn.titleEdgeInsets;
    delBtn.titleEdgeInsets = UIEdgeInsetsMake(edgeInset.top, edgeInset.left-10.f, edgeInset.bottom, edgeInset.right-10);
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //delBtn.titleLabel.center = CGPointMake(delBtn.center.x-10,delBtn.center.y);
    [delBtn addTarget:self action:@selector(deleteTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    if(!srcTagBtn)
    {
        bgImageView.hidden = NO;
        delBtn.hidden = YES;
    }
    else 
    {
        bgImageView.hidden = YES;
    }
    [self.view addSubview:delBtn];
    
  
    
    
   
    //self.subData = [
    UIPickViewDataSourceBase    *tempDataSource = [[UIPickViewDataSourceBase alloc]initWithData:self.data];
    
    NSString *key = [self.tempDict objectForKey:@"Cats1"];
    
    if(!key)
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
    selCat = [self.tempDict objectForKey:@"Cats2"]; //[self.srcData objectAtIndex:0];
    if(!selCat)
    {
        [classPickView selectRow:0 inComponent:1 animated:NO]; 
    }
    else 
    {
        for(int i = 0;i<[self.subData count];i++)
        {
            if([selCat isEqualToString:[self.subData objectAtIndex:i]])
            { 
                [classPickView selectRow:i inComponent:1 animated:NO]; 
                break;
            }
        }
    }
    
    //for selector top class
    selCat = [self.tempDict objectForKey:@"Cats1"];
    if(!selCat)
    {
        [classPickView selectRow:0 inComponent:0 animated:NO]; 
    }
    else 
    {
        for(int i = 0;i<[self.data count];i++)
        {
            if([selCat isEqualToString:[self.data objectAtIndex:i]])
            { 
                [classPickView selectRow:i inComponent:0 animated:NO]; 
                break;
            }
        }
    }
    
     [self setCurrentTagData];
    
    [self.view addSubview:classPickView];
    //[classPickView release]
    [classPickView release];
    classPickView.frame = CGRectOffset(classPickView.frame,0,kDeviceScreenHeight-classPickView.frame.size.height-20.f);
    classPickView.hidden = YES;
    
}

-(void)setCurrentTagData
{
    [self.tempDict setValue:classBtn.titleLabel.text   forKey:@"Cats2"];
    [self.tempDict setValue:subClassInputTextField.text  forKey:@"Brand"];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length>kInputTextCount)
    {
        return NO;
    }
    return YES;

}
-(void)inputTextDidChange:(NSNotification*)ntf
{
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}
-(void)setRightBtnEnable:(BOOL)enable
{
    [super setRightBtnEnable:enable];
    if(enable == NO)
    {
        [self setRightTextColor:kUploadTagChoosNavItemRightTextColor];
    }
}

-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change  context:(void*)context
{
    NSLog(@"%@",[tempDict description]);
    //if([[change objectForKey:@"kind"]intValue]== 1)
    NSString *currentClass = [self.tempDict objectForKey:@"Cats2"];
    NSString *currentBrand = [self.tempDict objectForKey:@"Brand"];
    if([currentClass isEqualToString:classBtn.titleLabel.text]&&[currentBrand isEqualToString:subClassInputTextField.text])
    {
        [self setRightBtnEnable:NO];
        //curentClass = classBtn.titleLabel.text;
    }
    else
    {
        [self setRightBtnEnable:YES];
    }
    if([currentBrand isEqualToString:NSLocalizedString(@"Choose class",@"")]||
       [classBtn.titleLabel.text isEqualToString:NSLocalizedString(@"Choose class",@"")])
    {
         [self setRightBtnEnable:NO];
    }
    
}
/*
- (void)didChangeValueForKey:(NSString *)key
{
    //NSLog(@"%@",key);
    
}
*/
- (void)inputKeyBoradViewWillApprear:(NSNotification*)ntf
{
    classPickView.hidden = YES;
}
- (void)initPickView{


}
- (void)didSelectorClassBtn:(id)sender
{
    [self initPickView];
    classPickView.hidden = NO;
    [subClassInputTextField resignFirstResponder];
}
#pragma mark -
#pragma mark inputText delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    int row = [classPickView selectedRowInComponent:0];
    NSString *key = [self.data objectAtIndex:row];
    [self.tempDict setValue:key forKey:@"Cats1"];
    int secondRow = [classPickView selectedRowInComponent:1];
    
    NSString *selText = [self.subData objectAtIndex:secondRow];
    [classBtn setTitle:selText forState:UIControlStateNormal];
     
    //[subClassInputTextField becomeFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
    [textField resignFirstResponder];
    return NO;
  
} 
- (void)viewDidUnload
{
    [super viewDidUnload];
    [self removeKeyValueObserver];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
#pragma mark pickView delegate

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
    return [data  objectAtIndex:row];
#endif

}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
#ifdef TWO_CLASS
    if(component == 0)
    {
        NSString *key = [self.data objectAtIndex:row];
        [self.tempDict setValue:key forKey:@"Cats1"];

        self.subData = [self  getSubDataByKey:key];
        
        [pickDataSource setSubData:self.subData];
        [pickerView  reloadComponent:1];
    }
    if(component == 1)
    {
        
        NSString *selText = [self.subData objectAtIndex:row];
        
        [classBtn setTitle:selText forState:UIControlStateNormal];
        [classBtn setTitleColor:kUploadChooseTextColor forState:UIControlStateNormal];
        
        [subClassInputTextField becomeFirstResponder];
        
    }
#else
    NSString *selText = [data objectAtIndex:row];
    [classBtn setTitle:selText forState:UIControlStateNormal];
    [subClassInputTextField becomeFirstResponder];
#endif
}
#if 0
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel *pickerRowLabel = (UILabel *)view;
    if (pickerRowLabel == nil) 
    {
        // Rule 1: width and height match what the picker view expects.
        //         Change as needed.
        CGRect frame = CGRectMake(0, 0.0, 150/2.f, 44);
        pickerRowLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        // Rule 2: background color is clear. The view is positioned over
        //         the UIPickerView chrome.
        pickerRowLabel.backgroundColor = [UIColor clearColor];
        pickerRowLabel.textColor = kUploadPickViewTextColor;
        pickerRowLabel.textAlignment = UITextAlignmentLeft;
        //pickerRowLabel.font = kUploadPhotoTextFont_SYS_24;
        // Rule 3: view must capture all touches otherwise the cell will highlight,
        //         because the picker view uses a UITableView in its implementation.
        pickerRowLabel.userInteractionEnabled = YES;
    }
    NSString *titleStr = nil;
#ifdef TWO_CLASS
    if(component == 0)
    {
        titleStr  = [self.data objectAtIndex:row];
    }
    else {
        titleStr = [self.subData objectAtIndex:row];
    }
#else   
    return [data  objectAtIndex:row];
#endif
    pickerRowLabel.text = titleStr;
    return pickerRowLabel;

}
#endif
#pragma mark -
#pragma mark set Tag data view action
-(void)setDefaultTagView
{
    //[self setRightBtnEnable:NO];
   // [self  setCurrentTagData];
    [self.tempDict setValue:NSLocalizedString(@"Choose class",@"")  forKey:@"Cats2"];
    [self.tempDict setValue:@"" forKey:@"Brand"];
    
    [classBtn setTitle:NSLocalizedString(@"Choose class",@"") forState:UIControlStateNormal];
    [classBtn setTitleColor:kUploadNoChooseTextColor forState:UIControlStateNormal];
    [subClassInputTextField setText:@""];
    isChangeTag = NO;
    
    delBtn.hidden = YES;
    tagBgView.hidden = NO;
    
}
-(void)doConfirmTagView
{
    [self setRightBtnEnable:NO];
    delBtn.hidden = NO;
    tagBgView.hidden = YES;
    isChangeTag = YES;
    [subClassInputTextField resignFirstResponder];
    classPickView.hidden = YES;
}
-(void)deleteTagBtn:(id)sender
{

#if 1
    if(delegate&&[delegate respondsToSelector:@selector(didDeleteTagBtn:withInforView:)])
    {
        [delegate didDeleteTagBtn:self.srcTagBtn withInforView:nil];
    }
#endif
    [self setDefaultTagView];
    
}
#pragma mark -
#pragma mark top nav item touch event

-(void)didSelectorTopNavItem:(id)navObj
{
    //[super didSelectorTopNavItem:navObj];
    switch ([navObj tag])
	{
		case 0:
        {
#if 0
            if(isChangeTag)
            {
                
                
                // [self makeRealUploadClassData];
                
                for(id item in tempDict)
                {
                    NSLog(@"key:%@,value:%@",item,[tempDict valueForKey:item]);
                }
                
                if(delegate&&[delegate respondsToSelector:@selector(didChangeTagInfo:withData:)])
                {
                    /*
                     NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                     curentClass,@"Cats",
                     subClassInputTextField.text,@"Brand",
                     nil
                     ];
                     */
                    
                    [delegate didChangeTagInfo:self.srcTagBtn withData:tempDict];
                    
                }
                
            }
#endif
            
            [self.navigationController popViewControllerAnimated:YES];// animated:
            
			break;
        }
		case 1:
		{
            
            //return;
            /*
             PlayingMenuViewController *playMenuVc = [[PlayingMenuViewController alloc]init];
             //[self.navigationController pushViewController:playMenuVc animated:YES];
             //[[NSNotificationCenter defaultCenter] postNotificationName: object:playMenuVc];
             [ZCSNotficationMgr postMSG:kPushNewViewController obj:playMenuVc];
             [playMenuVc release];
             */
            [self setCurrentTagData];
            [self doConfirmTagView];
#if 1
           
            // if(isChangeTag)
            {
                
                
                // [self makeRealUploadClassData];
                
                for(id item in tempDict)
                {
                    NSLog(@"key:%@,value:%@",item,[tempDict valueForKey:item]);
                }
                
                if(delegate&&[delegate respondsToSelector:@selector(didChangeTagInfo:withData:)])
                {
                    /*
                     NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                     curentClass,@"Cats",
                     subClassInputTextField.text,@"Brand",
                     nil
                     ];
                     */
                    
                    [delegate didChangeTagInfo:self.srcTagBtn withData:tempDict];
                    
                }
                
            }
            [self.navigationController popViewControllerAnimated:YES];
#else
           
            //curentClass = classBtn.titleLabel.text;
           
#endif
			break;
		}
	}
}
#pragma mark -
#pragma mark  tag data operator

-(NSArray*)getSubDataByKey:(NSString*)key
{
    NSDictionary *subClassDict = [self.classAllData objectForKey:key];
    NSDictionary *subClassItem = [subClassDict objectForKey:@"sub"];
    return [subClassItem allKeys];
}

#pragma mark -
#pragma mark touch event 
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [subClassInputTextField  resignFirstResponder];
    [classPickView setHidden:YES];
}

@end
