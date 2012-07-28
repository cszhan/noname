//
//  MyProfileViewController.h
//  DressMemo
//
//  Created by  on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UISimpleNetBaseViewController.h"
#import "UINetActiveIndicatorButton.h"
//#import ""

#define  KUserItemLeftPendingX                     18.f/2.f
#define  kUserItemPendingW                         28.f/2.f
typedef enum UserType
{
    USE_SELF,
    USE_OTHER,
}UserType;
@interface MyProfileViewController : UISimpleNetBaseViewController
@property(nonatomic,retain)UIControl *leftBtn;
@property(nonatomic,retain)UIControl *rightBtn;
@property(nonatomic,retain)UIImageView  *userIconView;
@property(nonatomic,retain)UILabel *timeLabel;
@property(nonatomic,retain)UILabel *userNickNameLabel;
@property(nonatomic,retain)UILabel *userDiscriptionLabel;
@property(nonatomic,retain)UITextView *userDiscriptionTextView;
@property(nonatomic,retain)UILabel *userLocaltionLabel;
@property(nonatomic,retain)UIButton *locationTagBtn ;
@property(nonatomic,retain)NSMutableArray *iconBtnArr;
@property(nonatomic,retain)NSString *userId;
@property(nonatomic,retain)NSDictionary *userData;
@property(nonatomic,retain)UINetActiveIndicatorButton *relationBtn;
//@property(nonatomic,retain)NSDictionary *
@end
