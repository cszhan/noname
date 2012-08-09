//
//  ROPublishFeedParam.h
//  UMSNSDemo
//
//  Created by cszhan on 11-12-18.
//  Copyright 2011 Realcent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORequestParam.h"

@interface ROPublishFeedRequestParam : RORequestParam {

}
//@property(nonatomic,retain)NSString* method;
@property(nonatomic,retain)NSString* title;
@property(nonatomic,retain)NSString* text;
@property(nonatomic,retain)NSString* imageUrl;
@end
