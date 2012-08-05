//
//  DataParserEngine.m
//  DressMemo
//
//  Created by cszhan on 12-8-5.
//
//

#import "DataParserEngine.h"
#import "NTESMBDecodeJSONOperation.h"
@interface DataParserEngine()
@property(nonatomic,retain)NSOperationQueue *queue;
@end
@implementation DataParserEngine
@synthesize queue;
-(void)queueParserOperateionWithJSonData:(NSString*)jsonData
{
    NTESMBDecodeJSONOperation *op = [[NTESMBDecodeJSONOperation alloc]  initWithJSONString:jsonData];
    op.delegate = self;
    //op.isFromSearchAPI = isSearchState;
    [queue addOperation:op];
    [op release];
}
@end
