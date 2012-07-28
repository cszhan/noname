//
//  UITextViewInputCell.m
//  DressMemo
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UITextViewInputCell.h"

@implementation UITextViewInputCell
@synthesize inputTextView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(id)getFromNibFile
{
    NSArray *nibItems = [[NSBundle mainBundle] loadNibNamed:@"UITextViewInputCell" owner:self options:nil];
    UITextViewInputCell *instance = [nibItems objectAtIndex:0];
    instance.inputTextView.returnKeyType = UIReturnKeyDone;
    //instance.inputTextView.delegate = instance;
    return instance;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    [textView resignFirstResponder];
    //textView.layer.borderColor = [UIColor blackColor].CGColor;
    //textView.layer.borderWidth = 0.0f;
}
@end
