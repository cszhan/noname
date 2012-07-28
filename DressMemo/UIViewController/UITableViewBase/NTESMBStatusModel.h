//
//  NTESMBStatusModel.h
//  网易微博iPhone客户端
//	一条微博的模型
//
//  Created by Xu Han Jie on 10-5-26.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESMBUserModel.h"
#import "Status.h"

#import <MapKit/MapKit.h>
#import "NTESMBVenueModel.h"
typedef enum StatusModelType
{
	StatusModel_Root = 0,
	StatusModel_Reply,
}StatusModelType;
@interface NTESMBStatusModel : NSObject <MKAnnotation> {
	NSString *idn;
	NSString *cursorID;
	NSString *replyID;
	NSString *text;
	NTESMBUserModel *user;
	User *homeTimelineUser;
	NSDate *createAt;
	NSDate *orderTime;
	NSNumber *hasPhoto;
	NSString *imageUrl;
	NSString *rootImageUrl;
	NSString *source;
	NSNumber *favorited;
	NSNumber *retweeted;
	NSNumber *retweetedByMe;
	//保存当前内容对应cell的高度，有可能是0
	CGFloat cellHeight;
	CGFloat labelHeight;//label的高度
	CGFloat rootHeight;
	//转发人
	NSString *retweetUsername;
	//comment count
	NSString	*replyCount;
	NSString	*retweetCount;
	NSString	*tweetSource;
	//reply
	/*
	 *in_reply_to_status_id":"-3334373500841821049",
	 "in_reply_to_user_id":"1697405455581465021",
	 "in_reply_to_screen_name":"cszhan",
	 "in_reply_to_user_name":"cszhan",
	 "in_reply_to_status_text":"Good"
	 */
	NSString	*replyUserName;//   in_reply_to_screen_name
	NSString	*replyStatusText;
	BOOL isSeparator;
	double geoLong;
	double geoLat;
	NTESMBVenueModel *venue;
	
	//原文引用
	NSString *rootText;
	NSString *rootUsername;
	NSString *rootReplyCount;//root tweet comment count
	NSString *rootRetweetCount;//root tweet comment count
	NSString *rootTweetId;
	StatusModelType modelType;
	//skipType
	NSMutableDictionary *skipTypeHeightDict;
	//
	NSString	*displayStatusText;
	NSString	*displayRootText;
	int type ;
	//skip tiny image data
	NSData		*imageData;
}
@property(nonatomic,assign) StatusModelType modelType;
@property(nonatomic,retain) NSString *displayStatusText;
@property(nonatomic,retain) NSString *displayRootText;
@property (nonatomic, retain) NSString *idn;
@property (nonatomic, retain) NSString *cursorID;
@property (nonatomic, retain) NSString *replyID;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, retain) NTESMBUserModel *user;
@property (nonatomic, retain) User *homeTimelineUser;
@property (nonatomic, retain) NSDate *createAt;
@property (nonatomic, retain) NSDate *orderTime;
@property (nonatomic, retain) NSNumber *hasPhoto;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *rootImageUrl;
@property (nonatomic, retain) NSNumber *favorited;
@property (nonatomic, retain) NSNumber *retweeted;
@property (nonatomic, retain) NSNumber *retweetedByMe;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat rootHeight;
@property (nonatomic, assign) CGFloat labelHeight;
@property (nonatomic,assign) BOOL isSeparator;
@property (nonatomic, copy) NSString *retweetUsername;
@property (nonatomic,assign) double geoLong;
@property (nonatomic,assign) double geoLat;
@property (nonatomic,retain) NTESMBVenueModel *venue;

@property (nonatomic, copy) NSString *rootText;
@property (nonatomic, copy) NSString *rootUsername;

@property (nonatomic,retain) NSString *replyCount;
@property (nonatomic,retain) NSString  *retweetCount;

@property (nonatomic,retain)  NSString *rootReplyCount;//root tweet comment count
@property (nonatomic,retain)  NSString *rootRetweetCount;//root tweet comment count

@property(nonatomic,retain ) NSString	*tweetSource;
@property(nonatomic,retain) NSString		*rootTweetId;

@property(nonatomic,retain) NSString		*replyUserName;
@property(nonatomic,retain) NSString		*replyStatusText;
@property(nonatomic,retain) NSData		*imageData;

- (id) initWithDictionary:(NSDictionary *) dic;
- (id) initWithStatus:(Status *) status;
- (void) updateStatus:(Status *) status;
- (NSString *) featuredText;
- (NSString *) featuredRootText;
- (NSString *) getNeteaseImageUrl;
- (NSString *) getNeteaseThumbImageUrl;
- (NSString *) getRootImageUrl;
- (NSString *) getRootThumbImageUrl;
- (NSString	*) getNeteaseCommonUrl;
- (void) makeCellHeight:(CGFloat) fontSize;
- (id) initSeparator;

@end
