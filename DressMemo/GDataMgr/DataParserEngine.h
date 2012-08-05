//
//  DataParserEngine.h
//  DressMemo
//
//  Created by cszhan on 12-8-5.
//
//

#import <Foundation/Foundation.h>

@protocol DataParserEngineDelegate <NSObject>
- (void) didParserDataOk:(NSArray *)array;
@end
@interface DataParserEngine : NSObject
-(void)queueParserOperateionWithJSonData:(NSString*)jsonData;
@end
