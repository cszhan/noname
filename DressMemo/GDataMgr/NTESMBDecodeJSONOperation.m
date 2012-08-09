//
//  DecodeJSONOperation.m
//  网易微博iPhone客户端
//
//  Created by Wang Cong on 10-6-11.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBDecodeJSONOperation.h"
/*
#import "NTESMBStatusModel.h"
#import "NTESMBUserModel.h"
*/
@implementation NTESMBDecodeJSONOperation
@synthesize delegate;
@synthesize isFromSearchAPI;
- (id) initWithJSONString:(NSString *) json
{
	self = [super init];
	if (self != nil) {
		jsonString= [json retain];
	}
	return self;
}

- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableArray *statusToAdd = [[self getStatusToAdd] retain];
	[delegate userSaved:statusToAdd];
	[statusToAdd release];
	
	[pool release];
}

- (NSMutableArray *)getStatusToAdd{
	NSArray *array = nil;
	id		jsonObj = nil;
	NSMutableArray *statusToAdd = [NSMutableArray array];	
	//NE_LOG(@"ttt:%@",jsonString);
	@try
    {
		jsonObj = [jsonString JSONValue];
		if (isFromSearchAPI == NO)
		{
			
			if([jsonObj isKindOfClass:[NSDictionary class]]){
				if([jsonObj objectForKey:@"error"]){
					return statusToAdd;
				}
			}
			else if([jsonObj isKindOfClass:[NSArray class]]){
				array = (NSArray*)jsonObj;
			}
		}
		else
		{
			if([jsonObj isKindOfClass:[NSDictionary class]]){
				array = [jsonObj objectForKey:@"results"];
			}
			else {
				return statusToAdd;
			}

			
		}
		//if([array objectForKey:@"error"]){
//			return statusToAdd;
//		}
		if([array isEqual:[NSNull null]])
			return statusToAdd;
		
	}
	@catch (NSException * e) {
		NE_LOG(@"exception",e.reason);
		return statusToAdd;
	}	
	NSInteger i = 0;
	for (NSDictionary *statusDic in array)
	{
		/*
		NE_LOG(@"%d",i++);
		NE_LOG(@"%@",[statusDic description]);
		*/
		if([[statusDic objectForKey:@"flag"] isEqualToString:@"DELETED"])
        {
			continue;
		}
		if([[statusDic objectForKey:@"user"]isEqual:[NSNull null]])
        {
			continue;
		}
		@try {
//			NTESMBStatusModel *statusModel = [[NTESMBStatusModel alloc] initWithDictionary:statusDic];
//			NTESMBUserModel *userModel;
//			if (isFromSearchAPI)
//            {
//				userModel = [[NTESMBUserModel alloc] initWithSearchDictionary:statusDic];
//			}else
//            {
//				userModel = [[NTESMBUserModel alloc] initWithDictionary:[statusDic objectForKey:@"user"]];
//			}
//			statusModel.user = userModel;
//			
//			[statusToAdd addObject:statusModel];
//			[statusModel release];
//			[userModel release];
		}
		@catch (NSException * e) {
			
		}

	}
	return statusToAdd;
}
@end
