//
//  Status.h
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-6-1.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class User;

@interface Status :  NSManagedObject  
{
	double geoLong;
	double geoLat;
	double venueLat;
	double venueLong;
}

@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSNumber * hasPhoto;
@property (nonatomic, retain) NSNumber * retweeted;
@property (nonatomic, retain) NSNumber * retweetedByMe;
@property (nonatomic, retain) NSNumber * favorited;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * idn;
@property (nonatomic, retain) NSString * cursorID;
@property (nonatomic, retain) NSString * replyID;
@property (nonatomic, retain) NSString * retweetUsername;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * orderTime;
@property (nonatomic, retain) User * homeTimelineUser;
@property (nonatomic, retain) User * user;
@property (nonatomic) double geoLong;
@property (nonatomic) double geoLat;
@property (nonatomic) double venueLong;
@property (nonatomic) double venueLat;
@property (nonatomic, retain) NSString *venueID;
@property (nonatomic, retain) NSString *venueName;
@property (nonatomic, retain) NSString *rootText;
@property (nonatomic, retain) NSString *rootUsername;
@property (nonatomic, retain) NSString *replyCount;
@property (nonatomic, retain) NSString *retweetCount;
@property (nonatomic, retain) NSString *rootTweetId;
@end



