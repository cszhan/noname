//
//  constant.h
//  UMSNSDemo
//
//  Created by Fengfeng Pan on 11-12-10.
//  Copyright (c) 2011年 Realcent. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define IPAD_ONLY 1
//#define K_APPKEY @"4dda1ce1431fe354a900005c"
//#define K_APPKEY @"fake_key"

//app key and secrect
#define K_APPKEY_TENCENT @"71dfe1e3b360414b9bb1ca56ecbe78a9"
#define K_APPSECRET_TENCENT @"6ee001345c9790dd2f21bbd5ab6376b8"

#define K_APPKEY_SINA @"4050204319"
#define K_APPSECRET_SINA @"a6a9c8d0909fbf22f8cad7b8861c4bea"

//#define k_AppID @"173019"
//#define K_APPKEY_Ren @"77d66d3480634e69a6464b275d2e3899"
//#define K_APPSECRET_Ren @"4421e3703ec9425c8b6306368fe12a57"

#define k_AppID_Ren @"173454"
#define K_APPKEY_Ren @"36fbeea271ac4ae09bc1e5d66a8f8339"
#define K_APPSECRET_Ren @"a04942dae53f473298f397506035b543"


#define K_SHARE_DATAMODEL @"K_SHARE_DATAMODEL"


//share platform type
#define K_PLATFORM_Sina @"weibo_sina"
#define K_PLATFORM_RenRen @"weibo_renren"
#define K_PLATFORM_Tencent @"weibo_tencent"

//share model property
#define K_PLATFORM_MODEL_UID @"K_PLATFORM_MODEL_UID"
//#define K_PLATFORM_MODEL_TYPE @"K_PLATFORM_MODEL_TYPE"
#define K_PLATFORM_MODEL_SWITCHON @"K_PLATFORM_MODEL_SWITCHON"
#define K_PLATFORM_MODEL_TOKENKEY @"K_PLATFORM_TOKENKEY"
#define K_PLATFORM_MODEL_TOKENSECRET @"K_PLATFORM_TOKENSECRET"
//only for renren
#define K_PLATFORM_MODEL_ACCESSTOKEN @"accessToken"
#define K_PLATFORM_MODEL_EXPIRETIME  @"expireTime"

//#define K_FRAME_WIDTH 320
//#define K_FRAME_HEIGHT 460
//#define K_NAVBAR_HEIGHT 44

#define K_UPDATEUSER_NOTE @"K_UPDATEUSER_NOTE"
//#define K_CANCELBIND_NOTE @"K_CANCELBIND_NOTE"
#define K_SHARESWITCH_CHANGE @"K_SHARESWITCH_CHANGE"
#define K_SEND_RESULT_NOTE @"K_SEND_RESULT_NOTE"

#ifdef IPAD_ONLY
#define K_FRAME_WIDTH 540
#define K_FRAME_HEIGHT 620
#define K_NAVBAR_HEIGHT 44
#define K_GROUPCELL_GAP 30
#define K_KEYBOARD_HEIGHT 300
#define K_ImageButton_Width 120

#define K_MAINSCREEN_WIDTH 768
#define K_MAINSCREEN_HEIGHT 1024
#else
#define K_FRAME_WIDTH 320
#define K_FRAME_HEIGHT 460
#define K_NAVBAR_HEIGHT 44
#define K_GROUPCELL_GAP 10    
#define K_KEYBOARD_HEIGHT 216
#define K_ImageButton_Width 60

#define K_MAINSCREEN_WIDTH 320
#define K_MAINSCREEN_HEIGHT 480
#endif