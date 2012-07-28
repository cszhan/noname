//
//  FriendItemCell.h
//  DressMemo
//
//  Created by  on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINetActiveIndicatorButton.h"
@interface FriendItemCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UILabel *nickNameLabel;
@property(nonatomic,retain)IBOutlet UILabel *locationLabel;
@property(nonatomic,retain)IBOutlet UINetActiveIndicatorButton *relationBtn;
@property(nonatomic,retain)IBOutlet UIImageView *userIconImageView;
@end
