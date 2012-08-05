//
//  MyProfileViewController.m
//  DressMemo
//
//  Created by  on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ZCSNetClientDataMgr.h"
#import "AppSetting.h"
#import "UserConfig.h"
#import "UIBaseFactory.h"
#import "UIButtonLikeCell.h"
#import <QuartzCore/QuartzCore.h>

#import "UserSettingViewController.h"
#import "UserInforEditViewController.h"

#import "DressMemoViewController.h"
#import "FavDressMemoViewController.h"
#import "FollowedViewController.h"
#import "FollowingViewController.h"
#import "MesssageBoxViewController.h"
#import "DBManage.h"

#import "TDBadgedCell.h"

#import "AppSetting.h"

static NSString *iconFilNameArr[] = 
{@"icon-dress.png",@"icon-like.png",@"icon-following.png",@"icon-follower.png"};
static NSString *iconTextArr[]=
{@"穿着",@"喜欢",@"关注",@"粉丝"};

@interface MyProfileViewController ()
@property(nonatomic,assign) id followRequest;
@property(nonatomic,assign) id unfollowRequest;
//@property(nonatomic,retain)NSDictionary* userData;
@end
@implementation MyProfileViewController
@synthesize leftBtn;
@synthesize rightBtn;
@synthesize userIconView;
@synthesize iconBtnArr;
@synthesize userData;
@synthesize timeLabel;

@synthesize userNickNameLabel;
@synthesize userDiscriptionLabel;
@synthesize userDiscriptionTextView;
@synthesize userLocaltionLabel;
@synthesize locationTagBtn;
@synthesize request;
@synthesize userId;
@synthesize relationBtn;
@synthesize followRequest;
@synthesize unfollowRequest;

-(void)dealloc{
    self.relationBtn = nil;
    self.iconBtnArr = nil;
    self.userIconView = nil;
    self.leftBtn = nil;
    self.rightBtn = nil;
    self.userData = nil;
    self.timeLabel = nil;
    self.userNickNameLabel = nil;
    self.userDiscriptionLabel = nil;
    self.userDiscriptionTextView  = nil;
    self.userLocaltionLabel = nil;
    self.locationTagBtn = nil;
    self.userId = nil;
    //self.userData = nil;
    [super dealloc];
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
    if(!self.isVisitOther)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        /*
         imgPath = [[NSBundle mainBundle] pathForResource:@"postblog" ofType:@"png"];
         assert(imgPath);
         bgImage =  [UIImage imageWithContentsOfFile:imgPath];
         */
        UIImageWithFileName(bgImage,@"btn-box.png");
        //UIImage *bgImageS = nil;
        //UIImageWithFileName(bg
        [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
        UIImageWithFileName(bgImage,@"btn-box.png");
        [btn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
        //|UIControlStateHighlighted|UIControlStateSelected
        btn.frame = CGRectMake(kMBAppTopToolXPending,kMBAppTopToolYPending,bgImage.size.width/kScale, bgImage.size.height/kScale);
        //[mainView.mainFramView addSubview:btn];
        NE_LOG(@"btn frame");
        NE_LOGRECT(btn.frame);
        [arr addObject:btn];
        
        self.leftBtn = btn;
    }
    else
    {
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
        //|UIControlStateHighlighted|UIControlStateSelected
        btn.frame = CGRectMake(kMBAppTopToolXPending,kMBAppTopToolYPending,bgImage.size.width/kScale, bgImage.size.height/kScale);
        //[mainView.mainFramView addSubview:btn];
        NE_LOG(@"btn frame");
        NE_LOGRECT(btn.frame);
        
        [arr addObject:btn];
        self.leftBtn = btn;
        UILabel *btnTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(kTopNavItemLabelOffsetX,kTopNavItemLabelOffSetY, btn.frame.size.width,btn.frame.size.height)];
        btnTextLabel.backgroundColor = [UIColor clearColor];
        //btnTextLabel.center = 
        btnTextLabel.text = NSLocalizedString(@"Return", @"");
        btnTextLabel.textColor = [UIColor whiteColor];
        btnTextLabel.font = kNavgationItemButtonTextFont;
        btnTextLabel.textAlignment = UITextAlignmentLeft;
        //leftText = btnTextLabel;
        [btn addSubview:btnTextLabel];
        [btnTextLabel release];
    }
    if(!self.isVisitOther)
    {
        /*
         * camera
         */
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        /*
         imgPath = [[NSBundle mainBundle] pathForResource:@"camera" ofType:@"png"];
         assert(imgPath);
         bgImag =  [UIImage imageWithContentsOfFile:imgPath];
         */
        //UIImageScaleWithFileName(bgImage,@"camera");
        UIImageWithFileName(bgImage,@"btn-setting.png");
        [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
        /*
         UIImageWithFileName(bgImage,@"btn-red.png");
         [btn setBackgroundImage:bgImage forState:UIControlStateSelected];
         */
        //|UIControlStateHighlighted|UIControlStateSelected
        btn.frame = CGRectMake(kDeviceScreenWidth-bgImage.size.width/kScale-kMBAppTopToolXPending,kMBAppTopToolYPending,bgImage.size.width/kScale, bgImage.size.height/kScale);
        [arr addObject:btn];
        self.rightBtn = btn;
    }
    else 
    {
        UINetActiveIndicatorButton *btn = [UINetActiveIndicatorButton buttonWithType:UIButtonTypeCustom];
        self.relationBtn = btn;
        UIImage *bgImage = nil;
        CGRect rect = CGRectZero;
        NSString *followTag = [self.userData objectForKey:@"status"];
        int relationTag = [followTag intValue];
        if([followTag isEqualToString:@"1"])//followed
        {
            rect = [self setFollowedButtonStatus:bgImage];
            //cell.relationBtn.tag = relationTag
        }
        if([followTag isEqualToString:@"0"])
        {
            rect = [self setUnfollowButtonStaus:bgImage];
        }
      
        self.relationBtn.tag = relationTag;
        self.relationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.relationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f,0.f,0.f,5.f)];
        // self.relationBtn.rowIndex = indexPath.row;
        [self.relationBtn addTarget:self action:@selector(relationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //CGRect rect = CGRectMake(kDeviceScreenWidth-bgImage.size.width/kScale-kMBAppTopToolXPending,kMBAppTopToolYPending,bgImage.size.width/kScale, bgImage.size.height/kScale);
        self.relationBtn.frame = rect;
        [arr addObject:btn];
        
    }
	//CGRect rect = CGRectMake(0.f, 0.f, kDeviceScreenWidth, kMBAppTopToolBarHeight);
	
    
	UIImageWithFileName(bgImage,@"titlebar.png");
	NETopNavBar  *tempNavBar= [[NETopNavBar alloc]
							   initWithFrame:rect withBgImage:bgImage withBtnArray:arr selIndex:-1];
	
	//tempNavBar.navTitle = ;
	tempNavBar.delegate = self;
	//tempNavBar.navTitle = navBarTitle;
	NE_LOGRECT(tempNavBar.frame);
	//[mainView.topBarView addSubview:tempNavBar];
	//NE_LOG(@"tt:%0x",mainView.topBarView);
	mainView.topBarView = tempNavBar;
	//NE_LOG(@"tt:%0x",tempNavBar);
	//[topBarViewNavItemArr insertObject:tempNavBar atIndex:index];
	[tempNavBar release]; 
	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}
-(void)initSubViews
{
    //upload bg image
    UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"BG-user.png");
    UIImageView *userPanelView = [[UIImageView alloc ]initWithImage:bgImage];
    userPanelView.frame = CGRectMake(0,(396-40.f-18)/2,bgImage.size.width/kScale, bgImage.size.height/kScale);
    userPanelView.userInteractionEnabled = YES;
    NE_LOGRECT(userPanelView.frame);
    bgImage = nil;
    //clothe background
    UIImageWithFileName(bgImage,kUserImageDefaultName);
    UIImageView *bgImageView = [[UIImageView alloc ]initWithImage:bgImage];
    bgImageView.frame = CGRectMake(KUserItemLeftPendingX,kUserItemPendingW+kMBAppTopToolBarHeight,bgImage.size.width/kScale, bgImage.size.height/kScale);
    bgImageView.userInteractionEnabled = YES;
    bgImageView.layer.borderWidth = 5.f;
    bgImageView.layer.borderColor = [[UIColor whiteColor]CGColor];
    bgImageView.layer.masksToBounds = NO;
    self.userIconView = bgImageView;
    [self.view addSubview:bgImageView];
    [bgImageView release];
    CGFloat tagOffsetX = self.userIconView.frame.origin.x;
    CGFloat tagOffsetY = self.userIconView.frame.origin.y;
    if(!self.isVisitOther)
    {
        UIImage *bgImage= nil;
        UIImageWithFileName(bgImage,@"btn-usersetting.png");
        CGRect rect = CGRectMake(0,0,bgImage.size.width/kScale, bgImage.size.height/kScale);
        UIButton *classBtn = [UIBaseFactory forkUIButtonByRect:rect text:NSLocalizedString(@"Choose class",@"") image:bgImage];
        CGSize size = self.userIconView.frame.size;
        classBtn.center = CGPointMake(tagOffsetX+(size.width - bgImage.size.width/(2*kScale)),tagOffsetY+(size.height - bgImage.size.height/(2*kScale)));
        [classBtn addTarget:self action:@selector(didTouchEditUserInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
        //classBtn.layer.masksToBounds = YES;
        //classBtn.center = CGPointMake(+size.width,self.userIconView.frame.origin.y+size.height);
        [self.view addSubview:classBtn];
    }
    else 
    {
       

    }
    //four but 
    CGFloat startX = KUserItemLeftPendingX;
    CGFloat startY = KUserItemLeftPendingX;
    self.iconBtnArr = [NSMutableArray  arrayWithCapacity:4];
    
    UIImage *iconImage = nil;
    CGSize btnSize ;
    int tagIndex = -1;
    for(int i = 0;i<2;i++)
    {
        for(int j =0;j<2;j++)
        {
            tagIndex = i*2+j;
            UIButtonLikeCell *btnCell = [UIButtonLikeCell getFromNibFile];
            UIImageWithFileName(iconImage,@"btn-info.png");
            btnCell.layer.contents = (id)[iconImage CGImage];
            btnSize = btnCell.frame.size;
            NSString *fileName = iconFilNameArr[tagIndex];
            UIImageWithFileName(iconImage,fileName);
            btnCell.iconImageView.image = iconImage;
            btnCell.iconImageView.frame = CGRectMake(12.f, 70.f/kScale,iconImage.size.width/kScale, iconImage.size.height/kScale);
            btnCell.labelText.textColor = kUserIconBtnTextColor;
            btnCell.labelText.font = kAppTextSystemFont(11);
            btnCell.labelText.frame = CGRectMake(12.f, 12.f,40.f,20.f);
            btnCell.tag = tagIndex;
            btnCell.labelText.text  = iconTextArr[tagIndex];
            btnCell.touchDelegate = self;
            btnCell.labelCountText.text = @"0";
            btnCell.labelCountText.textColor = kUserIconBtnCountTextColor;
            btnCell.labelCountText.font = kAppTextBoldSystemFont(15);
            
            btnCell.frame = CGRectMake(startX, startY,btnCell.frame.size.width, btnCell.frame.size.height);
            startX = startX+btnSize.width+10.f;
            //[btnCell addT];
            [self.iconBtnArr addObject:btnCell];
            [userPanelView addSubview:btnCell];
        }
        startX  = KUserItemLeftPendingX ;//next round
        startY  = startY+btnSize.height +10.f;
    
    }
    [self.view addSubview:userPanelView];
    [userPanelView release];
    //for nickname and 
    CGFloat startLabelX = KUserItemLeftPendingX+self.userIconView.frame.size.width+kUserItemPendingW;
    CGFloat startLabelY = self.userIconView.frame.origin.y;
    CGRect rect = CGRectMake(startLabelX,startLabelY,427.f/2.f,12.f);
    self.userNickNameLabel  = [UIBaseFactory forkUILabelByRect:rect 
                                                  font:kAppTextSystemFont(12)
                                             textColor:
                       kUserIconBtnTextColor text:@""];
    
    self.userNickNameLabel.text = @"";
    self.userNickNameLabel.textAlignment = UITextAlignmentLeft;
    self.userNickNameLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:userNickNameLabel];
    
    startLabelY = startLabelY + self.userNickNameLabel.frame.size.height+30.f/2.f;
    CGRect desRect = CGRectMake(startLabelX, startLabelY,427.f/2.f,96.f/2.f-12.f);
    
    //for description
#if 0
    self.userDiscriptionTextView = [[[UITextView alloc]initWithFrame:desRect]autorelease];
    self.userDiscriptionTextView.text = @"你好哈阿d拉sdf来dasadafsl卡ds卡sdlj发生；大d赛；发sdj卡sdf干 dkkksadflksdf；旅客机；啊;
    self.userDiscriptionTextView.editable = NO;
    self.userDiscriptionTextView.textColor = kUserIconBtnTextColor;
    self.userDiscriptionTextView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.userDiscriptionTextView];
#else
    self.userDiscriptionLabel  = [UIBaseFactory forkUILabelByRect:desRect 
                                                          font:kAppTextSystemFont(12)
                                                     textColor:
                               kUserIconBtnTextColor text:@""];
    self.userDiscriptionLabel.numberOfLines = 0;
    self.userDiscriptionLabel.textAlignment = UITextAlignmentLeft;
    self.userDiscriptionLabel.text = @"";//@"你好哈阿d拉sdf来dasadafsl卡ds卡sdlj发生；大d赛；发sdj卡sdf干 dkkksadflksdf；旅客机；啊lf大；fkljds；kljsadfkl；jsadf；ljksdfl；jksdfsl；卡f家";
    
    self.userDiscriptionLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.userDiscriptionLabel];
    
#endif
    //for join time 
    rect = CGRectMake(0.f,(776-40)/2.f,kDeviceScreenWidth,46.f);
    self.timeLabel  = [UIBaseFactory forkUILabelByRect:rect 
                                                      font:kAppTextSystemFont(10)
                                                 textColor:kUserIconBtnTextColor
                       text:@""];
    [self.view addSubview:timeLabel];
    //for location 
     startLabelY = startLabelY + self.userDiscriptionLabel.frame.size.height+30.f/2.f;
    //bgImage= nil;
    UIImageWithFileName(bgImage,@"icon-local.png");
    rect = CGRectMake(startLabelX,startLabelY,bgImage.size.width/kScale, bgImage.size.height/kScale);
    self.locationTagBtn = [UIBaseFactory forkUIButtonByRect:rect text:@"" image:bgImage];
    //CGSize size = self.userIconView.frame.size;
    
    //[classBtn addTarget:self action:@selector(didTouchEditUserInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationTagBtn];
    self.locationTagBtn.hidden = YES;
    //location label 
    rect = CGRectMake(startLabelX+bgImage.size.width/kScale+10.f,startLabelY,120.f,12);
    self.userLocaltionLabel  = [UIBaseFactory forkUILabelByRect:rect 
                                                          font:kAppTextSystemFont(12)
                                                     textColor:
                               kUserIconBtnTextColor text:@""];
    
    self.userLocaltionLabel.text = @"";
    self.userLocaltionLabel.textAlignment = UITextAlignmentLeft;
    self.userLocaltionLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:userLocaltionLabel];
    [self initUIViewData];
}
#pragma mark -
#pragma mark set button image
- (CGRect)setFollowedButtonStatus:(UIImage*)bgImage
{
    //UIImage *bgImage = nil;
    UIImageWithFileName(bgImage, @"btn-followed.png");
    [self.relationBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    NSString *str = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Cancel", @""), NSLocalizedString(@"Following", @"")];
    //[self.relationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f,0.f,-10.f,0.f)];
    [self.relationBtn setTitle:str forState:UIControlStateNormal];
    CGRect rect = CGRectMake(kDeviceScreenWidth-bgImage.size.width/kScale-kMBAppTopToolXPending,kMBAppTopToolYPending,bgImage.size.width/kScale, bgImage.size.height/kScale);
    return rect;
    //self.relationBtn.frame = rect;
   // self.relationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
   // [self.relationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f,0.f,0.f,0.f)];
}
- (CGRect)setUnfollowButtonStaus:(UIImage*)bgImage
{
    //UIImage *bgImage = nil;
    UIImageWithFileName(bgImage, @"btn-follow.png");
    [self.relationBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    NSString *str = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Following", @"")];
    [self.relationBtn setTitle:str forState:UIControlStateNormal];
    CGRect rect = CGRectMake(kDeviceScreenWidth-bgImage.size.width/kScale-kMBAppTopToolXPending,kMBAppTopToolYPending,bgImage.size.width/kScale, bgImage.size.height/kScale);
    //return rect;
    return rect;
   // self.relationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //[self.relationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f,0.f,0.f,0.f)];
}
#pragma mark -
#pragma mark set ui view user data
- (void)initUIViewData
{
    self.leftBtn = nil;
    self.rightBtn = nil;
    if(!self.isVisitOther)
    {
        NSString *loginUserId = [AppSetting getLoginUserId];
        if(loginUserId)
        {
            self.userData = [AppSetting getLoginUserDetailInfo:loginUserId];
            [self setUIViewData];
        }
    }
   
}
- (void)setUIViewData
{
    //self.userIconView = nil;
    //self.userData = nil;
    NSString *resignTimeStr = [self.userData objectForKey:@"regtime"];
    NSDate  *resignTime = [NSDate  dateWithTimeIntervalSince1970:[resignTimeStr longLongValue]];
    self.timeLabel.text = [resignTime memoFormatTime:@"YYYY年MM月dd日 加入"];
    self.userNickNameLabel.text = [self.userData objectForKey:@"uname"];
    self.userDiscriptionLabel.text = [self.userData objectForKey:@"desc"];
    UIButtonLikeCell *btn = nil;
    btn = [self.iconBtnArr objectAtIndex:0];
    btn.labelCountText.text = [self.userData objectForKey:@"memos"];
    
    btn = [self.iconBtnArr objectAtIndex:1];
    btn.labelCountText.text = [self.userData objectForKey:@"memofavors"];
    
    btn = [self.iconBtnArr objectAtIndex:2];
    btn.labelCountText.text = [self.userData objectForKey:@"follow"];
    
    btn = [self.iconBtnArr objectAtIndex:3];
    btn.labelCountText.text = [self.userData objectForKey:@"followby"];
    if(!self.isVisitOther)
    {
        //UITabBar
        CGRect rect = self.leftBtn.frame;
        UIImage *bgImage = nil;
         UIImageWithFileName(bgImage, @"inputboxL.png");
#if 1
        UIEdgeInsets resizeEdgeInset = UIEdgeInsetsMake(0.f,25.f,0.f,0.f);
        if([bgImage respondsToSelector:@selector(resizableImageWithCapInsets:)]&&1)
        {
            bgImage =[bgImage resizableImageWithCapInsets:resizeEdgeInset];
            
        }
        else 
        {
            bgImage = [bgImage stretchableImageWithLeftCapWidth:25.f topCapHeight:0.f];
        }
#endif
        //UIImageView *bgView = [[UIImageView alloc]initWithImage:bgImage];
        TDBadgeView *msgView = [[TDBadgeView alloc]initWithFrame:CGRectMake(rect.origin.x+10.f,rect.origin.y+5.f, bgImage.size.width,bgImage.size.height)];
        msgView.badgeNumber = 10;
        [self.leftBtn addSubview:msgView];
    }
    //for localiton
#if 0
    self.userLocaltionLabel.text = [self.userData objectForKey:@"city"];
    if(![self.userLocaltionLabel.text isEqualToString:@"0"])
    {
        self.userLocaltionLabel.hidden = NO;
        self.locationTagBtn.hidden = NO;
    }
#endif
    [self setUserCityData];
    //self.userDiscriptionTextView  = nil;
}
-(void)setUserCityData
{
    DBManage *dbMgr = [DBManage getSingleTone];
    if(self.userData)
    {
        NSDictionary *citData = [dbMgr getCityNameById:[self.userData objectForKey:@"city"] proviceId:[self.userData objectForKey:@"prov"]];
        if([citData objectForKey:@"prov"]&&[citData objectForKey:@"city"])
        {
            self.userLocaltionLabel.text = [citData objectForKey:@"city"];
            self.userLocaltionLabel.hidden = NO;
            self.locationTagBtn.hidden = NO;
            
        }
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelectorInBackground:@selector(getUserInforFromNet) withObject:nil];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.request cancelRequest:<#(NTESMBRequest *)#>]
}
- (void)viewDidLoad

{
    [super viewDidLoad];
    
    UIImage *bgImage = nil;
	UIImageWithFileName(bgImage,@"BG.png");
	//assert(bgImage);
	mainView.bgImage = bgImage;
    [self initSubViews];
    //[self getMyPostMemos];
    
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
#pragma mark user infor edit touch event
-(void)didTouchEditUserInfoBtn:(id)sender
{

    UserInforEditViewController *userEditVc = [[UserInforEditViewController alloc]init];
    userEditVc.userData = self.userData;
    [self.navigationController pushViewController:userEditVc animated:YES];
    [userEditVc release];


}
#pragma mark icon button touch
-(void)didTouchEvent:(id)sender
{
    int index = [sender tag];
    switch (index) 
    {
        case 0://my post memos
        {
            DressMemoViewController *dressMemoVc = [[DressMemoViewController alloc]init];
            dressMemoVc.isVisitOther = self.isVisitOther;
            dressMemoVc.userId = [self.userData objectForKey:@"uid"];
            [self.navigationController pushViewController:dressMemoVc animated:YES];
            [dressMemoVc release];
            
        }
            break;
        case 1:
        {
        
            FavDressMemoViewController *dressMemoVc = [[FavDressMemoViewController alloc]init];
            dressMemoVc.isVisitOther = self.isVisitOther;
            dressMemoVc.userId = [self.userData objectForKey:@"uid"];
            [self.navigationController pushViewController:dressMemoVc animated:YES];
            [dressMemoVc release];
        }
            break;
        case 2://my following
        {
            FollowingViewController *dressMemoVc = [[FollowingViewController alloc]init];
            dressMemoVc.isVisitOther = self.isVisitOther;
            dressMemoVc.userId = [self.userData objectForKey:@"uid"];
            NSInteger count = [((UIButtonLikeCell*)sender).labelCountText.text intValue];
            dressMemoVc.itemCount = count;
            [self.navigationController pushViewController:dressMemoVc animated:YES];
            [dressMemoVc release];
            
        
        }
            break;
        case 3://my followed
        {
            
            FollowedViewController *dressMemoVc = [[FollowedViewController alloc]init];
            dressMemoVc.userId = [self.userData objectForKey:@"uid"];
            NSInteger count = [((UIButtonLikeCell*)sender).labelCountText.text intValue];
            dressMemoVc.itemCount = count;
            dressMemoVc.isVisitOther = self.isVisitOther;
            [self.navigationController pushViewController:dressMemoVc animated:YES];
            [dressMemoVc release];
        
        }
        default:
            break;
    }

}
#pragma mark 
-(void)didSelectorTopNavItem:(id)navObj{
	NE_LOG(@"select item:%d",[navObj tag]);
    if([navObj isKindOfClass:[UINetActiveIndicatorButton class]]){
    
       
        return;
    }
	switch ([navObj tag])
	{
		case 0:
        {
        
            if(self.isVisitOther)
            {
                [self.navigationController popViewControllerAnimated:YES];// animated:
            }
            else //if self it is 
            {
                MesssageBoxViewController *messageVc = [[MesssageBoxViewController alloc]init];
                [self.navigationController pushViewController:messageVc animated:YES];
                [messageVc release];
                //[[NSNotificationCenter defaultCenter] postNotificationName: object:playMenuVc];
                //[ZCSNotficationMgr postMSG:kPushNewViewController obj:playMenuVc];
                //[UserSettingViewController release];
                
            }
        }
			break;
		case 1:
		{
            
			if(self.isVisitOther)
            {
                
                return ;
            
            }
            else 
            {
                UserSettingViewController *playMenuVc = [[UserSettingViewController alloc]init];
                [self.navigationController pushViewController:playMenuVc animated:YES];
                //[[NSNotificationCenter defaultCenter] postNotificationName: object:playMenuVc];
                //[ZCSNotficationMgr postMSG:kPushNewViewController obj:playMenuVc];
                [playMenuVc release];
            }
             
			break;
		}
	}
}
#pragma mark follow and unfollow user action
-(void)relationButtonAction:(id)sender{
    
    switch ([sender tag]) {
        case 1:
            [self unfollowUserAction:sender];
            break;
        case 0:
            [self followUserAction:sender];
            break;
        default:
            break;
    }
    
    
}
-(void)unfollowUserAction:(id)sender
{   
    //int rowIndex = [sender rowIndex];
    NSDictionary *itemData = self.userData;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [itemData objectForKey:@"uid"] ,@"fuid",
                           nil];
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    self.unfollowRequest = [netMgr unfollowUser:param];
    [sender startNetActive];
    //[self.requestDict setValue:request forKey:stringIndexRow]; 
}
-(void)followUserAction:(id)sender
{
    NSDictionary *itemData = self.userData;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [itemData objectForKey:@"uid"] ,@"fuid",
                           nil];
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    // [self.requestDict setValue:[netMgr followUser:param] forKey:[NSString stringWithFormat:@"%d",[sender tag]]]; 
    self.followRequest = [netMgr followUser:param];
    [sender startNetActive];
    //[sender startNetActive];
}
#pragma mark -
#pragma mark -
#pragma mark net request and respond
- (void)getUserInforFromNet
{
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    //NSString *userId = nil;
    if(!self.isVisitOther)
    {
        self.userId = [AppSetting getLoginUserId] ;
    }
    assert(self.userId);
    NSDictionary *param = [NSDictionary dictionaryWithObject:self.userId forKey:@"uid"];
        
    self.request = [netMgr getUserInfor:param];
    
}
-(void)didNetDataOK:(NSNotification*)ntf
{
    //kNetEnd(self.view);
    //NE_LOG(@"warning not implemetation net respond");
    //self.view.userInteractionEnabled = YES;
    id obj = [ntf object];
    id respRequest = [obj objectForKey:@"request"];
    id data = [obj objectForKey:@"data"];
    NSString *resKey = [respRequest resourceKey];
    if(self.request == respRequest&&[resKey isEqualToString:@"getuser"])
    {
        if([data isKindOfClass:[NSDictionary class]])
        {
            self.userData = data;
        }
            
        else if([data isKindOfClass:[NSArray class]])
        {
            self.userData = [data objectAtIndex:0];
        }
        if(self.userData&&!self.isVisitOther)
        {
            [AppSetting setLoginUserDetailInfo:self.userData userId:[AppSetting getLoginUserId]];
        }
        [self setUIViewData];
    }
    UIImage *bgImage = nil;
    if(self.followRequest == respRequest)
    {
        
        [self setFollowedButtonStatus:bgImage];
        self.relationBtn.tag = 1;
        [self.relationBtn stopNetActive];
    }
    if(self.unfollowRequest == respRequest)
    {
        [self setUnfollowButtonStaus:bgImage];
        self.relationBtn.tag = 0;
        [self.relationBtn stopNetActive];
    }
}
-(void)didNetDataFailed:(NSNotification*)ntf
{
    //NE_LOG(@"warning not implemetation net respond");
}
@end
