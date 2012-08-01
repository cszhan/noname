//
//  DB.m
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-18.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//
//#import "XAuthAPI.h"
#import "NTESMBDB.h"
static NTESMBDB *instance = nil;

@implementation NTESMBDB

@synthesize context;

+ (NTESMBDB *) getInstance
{
	@synchronized(self)
    {
		if (instance == nil)
		{
			instance = [[NTESMBDB alloc] init];
		}
	}
	return instance;
}

- (void)setContext:(NSManagedObjectContext *)c{
	context = [c retain];
	//MFMailComposeViewController *  test = [[MFMailComposeViewController alloc]init];
	userRequest = [[NSFetchRequest alloc] init];
	[userRequest setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
	statusRequest = [[NSFetchRequest alloc] init];
	[statusRequest setEntity:[NSEntityDescription entityForName:@"Status" inManagedObjectContext:context]];
	
}

//- (NSArray *) getDataWithID:(NSNumber *) idn entityName:(NSString *) entityName
//{	
//	NSFetchRequest *request = [[NSFetchRequest alloc] init];
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idn = %@", idn];
//	[request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
//	[request setPredicate:predicate];
//	NSArray *arr = [context executeFetchRequest:request error:nil];
//	[request release];
//	return arr;
//}

- (Status *) getOrInsertHomeTimelineWithStatusModel:(NTESMBStatusModel *)model isExisted:(BOOL *)existed
{
	if (model.isSeparator) {
		Status *aObject = (Status *)[NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:context];
		[model updateStatus:aObject];
		//NE_LOG(@"%@",aObject);
		return aObject;
	}
	
	//BOOL e = NO;
	//User *homeTimelineUser = [self getOrInsertUserWithUserModel:model.homeTimelineUser isExisted:&e];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idn = %@ && homeTimelineUser = %@", model.idn, model.homeTimelineUser];

	[statusRequest setPredicate:predicate];
	NSArray *arr = [context executeFetchRequest:statusRequest error:nil];
	Status *aObject = nil;
	if ([arr count] == 0)
	{		
		aObject = (Status *)[NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:context];
		[model updateStatus:aObject];
		*existed = NO;
		return aObject;
	}
	aObject = (Status *)[arr objectAtIndex:0];
	return aObject;
}

- (Status *) getStatus:(NTESMBStatusModel *)model{
	//TODO 这里获取没有考虑多用户的情况
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idn = %@", model.idn];
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idn CONTAINS %@", [NSString stringWithFormat:@"%@:",model.idn]];
	
	[statusRequest setPredicate:predicate];
	NSArray *arr = [context executeFetchRequest:statusRequest error:nil];
	if ([arr count] == 0)
	{		
		return nil;
	}
	return [arr objectAtIndex:0];
}

- (User *) getOrInsertUserWithUserModel:(NTESMBUserModel *)model isExisted:(BOOL *)existed
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idn = %@", model.idn];
	[userRequest setPredicate:predicate];
	NSArray *arr = [context executeFetchRequest:userRequest error:nil];

	User *aObject = nil;
	if ([arr count] == 0)
	{		
		aObject = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
		[model updateUser:aObject];
		*existed = NO;
		return aObject;
	}
	aObject = (User *)[arr objectAtIndex:0];
	return aObject;
}

- (User *) getUserWithScreenName:(NSString *)screenName
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"screenName = %@", screenName];
	[request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
	[request setPredicate:predicate];
	NSArray *arr = [context executeFetchRequest:request error:nil];
	[request release];
	User *aObject = nil;
	if ([arr count] == 0)
	{		
		return nil;
	}
	aObject = (User *)[arr objectAtIndex:0];
	return aObject;
}
- (User*)getUserById:(NSString*)userId{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idn = %@", userId];
	[request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
	[request setPredicate:predicate];
	NSArray *arr = [context executeFetchRequest:request error:nil];
	[request release];
	User *aObject = nil;
	if ([arr count] == 0)
	{		
		return nil;
	}
	aObject = (User *)[arr objectAtIndex:0];
	return aObject;
}
- (NSArray *) getAllUser
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"screenName" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];
	NSArray *arr = [context executeFetchRequest:request error:nil];
	[request release];
	return arr;
}

- (NSArray *) getAllStatus
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"Status" inManagedObjectContext:context]];
	NSArray *arr = [context executeFetchRequest:request error:nil];
	[request release];
	return arr;
}

- (void) deleteStatusWithStatusModel:(NTESMBStatusModel *) statusModel
{
	BOOL isExisted = NO;
	Status *statusToDelete = [self getOrInsertHomeTimelineWithStatusModel:statusModel isExisted:&isExisted];
	[context deleteObject:statusToDelete];
	[self saveToDisk];
}

- (void) clearAllData
{
	NSArray *allUser = [self getAllUser];
	NSArray *allStatus = [self getAllStatus];
	for (NSManagedObject *o in allUser)
	{
		[context deleteObject:o];
	}
	for (NSManagedObject *o in allStatus)
	{
		[context deleteObject:o];
	}
	//clear the AuthAPI
	//[XAuthAPI clearSignleton];
	[self saveToDisk];
}

- (void) cutHomeTimeline:(User *)user{
	//make a request
#if 0
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"Status" inManagedObjectContext:context]];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@" homeTimelineUser = %@", user];
	[request setPredicate:predicate];
	//not includesubentities for speed
	[request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
	NSError *err;
	//first count, if there's too many entities, delete the olders
	NSUInteger count = [context countForFetchRequest:request error:&err];
	//NE_LOG(@"before cutting [%d]",count);
	if (count>HOMETIMELINE_LIMIT) 
	{
		//sort by time
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderTime" ascending:NO];
		[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		[sortDescriptor release];
		//keep the newest
		[request setFetchOffset:HOMETIMELINE_LIMIT];
		NSArray *cuts = [context executeFetchRequest:request error:nil];
		NE_LOG(@"cutting [%d]",cuts.count);
		for (NSManagedObject *o in cuts)
		{
			[context deleteObject:o];
		}
	}
	[request release];
#endif	
}

//- (NSArray *) allDataWithEntityName:(NSString *) entityName
//{
//	NSFetchRequest *request = [[NSFetchRequest alloc] init];
//	[request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
//	NSArray *arr = [context executeFetchRequest:request error:nil];
//	[request release];
//	return arr;
//}


- (void) saveToDisk
{
	NSError *error = nil;
	if (context != nil) {
        if ([context hasChanges] && ![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NE_LOG(@"Unresolved error %@, %@", error, [error userInfo]);
			
			NE_LOG(@"Failed to save to data store: %@", [error localizedDescription]);
			NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
			if(detailedErrors != nil && [detailedErrors count] > 0) {
				for(NSError* detailedError in detailedErrors) {
					NE_LOG(@"  DetailedError: %@", [detailedError userInfo]);
				}
			}
			else {
				NE_LOG(@"  %@", [error userInfo]);
			}
        }
	}
#if 0
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"Status" inManagedObjectContext:context]];
	NSArray *arr = [context executeFetchRequest:request error:nil];
	for(Status *item in arr){
		//if(item.
		//if(item.retweetCount)
			NE_LOG(@"%@ == %@",item.replyCount, item.retweetCount);
		//NE_LOG(@"%@",[item.replyCount description]);
	}
	[request release];
	
#endif	
}

- (void) dealloc
{
	[context release];
	[userRequest release];
	[statusRequest release];
	[super dealloc];
}


@end
