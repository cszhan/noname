//
//  ZCSNetClientMgr.h
//  DressMemo
//
//  Created by  on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCSNetClientDataMgr : NSObject
+(id)getSingleTone;
-(void)startUserLogin:(NSDictionary*)param;
/*user*/
-(id)getUserInfor:(NSDictionary*)param;
/*follow*/
-(id)getFollowingUserList:(NSDictionary*)param;
-(id)getFollowedUserList:(NSDictionary*)param;
/*memos*/
-(id)getPostMemos:(NSDictionary*)param;
-(id)getFavMemos:(NSDictionary*)param;
-(id)getFavorMemoUsers:(NSDictionary*)param;
-(id)getMemoDetail:(NSDictionary*)param;
-(id)doFavorMemo:(NSDictionary*)param;
-(id)unDoFavorMemo:(NSDictionary*)param;
/*comment*/
-(id)getMemoComments:(NSDictionary*)param;
-(id)addMemoComment:(NSDictionary*)param;
-(id)addCommentReply:(NSDictionary*)param;
/*msg*/
-(id)getMessageList:(NSDictionary*)param;
@end
