//
//  DecodeJSONOperation.h
//  网易微博iPhone客户端
//
//  Created by Wang Cong on 10-6-11.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SaveUserToDBOperationDelegate <NSObject>

- (void) userSaved:(NSArray *) array;

@end

@interface NTESMBDecodeJSONOperation : NSOperation {
	id <SaveUserToDBOperationDelegate> delegate;
	NSString * jsonString;
		//要解析从搜索结果返回的信息（搜索的api返回的json结构跟其他timeline API的不一样，需要分别处理）
	BOOL isFromSearchAPI;
}

@property (nonatomic, assign) id <SaveUserToDBOperationDelegate> delegate;
@property (nonatomic, assign) BOOL isFromSearchAPI;

- (id) initWithJSONString:(NSString *) json;
- (NSMutableArray *)getStatusToAdd;

@end
