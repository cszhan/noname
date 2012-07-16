//
//  TagDescriptionViewController.h
//  DressMemo
//
//  Created by  on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIBaseViewController.h"
#import "UITagChooseBaseViewController.h"
#import "GCPlaceholderTextView.h"
//#import ""
@interface MemoDescriptionViewController : UIViewController
@property(nonatomic,retain) IBOutlet UITextField *subAddressTextFied;
@property(nonatomic,retain) IBOutlet UIButton    *AddressBtn;
@property(nonatomic,retain) IBOutlet UIButton    *motionBtn;
@property(nonatomic,retain) IBOutlet UIButton    *senceBtn;
@property(nonatomic,retain) IBOutlet GCPlaceholderTextView    *despTextView;
@property(nonatomic,retain) IBOutlet UIPickerView *pickerView;
@property(nonatomic,retain) IBOutlet UIView      *mainFrameView;
//@property(nonatomic,retain) IBOutlet UILabel     *indicatorTextLabel;
@property(nonatomic,assign) CGSize  gMainFrameSize;
@end
