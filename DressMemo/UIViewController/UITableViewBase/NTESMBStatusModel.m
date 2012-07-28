//
//  NTESMBStatusModel.m
//  网易微博iPhone客户端
//	一条微博的模型
//
//  Created by Xu Han Jie on 10-5-26.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBStatusModel.h"
#import "NSDate+Ex.h"
#import "User.h"
#import "DB.h"
#import "NSString+Ex.h"
#import "UIParamsCfg.h"
#import "NEDebugTool.h"
#if 1
#import "RegexKitLite.h"
#import "RegexMatchEnumerator.h"
#endif
@interface NTESMBStatusModel(Private)
- (NSString *) featured:(NSString *)text;
@end

@implementation NTESMBStatusModel

@synthesize idn;
@synthesize cursorID;
@synthesize replyID;
@synthesize text;
@synthesize user;
@synthesize homeTimelineUser;
@synthesize createAt;
@synthesize orderTime;
@synthesize hasPhoto;
@synthesize imageUrl;
@synthesize rootImageUrl;
@synthesize source;
@synthesize favorited;
@synthesize retweeted;
@synthesize retweetedByMe;
@synthesize cellHeight;
@synthesize labelHeight;
@synthesize rootHeight;
@synthesize isSeparator;
@synthesize retweetUsername;
@synthesize geoLong;
@synthesize geoLat;
@synthesize venue;
@synthesize rootText;
@synthesize rootUsername;

@synthesize replyCount;
@synthesize retweetCount;

@synthesize rootReplyCount;
@synthesize rootRetweetCount;
@synthesize tweetSource;
@synthesize rootTweetId;
@synthesize modelType;
@synthesize replyUserName;
@synthesize replyStatusText;
@synthesize displayStatusText;
@synthesize displayRootText;

@synthesize imageData;
- (id) initSeparator{
	self = [super init];
	isSeparator = YES;
	idn=nil;//[NSString stringWithFormat:@"%d",[self hash]];
	//NE_LOG(@"init sep");
	return self;
}
-(id)init{
	if(self = [super init]){
		skipTypeHeightDict = [[NSMutableDictionary alloc]init];
	}
	return self;
}

//从网站下载时的包装
- (id) initWithDictionary:(NSDictionary *) dic
{
	self = [super init];
	if (self != nil) {
		//id
		self.idn = [dic objectForKey:@"id"];
		if(![[dic objectForKey:@"root_in_reply_to_status_id"] isEqual:[NSNull null]])
		self.rootTweetId = [dic objectForKey:@"root_in_reply_to_status_id"];
		NSString *s = [dic objectForKey:@"text"];
		//需要处理额外的&quot; &amp;字符 html decode
		//这里注意，列表显示要使用decode过的文字，但是单条模式由于涉及了webview因此需要使用没有decode过的文字
		//因为列表模式出现的时机更要求效率，所以平时内存和数据库里面存储的是Decode过的，单条模式时再encode html一下
		self.text = [s HTMLDecode];
		//处理图片
		[self getNeteaseImageUrl];
		if (imageUrl!=nil){
			self.hasPhoto = [NSNumber numberWithBool:YES];
		}else{
			self.hasPhoto = [NSNumber numberWithBool:NO];
		}
		//处理收藏
		NSNumber *isFavoritedNumber = [NTESMBUtility objectToNSNumber:[dic objectForKey:@"favorited"]];
		if ([isFavoritedNumber isEqualToNumber:[NSNumber numberWithInt:0]]){
			self.favorited = [NSNumber numberWithBool:NO];
		}else{
			self.favorited = [NSNumber numberWithBool:YES];
		}
		
		//处理时间
		self.createAt = [NSDate dateFromNeteaseString:[dic objectForKey:@"created_at"]];
		
		//处理转发和排序时间
		NSNumber *retweetCount = [NTESMBUtility objectToNSNumber:[dic objectForKey:@"retweet_count"]];
		
		//如果是rt的就不用create_at,用retweet_created_at做排序
		if ([retweetCount isEqualToNumber:[NSNumber numberWithInt:0]]){
			self.retweeted = [NSNumber numberWithBool:NO];
			self.orderTime = self.createAt;
		}else{
			self.retweeted = [NSNumber numberWithBool:YES];
			NSString * _createAt  = [dic objectForKey:@"retweet_created_at"];
			if ([_createAt isEqual:[NSNull null]]) {
				_createAt =  [dic objectForKey:@"created_at"];
			}
			self.orderTime = [NSDate dateFromNeteaseString:_createAt];
		}
		
		//是否被自己转发
		self.retweetedByMe = [NTESMBUtility objectToNSNumber:[dic objectForKey:@"is_retweet_by_user"]];
		self.retweetCount = [dic objectForKey:@"retweet_count"];
		//NE_LOG(@"KKKKKKK:%@",self.retweetCount);
		self.replyCount = [dic objectForKey:@"comments_count"];//[dic objectForKey:@"comments_count"];
		//NE_LOG(@"KKKKKKK11:%@",self.replyCount);
		//处理转发人
		NSString *_retweetUsername = [dic objectForKey:@"retweet_user_name"];
		if ([_retweetUsername isEqual:[NSNull null]]) {
			/*有一种情况是我自己转发的*/
			if ([[NTESMBUtility objectToNSNumber:[dic objectForKey:@"is_retweet_by_user"]] isEqualToNumber:[NSNumber numberWithInt:1]]) {
				self.retweetUsername = [NTESMBUtility currentName];
			}else/*否则就是无值了*/
				self.retweetUsername = nil;
		}else {
			self.retweetUsername = _retweetUsername;
		}
		
		//处理来源
		NSString *realText = nil;
		NSString *souceText = [dic objectForKey:@"source"];
		if(![souceText isEqualToString:@"网易微博"]){
			realText = [NSString HTMLtoText:souceText];
			NE_LOG(@"test:%@",realText);
			if(realText == nil)
				realText = @"未知";
			self.source = [NSString stringWithFormat:@"来自 %@",realText];
		}
		else {
			self.source = [NSString stringWithFormat:@"来自 %@",souceText];
		}

		//处理回复id
		NSString *replyid = [dic objectForKey:@"in_reply_to_status_id"];
		if ([replyid isEqual:[NSNull null]]) {
			self.replyID = nil;
		}else {
			self.replyID = replyid;
		}
		
		//处理原文信息
		NSString *_rootText = [dic objectForKey:@"root_in_reply_to_status_text"];		
		
		if ([_rootText isEqual:[NSNull null]]) {
			self.rootText = nil;
		}else {
			self.rootText = [_rootText HTMLDecode];
							 
			self.rootUsername = [dic objectForKey:@"root_in_reply_to_user_name"];
			//text没图，rootText里面有图片的也是有图
			if (![self.hasPhoto boolValue]) {
				[self getRootImageUrl];
				if (self.rootImageUrl!=nil) {
					self.hasPhoto = [NSNumber numberWithBool:YES];
				}
			}
		}
		//comment me
		/*
		 *in_reply_to_status_id":"-3334373500841821049",
		 "in_reply_to_user_id":"1697405455581465021",
		 "in_reply_to_screen_name":"cszhan",
		 "in_reply_to_user_name":"cszhan",
		 "in_reply_to_status_text":"Good"
		 */
		self.replyUserName = [dic objectForKey:@"in_reply_to_user_name"];
		self.replyStatusText = [dic objectForKey:@"in_reply_to_status_text"];
		//处理地理位置
		NSDictionary *geo = [dic objectForKey:@"geo"];
		if (geo != nil && ![geo isEqual:[NSNull null]]) {
			
			NSArray *coor = [geo objectForKey:@"coordinates"];
			self.geoLat = [(NSString *)[coor objectAtIndex:0] doubleValue];
			self.geoLong= [(NSString *)[coor objectAtIndex:1] doubleValue];
			//NE_LOG(@"----%f,%f",geoLat,geoLong);
			//self.geoLat+= (arc4random()%100)/1000.0;
		}/*else{
			static NSString *geoPattern = @"^我在(\\+?-?\\d+\\.\\d+),(\\+?-?\\d+\\.\\d+)";
			//NSMutableString *imageString = [[NSMutableString alloc] init];
			NSArray * geoArray = [self.text captureComponentsMatchedByRegex:geoPattern];
			if (geoArray != nil && geoArray.count==3) {
				self.geoLat = [[geoArray objectAtIndex:1] floatValue];
				self.geoLong = [[geoArray objectAtIndex:2] floatValue];
			}
		}*/
		
		//处理POI
		NSDictionary *venueDict = [dic objectForKey:@"venue"];
		if (venueDict != nil && ![venueDict isEqual:[NSNull null]]) {
			/*
			NSString *id = [venueDict objectForKey:@"id"];
			if ([id isEqualToString:@"0"])
			{
				self.venue = nil;
			}
			else
			*/
			{
				self.venue = [[[NTESMBVenueModel alloc]initWithDictionary:venueDict]autorelease];
				//if (self.geoLat==0)
				{
					self.geoLat= venue.geoLat;
					self.geoLong = venue.geoLong;
				}
			}
			
		}
		
		//cursorid,用来分页
		NSString *cursor = [dic objectForKey:@"cursor_id"];
		if ([cursor isEqual:[NSNull null]] || cursor == nil) {
			self.cursorID = self.idn;
		}else {
			self.cursorID = cursor;
		}
		
	}
	[self getNeteaseImageUrl];
	[self getRootImageUrl];
	return self;
}
//从数据库里获取信息时的包装
- (id) initWithStatus:(Status *) status
{
	self = [super init];
	if (self != nil) {
		self.idn = status.idn;
		self.text = status.text;
		self.createAt = status.createdAt;
		NTESMBUserModel *userModel = [[NTESMBUserModel alloc] initWithUserData:status.user];
		self.user = userModel;
		self.hasPhoto = status.hasPhoto;
		[userModel release];
		self.favorited = status.favorited;
		self.retweeted = status.retweeted;
		self.retweetedByMe = status.retweetedByMe;
		self.source = status.source;
		self.replyID = status.replyID;
		self.cursorID = status.cursorID;
		self.orderTime = status.orderTime;
		self.retweetUsername = status.retweetUsername;
		self.geoLat = status.geoLat;
		self.geoLong = status.geoLong;
		self.replyCount = status.replyCount;
		self.retweetCount = status.retweetCount;
		self.rootTweetId = status.rootTweetId;
		//for sep
		if (self.idn==nil) {
			self.isSeparator = YES;
		}
		if (status.venueID!=nil) {
			self.venue = [[NTESMBVenueModel alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:status.venueID,@"id",status.venueName,@"name",nil]];
			self.venue.geoLat = status.venueLat;
			self.venue.geoLong = status.venueLong;
		}
		self.rootText = status.rootText;
		self.rootUsername = status.rootUsername;
		[self getNeteaseImageUrl];
		[self getRootImageUrl];
	}
	return self;
}
//设置更新数据库时要更新的字段
- (void) updateStatus:(Status *) status
{
	status.idn = idn;
	status.text = text;
	status.createdAt = createAt;
	status.hasPhoto = hasPhoto;
	status.favorited = self.favorited;
	status.retweeted = self.retweeted;
	status.retweetedByMe = self.retweetedByMe;
	status.source = self.source;
	status.homeTimelineUser = self.homeTimelineUser;
	status.replyID = self.replyID;
	status.cursorID = self.cursorID;
	status.orderTime = self.orderTime;
	status.retweetUsername = self.retweetUsername;
	status.geoLat = self.geoLat;
	status.geoLong = self.geoLong;
	status.replyCount = self.replyCount;
	status.retweetCount = self.retweetCount;
	status.rootText = self.rootText;
	status.rootUsername = self.rootUsername;
	if(self.rootTweetId!= nil)
		status.rootTweetId = self.rootTweetId;
	if (self.venue!=nil) {
		status.venueID = self.venue.id;
		status.venueName = self.venue.name;
		status.venueLat = self.venue.geoLat;
		status.venueLong = self.venue.geoLong;
	}
}
- (void) dealloc
{
	[idn release];
	[cursorID release];
	[replyID release];
	[text release];
	[source	release];
	[user release];
	[homeTimelineUser release];
	[createAt release];
	[orderTime release];
	[imageUrl release];
	[rootImageUrl release];
	[favorited release];
	[retweeted	release];
	[retweetedByMe release];
	[retweetUsername release];
	[venue release];
	[rootText release];
	[rootUsername release];
	[tweetSource release];
	[replyCount release];
	[retweetCount release];
	[rootTweetId release];
	[super dealloc];
}

//这个方法会返回用在tweet详细页面的html代码
- (NSString *) featured:(NSString *)_text{
#ifdef DEBUG
	NE_LOG(@"origin text:%@",_text);
#endif
	NSMutableString	*s = [NSMutableString stringWithString:[_text HTMLencode]];
	//处理表情
	[s replaceOccurrencesOfRegex:@"\\[(勾引|纠结|开心|困死了|路过|冒泡|飘走|思考|我顶|我晕|抓狂|装酷|崩溃|鄙视你|不说|大哭|飞吻|工作忙|鼓掌|害羞|坏|坏笑|教训|惊讶|可爱|老大|欠揍|撒娇|色迷迷|送花|偷笑|挖鼻孔|我吐|嘘|仰慕你|yeah|疑问|晕|砸死你|眨眼|福|红包|菊花|蜡烛|礼物|圣诞老人|圣诞帽|圣诞树|扭扭|转圈圈|踢踏舞|强|跳舞|蜷|吃惊|我汗|呐喊|生病|隐身|放松|捶地|嗯|撒花|心|囧|害怕|冷|震惊|怒|狂笑|渴望|飘过|转圈哭|得瑟|hi|闪电|同意|星星眼)\\]" 
					  withString:@"<img src='$1.gif' class='face'/>" ];
	
	//处理@用户
	[s replaceOccurrencesOfRegex:@"@([\u4e00-\u9fa5a-zA-Z0-9]+)" withString:@"<a href='profile://name/$1'>@$1</a>"];
	//处理#话题
	[s replaceOccurrencesOfRegex:@"#([\u4e00-\u9fa5a-zA-Z0-9+|]+)" withString:@"<a href='topic://topic/$1'>#$1</a>"];
	//替换第一个126.fm因为他会成为图片
	//todo只处理第一张图片
	[s replaceOccurrencesOfRegex:@"(http://126.fm/[a-zA-Z0-9]+)" withString:@""];
	//处理链接,这里不用匹配所有的url的情况，因为理论上都回被163.fm过
	[s replaceOccurrencesOfRegex:@"(https?://[\\w\\d#%/$~_?\\+=\\.]+)" withString:@"<a href='$1'>$1</a>"];
#ifdef DEBUG
	NE_LOG(@"featuredText:%@",s);
#endif
	//return [NSString stringWithFormat:@"[featured:]%@",self.text]; 
	return s;
	
}
- (NSString *) featuredText{
	return [self featured:self.text];
}
- (NSString *) featuredRootText{
	if (self.rootText==nil) {
		return nil;
	}
	return [self featured:self.rootText];
}

//获取此tweet里面的image url，取第一个符合要求的链接，如果没有返回nil
- (NSString *) getNeteaseImageUrl{
	if (imageUrl==nil) {
		//只获取第一个
		static NSString *patternString1 = @"http://126.fm/[a-zA-Z0-9]+";
		//NSMutableString *imageString = [[NSMutableString alloc] init];
		RegexMatchEnumerator *enum1 = [[RegexMatchEnumerator alloc] initWithString:self.text regex:patternString1];
		//self.text = [self.text 
		self.imageUrl = [enum1 nextObject];
		if(imageUrl != nil){
			NSRange range = [enum1 matchedRange];
			//NE_LOG(@"Range:(%d==,%d)",range.location,range.length);
			self.displayStatusText = [self.text  stringByReplacingCharactersInRange:range withString:@""];
		}
		[enum1 release];
	}
	return imageUrl;
}
//-(NSString*)getPercentImageUrlText:(NSString*)srcUrl{
//	if(source != nil){
//		static NSString *patternString1 = @"http://126.fm/[a-zA-Z0-9]+";
//		//NSMutableString *imageString = [[NSMutableString alloc] init];
//		RegexMatchEnumerator *enum1 = [[[RegexMatchEnumerator alloc] initWithString:source regex:patternString1] autorelease];
//		//self.text = [self.text 
//		[enum1 nextObject];
//		NSRange range = [enum1 matchedRange];
//		NE_LOG(@"Range:(%d==,%d)",range.location,range.length);
//		return [source stringByReplacingCharactersInRange:range withString:@""];
//	}
//	return nil;
//}
- (NSString *) getRootImageUrl{
	if (rootImageUrl==nil) {
		if (self.rootText==nil) {
			return nil;
		}
		//只获取第一个
		static NSString *patternString1 = @"http://126.fm/[a-zA-Z0-9]+";
		//NSMutableString *imageString = [[NSMutableString alloc] init];
		RegexMatchEnumerator *enum1 = [[[RegexMatchEnumerator alloc] initWithString:self.rootText regex:patternString1] autorelease];
		self.rootImageUrl = [enum1 nextObject];
		if(self.rootImageUrl != nil){
			NSRange range = [enum1 matchedRange];
			self.displayRootText  = [self.rootText  stringByReplacingCharactersInRange:range withString:@""];
		}
	}
	return rootImageUrl;
}



//获取此tweet里面的image url的缩略图的地址，取一个符合要求的链接，如果没有返回nil
- (NSString *) getNeteaseThumbImageUrl{
	//只获取第一个
	NSString *url = [self getNeteaseImageUrl];
	if (url == nil) {
		return nil;
	}
	return [url YoudaoImageUrlWithWidth:216 AndHeight:163];
}
-(NSString*)getStatusTinyImageUrl{
	NSString *url = [self getNeteaseImageUrl];
	if (url == nil) {
		return nil;
	}
	return [url YoudaoImageUrlWithWidth:kSkipTimelinePhotoTinySize AndHeight:kSkipTimelinePhotoTinySize];

}
-(NSString*)getRootTinyImageUrl{
	NSString *url = [self getRootImageUrl];
	if (url == nil) {
		return nil;
	}
	return [url YoudaoImageUrlWithWidth:kSkipTimelinePhotoTinySize AndHeight:kSkipTimelinePhotoTinySize];

}
- (NSString *) getRootThumbImageUrl{
	//只获取第一个
	NSString *url = [self getRootImageUrl];
	if (url == nil) {
		return nil;
	}
	return [url YoudaoImageUrlWithWidth:216 AndHeight:163];
}

//获取此tweet里面的链接的地址，取从头开始的第一个，如果没有返回nil
- (NSString	*) getNeteaseCommonUrl{
	static NSString *urlPattern = @"https?://[a-zA-Z0-9./_-]+";
	RegexMatchEnumerator *enum1 = [[[RegexMatchEnumerator alloc] initWithString:self.text regex:urlPattern] autorelease];
	//排除掉126.fm的图片
	NSString *next;
	while (YES) {
		next= (NSString *)[enum1 nextObject];
		if (next==nil || ![next hasPrefix:@"http://126.fm"]) {
			break;
		}
	}
	return next;
}

- (CGFloat) cellHeight{
	type = [[NTESMBUserSettingsCenter getInstance]skimTimelineCellViewType];
	/*
	switch (skipType) {
		case 0:
			break;
		case 1:
			break;
		case 2:
			break;
		default:
			break;
	}
	*/
	cellHeight = [[skipTypeHeightDict objectForKey:[NSNumber numberWithInt:type]] intValue];
	if (cellHeight>0) {
		return cellHeight;
	}
	CGFloat fontSize = [[NTESMBUserSettingsCenter getInstance] fontSize];
	[self makeCellHeight:fontSize];
	return cellHeight;
}

- (void) makeCellHeight:(CGFloat) fontSize{
	CGFloat adjustXoffset = 0.f;
	NSString *statusText = nil;
	NSString *statusRootText = nil;
	if(displayStatusText == nil)
		statusText = self.text;
	else {
		statusText = self.displayStatusText;
	}
	if(displayRootText == nil)
		statusRootText = self.rootText;
	else {
		statusRootText = self.displayRootText;
	}
	
	 type = [[NTESMBUserSettingsCenter getInstance]skimTimelineCellViewType];
	if(type == Skim_Text)
		adjustXoffset = TIMELINE_CELL_TEXT_LEFT_OFFSET;
	
	labelHeight = [NTESMBUtility getHeightForText:statusText
												 maxWidth:kMBAppRealViewWidth - TIMELINE_CELL_TEXT_LEFT_OFFSET - TIMELINE_CELL_TEXT_RIGHT_OFFSET+adjustXoffset
												maxHeight:TIMELINE_CELL_TEXT_MAX_HEIGHT
													 font:[UIFont systemFontOfSize:fontSize]];
	CGFloat minHeight = TIMELINE_CELL_TEXT_MIN_HEIGHT;
	CGFloat textHeight = labelHeight + TIMELINE_CELL_TEXT_TOP_OFFSET + TIMELINE_CELL_TEXT_BOTTOM_OFFSET + 3;
	//for comment
	if(modelType == StatusModel_Root){
	   if (rootText!=nil) {
		   rootHeight = [NTESMBUtility getHeightForText:[NSString stringWithFormat:@"%@: %@",rootUsername,statusRootText] 
											   maxWidth:TIMELINE_CELL_ROOT_TEXT_WEIGHT+adjustXoffset 
											  maxHeight:TIMELINE_CELL_TEXT_MAX_HEIGHT 
												   font:[UIFont systemFontOfSize:(fontSize-2)]];
		   textHeight+=rootHeight+10;//10是上下空白;
	   }
	}
	//reply me
	if(modelType == StatusModel_Reply)
	{
		if (replyStatusText!=nil) {
			rootHeight = [NTESMBUtility getHeightForText:[NSString stringWithFormat:@"%@: %@",replyUserName,replyStatusText] 
												maxWidth:TIMELINE_CELL_ROOT_TEXT_WEIGHT +adjustXoffset
											   maxHeight:TIMELINE_CELL_TEXT_MAX_HEIGHT 
													font:[UIFont systemFontOfSize:(fontSize-2)]];
			textHeight+=rootHeight+10;//10是上下空白;
		}
	}

	//if (venue!=nil) 
	{
		textHeight+=TIMELINE_CELL_VENUE_HEIGHT;
	}
	if([hasPhoto boolValue]&&imageUrl){
		if(type == 0 ){
			textHeight += kSkipTimelinePhotoTinySize+5.f*2;
		}
	}
	if([hasPhoto boolValue]&& rootImageUrl){
		if(type == 0 ){
			textHeight += kSkipTimelinePhotoTinySize+5.f*2;
		}
	}
	if (textHeight < minHeight){
		cellHeight = minHeight;
	}else {
		cellHeight = textHeight;
	}
}

#pragma mark -
#pragma mark MKAnnotation
- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = self.geoLat;
    theCoordinate.longitude = self.geoLong;
    return theCoordinate; 
}

- (NSString *)title
{
    return self.user.name;
}

// optional
- (NSString *)subtitle
{
    //return [status.createAt timeIntervalStringSinceNow];
	if ([self.text length]>20) {
		return [NSString stringWithFormat:@"%@...",[self.text substringToIndex:18]];
	}
	//加右侧padding是为了让泡泡大小合适
	return [self.text stringByPaddingToLength:20 withString:@" " startingAtIndex:0];
}


@end
