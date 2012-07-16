
//
//  NEAlertTextView.m
//  MP3Player
//
//  Created by cszhan on 12-2-5.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ZCSAlertInforView.h"
#import <QuartzCore/QuartzCore.h>
#include "UIParamsCfg.h"
#define kLeftPendingX 10.f
#define kTopPendingY 5.f
@interface ZCSAlertInforView()
@property(nonatomic,assign)BOOL isWindowAlert;
@end
@implementation ZCSAlertInforView
static UILabel *label = nil;
@synthesize text;
@synthesize isHiddenAuto;
@synthesize isWindowAlert;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}
- (void)setBGContent:(UIImage*)image{
    self.layer.contents = (id)[image CGImage];
}
-(id)initWithFrame:(CGRect)frame withText:(NSString*)text{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.frame = CGRectMake(0.f, 0.f, 160.f, 40.f);
		self.text = text;
		label = [[UILabel alloc]initWithFrame:CGRectMake(kLeftPendingX, kTopPendingY, self.frame.size.width-kLeftPendingX*2, self.frame.size.height-kTopPendingY*2)];
		label.text = text;
		label.font = kPlayViewTopBarTileFont;//[UIFont b:14];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		label.backgroundColor = [UIColor clearColor];
		label.center = self.center;
		self.backgroundColor = [UIColor blackColor];
		self.alpha = 1;
        // if(isWindow)
        {
            //self.windowLevel = UIWindowLevelAlert;
            isWindowAlert  = YES;
        }
        isHiddenAuto = YES;
		[self addSubview:label];
		[label release];
    }
    return self;
    
}
-(id)initWithFrame:(CGRect)frame withText:(NSString*)text isWindow:(BOOL)isWindow{
	self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		//self.frame = CGRectMake(0.f, 0.f, 160.f, 40.f);
		self.text = text;
		label = [[UILabel alloc]initWithFrame:CGRectMake(kLeftPendingX, kTopPendingY, self.frame.size.width-kLeftPendingX*2, self.frame.size.height-kTopPendingY*2)];
		label.text = text;
		label.font = kPlayViewTopBarTileFont;//[UIFont b:14];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		label.backgroundColor = [UIColor clearColor];
		label.center = self.center;
		self.backgroundColor = [UIColor blackColor];
		self.alpha = 0;
        if(isWindow)
        {
            //self.windowLevel = UIWindowLevelAlert;
            isWindowAlert  = YES;
        }
		[self addSubview:label];
		[label release];
    }
    return self;
	
}
-(void)setTextFont:(UIFont*)font{
    label.font = font;
}
-(void)show{
    if(isWindowAlert)
    {
        [self makeKeyWindow];
        [self makeKeyAndVisible];
    }
	self.alpha = 0.f;
	//[[UIApplication sharedApplication]keyWindow]
	[UIView animateWithDuration:0.5 
					 animations:^
     {self.alpha = 0.9f; } 
					 completion:^(BOOL finished)
     { 
         
         
     }
	 ];
    if(isHiddenAuto)
        [self performSelector:@selector(hiddenAuto) withObject:nil afterDelay:2.5];
}
- (void)hiddenAfterDelay:(NSTimeInterval)duration
{
    //[self performSelector:@selector(hiddenAuto) withObject:nil afterDelay:duration];
    [self performSelector:@selector(hiddenUpAnimation) withObject:nil afterDelay:duration];
}
-(void)hiddenAuto
{
	[UIView animateWithDuration:0.8 
					 animations:^
	 {  
         self.alpha = 0;
         
     } 
					 completion:^(BOOL finished)
	 { 
         
         
	 }
	 ];
    if(isWindowAlert)
    {
        [self resignKeyWindow];
    }
}
-(void)hiddenUpAnimation{
    [UIView animateWithDuration:0.8 
					 animations:^
	 {  
        
         self.frame = CGRectOffset(self.frame, 0,-self.frame.size.height);
        } 
					 completion:^(BOOL finished)
	 { 
        
          self.alpha = 0;
         
	 }
	 ];
}
-(void)layoutSubviews{
	label.text = text;
	//self.center = CGPointMake(kDeviceScreenWidth/2, kDeviceScreenHeight/2);
	label.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
	//NE_LOGRECT(label.frame);
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	//[UIFont ];
	[super drawRect:rect];
}

- (void)dealloc {
	self.text = nil;
    [super dealloc];
}
#if 0
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    /*
    UIView *parent = [self superview];
    if(parent == self)
    {
        return  [[[parent superview] hitTest:point withEvent:event] ;]
    }
    */
    //if(CGRectContainsPoint(, point))
    //return  [parent hitTest:point withEvent:event];
}
#endif
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    [super touchesBegan:touches withEvent:event];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
