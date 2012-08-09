//
//  DressMemoDetailTableViewCell.m
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DressMemoDetailTableViewCell.h"
#import "NTESMBLocalImageStorage.h"
#import "NTESMBServer.h"
#import "DressMemoUserIconCache.h"
#import "DressMemoUserIconDownloader.h"

#pragma mark -
#pragma mark UIAppendInfoDetailView
@implementation UIAppendInfoDetailView 

@synthesize drawDashLine = _drawDashLine;

#define kUIAppendInfoDetailViewLabelFont [UIFont systemFontOfSize:14]
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _thumbImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _thumbImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_thumbImageView];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.text = @"真是郁闷啊！";
        _infoLabel.textAlignment = UITextAlignmentLeft;
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _infoLabel.font = kUIAppendInfoDetailViewLabelFont;
        _infoLabel.numberOfLines = 0;
        _infoLabel.textColor = [UIColor colorWithRed:70.0/255.0 green:70./255.0 blue:70.0/255.0 alpha:1.0];
        [self addSubview:_infoLabel];
        
        UIImage *img = nil;
        UIImageWithFileName(img, @"icon-location.png");
        _thumbImageView.image = img;
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)dealloc{
    Safe_Release(_thumbImageView)
    Safe_Release(_infoLabel)
    
    [super dealloc];
}

#define kUIAppendInfoDetailViewTopPadding 10
#define kUIAppendInfoDetailViewBottomPadding 10
#define kUIAppendInfoDetailViewImageLabelPadding 17
#define kUIAppendInfoDetailViewLabelRightPadding (24+17)

#define kUIAppendInfoDetailViewImageTopPadding 10
//#define kUIAppendInfoDetailViewImageBottomPadding 5
#define kUIAppendInfoDetailViewImageLeftPadding (24+17)
#define kUIAppendInfoDetailViewImageWidth 25
#define kUIAppendInfoDetailViewImageHeight 30
- (void)layoutSubviews{
    [super layoutSubviews];
    
    _thumbImageView.frame = CGRectMake(kUIAppendInfoDetailViewImageLeftPadding, 
                                       kUIAppendInfoDetailViewImageTopPadding, 
                                       kUIAppendInfoDetailViewImageWidth, 
                                       kUIAppendInfoDetailViewImageHeight);

    CGFloat positionX = _thumbImageView.frame.origin.x + _thumbImageView.frame.size.width;
    positionX += kUIAppendInfoDetailViewImageLabelPadding;
    
    CGFloat maxWidth = self.bounds.size.width - positionX - kUIAppendInfoDetailViewLabelRightPadding;
    CGFloat labelHeight = [NTESMBUtility getHeightForText:_infoLabel.text
                                                 maxWidth:maxWidth 
                                                maxHeight:1000 
                                                     font:_infoLabel.font];
    _infoLabel.frame = CGRectMake(ceil(positionX), 
                                  ceil((self.bounds.size.height-labelHeight)/2), 
                                  ceil(maxWidth), ceil(labelHeight));
    
    [self setNeedsDisplay];

}

#define kUIAppendInfoDetailViewMinHeight (74/2)
+ (CGFloat)viewHeight:(NSDictionary *)dataDic withViewWidth:(CGFloat)width{
    CGFloat labelMaxWidth = width-kUIAppendInfoDetailViewImageLeftPadding-kUIAppendInfoDetailViewImageWidth-kUIAppendInfoDetailViewImageLabelPadding-kUIAppendInfoDetailViewLabelRightPadding;
    CGFloat labelHeight = [NTESMBUtility getHeightForText:[[dataDic allValues] objectAtIndex:0]
                                                 maxWidth:labelMaxWidth 
                                                maxHeight:1000 
                                                     font:kUIAppendInfoDetailViewLabelFont];
    
    CGFloat contentHeight = labelHeight > kUIAppendInfoDetailViewImageHeight?labelHeight:kUIAppendInfoDetailViewImageHeight;

    CGFloat height = contentHeight+kUIAppendInfoDetailViewTopPadding+kUIAppendInfoDetailViewBottomPadding;
    height = height>kUIAppendInfoDetailViewMinHeight?height:kUIAppendInfoDetailViewMinHeight;
    
    return height;
    

}

- (void)setDrawDashLine:(BOOL)t{
    _drawDashLine = t;
    [self setNeedsDisplay];
}

- (void)reloadData:(NSDictionary *)dataDic{
    _infoLabel.text = [[dataDic allValues] objectAtIndex:0];
}


#define kDrawLineWidth 1
- (void)drawDashLine:(CGPoint)p1 toPoint:(CGPoint)p2 context:(CGContextRef)context{
    CGContextSaveGState(context);
    
    CGContextBeginPath(context);  
    CGContextSetLineWidth(context, kDrawLineWidth);  
    UIColor *lineColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);  
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    float lengths[] = {4,4};   
    CGContextSetLineDash(context, 0, lengths,2);  
    CGContextMoveToPoint(context, p1.x, p1.y);  
    CGContextAddLineToPoint(context, p2.x, p2.y);  
    CGContextStrokePath(context);   
    
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if (self.drawDashLine) {
        CGContextRef context =UIGraphicsGetCurrentContext();  
        
        [self drawDashLine:CGPointMake(_infoLabel.frame.origin.x, self.bounds.size.height)
                   toPoint:CGPointMake(self.bounds.size.width-kUIAppendInfoDetailViewLabelRightPadding, self.bounds.size.height)
                   context:context];
    }
}


@end

#pragma mark -
#pragma mark UIAppendInfoCell
@implementation UIAppendInfoCell

#define kOffset -24
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _infoViews = [[NSMutableArray alloc] initWithCapacity:0];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *tv = [[UIView alloc] initWithFrame:self.bounds];
        tv.clipsToBounds = YES;
        tv.autoresizesSubviews = YES;
        self.backgroundView = tv;
        [tv release];
        
        UIImage *img = nil;
        UIImageWithFileName(img, @"BG-setting.png");
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kOffset, 
                                                                            tv.bounds.size.width, 
                                                                            -kOffset+tv.bounds.size.height)];
        bgView.image = img;
        bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [tv addSubview:bgView];
        [bgView release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    Safe_Release(_infoViews)
    
    [super dealloc];
}

#define kUIAppendInfoCellTopPadding 12
#define kUIAppendInfoCellBottomPadding 12
#define kUIAppendInfoCellLeftPadding 0
#define kUIAppendInfoCellRightPadding 0
+ (CGFloat)cellHeight:(NSArray *)datas withCellWidth:(CGFloat)width{
    CGFloat cellHeight = 0;
    
    for (NSDictionary *dataDic in datas) {
        if ([[[dataDic allValues] objectAtIndex:0] length]) {
                cellHeight += [UIAppendInfoDetailView viewHeight:dataDic withViewWidth:width - kUIAppendInfoCellLeftPadding - kUIAppendInfoCellRightPadding];
        }
    }
    
    return (cellHeight+kUIAppendInfoCellTopPadding+kUIAppendInfoCellBottomPadding);
//    return cellHeight;
}

- (void)reloadData:(NSArray *)datas{
    for (UIView *tv in _infoViews) {
        [tv removeFromSuperview];
    }
    
    [_infoViews removeAllObjects];
    
    for (int i=0; i<[datas count]; i++) {
        NSDictionary *dataDic = [datas objectAtIndex:i];
        UIAppendInfoDetailView *tv = [[UIAppendInfoDetailView alloc] initWithFrame:CGRectZero];
        [tv reloadData:dataDic];
        
        if (i!=[datas count]-1) {
            tv.drawDashLine = YES;
        }
        
        CGFloat width = self.bounds.size.width - kUIAppendInfoCellLeftPadding - kUIAppendInfoCellRightPadding;
        CGFloat height = [UIAppendInfoDetailView viewHeight:dataDic withViewWidth:width];
        tv.bounds = CGRectMake(0, 0, width, height);
        
        [self addSubview:tv];
        [_infoViews addObject:tv];
        [tv release];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat yPostion = kUIAppendInfoCellTopPadding;
    for (UIAppendInfoDetailView *tv in _infoViews) {
        tv.frame = CGRectMake(kUIAppendInfoCellLeftPadding, yPostion, 
                              tv.bounds.size.width, tv.bounds.size.height);
        
        yPostion += tv.bounds.size.height;
    }
}

@end

#pragma mark -
#pragma mark UILoadPicImageView
@implementation UILoadPicImageView 

- (void)loadPicWithPath:(NSString *)path{
    UIImage *userIcon = [[DressMemoUserIconCache getInstance] getImageWithUserIconPath:path];
	if (userIcon != nil) {
        self.image = userIcon;
	}else{
        _downloader= [[DressMemoUserIconDownloader alloc] initWithUserIconUrl:path
                                                                    indexPath:nil];
        _downloader.delegate = self;
        [[NTESMBServer getInstance] addRequest:_downloader];
        [_downloader release];
    }
}

- (void)requestCompleted:(NTESMBRequest *)request{
    if (request == _downloader) {
        if(request.receiveData){
			[[NTESMBLocalImageStorage getInstance] saveImageDataToIconDir:request.receiveData 
                                                                urlString:request.urlString];
		}
        UIImage *image = [UIImage imageWithData:request.receiveData];
        self.image = image;
        
        _downloader = nil;
    }
}

- (void)requestFailed:(NTESMBRequest *)request{
    if (request == _downloader) {
        _downloader = nil;
    }
}

- (void)dealloc{
    if (_downloader) {
        _downloader.delegate = nil;
        [[NTESMBServer getInstance] cancelRequest:_downloader];
    }
    
    [super dealloc];
}
@end

#pragma mark -
#pragma mark UICollectedUserCell
@implementation UICollectedUserCell 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _userIcons = [[NSMutableArray alloc] initWithCapacity:0];
        
        _likeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _likeImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_likeImageView];
        
        _collectCount = [[UILabel alloc] initWithFrame:CGRectZero];
        _collectCount.font = [UIFont systemFontOfSize:12];
        _collectCount.backgroundColor = [UIColor clearColor];
        _collectCount.textAlignment = UITextAlignmentLeft;
        _collectCount.textColor = [UIColor colorWithRed:70/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];
        _collectCount.text = @"1254人喜欢";
        [self.contentView addSubview:_collectCount];
        
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_moreBtn];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *img;
        UIImageWithFileName(img, @"icon-likeheart.png");
        _likeImageView.image = img;
        
        UIImageWithFileName(img, @"icon-moreliker.png");
        [_moreBtn setImage:img forState:UIControlStateNormal];
        
    }
    
    return self;
}

- (void)dealloc{
    Safe_Release(_userIcons)
    Safe_Release(_likeImageView)
    Safe_Release(_collectCount)
    Safe_Release(_moreBtn)
    
    [super dealloc];
}

#define kUICollectedUserCellFrameLeftPadding 24
#define kUICollectedUserCellFrameRightPadding 24
#define kUICollectedUserCellFrameTopPadding 0
#define kUICollectedUserCellFrameBottomPadding 0 
#define kUICollectedUserCellInnerLeftPadding   12 
#define kUICollectedUserCellInnerTopPadding    12

#define kUICollectedUserCellLikeImageWidth    19
#define kUICollectedUserCellLikeImageHeight   15
#define kUICollectedUserCellLikeImageLabelPadding 10
#define kUICollectedUserCellLikeImageUserIconPadding 9

#define kUICollectedUserCellUserIconWidth 35
#define kUICollectedUserCellUserIconHeight 35
#define kUICollectedUserCellUserIconPadding 0

#define kUICollectedUserCellMoreBtnWidth 35
#define kUICollectedUserCellMoreBtnHeight 35
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat positionX = kUICollectedUserCellFrameLeftPadding+kUICollectedUserCellInnerLeftPadding;
    CGFloat positionY = kUICollectedUserCellFrameTopPadding+kUICollectedUserCellInnerTopPadding;
    
    CGFloat cellContentWidth = self.bounds.size.width - kUICollectedUserCellFrameLeftPadding - kUICollectedUserCellFrameRightPadding - 2*kUICollectedUserCellInnerLeftPadding;
    
    _likeImageView.frame = CGRectMake(positionX, positionY, 
                                      kUICollectedUserCellLikeImageWidth, 
                                      kUICollectedUserCellLikeImageHeight);
    
    CGFloat viewHeight = [NTESMBUtility getHeightForText:_collectCount.text font:_collectCount.font];
    _collectCount.frame = CGRectMake(_likeImageView.frame.origin.x+_likeImageView.frame.size.width+kUICollectedUserCellLikeImageLabelPadding, 
                                     _likeImageView.frame.origin.y, 
                                     cellContentWidth - _likeImageView.bounds.size.width, 
                                     viewHeight);
    
    positionY = _likeImageView.frame.origin.y+_likeImageView.frame.size.height+kUICollectedUserCellLikeImageUserIconPadding;
    for (UIView *tv in _userIcons) {
        tv.frame = CGRectMake(positionX, positionY, 
                              kUICollectedUserCellUserIconWidth, 
                              kUICollectedUserCellUserIconHeight);
        
        positionX += kUICollectedUserCellUserIconWidth + kUICollectedUserCellUserIconPadding;
    }
    
    
    
    _moreBtn.frame = CGRectMake(ceil(positionX), 
                                ceil(positionY+(kUICollectedUserCellUserIconHeight-kUICollectedUserCellMoreBtnHeight)/2), 
                                kUICollectedUserCellMoreBtnWidth, 
                                kUICollectedUserCellMoreBtnHeight);
    
    
}

+ (CGFloat)cellHeight{
    return kUICollectedUserCellFrameTopPadding+kUICollectedUserCellInnerTopPadding+kUICollectedUserCellLikeImageHeight+kUICollectedUserCellLikeImageUserIconPadding+kUICollectedUserCellUserIconHeight+kUICollectedUserCellFrameBottomPadding+kUICollectedUserCellInnerTopPadding;
}

- (void)clearViews{
    for (UIView *tv in _userIcons) {
        [tv removeFromSuperview];
    }
    
    [_userIcons removeAllObjects];
}

#define kUICollectedUserCellUserIconMaxCount 6
- (void)reloadData:(NSArray *)datas{
    [self clearViews];
    
    CGFloat maxCount = [datas count]<kUICollectedUserCellUserIconMaxCount?[datas count]:kUICollectedUserCellUserIconMaxCount;
    
    for (int i = 0; i<maxCount; i++) {
        DressMemoUserModel *user = [datas objectAtIndex:i];
        if (![user isKindOfClass:[DressMemoUserModel class]]) {
            continue;
        }
        
        UILoadPicImageView *tv = [[UILoadPicImageView alloc] initWithFrame:CGRectZero];
        [tv loadPicWithPath:user.userImageURL];
        tv.backgroundColor = [UIColor yellowColor];
        [_userIcons addObject:tv];
        [tv release];
        
        [self.contentView addSubview:tv];
    }
    
    _moreBtn.hidden = !([datas count] >= 6);
    _collectCount.text = [NSString stringWithFormat:@"%d 人喜欢", [datas count]];
    
    [self setNeedsLayout];
}

@end

#pragma mark -
#pragma mark UICommentCell

#define kUICommentCellUserFont [UIFont systemFontOfSize:15]
#define kUICommentCellCommentTextFont [UIFont systemFontOfSize:14]
#define kUICommentCellTimeFont [UIFont systemFontOfSize:12]
@implementation UICommentCell 
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UIImage *img = nil;
        
        _userIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userIcon.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_userIcon];
        
        _commentCreator = [[UIButton alloc] initWithFrame:CGRectZero];
        [_commentCreator setTitle:@"奇葩大仙"
                         forState:UIControlStateNormal];
        _commentCreator.titleLabel.font = kUICommentCellUserFont;
        _commentCreator.backgroundColor = [UIColor clearColor];
        [_commentCreator setTitleColor:[UIColor colorWithRed:180.0/255.0 green:3.0/255.0 blue:0 alpha:1.0]
                              forState:UIControlStateNormal];
        [_commentCreator addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_commentCreator];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLabel.text = @"回复";
        _commentLabel.textColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];
        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.font = kUICommentCellUserFont;
        [self.contentView addSubview:_commentLabel];
        
        _commentedUser = [[UIButton alloc] initWithFrame:CGRectZero];
        [_commentedUser setTitle:@"我" forState:UIControlStateNormal];
        _commentedUser.titleLabel.font = kUICommentCellUserFont;
        _commentedUser.backgroundColor = [UIColor clearColor];
        [_commentedUser setTitleColor:[UIColor colorWithRed:180.0/255.0 green:3.0/255.0 blue:0 alpha:1.0]
                              forState:UIControlStateNormal];
        [_commentedUser addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_commentedUser];
        
        _time = [[UILabel alloc] initWithFrame:CGRectZero];
        _time.text = @"一分钟前";
        _time.font = kUICommentCellTimeFont;
        _time.backgroundColor = [UIColor clearColor];
        _time.textColor = [UIColor colorWithRed:194/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
        [self.contentView addSubview:_time];
        
        _timeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _timeImageView.backgroundColor = [UIColor clearColor];
        UIImageWithFileName(img, @"icon-time.png");
        _timeImageView.image = img;
        [self.contentView addSubview:_timeImageView];
        
        _commentBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_commentBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.backgroundColor = [UIColor clearColor];
        UIImageWithFileName(img, @"icon-reply.png");
        [_commentBtn setImage:img forState:UIControlStateNormal];
        [self.contentView addSubview:_commentBtn];
        
        _commentText = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentText.text = @"大爱test！！！大爱test！！！大爱test！！！大爱test！！！";
        _commentText.font = kUICommentCellCommentTextFont;
        _commentText.textColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];
        _commentText.backgroundColor = [UIColor clearColor];
        _commentText.numberOfLines = 0;
        [self.contentView addSubview:_commentText];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)dealloc{
    Safe_Release(_userIcon)
    Safe_Release(_commentText)
    Safe_Release(_commentBtn)
    Safe_Release(_commentCreator)
    Safe_Release(_commentLabel)
    Safe_Release(_commentedUser)
    Safe_Release(_time)
    Safe_Release(_timeImageView)
    
    self.delegate = nil;
    
    [super dealloc];
}

#define kUICommentCellViewsPadding 12
#define kUICommentCellUserIconWidth 25
#define kUICommentCellUserIconHeight 25

#define kUICommentCellLabelsPadding 5
#define kUICommentCellTimeImageViewWidth 11
#define kUICommentCellTimeImageViewHeight 11

#define kUICommentCellBtnViewWidth 24
#define kUICommentCellBtnViewHeight 24
#define kUICommentCellBtnBottomPadding 5

#define kUICommentCellNameTextPadding 10

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat positionX = kUICollectedUserCellFrameLeftPadding+kUICollectedUserCellInnerLeftPadding;
    CGFloat positionY = kUICollectedUserCellFrameTopPadding+kUICollectedUserCellInnerTopPadding;
    
    _userIcon.frame = CGRectMake(positionX, positionY, 
                                 kUICommentCellUserIconWidth, 
                                 kUICommentCellUserIconHeight);
    
    CGSize viewSize = [NTESMBUtility getSizeForText:[_commentCreator titleForState:UIControlStateNormal]
                                               font:_commentCreator.titleLabel.font];
    _commentCreator.frame = CGRectMake(_userIcon.frame.origin.x+_userIcon.frame.size.width+kUICommentCellViewsPadding, 
                                       _userIcon.frame.origin.y, 
                                       viewSize.width, viewSize.height);
    
    _commentLabel.hidden = !([[_commentedUser titleForState:UIControlStateNormal] length] > 0);
    
    if (!_commentLabel.hidden) {
        viewSize = [NTESMBUtility getSizeForText:_commentLabel.text font:_commentLabel.font];
        _commentLabel.frame = CGRectMake(_commentCreator.frame.origin.x+_commentCreator.frame.size.width+kUICommentCellLabelsPadding, _commentCreator.frame.origin.y, 
                                         viewSize.width, viewSize.height);
        
        viewSize = [NTESMBUtility getSizeForText:[_commentedUser titleForState:UIControlStateNormal]
                                            font:_commentedUser.titleLabel.font];
        _commentedUser.frame = CGRectMake(_commentLabel.frame.origin.x+_commentLabel.frame.size.width+kUICommentCellLabelsPadding, _commentLabel.frame.origin.y, viewSize.width, viewSize.height);
    }
    
    
    CGFloat cellContentWidth = self.bounds.size.width - kUICollectedUserCellFrameLeftPadding - kUICollectedUserCellFrameRightPadding - 2*kUICollectedUserCellInnerLeftPadding;
    
    CGFloat commetTextMaxWidth = cellContentWidth - _userIcon.bounds.size.width - kUICommentCellViewsPadding;
    CGFloat textHeight = [NTESMBUtility getHeightForText:_commentText.text 
                                                maxWidth:commetTextMaxWidth
                                               maxHeight:10000 
                                                    font:_commentText.font];
    
    _commentText.frame = CGRectMake(_commentCreator.frame.origin.x, 
                                    _commentCreator.frame.origin.y+_commentCreator.bounds.size.height+kUICommentCellNameTextPadding, 
                                    commetTextMaxWidth, textHeight);
    
    CGFloat cellBottomPadding = kUICollectedUserCellFrameBottomPadding+kUICollectedUserCellInnerTopPadding;
    _timeImageView.frame = CGRectMake(_commentText.frame.origin.x, 
                                      self.bounds.size.height-cellBottomPadding-kUICommentCellTimeImageViewHeight, 
                                      kUICommentCellTimeImageViewWidth, 
                                      kUICommentCellTimeImageViewHeight);
    
    viewSize = [NTESMBUtility getSizeForText:_time.text font:_time.font];
    _time.frame = CGRectMake(_timeImageView.frame.origin.x+_timeImageView.frame.size.width+kUICommentCellLabelsPadding, 0,
                              viewSize.width, viewSize.height);
    _time.center = CGPointMake(_time.center.x, 
                               _timeImageView.center.y);
    
    CGFloat cellRightPadding = kUICollectedUserCellFrameRightPadding+kUICollectedUserCellInnerLeftPadding;
    _commentBtn.frame = CGRectMake(self.bounds.size.width-cellRightPadding-kUICommentCellBtnViewWidth, 
                                    self.bounds.size.height-kUICommentCellBtnBottomPadding-kUICommentCellBtnViewHeight,
                                    kUICommentCellBtnViewWidth, kUICommentCellBtnViewHeight);
    
    
}

+ (CGFloat)cellHeight:(DressMemoCommentModel *)data withCellWidth:(CGFloat)width{
    CGFloat cellTopPadding = kUICollectedUserCellInnerTopPadding+kUICollectedUserCellFrameTopPadding;
    CGFloat cellBottomPadding = kUICollectedUserCellFrameBottomPadding+kUICollectedUserCellInnerTopPadding;
    CGFloat cellLeftPadding = kUICollectedUserCellFrameLeftPadding+kUICollectedUserCellInnerTopPadding;
    CGFloat cellRightPadding = kUICollectedUserCellInnerTopPadding+kUICollectedUserCellFrameRightPadding;
    
    CGFloat contentHeight = 0;
    
    NSString *text = [data.creatorUser name];
    if (![text length]) {
        text = @"ceshi zhang hao";
    }

    contentHeight += [NTESMBUtility getHeightForText:text font:kUICommentCellUserFont];
    contentHeight += kUICommentCellNameTextPadding;
    
    contentHeight += [NTESMBUtility getHeightForText:data.commentText 
                                            maxWidth:width-cellLeftPadding-cellRightPadding-kUICommentCellUserIconWidth-kUICommentCellViewsPadding maxHeight:1000 font:kUICommentCellCommentTextFont];
    contentHeight += kUICommentCellViewsPadding;
    
    contentHeight += kUICommentCellTimeImageViewHeight;
    
    return (contentHeight+cellTopPadding+cellBottomPadding);
}

- (void)reloadData:(DressMemoCommentModel *)data{
    if (![data isKindOfClass:[DressMemoCommentModel class]]) {
        return;
    }
    
    _time.text = data.addTime;
    _commentText.text = data.commentText;
    
    
    [_commentCreator setTitle:data.commentedUserName forState:UIControlStateNormal];
    [_commentedUser setTitle:data.replyUserNickName forState:UIControlStateNormal];
    
    
    [self setNeedsLayout];
}
         
- (void)btnPressed:(id)sender{  
    if (sender == _commentBtn) {
        if ([_delegate respondsToSelector:@selector(commentBtnPressedOnCommentCell:)]) {
            [self.delegate commentBtnPressedOnCommentCell:self];
        }   
    
    }else if(sender == _commentCreator){
        if ([_delegate respondsToSelector:@selector(commentCreatorUserPressedOnCommentCell:)]) {
            [self.delegate commentCreatorUserPressedOnCommentCell:self];
        }
        
    }else if(sender == _commentedUser){
        if ([_delegate respondsToSelector:@selector(commentedUserPressedOnCommentCell:)]) {
            [self.delegate commentedUserPressedOnCommentCell:self];
        }
        
    }

}

@end
