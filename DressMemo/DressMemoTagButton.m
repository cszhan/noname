//
//  DressMemoTagButton.m
//  DressMemo
//
//  Created by  on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DressMemoTagButton.h"

@implementation DressMemoTagButton
@synthesize tagInforView;
@synthesize imageTag;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc{
    self.tagInforView = nil;
    [super dealloc];
}
@end
