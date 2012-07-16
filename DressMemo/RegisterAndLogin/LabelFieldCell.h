//
//  LabelFieldCell.h
//  Ebox_Iphone
//
//  Created by pff on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCSTableViewCellBase.h"
#import "ZCSRoundLabel.h"
extern NSString *TextFieldShouldResign;
@protocol didEndCellInput <NSObject>
@optional
-(void)didEndCellInput:(id)sender;
@end
@interface LabelFieldCell : ZCSTableViewCellBase <UITextFieldDelegate>{
	IBOutlet ZCSRoundLabel *cellName;
	IBOutlet UITextField *cellField;
}

@property (nonatomic, retain)IBOutlet UILabel *cellName;
@property (nonatomic, retain)IBOutlet UITextField *cellField;
@property (nonatomic, assign) id delegate;
//@property (nonatomic, retain)IBOutlet UIImageView *cellLeftBGView;

-(void)setLabelName:(NSString *)name;
-(void)setFieldName:(NSString *)name;

-(void)setLabelTextColor:(UIColor *)tColor;
-(void)setLabelTextSize:(int)tSize;

-(void)setFieldTextColor:(UIColor *)tColor;
-(void)setFieldTextSize:(int)tSize;

-(void)setFieldTextFont:(UIFont*)font;
-(void)setLabelTextFont:(UIFont*)font;

@end
