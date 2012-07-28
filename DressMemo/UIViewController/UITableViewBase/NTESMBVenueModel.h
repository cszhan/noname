//
//  NTESMBVenueModel.h
//  网易微博iPhone客户端
//	一个地点(POI)的模型
//
//  Created by Wang Cong on 10-11-6.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NTESMBVenueModel : NSObject {
	double geoLong;
	double geoLat;
	NSString *id;
	NSString *name;
	NSString *address;
	NSString *city;
	NSString *province;
	NSString *state;
}
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *state;

@property (nonatomic,assign) double geoLong;
@property (nonatomic,assign) double geoLat;

- (id) initWithDictionary:(NSDictionary *) dic;
@end
