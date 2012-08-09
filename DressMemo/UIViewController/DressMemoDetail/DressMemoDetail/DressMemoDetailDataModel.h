//
//  DressMemoDetailDataModel.h
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DressMemoUserModel.h"
extern NSString *kAppendInfoEmotionKey; 
extern NSString *kAppendInfoLocationKey;
extern NSString *kAppendInfoOccasionKey;
extern NSString *kAppendInfoDiscriptionKey;

@class DressMemoDetailUserModel;
@class DressMemoTagModel;


@interface DataModelBase:NSObject
- (id) initWithDictionary:(NSDictionary *) dic;
@end

#pragma mark -
#pragma mark DressMemoDetailDataModel
@interface DressMemoDetailDataModel : DataModelBase
{
    NSString           *_memoId;
    NSString           *_addTime;
    NSString           *_coverImageURLPath;
    
    DressMemoUserModel *_user;
    
    //图片url array 以后用
    NSArray            *_picArray;
    
    //tag数组，里面的object类型为DressMemoTagModel
    NSArray            *_tagArray; 
    
    /**
     *  附加信息，字典结构，key value如下
     *  kAppendInfoEmotionKey   心情
     *  kAppendInfoLocationKey  地点
     *  kAppendInfoOccasionKey  场合
     *  kAppendInfoDiscriptionKey  描述 
     */
    NSDictionary       *_appendInfoDic; 
    
    //喜欢的人，头像列表 最多六个人的头像
    NSArray            *_favUsers;
    
    //评论信息数组, 里面object类型为DressMemoCommentModel      
    NSArray            *_comments;
}
@property(nonatomic,retain) NSString           *memoId;
@property(nonatomic,retain) NSString           *addTime;
@property(nonatomic,retain) NSString           *coverImageURLPath;

@property(nonatomic,retain) DressMemoUserModel *user;

//图片url array 以后用
@property(nonatomic,retain) NSArray            *picArray;

//tag数组，里面的object类型为DressMemoTagModel
@property(nonatomic,retain) NSArray            *tagArray;

/**
 *  附加信息，字典结构，key value如下
 *  kAppendInfoEmotionKey   心情
 *  kAppendInfoLocationKey  地点
 *  kAppendInfoOccasionKey  场合
 *  kAppendInfoDiscriptionKey  描述
 */
@property(nonatomic,retain) NSDictionary       *appendInfoDic;

//喜欢的人，头像列表 最多六个人的头像
@property(nonatomic,retain)NSArray             *favUsers;

//评论信息数组, 里面object类型为DressMemoCommentModel
@property(nonatomic,retain) NSArray          *comments;

@end

#pragma mark -
#pragma mark DressMemoDetailUserModel
@interface DressMemoDetailUserModel : DataModelBase
{
    NSString *_idn;
    NSString *_name;
    NSString *_iconURLPath;
}

@property (nonatomic, copy)NSString *idn;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *iconURLPath;

@end

#pragma mark -
#pragma mark DressMemoTagModel
@interface DressMemoTagModel : DataModelBase{
    NSString *_picId;
    NSString *_idn;
    NSString *_catName;
    NSString *_brandName;
    CGPoint  tagPoint;
}

@property (nonatomic, copy)NSString *picId;
@property (nonatomic, copy)NSString *idn;
@property (nonatomic, copy)NSString *catName;
@property (nonatomic, copy)NSString *brandName;
@property (nonatomic,assign)CGPoint tagPoint;
@end
@interface DressMemoPicModel : DataModelBase{
    NSString *_picId;
    NSString *memoId;
    NSString *picPath;
}

@property (nonatomic, copy)NSString *picId;
@property (nonatomic, copy)NSString *memoId;
@property (nonatomic, retain)NSString *picPath;

@end

#pragma mark -
#pragma mark DressMemoCommentModel

@interface DressMemoCommentModel : DataModelBase
{
    
    NSString *_idn;
    NSString *_commentText;
    NSString *_memoId;
    NSString *_addTime;
    NSString *_replyUserNickName;
    NSString *_replyUserId;
    DressMemoDetailUserModel *_creatorUser;
    NSString *_uid;
    NSString *_commentedUserName;
}
@property (nonatomic,retain)NSString * replyUserNickName;
@property (nonatomic,retain)NSString * replyUserId;

@property (nonatomic, copy)NSString *idn;
@property (nonatomic, copy)NSString *commentText;
@property (nonatomic, copy)NSString *memoId;
@property (nonatomic, copy)NSString *addTime;
@property (nonatomic, copy)NSString *commentedUserName;
@property (nonatomic, copy)NSString *uid;

@property (nonatomic, retain)DressMemoDetailUserModel *creatorUser;

@end
