//
//  LoginAndSignupConfig.h
//  DressMemo
//
//  Created by  on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef DressMemo_LoginAndSignupConfig_h
#define DressMemo_LoginAndSignupConfig_h
#import "UIFramework.h"

#define kLoginAndSignupMainLogoStartX                 142.f/2.f
#define kLoginAndSignupMainLogoStartY                 194.f/2.f

#define kLoginAndSignupMainLoginButtonStartY          574.f/2.f
#define kLoginAndSignupMainSignupButtonStartY          698.f/2.f

#define  kLoginCellItemLeftWidth                   40.f
#define  kLoginCellItemLeftBGColor                 [UIColor greenColor]
#define  kLoginAndSignupCellLineColor              HexRGB(170,170,170)
#define  kLoginAndSignupCellImageBGColor           HexRGB(231,231,231)

#define  kLoginAndSignupHintTextColor              [UIColor lightGrayColor]
#define  kLoginAndSignupHintTextFont               [UIFont systemFontOfSize:16]

#define  kLoginAndSignupInputTextColor             [UIColor lightGrayColor]
#define  kLoginAndSignupInputTextFont              [UIFont systemFontOfSize:16]


#define  kRegisterAvatorImagePending                    17.f

#define  kLoginResetPasswardPending                     18.f/2.f

#define  kLoginViewRadius                               5.0

#define  kLoginCellItemHeight                          44.f

#define  kRegisterCellImageItemHeight                  58.f

//
//  LoginConst.h
//  Ebox_Iphone
//
//  Created by pff on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define kScreenHeight 480
#define kScreenWidth 320
#define kStatusBarHeight 20

#define kLogoWidth	148
#define kLogoHeight	207
#define kLogoPlaceX	((kScreenWidth-kLogoWidth)/2)
#define kLogoPlaceY	(58)

#define kLogoSmallWidth 136
#define kLogoSmallHeight 191
#define kLogoSmallPlaceX ((kScreenWidth-kLogoSmallWidth)/2)
#define kLogoSmallPlaceY 35

#define kCloudLogoWidth kScreenWidth
#define kCloudLogoHeight 117
#define kCloudLogoPlaceY ((460-kCloudLogoHeight))

#define kTableCellTableGap 10
#define kTableCellTableXGap 10
#define kTableLogoGap 20

#define kTableWidth	(280+kTableCellTableXGap*2)
#define kTablePlaceX (kScreenWidth-kTableWidth)/2
#define kTablePlaceY (kLogoSmallPlaceY+kLogoSmallHeight-kTableCellTableGap+kTableLogoGap)
#define kTableCellHeight 44
#define kTableHeight (kTableCellHeight*2+kTableCellTableGap*2)

#define kTableCellButtonGap 15

#define kLoginButtonWidth 282
#define kLoginButtonHeight 40
#define kLoginButtonPlaceX (kScreenWidth-kLoginButtonWidth)/2
#define kLoginButtonPlaceY (kTablePlaceY+kTableHeight-kTableCellTableGap+kTableCellButtonGap)

#define kButtonGap 8
#define kRegButtonPlaceY (kLoginButtonPlaceY+kLoginButtonHeight+kButtonGap)

#define kEmailNoteButtonGap 6
#define kEmailNoteWidth 300
#define kEmailNoteHeight 11
#define kEmailNotePlaceX	34
#define kEmailNotePlaceY (kTablePlaceY+kTableCellTableGap-kEmailNoteHeight-kEmailNoteButtonGap)	



#define kOutOfFrame 2000

#define kKeyBoardHeight 216

#endif
