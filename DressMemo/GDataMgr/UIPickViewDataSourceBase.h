//
//  UIPickViewDataSourceBase.h
//  DressMemo
//
//  Created by  on 12-7-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIPickViewDataSourceBase : NSObject<UIPickerViewDataSource>
-(id)initWithData:(NSArray*)srcData;
-(void)setSourceData:(NSArray*)srcData;
-(void)setSubData:(NSArray*)subData;
-(void)setSourceData:(NSArray *)srcData withSubData:(NSArray*)srcData;
@end
