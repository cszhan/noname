//
//  TapImage.m
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "TapImage.h"
#import "ZCSNotficationMgr.h"
#import <QuartzCore/QuartzCore.h>
@implementation TapImage
@synthesize delegate;
@synthesize hasImageData;
@synthesize hasZoom;
@synthesize maskView;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
                    //:(NSSet *)touches withEvent:(UIEvent *)event
{
    isMoveTouch = NO;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    isMoveTouch = YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	//NSLog(@"Touches began");
    if(isMoveTouch)
        return;
	/*
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello!" 
													message:@"You tapped me!" 
												   delegate:nil 
										  cancelButtonTitle:@"Oh yes!" 
										  otherButtonTitles:nil];
	
	[alert show];
	[alert release];
    */
    NSArray *touchEventsArr = [[event allTouches]allObjects];
    curTouchPoint = [[touchEventsArr objectAtIndex:0]locationInView:self];
    if(self.delegate &&[self.delegate respondsToSelector:@selector(didTouchView:)])
    {
        [self.delegate didTouchView:self];
    }
   //[ZCSNotficationMgr postMSG:k obj:<#(id)#>
}
/*
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return  self;
}
*/
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    return YES;
//}

-(CGPoint)getTouchPoint
{
    return curTouchPoint;
}
-(void)dealloc
{
    [super dealloc];
}
@end
