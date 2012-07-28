//
//  NTESMBUserModel.h
//  网易微博iPhone客户端
//	一个用户的模型
//
//  Created by Xu Han Jie on 10-5-26.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


@interface NTESMBUserModel : NSObject {
	NSString *idn;
	NSString *name;
	NSString *screenName;
	NSString *userImageURL;
	NSData   *userImageData;
	NSString *info;
	NSArray *iTagArr;
	BOOL   imanTag;  
	//only for json
	NSString *location;
}

+(id)sharedUserModel;
@property (nonatomic, retain) NSString *idn;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, copy) NSString *userImageURL;
@property (nonatomic, readonly) NSArray *iTagArr;
@property (nonatomic, retain) NSData *userImageData;
@property (nonatomic, copy) NSString *info;
@property (nonatomic,assign) BOOL imanTag;
@property (copy)NSString *location;

- (id) initWithDictionary:(NSDictionary *) dic;
- (id) initWithSearchDictionary:(NSDictionary *) dic;
- (id) initWithUserData:(User *) user;
- (void) updateUser:(User *) user;
-(void)clearSharedUserModel;
@end
