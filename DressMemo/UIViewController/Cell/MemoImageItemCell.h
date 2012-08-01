//
//  MemoImageItemCell.h
//  DressMemo
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MemoImageItemCellDelegate<NSObject>
@optional
-(void)didTouchItemCell:(id)cell subItem:(id)sender;
@end
@interface MemoImageItemCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UIButton *imageItemBtn0;
@property(nonatomic,retain)IBOutlet UIButton *imageItemBtn1;
@property(nonatomic,retain)IBOutlet UIButton *imageItemBtn2;
@property(nonatomic,retain)IBOutlet UIButton *imageTimeTitleBtn0;
@property(nonatomic,retain)IBOutlet UIButton *imageTimeTitleBtn1;
@property(nonatomic,retain)IBOutlet UIButton *imageTimeTitleBtn2;
@property(nonatomic,retain)NSIndexPath *indexPath;
@property(nonatomic,assign)id delegate;
@end
