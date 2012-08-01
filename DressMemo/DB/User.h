//
//  User.h
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-6-1.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Status;

@interface User :  NSManagedObject  
{
	Boolean  imanTag;
}

//@property (nonatomic, retain) NSNumber * homeTimelineSinceID;
//@property (nonatomic, retain) NSNumber * homeTimelineMaxID;
@property (nonatomic, retain) NSString * idn;
//@property (nonatomic, retain) NSNumber * followersCount;
@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSString * userImageURL;
//@property (nonatomic, retain) NSNumber * friendsCount;
//@property (nonatomic, retain) NSNumber * statusCount;
//@property (nonatomic, retain) NSNumber * favoritesCount;
@property (nonatomic, retain) NSData * userImageData;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, assign) Boolean  imanTag;
//@property (nonatomic, retain) NSSet* homeStatus;
//@property (nonatomic, retain) NSSet* status;

@end


//@interface User (CoreDataGeneratedAccessors)
//- (void)addHomeStatusObject:(Status *)value;
//- (void)removeHomeStatusObject:(Status *)value;
//- (void)addHomeStatus:(NSSet *)value;
//- (void)removeHomeStatus:(NSSet *)value;
//
//- (void)addStatusObject:(Status *)value;
//- (void)removeStatusObject:(Status *)value;
//- (void)addStatus:(NSSet *)value;
//- (void)removeStatus:(NSSet *)value;
//
//@end

