//
//  LabelImageCell.m
//  Ebox_Iphone
//
//  Created by pff on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LabelImageCell.h"


@implementation LabelImageCell
@synthesize cellLabel;
@synthesize cellImage;
//@synthesize cellBGView;
- (void)dealloc 
{
#if 1
    self.cellImage = nil;
	self.cellLabel = nil;
#endif
    //self.cellBGView = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
		NSArray *nibItems = [[NSBundle mainBundle] loadNibNamed:@"LabelImageCell" owner:self options:nil];
		self = [nibItems objectAtIndex:0];
       // subView.backgroundColor = [UIColor clearColor];
		cellLabel.font = [UIFont systemFontOfSize:16];
		cellLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
		cellLabel.textAlignment = UITextAlignmentLeft;
        //self.cellImage.contentMode = 
        //cellBGView.backgroundColor  = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

-(void)setLabelName:(NSString *)str{
	cellLabel.text = str;
}
-(void)setCellImg:(UIImage *)img{
	cellImage.image = img;
}



@end
