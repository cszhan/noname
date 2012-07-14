//
//  LabelFieldCell.m
//  Ebox_Iphone
//
//  Created by pff on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LabelFieldCell.h"
#import "LoginAndSignupConfig.h"
#import <QuartzCore/QuartzCore.h>
NSString *TextFieldShouldResign = @"TextFieldShouldResign";

@implementation LabelFieldCell
@synthesize cellName;
@synthesize cellField;
@synthesize cellLeftBGView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
		NSArray *nibItems = [[NSBundle mainBundle] loadNibNamed:@"LabelFieldCell" owner:self options:nil];

        UIImageView *superCellLeftBGView = self.cellLeftBGView;
		self = [nibItems objectAtIndex:0];
#if 0
        self.cellLeftBGView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.cellLeftBGView.backgroundColor = kLoginCellItemLeftBGColor;
        self.cellLeftBGView.frame = CGRectMake(0.f, 0.f, kLoginCellItemLeftWidth, kLoginCellItemHeight);
#endif
        //UIView *subView = [nibItems objectAtIndex:0];
		//[self addSubview:subView];
        //subView.backgroundColor = [UIColor clearColor];
        //[self insertSubview:self.cellLeftBGView belowSubview:cellName];
		cellName.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        cellName.layer.masksToBounds = YES;
        cellName.radius = 10.0;
        //cellName.clipsToBounds = YES;
        //cellName.layer.cornerRadius = 5.0;
        cellName.backgroundColor = [UIColor clearColor];
        //cellName.cellLeftBGView = [];
        cellName.cornerColor = kLoginAndSignupCellLineColor;
        cellName.bgColor = kLoginAndSignupCellImageBGColor;
        cellName.layer.borderWidth = 0.f;
        cellName.textAlignment = UITextAlignmentCenter;
        //.backgroundColor = [UIColor clearColor];
        self.cellLeftBGView.hidden = YES;
        self.cellLeftBGView.clipsToBounds = YES;
        self.cellLeftBGView.layer.masksToBounds = YES;
		cellField.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignField:) name:TextFieldShouldResign object:nil];
        //self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withLoadXIB:(BOOL)isfromXIB
{
   
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
		NSArray *nibItems = [[NSBundle mainBundle] loadNibNamed:@"LabelFieldCell" owner:self options:nil];
        //UIImageView *superCellLeftBGView = self.cellLeftBGView;
		self = [nibItems objectAtIndex:0];
        //self.cellLeftBGView = superCellLeftBGView;
        //UIView *subView = [nibItems objectAtIndex:0];
		//[self addSubview:subView];
        //subView.backgroundColor = [UIColor clearColor];
        //[self insertSubview:self.cellLeftBGView belowSubview:cellName];
		cellName.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        cellName.textAlignment = UITextAlignmentCenter;
        cellName.backgroundColor = [UIColor clearColor];
		cellField.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignField:) name:TextFieldShouldResign object:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	self.cellName = nil;
	self.cellField = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TextFieldShouldResign object:nil];
    [super dealloc];
}

-(void)setLabelName:(NSString *)name{
	cellName.text = name;
}
-(void)setFieldName:(NSString *)name{
	cellField.text = name;
}

-(void)setLabelTextColor:(UIColor *)tColor{
	cellName.textColor = tColor;
}
-(void)setLabelTextBGColor:(UIColor*)tColor{

    cellName.backgroundColor = tColor;

}
-(void)setLabelTextFont:(UIFont*)font{
    cellField.font = font;
}
-(void)setLabelTextSize:(int)tSize{
	cellName.font = [UIFont systemFontOfSize:tSize];
}
-(void)setLeftBackGroundViewColor:(UIColor*)color
{
    self.cellLeftBGView.backgroundColor = color;
}
-(void)setleftBackGroundViewFrame:(CGRect)rect
{
    self.cellLeftBGView.frame = rect;
}
-(void)setFieldTextColor:(UIColor *)tColor{
	cellField.textColor = tColor;
}
-(void)setFieldTextFont:(UIFont*)font{
    cellField.font = font;
}
-(void)setFieldTextSize:(int)tSize{
	cellField.font = [UIFont systemFontOfSize:tSize];
}

//-(void)setCellLeftBGView:(UIImageView *)_cellLeftBGView
//{
//    [self.cellLeftBGView removeFromSuperview];
//    self.cellLeftBGView = _cellLeftBGView; 
//}
-(void)resignField:(NSNotification *)note{
//	NSLog(@"%d",[cellField isFirstResponder]);
	[cellField resignFirstResponder];
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//	[textField resignFirstResponder];
//}
//
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
////	 NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
////	[center postNotificationName:UIKeyboardWillShowNotification object:nil];
////	[textField resignFirstResponder];
//} 
//-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//
//    //if(CGRectContainsPoint(self.frame, point))
//        return self.cellField;
///*
//    else 
//    {
//        return [super hitTest:point withEvent:event];
//    }
// */
//}
- (void)drawRect:(CGRect)rect 
{
#if 0
    CGRect colorRect = CGRectMake(9.f, 0.f, rect.size.width/3.f, rect.size.height);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor( context, [UIColor whiteColor].CGColor );
    CGContextFillRect( context, colorRect );
#endif
    /*
    CGRect holeRectIntersection = CGRectIntersection( holeRect, rect );
    
    CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
    CGContextSetBlendMode(context, kCGBlendModeClear);
    
    CGContextFillEllipseInRect( context, holeRect );
    */
    [super drawRect:rect];
}
@end
