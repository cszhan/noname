//
//  RequestCfg.h
//  NeteaseMicroblog
//
//  Created by cszhan on 2/22/11.
//  Copyright 2011 NetEase.com, Inc. All rights reserved.
//

//api source name
#include "NEDebugTool.h"
#define STATUS_SOURCE @"<a href=\"http://t.163.com/mobile/iphone\">iPhone客户端</a>"
#define kMBNetWorkFailedAlert @"网络好像有问题哦"
//encoding gbk
#define NSGBKStringEncoding CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)

// http async signal
#define HTTP_REQUEST_COMPLETE @"HTTP_REQUEST_COMPLETE"
#define HTTP_REQUEST_ERROR @"HTTP_REQUEST_ERROR"
#define UPDATE_NEW_STATUS_COUNT @"UPDATE_NEW_STATUS_COUNT"
#define REFRESH_HOME_PAGE @"REFRESH_HOME_PAGE"

#define REQUEST_DATA_DEBUG
#define REQUEST_DEBUG