//
//  NTESMBVenueModel.m
//  网易微博iPhone客户端
//	一个地点(POI)的模型
//
//  Created by Wang Cong on 10-11-6.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBVenueModel.h"


@implementation NTESMBVenueModel
@synthesize geoLat;
@synthesize geoLong;
@synthesize id;
@synthesize name;
@synthesize address;
@synthesize city;
@synthesize province;
@synthesize state;

- (id) initWithDictionary:(NSDictionary *) dic{
	self = [super init];
	if (self != nil) {
		self.id = [dic objectForKey:@"id"];
		self.name = [dic objectForKey:@"name"];

		self.address = [dic objectForKey:@"address"];
		if ([self.address length]<1) {
			self.address = @"银河系市太阳系区火星外大街42号";
		}
		self.city =  [dic objectForKey:@"city"];
		self.province =  [dic objectForKey:@"province"];
		self.state =  [dic objectForKey:@"state"];

		NSArray *coor = [dic objectForKey:@"coordinates"];
		self.geoLat = [(NSString *)[coor objectAtIndex:0] doubleValue];
		self.geoLong= [(NSString *)[coor objectAtIndex:1] doubleValue];
	}
	return self;
}

@end
