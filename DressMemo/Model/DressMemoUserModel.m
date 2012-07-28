//
//  NTESMBUserModel+DressMemoUserModel_h.m
//  DressMemo
//
//  Created by  on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DressMemoUserModel.h"

@implementation DressMemoUserModel
@synthesize postMemosNumStr;
@synthesize favMemosNumStr;
@synthesize followNumStr;
@synthesize followedNumStr;
@synthesize registerTimeStr;
@synthesize lastLoginTimeStr;
- (id) initWithDictionary:(NSDictionary *) dic
{
    /*
     *[{"uid":"2","uname":"cszhan","pass":"b221e4abf3add54bcd1679e597357d3e","email":"cszhan@163.com","desc":"","avatar":"","city":"","salt":"QS4K","regtime":"1340724647","lasttime":"1340724647","follow":"8","followby":"0","memos":"0","memofavors":"0","unreadnotice":"0"}]}
     */
    self = [super init];
	if (self != nil)
    {
		self.idn = [dic objectForKey:@"uid"];
		self.name = [dic objectForKey:@"email"];
		self.screenName = [dic objectForKey:@"uname"];
		self.userImageURL = [dic objectForKey:@"avatar"];
		self.location = [dic objectForKey:@"city"];
        self.favMemosNumStr = [dic objectForKey:@"memofavors"];
        self.postMemosNumStr = [dic objectForKey:@"memos"];
        self.followNumStr = [dic objectForKey:@"follow"];
        self.followedNumStr = [dic objectForKey:@"follwby"];
        self.registerTimeStr = [dic objectForKey:@"regtime"];
        self.lastLoginTimeStr = [dic objectForKey:@"lasttime"];
	}
	return self;
}
-(void)dealloc{
    self.postMemosNumStr = nil;
    self.favMemosNumStr = nil;
    self.followNumStr = nil;
    self.followedNumStr = nil;
    self.registerTimeStr = nil;
    self.lastLoginTimeStr = nil;
    [super dealloc];
}
@end
