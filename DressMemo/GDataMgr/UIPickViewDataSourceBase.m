//
//  UIPickViewDataSourceBase.m
//  DressMemo
//
//  Created by  on 12-7-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIPickViewDataSourceBase.h"
@interface UIPickViewDataSourceBase()
@property(nonatomic,retain)NSArray *data;
@property(nonatomic,retain)NSArray *multipleData;
@property(nonatomic,assign)BOOL mulTag;
@end
@implementation UIPickViewDataSourceBase
@synthesize data;
@synthesize multipleData;
@synthesize mulTag;
-(id)initWithData:(NSArray*)srcData
{
    if(self= [super init])
    {
        self.data = [NSMutableArray arrayWithArray:srcData];
    }
    return self;
}
-(void)setSourceData:(NSArray *)srcData{
    self.data = srcData;
    //self.subData = 
}
-(void)setSubData:(NSArray*)subData
{
    self.multipleData = subData;
    mulTag = YES;
}
-(void)setMutipleConponentData:(NSArray*)srcData{
    self.multipleData = srcData;
    mulTag = YES;
}
-(void)setSourceData:(NSArray *)srcData withSubData:(NSArray*)subData{
    self.multipleData = subData;
    self.data = srcData;
}
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(mulTag)
    {
        return 2;
    }
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(mulTag)
    { 
        if(component == 0)
            return [self.data count];
        if(component == 1)
            return [self.multipleData count];
    }
    else 
    return [self.data count];
}
-(void)dealloc
{
    self.data = nil;
    self.multipleData = nil;
    [super dealloc];
}
@end
