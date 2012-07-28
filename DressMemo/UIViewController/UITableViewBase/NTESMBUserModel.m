//
//  NTESMBUserModel.m
//  网易微博iPhone客户端
//	一个用户的模型
//
//  Created by Xu Han Jie on 10-5-26.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBUserModel.h"

static   NTESMBUserModel *sharedUser = nil;
@implementation NTESMBUserModel
@synthesize idn;
@synthesize name;
@synthesize screenName;
@synthesize userImageURL;
@synthesize userImageData;
@synthesize info;
@synthesize location;
@synthesize imanTag;
@synthesize iTagArr;
+(id)sharedUserModel{
	@synchronized(self){
		if(sharedUser == nil){
			sharedUser = [[self alloc]init];
		}
		return sharedUser;
	}
	
}
- (id) initWithDictionary:(NSDictionary *) dic
{
	self = [super init];
	if (self != nil) 
    {
		self.idn = [dic objectForKey:@"id"];//[NTESMBUtility objectToNSNumber:[dic objectForKey:@"id"]];
		self.name = [dic objectForKey:@"name"];
		self.screenName = [dic objectForKey:@"screen_name"];
		NSString *imageUrl = [dic objectForKey:@"profile_image_url"];
		if(![[dic objectForKey:@"sysTag"] isEqual:[NSNull null]]){
			if([dic objectForKey:@"sysTag"]){
			self.imanTag = YES;
			[iTagArr release];
			iTagArr = [[NSArray arrayWithArray:[dic objectForKey:@"sysTag"]] retain];
			}
		}
		else
        {
			self.imanTag = NO;
		}

		if ([imageUrl isEqual:[NSNull null]])
        {
			self.userImageURL = @"";
		}else {
			
			//if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){//4.0
//			imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"w=48&h=48" withString:[NSString stringWithFormat:@"w=%d&h=%d",TIMELINE_CELL_PHOTO_SIZE*2,TIMELINE_CELL_PHOTO_SIZE*2]];
//				/*
//				 http://oimageb3.ydstatic.com/image?w=48&h=48&url=http%3A%2F%2Fmimg.126.net%2Fp%2Fbutter%2F1008031648%2Fimg%2Fface_big.gif
//				 */
//			}
//			else{
//			imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"w=48&h=48"withString:[NSString stringWithFormat:@"w=%d&h=%d",TIMELINE_CELL_PHOTO_SIZE,TIMELINE_CELL_PHOTO_SIZE]];   
//			}
			
			self.userImageURL = imageUrl;
		}
				
		NSString *loc = [dic objectForKey:@"location"];
		if ([loc isEqual:[NSNull null]]) {
			self.location = @"";
		}else {
			self.location = loc;
		}
		
		NSString *_info = [dic objectForKey:@"description"];
		if ([_info isEqual:[NSNull null]]) {
			self.info = @"";
		}else {
			self.info = _info;
		}
	}
	return self;
}

- (id) initWithSearchDictionary:(NSDictionary *) dic
{
	self = [super init];
	if (self != nil) {
		self.idn = [dic objectForKey:@"from_user_id"];
		self.name = [dic objectForKey:@"from_user_name"];
		self.screenName = [dic objectForKey:@"from_user"];
		self.userImageURL = [dic objectForKey:@"profile_image_url"];
		if(![[dic objectForKey:@"sysTag"] isEqual:[NSNull null]]){
			if([dic objectForKey:@"sysTag"]){
				self.imanTag = YES;
				[iTagArr release];
				iTagArr = [[NSArray arrayWithArray:[dic objectForKey:@"sysTag"]] retain];
			}
		}
		else {
			self.imanTag = NO;
		}
		
	}
	return self;
}


- (id) initWithUserData:(User *) user
{
	self = [super init];
	if (self != nil) {
		self.idn = user.idn;
		self.name = user.name;
		self.screenName = user.screenName;
		self.userImageURL = user.userImageURL;
		self.userImageData = user.userImageData;
		self.info = user.info;
		if(user.imanTag == 1){
			self.imanTag = YES;
		}
		else {
			self.imanTag = NO;
		}

	}
	return self;
}

- (void)updateUser:(User *) user
{
	user.idn = idn;
	user.name = name;
	user.screenName = screenName;
	user.userImageURL = userImageURL;
	user.userImageData = userImageData;
	if(imanTag)
		user.imanTag = 1;
	else {
		user.imanTag = 0;
	}
	//用户个人信息用不到，现在不存数据库好了
	//user.info = info;
}
- (void)clearSharedUserModel
{
	self.idn = nil;
	self.name = nil;
	self.screenName = nil;
	self.userImageURL = nil;
	self.userImageData = nil;
	[iTagArr release];
	iTagArr = nil;
	self.info = nil;
}
- (void) dealloc
{
	[idn release];
	[name release];
	[screenName release];
	[userImageURL release];
	[userImageData release];
	[iTagArr release];
	[info release];
	[super dealloc];
}


@end
