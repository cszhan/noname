//
//  ROPublishFeedParam.m
//  UMSNSDemo
//
//  Created by cszhan on 11-12-18.
//  Copyright 2011 Realcent. All rights reserved.
//

#import "ROPublishFeedRequestParam.h"


@implementation ROPublishFeedRequestParam
@synthesize title;
@synthesize text;
@synthesize imageUrl;
-(id)init
{
	if (self = [super init]) {
		self.method = [NSString stringWithFormat:@"feed.publishFeed"];
		//self.page = [NSString stringWithFormat:@"1"];
		//self.count = [NSString stringWithFormat:@"10"];
		self.apiVersion = @"1.0";
	}
	
	return self;
}

-(void)addParamToDictionary:(NSMutableDictionary*)dictionary
{
	if (dictionary == nil) {
		return;
	}
	
	if (self.text) {
		[dictionary setObject:self.text forKey:@"description"];
	}
	
	if (self.imageUrl) 
	{
		[dictionary setObject:self.imageUrl forKey:@"image"];
	}
	if(self.title){
		[dictionary setObject:self.title forKey:@"name"];
	}
	else {
		[dictionary setObject:@" " forKey:@"name"];
	}
	[dictionary setObject:@" " forKey:@"url"];
	//[dictionary setObject:self.userID forKey:@"uid"];
}
-(void)dealloc{
	self.text = nil;
	self.imageUrl = nil;
	self.method = nil;
	self.title = nil;
	[super dealloc];
}
@end
