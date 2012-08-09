//
//  UIRetweetView.m
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIRetweetView.h"
#import "SharePlatformCenter.h"

#pragma mark -
#pragma mark UIRetweetView
@implementation UIRetweetView
@synthesize tableView = _tableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:_tableView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc{
    Safe_Release(_tableView)
    
    [super dealloc];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _tableView.frame = self.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

#pragma mark -
#pragma mark UIRetweetInputCell
@implementation UIRetweetInputCell 
@synthesize inputView = _inputView;

#define kDefaultCount 140
#define kUIRetweetInputCellCountLabelFont [UIFont systemFontOfSize:12]
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _inputView = [[UITextView alloc] initWithFrame:CGRectZero];
        _inputView.font = [UIFont systemFontOfSize:14];
        _inputView.backgroundColor = [UIColor clearColor];
        _inputView.textColor = [UIColor lightGrayColor];
        _inputView.delegate = self;
        [self.contentView addSubview:_inputView];
        
        _image = [[UIImageView alloc] initWithFrame:CGRectZero];
        _image.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_image];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textColor = [UIColor darkGrayColor];
        _countLabel.font = kUIRetweetInputCellCountLabelFont;
        _countLabel.textAlignment = UITextAlignmentRight;
        _countLabel.text = @"140";
        [self.contentView addSubview:_countLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    return self;
}

- (void)dealloc{
    Safe_Release(_inputView)
    Safe_Release(_image)
    Safe_Release(_countLabel)
    
    [super dealloc];
}

#define kUIRetweetInputCellTopPadding 10
#define kUIRetweetInputCellLeftPadding 10

#define kUIRetweetInputCellImageWidth 60
#define kUIRetweetInputCellImageHeight 80   

#define kUIRetweetInputCellImageInputPadding 20
#define kUIRetweetInputCellInputHeight 120

#define kUIRetweetInputCellInputCountPadding 10
- (void)layoutSubviews{
    [super layoutSubviews];
    
    _image.frame = CGRectMake(kUIRetweetInputCellLeftPadding, 
                              kUIRetweetInputCellTopPadding, 
                              kUIRetweetInputCellImageWidth, 
                              kUIRetweetInputCellImageHeight);
    
    CGFloat viewWidth = self.contentView.bounds.size.width-kUIRetweetInputCellLeftPadding-kUIRetweetInputCellLeftPadding-_image.bounds.size.width-kUIRetweetInputCellImageInputPadding;
    
    _inputView.frame = CGRectMake(_image.frame.origin.x+_image.bounds.size.width+kUIRetweetInputCellImageInputPadding, 
                                  _image.frame.origin.y, 
                                  viewWidth, kUIRetweetInputCellInputHeight);
    
    CGSize viewSize = [NTESMBUtility getSizeForText:_countLabel.text font:_countLabel.font];
    _countLabel.frame = CGRectMake(self.contentView.bounds.size.width-kUIRetweetInputCellLeftPadding-viewSize.width, 
                                   _inputView.frame.origin.y+_inputView.frame.size.height+kUIRetweetInputCellInputCountPadding, 
                                   viewSize.width, viewSize.height);
    
}


+ (CGFloat)cellHeight{
    CGFloat contentHeight = 0;
    
    contentHeight+=kUIRetweetInputCellInputHeight;
    contentHeight+=kUIRetweetInputCellInputCountPadding;
    
    NSString *s = [NSString stringWithFormat:@"%d", kDefaultCount];
    CGFloat viewHeight = [NTESMBUtility getHeightForText:s font:kUIRetweetInputCellCountLabelFont];
    contentHeight+=viewHeight;
    
    return (contentHeight+kUIRetweetInputCellTopPadding+kUIRetweetInputCellTopPadding);
}

#pragma mark -Delegate
- (void)textViewDidChange:(UITextView *)textView{
    _countLabel.text = [NSString stringWithFormat:@"%d", kDefaultCount-[textView.text length]];
}

@end

#pragma mark -
#pragma mark UIRetweetBindCell
@implementation UIRetweetBindCell 
@synthesize weiboType = _weiboType;

#define kUIRetweetBindCellFont  [UIFont systemFontOfSize:14]
#define kUIRetweetBindCellNoBind @" 未绑定"
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _checkBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _checkBtn.backgroundColor = [UIColor blueColor];
        [_checkBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkBtn];
        
        _weiboName = [[UILabel alloc] initWithFrame:CGRectZero];
        _weiboName.backgroundColor = [UIColor clearColor];
        _weiboName.font = kUIRetweetBindCellFont;
        _weiboName.text = @"新浪微博";
        [self.contentView addSubview:_weiboName];
        
        _bindName = [[UILabel alloc] initWithFrame:CGRectZero];
        _bindName.backgroundColor = [UIColor clearColor];
        _bindName.font = kUIRetweetBindCellFont;
        _bindName.text = kUIRetweetBindCellNoBind;
        _bindName.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:_bindName];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)dealloc{
    Safe_Release(_checkBtn)
    Safe_Release(_weiboName)
    Safe_Release(_bindName)
    
    self.weiboType = nil;
    
    [super dealloc];
}

- (void)btnPressed:(id)sender{
    _checkBtn.selected = !_checkBtn.selected;
    
    if (_checkBtn.selected) {
        _checkBtn.backgroundColor = [UIColor redColor];
        [[SharePlatformCenter defaultCenter] switchOn:self.weiboType];
    }else {
        _checkBtn.backgroundColor = [UIColor blueColor];
        [[SharePlatformCenter defaultCenter] switchOff:self.weiboType];
    }
}

- (void)setWeiboType:(NSString *)weiboType{
    Safe_Release(_weiboType)
    _weiboType = [weiboType retain];
    
    _checkBtn.selected = [[SharePlatformCenter defaultCenter] switchState:weiboType];
    if (_checkBtn.selected) {
        _checkBtn.backgroundColor = [UIColor redColor];
    }else {
        _checkBtn.backgroundColor = [UIColor blueColor];
    }
}

#define kUIRetweetBindCellLeftPadding 16
#define kUIRetweetBindCellRightPadding 16
#define kUIRetweetBindCellTopPadding 10
#define kUIRetweetBindCellNoBindRightPadding 5

#define kUIRetweetBindCellCheckImageWidth 24
#define kUIRetweetBindCellCheckImageHeight 24

#define kUIRetweetBindCellCheckWeiboNamePadding 16
- (void)layoutSubviews{
    [super layoutSubviews];
    
    _checkBtn.frame = CGRectMake(kUIRetweetBindCellLeftPadding, 0, 
                                       kUIRetweetBindCellCheckImageWidth, 
                                       kUIRetweetBindCellCheckImageHeight);
    _checkBtn.center = CGPointMake(_checkBtn.center.x, 
                                   self.contentView.bounds.size.height/2);
    
    CGSize viewSize = [NTESMBUtility getSizeForText:_weiboName.text font:_weiboName.font];
    _weiboName.frame = CGRectMake(_checkBtn.frame.origin.x+_checkBtn.frame.size.width+kUIRetweetBindCellCheckWeiboNamePadding, kUIRetweetBindCellTopPadding, 
                                  viewSize.width, viewSize.height);
    
    viewSize = [NTESMBUtility getSizeForText:_bindName.text font:_bindName.font];
    CGFloat rightPadding = kUIRetweetBindCellRightPadding;
    
    if ([_bindName.text isEqualToString:kUIRetweetBindCellNoBind]) {
        rightPadding = kUIRetweetBindCellNoBindRightPadding;
    }
    
    _bindName.frame = CGRectMake(self.contentView.bounds.size.width-rightPadding-viewSize.width, 
                                 0, viewSize.width, viewSize.height);
    _bindName.center = CGPointMake(_bindName.center.x, _weiboName.center.y);
    
}


+ (CGFloat)cellHeight{
    NSString *s = @"新浪微博";
    CGFloat height = [NTESMBUtility getHeightForText:s font:kUIRetweetBindCellFont];
    return (height+kUIRetweetBindCellTopPadding+kUIRetweetBindCellTopPadding);
}

- (void)reloadData:(NSDictionary *)data withWeiBo:(NSString *)weiboName{
    _weiboName.text = weiboName;
    
    if ([data isKindOfClass:[NSDictionary class]] &&
        [[data objectForKey:K_PLATFORM_MODEL_UID] isKindOfClass:[NSString class]]) {
        _bindName.text = [data objectForKey:K_PLATFORM_MODEL_UID];
        _checkBtn.enabled = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
    }else {
        _bindName.text = kUIRetweetBindCellNoBind;
        _checkBtn.enabled = NO;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self setNeedsLayout];
}


@end

