//
//  LabelRightImageCell.h
//  DressMemo
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelRightImageCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UIView *seperateHLineView;
@property(nonatomic,retain)IBOutlet UIView *seperateVLineView;
@property(nonatomic,retain)IBOutlet UITextField *nickNameTextField;
@property(nonatomic,retain)IBOutlet UITextField *locationTextField;
@property(nonatomic,retain)IBOutlet UIButton *cityBtn;
@property(nonatomic,retain)IBOutlet UIImageView *userIconImageView;
@property(nonatomic,retain)IBOutlet UIButton  *userIconEditBtn;
@end
