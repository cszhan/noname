//
//  AppConfig.h
//  DressMemo
//
//  Created by  on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef DressMemo_AppConfig_h
#define DressMemo_AppConfig_h

#define  kNavgationItemButtonTextFont [UIFont systemFontOfSize:15]

#define  kAppTextSystemFont(x) [UIFont systemFontOfSize:x]

#define  kTopNavItemLabelOffSetY  -2.f
#define  kTopNavItemLabelOffsetX  13.f

#define  kInputTextPenndingX      10.f

#define  kUIAlertView(x)  UIAlertView *alertErr = [[[UIAlertView alloc]initWithTitle:nil message:x delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil, nil]autorelease];[alertErr show];

//if all the button is the same ,the offset should be all 0
#define kTabAllItemTextCenterXOffset    @"4,0,-4"
#define kTabAllItemTextCenterYOffset    @"0,0,0"

#define kTabAllItemText                 @"Dress what,Upload,Me"

#define kTabItemTextHeight              12
#define kTabItemTextFont            [UIFont systemFontOfSize:12]


#define kTabCountMax                              3
#define kTabItemImageSubfix                       @"png"


#endif

