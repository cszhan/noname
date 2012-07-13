//
//  TagChooseBrandViewController.h
//  DressMemo
//
//  Created by  on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UITagChooseBaseViewController.h"
#import "DressMemoTagButton.h"
@interface TagChooseBrandViewController : UITagChooseBaseViewController<UIPickerViewDelegate,UITextFieldDelegate>
@property(nonatomic,assign)id delegate;
/**
 0:cats
 1:brand
 */
-(void)setInitSourceData:(NSDictionary*)srcData ;
-(void)setInitSourceData:(NSDictionary *)srcData withTagBtn:(DressMemoTagButton*)btn;
          // withInforView:(UIView*)view;
//-(void)setInitTagSourceData:(NSDictionary*)srcData;
@end
