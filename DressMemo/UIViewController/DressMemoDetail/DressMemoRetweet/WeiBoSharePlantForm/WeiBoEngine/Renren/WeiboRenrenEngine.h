//
//  WeiboRenrenEngine.h
//  UMSNSDemo
//
//  Created by cszhan on 11-12-17.
//  Copyright 2011 Realcent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiBoBaseEngine.h"
#import "Renren.h"
@class ROResponse;
//@protocol RenrenDelegate
@interface WeiboRenrenEngine : WeiBoBaseEngine<RenrenDelegate>{
	Renren *renren;
	NSInteger requestType;
}
@property(nonatomic,assign)UIWebView * webView;
//@property(nonatomic,retain)ROResponse *response;
@property (nonatomic,retain)NSString *accessToken;
@property (nonatomic,retain) NSString *expirationDate;

@end
