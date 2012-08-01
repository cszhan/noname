//
//  DB.h
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-18.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESMBUserModel.h"
#import "NTESMBStatusModel.h"
#import "User.h"
#import "Status.h"
@interface NTESMBDB : NSObject {
	NSManagedObjectContext *context;
	NSFetchRequest *userRequest;
	NSFetchRequest *statusRequest;
}

@property (nonatomic, retain) NSManagedObjectContext *context;

+ (NTESMBDB *) getInstance;

//- (NSArray *) getDataWithID:(NSNumber *) idn entityName:(NSString *) entityName;
//- (NSArray *) allDataWithEntityName:(NSString *) entityName;

//- (NSManagedObject *) getOrInsertObjectWithDictionary:(NSDictionary *) aDic entityName:(NSString *) entityName isExisted:(BOOL *) existed;
//- (NSNumber *) timelineStatusStatusMaxIDWithUser:(User *) u ascending:(BOOL) asc;
//- (NSNumber *) homeTimelineStatusMaxIDWithUser:(User *) u ascending:(BOOL) asc;

- (NSArray *) getAllUser;
- (NSArray *) getAllStatus;
- (void) clearAllData;
- (void) deleteStatusWithStatusModel:(NTESMBStatusModel *) statusModel;

- (Status *) getOrInsertHomeTimelineWithStatusModel:(NTESMBStatusModel *)model isExisted:(BOOL *)existed;
- (Status *) getStatus:(NTESMBStatusModel *)model;
- (User *) getOrInsertUserWithUserModel:(NTESMBUserModel *)model isExisted:(BOOL *)existed;

- (User *) getUserWithScreenName:(NSString *)screenName;
- (User*)getUserById:(NSString*)userId;
- (void) cutHomeTimeline:(User *)user;
- (void) saveToDisk;

@end
