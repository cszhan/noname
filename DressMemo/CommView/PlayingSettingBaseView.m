//
//  PlayingSettingBaseView.m
//  MP3Player
//
//  Created by cszhan on 12-1-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayingSettingBaseView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PlayingSettingBaseView

- (void)awakeFromNib{
	// Initialization code.
	self.backgroundColor = [UIColor clearColor];
	self.alpha = 1.0;

}
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.backgroundColor = [UIColor clearColor];
		//self.alpha = 0.5;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/
- (void)setBgImage:(UIImage*)image{
	self.layer.contents = (id)image.CGImage;
}
- (void)dealloc {
    [super dealloc];
}


@end
