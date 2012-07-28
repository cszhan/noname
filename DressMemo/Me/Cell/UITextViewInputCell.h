//
//  UITextViewInputCell.h
//  DressMemo
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"
@interface UITextViewInputCell : UITableViewCell
@property(nonatomic,retain) IBOutlet GCPlaceholderTextView    *inputTextView;
@end
