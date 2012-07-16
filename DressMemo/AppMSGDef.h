//
//  AppMSGDef.h
//  DressMemo
//
//  Created by  on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef DressMemo_AppMSGDef_h
#define DressMemo_AppMSGDef_h
/**
 * ZCS net work
 */
#define kZCSNetWorkStart  @"ZCSNetWorkStart"
/**
 * NSNotification object NSDictionary object 
 */
#define kZCSNetWorkOK     @"ZCSNetWorkOk"
#define kZCSNetWorkServerFailed  @"ZCSNetWorkServerFailed"
#define kZCSNetWorkRespondFailed  @"ZCSNetWorkRespondFailed"
#define kZCSNetWorkRequestFailed  @"ZCSNetWorkRequestFailed"
/*
 photo pick 
 */
#define kUploadPhotoPickChooseMSG     @"uploadPhotoPickChooseMSG"
#define kUploadPhotoPickChooseEditMSG @"uploadPhotoPickChooseEditMSG"
#define kUploadActionSheetViewAlertMSG @"uploadActionSheetViewAlertMSG"

/**
 netupload process msg 
 */

#define   kUploadProcessStart @"uploadProcessStart"
#define   kUploadProcessUpdate @"uploadProcessUpdate"
#define   kUploadProcessEnd   @"uploadProcessEnd"



#endif
