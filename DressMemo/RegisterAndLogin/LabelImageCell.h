//
//  LabelImageCell.h
//  Ebox_Iphone
//
//  Created by pff on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIButtonLikeCell.h"
#import "ZCSTableViewCellBase.h"

@interface LabelImageCell : UIButtonLikeCell {
	IBOutlet UILabel *cellLabel;
	IBOutlet UIImageView *cellImage;
}
@property (nonatomic, retain) IBOutlet UILabel *cellLabel;
@property (nonatomic, retain) IBOutlet UIImageView *cellImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setLabelName:(NSString *)str;
-(void)setCellImg:(UIImage *)img;
@end
