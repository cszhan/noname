//
//  UIButtonLikeCell.h
//  DressMemo
//
//  Created by  on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UITableViewCellDelegate
@optional
-(void)didTouchEvent:(id)sender;
@end    
@interface UIButtonLikeCell : UITableViewCell
@property(nonatomic,assign)id touchDelegate;
@property(nonatomic,retain)UILabel *labelText;
@end
