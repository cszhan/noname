//
//  DressMemoDetailDataModel.m
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DressMemoDetailDataModel.h"
#import "DBManage.h"
const NSString *kAppendInfoEmotionKey = @"kAppendInfoEmotionKey";
const NSString *kAppendInfoLocationKey = @"kAppendInfoLocationKey";
const NSString *kAppendInfoOccasionKey = @"kAppendInfoOccasionKey";
const NSString *kAppendInfoDiscriptionKey = @"kAppendInfoDiscriptionKey";
@implementation DataModelBase
- (id) initWithDictionary:(NSDictionary *) dic
{
    if(self = [super init]){
    
    }
    return self;
}
@end
@implementation DressMemoDetailDataModel
@synthesize memoId;
@synthesize addTime;
@synthesize appendInfoDic;
@synthesize coverImageURLPath;
@synthesize favUserIconURLPaths;
@synthesize picArray;
@synthesize tagArray;
@synthesize user;

/*
 *"memoid":"103",
 "uid":"2",
 "addtime":"1343751316",
 "emotionid":"41",
 "occasionid":"20",
 "prov":"0",
 "city":"0",
 "location":"",
 "picid":"292",
 "picpath":"/memo/2012/08/01/20120801001516_jbLU_3daabfa0.jpg",
 "isrecommend":"0",
 "favornum":"1",
 "commentnum":"4",
 "user":{
 "uid":"2",
 "uname":"cszhan",
 "avatar":"/avatar/20120803152024_lY52_ebe8dd2f.png"
 },
 "pic":{
 "292":{
 "picid":"292",
 "memoid":"103",
 "uid":"2",
 "addtime":"1343751316",
 "path":"/memo/2012/08/01/20120801001516_jbLU_3daabfa0.jpg",
 "tags":[
 {
 "picid":"292",
 "tagid":"429",
 "catid":"103",
 "brandid":"31",
 "x":"56995",
 "y":"8154"
 }
 ]
 }
 */
- (id) initWithDictionary:(NSDictionary *) dic
{
    self = [super init];
	if (self != nil)
    {
		//self.id =          [dic objectForKey:@"commentid"];
		//self.commentText =  [dic objectForKey:@"comment"];
		self.memoId =       [dic objectForKey:@"memoid"];
		self.addTime =      [dic objectForKey:@"addtime"];
		self.coverImageURLPath = [dic objectForKey:@"picpath"];
        
        //for infor
        [self processInforDetail:dic];
        
        //for user
        NSDictionary *user = [dic objectForKey:@"user"];
        DressMemoUserModel *userModelItem = [[DressMemoUserModel alloc]initWithDictionary:user];
        self.user = userModelItem;
        [userModelItem release];
        
        //for pic and 
        NSDictionary *pic = [dic objectForKey:@"pic"];
        [self processPicDetail:pic];
	}
	return self;
}
-(void)processPicDetail:(NSDictionary*)picData
{
    NSMutableArray *tagArr = [NSMutableArray array];
    NSMutableArray *picPathArr = [NSMutableArray array];
    for(id picKey in picData)
    {
        NSDictionary *picItem = [picData objectForKey:picKey];
        NSArray * tagsArr = [picItem objectForKey:@"tags"];
        if(tagsArr)
        {
            for(id tagItem in tagsArr)
            {
                DressMemoTagModel *tagModel  = [[DressMemoTagModel alloc]initWithDictionary:tagItem];
                [tagArr addObject:tagModel];
                [tagModel release];
            }
        
        }
        DressMemoPicModel *picModel = [[DressMemoPicModel alloc]initWithDictionary:picItem];
        [picPathArr addObject:picModel];
        [picModel release];
    }
    self.tagArray = tagArr;
    self.picArray = picPathArr;
}
-(void)processInforDetail:(NSDictionary*)data
{
    NSDictionary * inforDict = [NSMutableDictionary dictionary];
    NSDictionary * alldataDict = nil;
    DBManage *dbMgr = [DBManage getSingleTone];
    /*
    "emotionid":"41",
    "occasionid":"20",
    "prov":"0",
    "city":"0",
    "location":"",
    */
    NSString *occasionValue = @"";
    NSString *emotionValue = @"";
    NSString *locationValue = @"未知";
    NSString *descValue = @"";
    //for occasion
    alldataDict = [dbMgr getTagDataByIdRaw:@"getOccasions"];
    NSString *occasion = [alldataDict objectForKey:[data objectForKey:@"occasionid"]];
    if(occasion)
    {
        occasionValue = occasion;
    }
    [inforDict setValue:occasionValue forKey:kAppendInfoOccasionKey];
    //for emotion
    alldataDict = [dbMgr getTagDataByIdRaw:@"getEmotions"];
    NSString *emotion = [alldataDict objectForKey:[data objectForKey:@"emotionid"]];
    if(emotion)
    {
        emotionValue = emotion;
    }
    [inforDict setValue:emotionValue forKey:kAppendInfoEmotionKey];
    //for location
    alldataDict = [dbMgr getCityNameById:[data objectForKey:@"prov"] proviceId:[data objectForKey:@"city"]];
    NSString *location = [data objectForKey:@"location"];
    if(alldataDict||location)
    {
        if(location)
        locationValue = [NSString stringWithFormat:@"%@市%@",[alldataDict objectForKey:@"city" ],location];
        else
        {
           locationValue = [NSString stringWithFormat:@"%@市",location];  
        }
           
    }
    [inforDict setValue:locationValue forKey:kAppendInfoLocationKey];
    //for desc
    NSString *descpiton = [data objectForKey:@"desc"];
    if(descpiton)
    {
        descValue = descpiton;
    }
    [inforDict setValue:descValue   forKey: kAppendInfoDiscriptionKey];
    
    self.appendInfoDic = inforDict;
}
@end

#pragma mark -
#pragma mark DressMemoUserModel
@implementation DressMemoDetailUserModel
@synthesize idn = _idn;
@synthesize name = _name;
@synthesize iconURLPath = _iconURLPath;

- (void)dealloc{
    self.idn = nil;
    self.name = nil;
    self.iconURLPath = nil;
    [super dealloc];
}

@end

#pragma mark -
#pragma mark DressMemoTagModel
/*
 * "picid":"292",
 "tagid":"429",
 "catid":"103",
 "brandid":"31",
 "x":"56995",
 "y":"8154"
 */
@implementation DressMemoTagModel
@synthesize picId = _picId;
@synthesize idn = _idn;
@synthesize catName = _catName;
@synthesize brandName = _brandName;
@synthesize tagPoint;
- (id) initWithDictionary:(NSDictionary *) dic
{
    self = [super init];
	if (self != nil)
    {
		self.idn =          [dic objectForKey:@"tagid"];
		self.picId =  [dic objectForKey:@"picid"];
        /*
		self.memoId =       [dic objectForKey:@"memoid"];
		self.addTime =      [dic objectForKey:@"addtime"];
		self.coverImageURLPath = [dic objectForKey:@"picpath"];
        */
        NSString *brandStr=  [dic objectForKey:@"brand"];
        if(brandStr)
        {
            self.brandName = brandStr;
        }
        else
        {
            self.brandName = @"";
        }
        NSString *xStr = [dic objectForKey:@"x"];
        NSString *yStr = [dic objectForKey:@"y"];
        self.tagPoint = CGPointMake([xStr floatValue], [yStr floatValue]);
	}
	return self;
}
- (void)dealloc
{
    self.picId = nil;
    self.idn = nil;
    self.catName = nil;
    self.brandName = nil;
    
    [super dealloc];
}

@end
@implementation DressMemoPicModel
@synthesize picId;
@synthesize picPath;
@synthesize memoId;
- (id) initWithDictionary:(NSDictionary *) dic
{
    self = [super init];
	if (self != nil)
    {
		self.picPath =          [dic objectForKey:@"picpath"];
		self.picId =  [dic objectForKey:@"picid"];
        self.memoId = [dic objectForKey:@"memoid"];
        /*
         self.memoId =       [dic objectForKey:@"memoid"];
         self.addTime =      [dic objectForKey:@"addtime"];
         self.coverImageURLPath = [dic objectForKey:@"picpath"];
         */
        
	}
	return self;
}
-(void)dealloc
{
    self.picId  = nil;
    self.picPath = nil;
    self.memoId = nil;
    
    [super dealloc];
}
@end    

#pragma mark -
#pragma mark DressMemoCommentModel
@implementation DressMemoCommentModel
@synthesize idn = _idn;
@synthesize commentText = _commentText;
@synthesize memoId = _memoId;
@synthesize addTime = _addTime;
@synthesize commentedUserName = _commentedUserName;
@synthesize replyUserNickName;
@synthesize replyUserId;

@synthesize creatorUser = _creatorUser;
/*
 * "commentid":"7",
 "comment":"这个是一个测试评论，哈哈！！",
 "memoid":"103",
 "addtime":"1344089288",
 "uid":"6",
 "uname":"kkzhan",
 "replyid":"0",
 "ruid":"0",
 "runame":""
 },
 reply comment type:
 
 "8":
 {
 "commentid":"8",
 "comment":"这个是一个回复评论测试，哈哈！！",
 "memoid":"103",
 "addtime":"1344090765",
 "uid":"6",
 "uname":"kkzhan",
 "replyid":"6",
 "ruid":"2",
 "runame":"cszhan"
 */

- (id) initWithDictionary:(NSDictionary *) dic
{
    self = [super init];
	if (self != nil)
    {
		self.idn =          [dic objectForKey:@"commentid"];
		self.commentText =  [dic objectForKey:@"comment"];
		self.memoId =       [dic objectForKey:@"memoid"];
		self.addTime =      [dic objectForKey:@"addtime"];
		self.commentedUserName = [dic objectForKey:@"uname"];
        if([[dic objectForKey:@"ruid"]isEqualToString:@"0"]&&
           [[dic objectForKey:@"replyid"]isEqualToString:@"0"])
        {
            self.replyUserId = nil;
            self.replyUserNickName = nil;
        }
        else
        {
            self.replyUserId = [dic objectForKey:@"ruid"];
            self.replyUserNickName = [dic objectForKey:@"runame"];
        }
	}
	return self;
}
- (void)dealloc
{
    self.replyUserId = nil;
    self.replyUserNickName = nil;
    self.idn = nil;
    self.commentText = nil;
    self.memoId = nil;
    self.addTime = nil;
    self.commentedUserName = nil;
    self.creatorUser = nil;
    [super dealloc];
}

@end
