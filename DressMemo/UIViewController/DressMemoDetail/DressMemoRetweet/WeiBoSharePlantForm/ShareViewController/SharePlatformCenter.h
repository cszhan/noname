//
//  SharePlatformCenter.h
//  UMSNSDemo
//
//  Created by Fengfeng Pan on 11-12-10.
//  Copyright (c) 2011年 Realcent. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UMSNSService.h"
#import "constant.h"
#import "WeiBoBaseEngine.h"

@interface SharePlatformModel : NSObject {
    NSString *_uid;
    //UMShareToType _platformType;

    Boolean _switchOn;
}

@property (nonatomic, copy)NSString *uid;
//@property (nonatomic, assign)UMShareToType platformType;
@property (nonatomic, assign)Boolean switchOn;

@end

@interface SharePlatformCenter : NSObject <WeiBoEngineDataDelegate>{
    NSMutableDictionary *_sharePlatformModelDic;
    
    WeiBoBaseEngine *_tencentWeibo;
    WeiBoBaseEngine *_sinaWeibo;
    WeiBoBaseEngine *_rerenWeibo;
    NSArray *_keyArray;
    
    NSMutableArray *_shareArray;
    NSMutableArray *_shareSuccessArray;
    NSMutableArray *_shareFailArray;
}

@property (nonatomic, copy) NSString *statusText;
@property (nonatomic, copy) NSString *imagePath;

+(SharePlatformCenter *)defaultCenter;
+(void)clearCenter;

-(void)switchOn:(NSString *)type;
-(void)switchOff:(NSString *)type;
- (BOOL)switchState:(NSString *)type;

-(void)sendStatus:(NSString *)status ImageData:(NSData *)data;

-(void)addModelData:(NSDictionary *)dataDic withType:(NSString *)type;
-(void)removeModelDataWithType:(NSString *)type;
-(void)removeAllModelData;
-(NSInteger)shareEnableCount;

-(void)saveToDisk;

-(NSInteger)modelCountInCenter;
-(NSDictionary *)modelDataAtIndex:(NSInteger)index;
-(NSDictionary *)modelDataWithType:(NSString *)type;
-(NSString *)modelKeyAtIndex:(NSInteger)index;

-(NSString *)plateformNameWithKey:(NSString *)key;

-(void)bindPlatformWithKey:(NSString *)key WithController:(UIViewController *)tc;
-(void)cancelBindPlatformWithKey:(NSString *)key;


@end
