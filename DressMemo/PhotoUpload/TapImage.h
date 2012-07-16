//
//  TapImage.h
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import <Foundation/Foundation.h>
@protocol TapImageDelegate<NSObject>
-(void)didTouchView:(UIImageView*)sender;
@end
@interface TapImage : UIImageView
{   
    CGPoint curTouchPoint;
    BOOL isMoveTouch;
  
}
@property(nonatomic,assign)BOOL hasImageData;
@property(nonatomic,assign)BOOL  hasZoom;
@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)UIView *maskView;
-(CGPoint)getTouchPoint;
@end
