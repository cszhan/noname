//
//  SharePlatformCenter.m
//  UMSNSDemo
//
//  Created by Fengfeng Pan on 11-12-10.
//  Copyright (c) 2011年 Realcent. All rights reserved.
//

#import "SharePlatformCenter.h"
#import "WeiBoTencentEngine.h"
#import "ShareAuthViewController.h"
#import "WeiBoSinaEngine.h"
#import "WeiboRenrenEngine.h"
@implementation SharePlatformModel 
@synthesize uid = _uid;
//@synthesize platformType = _platformType;
@synthesize switchOn = _switchOn;

-(void)dealloc{
    self.uid = nil;
   // self.platformType = -1;
    self.switchOn = NO;
    
    [super dealloc];
}

@end

SharePlatformCenter *center = nil;

@implementation SharePlatformCenter

@synthesize statusText;
@synthesize imagePath;

#pragma mark -
#pragma mark life
-(id)init{
    self = [super init];
    
    if (self) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:K_SHARE_DATAMODEL];
        
        if (dic) {
            _sharePlatformModelDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
            NSLog(@"model dic: %@", _sharePlatformModelDic);
        }else{
            _sharePlatformModelDic = [[NSMutableDictionary alloc] init];
        }
        
        _keyArray = [[NSArray alloc] initWithObjects: K_PLATFORM_Sina, K_PLATFORM_Tencent,K_PLATFORM_RenRen,nil];
    
        _tencentWeibo = [[WeiBoTencentEngine alloc] initWithAppKey:K_APPKEY_TENCENT AppSecret:K_APPSECRET_TENCENT];
        _tencentWeibo.dataDelegate = self;
        
        if ([_sharePlatformModelDic objectForKey:K_PLATFORM_Tencent]) {
            _tencentWeibo.tokenKey = [[_sharePlatformModelDic objectForKey:K_PLATFORM_Tencent] objectForKey:K_PLATFORM_MODEL_TOKENKEY];
            _tencentWeibo.tokenSecret = [[_sharePlatformModelDic objectForKey:K_PLATFORM_Tencent] objectForKey:K_PLATFORM_MODEL_TOKENSECRET];
        }
        
        _sinaWeibo = [[WeiBoSinaEngine alloc] initWithAppKey:K_APPKEY_SINA AppSecret:K_APPSECRET_SINA];
        _sinaWeibo.dataDelegate = self;
        
        if ([_sharePlatformModelDic objectForKey:K_PLATFORM_Sina]) {
            _sinaWeibo.tokenKey = [[_sharePlatformModelDic objectForKey:K_PLATFORM_Sina] objectForKey:K_PLATFORM_MODEL_TOKENKEY];
            _sinaWeibo.tokenSecret = [[_sharePlatformModelDic objectForKey:K_PLATFORM_Sina] objectForKey:K_PLATFORM_MODEL_TOKENSECRET];
        }
        _rerenWeibo = [[WeiboRenrenEngine alloc]initWithAppKey:K_APPKEY_Ren AppSecret:K_APPKEY_Ren appId:k_AppID_Ren];
		_rerenWeibo.dataDelegate = self;
		//[_rerenWeibo canceAuth];
		if ([_sharePlatformModelDic objectForKey:K_PLATFORM_RenRen]) {
            _rerenWeibo.tokenKey = [[_sharePlatformModelDic objectForKey:K_PLATFORM_RenRen] objectForKey:K_PLATFORM_MODEL_TOKENKEY];
            _rerenWeibo.tokenSecret = [[_sharePlatformModelDic objectForKey:K_PLATFORM_RenRen] objectForKey:K_PLATFORM_MODEL_TOKENSECRET];
			//_rerenWeibo.
			
			if(![_rerenWeibo isAuth]){
				[self removeModelDataWithType:K_PLATFORM_RenRen];
			}
		}
        _shareArray = [[NSMutableArray alloc] init];
        _shareFailArray = [[NSMutableArray alloc] init];
        _shareSuccessArray = [[NSMutableArray alloc] init];

    }
    
    return self;
}

-(void)dealloc{
    [_sharePlatformModelDic release];
    _sharePlatformModelDic = nil;
    
    [_keyArray release];
    _keyArray = nil;
    
    self.imagePath = nil;
    self.statusText = nil;
    
    [_tencentWeibo release];
    _tencentWeibo = nil;
    
    [_sinaWeibo release];
    _sinaWeibo = nil;
    
    [_shareFailArray release];
    _shareFailArray = nil;
    
    [_shareSuccessArray release];
    _shareSuccessArray = nil;
    
    [_shareArray release];
    _shareArray = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark public static api
+(SharePlatformCenter *)defaultCenter{
    @synchronized([SharePlatformCenter  class]){
        if (center == nil) {
            center = [[SharePlatformCenter alloc] init];
        }
    }
    
    return center;
}

+(void)clearCenter{
    if (center) {
        [center release];
        center = nil;
    }
}

#pragma mark -
#pragma mark instance api
-(void)switchOn:(NSString *)type{
    if ([type isKindOfClass:[NSString class]]) {
        NSDictionary *dic = [_sharePlatformModelDic objectForKey:type];
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dataModel = [[NSMutableDictionary alloc] initWithDictionary:dic];
            [dataModel setObject:[NSNumber numberWithBool:YES] forKey:K_PLATFORM_MODEL_SWITCHON];
            [_sharePlatformModelDic setObject:dataModel forKey:type];
            [self saveToDisk];
        }
    }

}

-(void)switchOff:(NSString *)type{
    if ([type isKindOfClass:[NSString class]]) {
        NSDictionary *dic = [_sharePlatformModelDic objectForKey:type];
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dataModel = [[NSMutableDictionary alloc] initWithDictionary:dic];
            [dataModel setObject:[NSNumber numberWithBool:NO] forKey:K_PLATFORM_MODEL_SWITCHON];
            [_sharePlatformModelDic setObject:dataModel forKey:type];
            [self saveToDisk];
        }
    }

}

- (BOOL)switchState:(NSString *)type{
    NSDictionary *dic = [_sharePlatformModelDic objectForKey:type];
    
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dataModel = [[NSMutableDictionary alloc] initWithDictionary:dic];
        
        return [[dataModel objectForKey:K_PLATFORM_MODEL_SWITCHON] boolValue];
    }
    
    return NO;
}

-(void)sendStatus:(NSString *)status ImageData:(NSData *)data{
    NSArray *keyArray = [_sharePlatformModelDic allKeys];
    
    for (NSString *key in keyArray) {
        NSDictionary *dic = [_sharePlatformModelDic objectForKey:key];
        
        NSNumber *switchOn = [dic objectForKey:K_PLATFORM_MODEL_SWITCHON];
        if ([switchOn isKindOfClass:[NSNumber class]] &&
            [switchOn boolValue]) {
            
            NSString *uid = [dic objectForKey:K_PLATFORM_MODEL_UID];
            if (![uid isKindOfClass:[NSString class]]) {
                continue;
            }
            
            WeiBoBaseEngine *engine = nil;
           
            if ([key isEqualToString:K_PLATFORM_Tencent]) {
                engine = _tencentWeibo;
            }else if([key isEqualToString:K_PLATFORM_Sina]){
                engine = _sinaWeibo;
            }
            else if([key isEqualToString:K_PLATFORM_RenRen]){
				engine = _rerenWeibo;
			}
            if (engine) {
                [engine sendStatus:status Image:data];
                [_shareArray addObject:engine];
            }
        }
            

        
    }
}

//-(void)asyncSendStatus{
//    [self sendStatus:self.statusText ImagePath:self.imagePath];
//}

-(void)saveToDisk{
    [[NSUserDefaults standardUserDefaults] setObject:_sharePlatformModelDic forKey:K_SHARE_DATAMODEL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)addModelData:(NSDictionary *)dataDic withType:(NSString *)type{
    if ([dataDic isKindOfClass:[NSDictionary class]] ||
        [type isKindOfClass:[NSString class]]) {
        [_sharePlatformModelDic setValue:dataDic forKey:type];
        
        [self saveToDisk];
    }
}

-(void)removeModelDataWithType:(NSString *)type{
    if ([type isKindOfClass:[NSString class]] && 
        [_sharePlatformModelDic objectForKey:type]) {
        
        [_sharePlatformModelDic removeObjectForKey:type];
        [self saveToDisk];
    }
}

-(void)removeAllModelData{
    [_sharePlatformModelDic removeAllObjects];
    [self saveToDisk];
}

-(NSInteger)shareEnableCount{
    int count = 0;
    
    NSArray *keyArray = [_sharePlatformModelDic allKeys];
    
    for (NSString *key in keyArray) {
        NSDictionary *modelData = [_sharePlatformModelDic objectForKey:key];
        
        if ([[modelData objectForKey:K_PLATFORM_MODEL_SWITCHON] boolValue]) {
            count++;
        }
    }
    
    return count;
}

-(NSInteger)modelCountInCenter{
	
    return [_sharePlatformModelDic count];
}

-(NSDictionary *)modelDataAtIndex:(NSInteger)index{
    NSArray *array = [_sharePlatformModelDic allKeys];

    if (index>=[array count]) 
        return nil;
    
    return [_sharePlatformModelDic objectForKey:[array objectAtIndex:index]];
}

-(NSDictionary *)modelDataWithType:(NSString *)type{
    NSDictionary *data = [_sharePlatformModelDic objectForKey:type];
    
    if (data == nil) {
        [self removeModelDataWithType:type];
    }
    
    return data;
}

-(NSString *)modelKeyAtIndex:(NSInteger)index{
    NSArray *array = [_sharePlatformModelDic allKeys];
    
    if (index>=[array count]) 
        return nil;
    
    return [array objectAtIndex:index];
}

-(NSString *)plateformNameWithKey:(NSString *)key{
    if (![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if ([key isEqualToString:K_PLATFORM_RenRen]) {
        return @"人人网";
    }else if([key isEqualToString:K_PLATFORM_Sina]){
        return @"新浪微博";
    }else if([key isEqualToString:K_PLATFORM_Tencent]){
        return @"腾讯微博";
    }
    
    return nil;
}

-(void)bindPlatformWithKey:(NSString *)key WithController:(UIViewController *)tc{
    if (![key isKindOfClass:[NSString class]] || ![tc isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    WeiBoBaseEngine *tengine = nil;
    
    if ([key isEqualToString:K_PLATFORM_Tencent] && ![_tencentWeibo isAuth]) {
        tengine = _tencentWeibo;
    }else  if ([key isEqualToString:K_PLATFORM_Sina] && ![_sinaWeibo isAuth]) {
        tengine = _sinaWeibo;
    }
    else if ([key isEqualToString:K_PLATFORM_RenRen] && ![_rerenWeibo isAuth]){
		tengine = _rerenWeibo;
		//[tengine auth];
		/*
		 id authVc = [tengine getAuthViewController];
		[tc.navigationController pushViewController:authVc animated:YES];
		return;
		*/
		
		ShareAuthViewController *ttc = [[ShareAuthViewController alloc] initWithEngine:tengine];
        ttc.type = 3;
		[tc.navigationController pushViewController:ttc animated:YES];
        [ttc release];
        tengine.authDelegate = ttc;
		
		return;
	}
    if (tengine) {
		ShareAuthViewController *ttc = [[ShareAuthViewController alloc] initWithEngine:tengine];
        [tc.navigationController pushViewController:ttc animated:YES];
        [ttc release];
        tengine.authDelegate = ttc;
    }

}

-(void)cancelBindPlatformWithKey:(NSString *)key{
    if (![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    [_sharePlatformModelDic removeObjectForKey:key];
    
    if ([key isEqualToString:K_PLATFORM_Sina]) {
        [_sinaWeibo canceAuth];
    }else if([key isEqualToString:K_PLATFORM_Tencent]){
        [_tencentWeibo canceAuth];
    }
    else if ([key isEqualToString:K_PLATFORM_RenRen]) {
		[_rerenWeibo canceAuth];
	}
    [self saveToDisk];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:K_CANCELBIND_NOTE object:self];
}

-(void)checkShareResult{
    if ([_shareArray count] == 0) {
        NSMutableString *result = [NSMutableString string];
        
        for (WeiBoBaseEngine *engine in _shareSuccessArray) {
            NSString *share = nil;
            if (engine == _sinaWeibo) {
                share = @"新浪微博";
            }else if(engine == _tencentWeibo){
                share = @"腾讯微博";
            }
            else if(engine == _rerenWeibo) {
				share = @"人人网";

			}

            [result appendFormat:@"分享至%@成功\n", share];
        }
        
        [_shareSuccessArray removeAllObjects];
        
        for (WeiBoBaseEngine *engine in _shareFailArray) {
            NSString *share = nil;
            if (engine == _sinaWeibo) {
                share = @"新浪微博";
            }else if(engine == _tencentWeibo){
                share = @"腾讯微博";
            }
			else if(engine == _rerenWeibo) {
				share = @"人人网";
				
			}
            [result appendFormat:@"分享至%@失败！\n", share];
        }
        
        [_shareFailArray removeAllObjects];
        
        UIAlertView *tv = [[UIAlertView alloc] initWithTitle:@"分享结果" message:result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [tv show];
        [tv release];
    }
}

#pragma mark -
#pragma mark weibo base engine
-(void)userInfoWithEngine:(WeiBoBaseEngine *)engine resultDic:(NSDictionary *)dic{
    NSString *nickname = nil;
    NSString *platType = nil;
    
    if (engine == _tencentWeibo) {
        nickname = [dic objectForKey:@"nick"];
        platType = K_PLATFORM_Tencent;
    }else if(engine == _sinaWeibo){
        nickname = [dic objectForKey:@"name"];
        platType = K_PLATFORM_Sina;
    }
    else if (engine == _rerenWeibo){
		WeiboRenrenEngine *tEngine = (WeiBoBaseEngine*)engine;
		nickname = [dic objectForKey:@"nick"];
		platType = K_PLATFORM_RenRen;
		NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:nickname, K_PLATFORM_MODEL_UID,
                              [NSNumber numberWithBool:YES], K_PLATFORM_MODEL_SWITCHON,
                              tEngine.tokenKey, K_PLATFORM_MODEL_TOKENKEY,
                              tEngine.tokenSecret, K_PLATFORM_MODEL_TOKENSECRET,
							  tEngine.accessToken, K_PLATFORM_MODEL_ACCESSTOKEN,
							  tEngine.expirationDate,K_PLATFORM_MODEL_EXPIRETIME,
                              nil];
        [self addModelData:tdic withType:platType]; 
        
        [[NSNotificationCenter defaultCenter] postNotificationName:K_UPDATEUSER_NOTE object:nil];
		return;
	}

    if ([nickname isKindOfClass:[NSString class]]) 
	{
        NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:nickname, K_PLATFORM_MODEL_UID,
                              [NSNumber numberWithBool:YES], K_PLATFORM_MODEL_SWITCHON,
                              engine.tokenKey, K_PLATFORM_MODEL_TOKENKEY,
                              engine.tokenSecret, K_PLATFORM_MODEL_TOKENSECRET,
                              nil];
        [self addModelData:tdic withType:platType]; 
        
        [[NSNotificationCenter defaultCenter] postNotificationName:K_UPDATEUSER_NOTE object:nil];
    }else {
        engine.tokenKey = nil;
        engine.tokenSecret = nil;
    }

}

-(void)sendStatusOKWithEngine:(WeiBoBaseEngine *)engine{
    [_shareArray removeObject:engine];
    [_shareSuccessArray addObject:engine];
    
    if ([_shareArray count] == 0) {
        [self checkShareResult];
		[[NSNotificationCenter defaultCenter] postNotificationName:K_SEND_RESULT_NOTE object:nil];
    }
	

}

-(void)sendStatusFailWithEngine:(WeiBoBaseEngine *)engine failReason:(NSString *)reason{
//    UIAlertView *tView = [[UIAlertView alloc] initWithTitle:nil message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [tView show];
//    [tView release];
	[[NSNotificationCenter defaultCenter] postNotificationName:K_SEND_RESULT_NOTE object:nil];
    [_shareArray removeObject:engine];
    [_shareFailArray addObject:engine];
    
    if ([_shareArray count] == 0) {
        [self checkShareResult];
    }
}
@end
