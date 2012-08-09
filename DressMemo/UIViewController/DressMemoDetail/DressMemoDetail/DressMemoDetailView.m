//
//  DressMemoDetailView.m
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DressMemoDetailView.h"
#import "DressMemoUserIconCache.h"
#import "DressMemoUserIconDownloader.h"

#import "NTESMBServer.h"

#import "BSPreviewScrollView.h"
#import "PhotoUploadXY.h"
#import "TapImage.h"

#pragma mark -
#pragma mark DressMemoDetailTableHeader
@implementation DressMemoDetailTableHeader
@synthesize tagsView = _tagsView;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _infoView = [[DressMemoInfoView alloc] initWithFrame:CGRectZero];
        [self addSubview:_infoView];
        
        _gallery = [[UIView alloc] initWithFrame:CGRectZero];
        _gallery.backgroundColor = [UIColor clearColor];
        [self addSubview:_gallery];
        [self initPreViewImageScrollerView];
        _tagsView = [[DressMemoDetailTagsView alloc] initWithFrame:CGRectZero];
        _tagsView.datasource = self;
     
        [self addSubview:_tagsView];
    }
    
    return self;
}
#pragma mark -
#pragma mark preview image
- (void)initPreViewImageScrollerView
{
    BSPreviewScrollView *scrollViewPreview = [[BSPreviewScrollView alloc]initWithFrame:CGRectMake(kPhotoUploadStartImageBGX, 20,kPhotoUploadStartScrollerW,kPhotoUploadStartScrollerH+40.f)];
    NE_LOGRECT(scrollViewPreview.frame);
    [scrollViewPreview setBackgroundColor:[UIColor clearColor]];
	scrollViewPreview.pageSize = CGSizeMake(kPhotoUploadStartScrollerW, kPhotoUploadStartScrollerH);
	// Important to listen to the delegate methods.
	scrollViewPreview.delegate = self;
    UIImage *bgImage= nil;
    UIImageWithFileName(bgImage,@"BG-mask.png");
    
    UIImageView *bgImageView = [[UIImageView alloc ]initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0.f,15.f,bgImage.size.width/kScale, bgImage.size.height/kScale);
    //scrollViewPreview.bgView = bgImageView;
    //CGPoint size = self.frame.size;
    //_bgView.center = CGPointMake(size.width/2.f,size.height/2.f);
    //[scrollViewPreview add:_bgView belowSubview:zoomView];];
    
    [scrollViewPreview setInsertBgView:YES];
    
    [scrollViewPreview setPageViewPendingWidth:kPhotoUploadScrollerPagePendingX];
    // [bgImageView addSubview:scrollViewPreview];
    
    //[mainView.mainFramView addSubview:bgImageView];
    [bgImageView release];
    //scrollViewPreview.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
	[_gallery addSubview:scrollViewPreview];
    [scrollViewPreview release];
    
}
#pragma mark -
#pragma mark BSPreviewScrollViewDelegate methods
-(UIView*)viewForItemAtIndex:(BSPreviewScrollView*)scrollView index:(int)index
{
	// Note that the images are actually smaller than the image view frame, each image
	// is 210x280. Images are centered and because they are smaller than the actual
	// view it creates a padding between each image.
    UIImage *imageData= nil;
    UIImageWithFileName(imageData, kPhotoUploadStartDefaultImageName);
	CGRect imageViewFrame = CGRectMake(kPhotoUploadStartImageBGX,kPhotoUploadStartImageBGY, imageData.size.width/kScale+kPhotoUploadScrollerPagePendingX*2,imageData.size.height/kScale);
	// TapImage is a subclassed UIImageView that catch touch/tap events
	TapImage *imageView = [[[TapImage alloc] initWithFrame:imageViewFrame] autorelease];
	imageView.userInteractionEnabled = YES;
    imageView.delegate = self;
    
    //has the
    imageView.image = imageData;//[UIImage imageNamed:[self.scrollPages objectAtIndex:index]];
    //imageView.frame =
    imageView.tag = index;
    NE_LOGRECT(imageView.frame);
#if 0
    if(index <[self.scrollPages count])
    {
        id imageData = [self.scrollPages objectAtIndex:index];
        UIImageView *photoImageView =nil;
        if([imageData isKindOfClass:[UIImage class]])
        {
            photoImageView = [[UIImageView alloc]initWithImage:imageData];
        }
        else if([imageData isKindOfClass:[NSString class]])
        {
            UIImage *realImageData = [UIImage imageNamed:imageData];
            photoImageView = [[UIImageView alloc]initWithImage:realImageData];
        }
        CGRect rect;
        rect.origin = CGPointMake(kPhotoUploadStartImageX, kPhotoUploadStartImageY);
        rect.size = CGSizeMake(kPhotoUploadStartImageW,kPhotoUploadStartImageH);
        photoImageView.frame = rect;
        [imageView addSubview:photoImageView];
        photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        [photoImageView release];
        imageView.hasImageData = YES;
    }
#endif
    //add mask
    UIImage *bgImage = nil;
    UIImageWithFileName(bgImage, @"pic-mask.png");
#if 0
    UIEdgeInsets resizeEdgeInset = UIEdgeInsetsMake(12.f,12.f,12.f,12.f);
    if([bgImage respondsToSelector:@selector(resizableImageWithCapInsets:)]&&1)
    {
        bgImage =[bgImage resizableImageWithCapInsets:resizeEdgeInset];
        
    }
    else
    {
        bgImage = [bgImage stretchableImageWithLeftCapWidth:12.f topCapHeight:12.f];
    }
#endif
    UIImageView *maskView =[[UIImageView alloc]initWithImage:bgImage];
    // maskView.frame =
    maskView.frame = CGRectMake(0.f, 0.f,bgImage.size.width/kScale, bgImage.size.height/kScale);
    [imageView addSubview:maskView];
    maskView.hidden = YES;
    [maskView release];
    //maskView.alpha = 1.f;
	imageView.contentMode = UIViewContentModeScaleToFill;
	return imageView;
}

-(int)itemCount:(BSPreviewScrollView*)scrollView
{
	// Return the number of pages we intend to display
	return kPhotoUploadStartMaxPicCount; //[self.scrollPages count];
}
#pragma mark -
- (void)dealloc{
    if (_downloader) {
        _downloader.delegate = nil;
        [[NTESMBServer getInstance] cancelRequest:_downloader];        
    }
    
    Safe_Release(_infoView)
    Safe_Release(_gallery)
    Safe_Release(_tagsView)
    
    [super dealloc];
}

- (void)reloadData:(DressMemoDetailDataModel *)dataModel{
    if (![dataModel isKindOfClass:[DressMemoDetailDataModel class]]) {
        return;
    }
    
    if (_downloader) {
        _downloader.delegate = nil;
        [[NTESMBServer getInstance] cancelRequest:_downloader];
    }

    _infoView.userNameLabel.text = dataModel.user.screenName;
    _infoView.timeLabel.text = dataModel.addTime;
    
    [_tagsView reloadData];
    [self setNeedsLayout];
    
    if([dataModel.user.userImageURL length] == 0)
        return;
    UIImage *userIcon = [[DressMemoUserIconCache getInstance] getImageWithUserIconPath:dataModel.user.userImageURL];
	if (userIcon != nil) {
        _infoView.userIconView.image = userIcon;
	}else{
        _downloader= [[DressMemoUserIconDownloader alloc] initWithUserIconUrl:dataModel.user.userImageURL
                                                                    indexPath:nil];
        _downloader.delegate = self;
        [[NTESMBServer getInstance] addRequest:_downloader];
        [_downloader release];
    }
}

#define kDressMemoDetailTableHeaderGalleryHeight 286

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize viewSize = [_infoView sizeThatFits:self.bounds.size];
    _infoView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    [_infoView setNeedsLayout];
    
    _gallery.frame = CGRectMake(_infoView.frame.origin.x, 
                                _infoView.frame.origin.y+_infoView.frame.size.height, 
                                self.bounds.size.width, kDressMemoDetailTableHeaderGalleryHeight);
    
    viewSize = [_tagsView sizeThatFits:self.bounds.size];
    _tagsView.frame = CGRectMake(_gallery.frame.origin.x, 
                                 _gallery.frame.origin.y+_gallery.frame.size.height, 
                                 viewSize.width, viewSize.height);
    [_tagsView setNeedsLayout];
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGFloat height = [_infoView sizeThatFits:size].height;
    height += kDressMemoDetailTableHeaderGalleryHeight;
    height += [_tagsView sizeThatFits:size].height;
    
    return CGSizeMake(size.width, height);
}

#pragma mark -Request Delegate
- (void) requestCompleted:(NTESMBRequest *) request
{
    if (request == _downloader)
    {
        if(request.receiveData){
			[[NTESMBLocalImageStorage getInstance] saveImageDataToIconDir:request.receiveData 
                                                                urlString:request.urlString];
		}
        UIImage *image = [UIImage imageWithData:request.receiveData];
        _infoView.userIconView.image = image;
        
        _downloader = nil;
    }
}

- (void) requestFailed:(NTESMBRequest *) request{
    if (request == _downloader) {
        _downloader = nil;
    }
}

/*
#pragma mark -Tag Datasource
- (NSInteger)countOfTagInTagsView:(DressMemoDetailTagsView *)tagsView{
    return 1;
    return 0;
}
- (DressMemoTagCell *)tagsView:(DressMemoDetailTagsView *)tagsView cellWithIndex:(NSInteger)index{
    return [[[DressMemoTagCell alloc] initWithFrame:CGRectZero] autorelease];
}
*/

@end

#pragma mark -
#pragma mark DressMemoDetailView
@implementation DressMemoDetailView
@synthesize tableView = _detailTableView;
@synthesize detailHeader = _detailHeader;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        _detailHeader = [[DressMemoDetailTableHeader alloc] initWithFrame:CGRectZero];
        [self addSubview:_detailHeader];
        
//        _detailTableView = [[NTESMBTweetieTableView alloc] initWithFrame:CGRectZero];
        _detailTableView = [[NTESMBTweetieTableView alloc] initWithFrame:CGRectZero hasDragEffect:YES hasSearchBar:NO];
        _detailTableView.hasDownDragEffect = YES;
        _detailTableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_detailTableView];
        
        _detailTableView.tableHeaderView = _detailHeader;
    
    }
    return self;
}

- (void)reloadData:(DressMemoDetailDataModel *)dataModel{
    [_detailHeader reloadData:dataModel];
    
    [_detailTableView reloadData];
    
    [self setNeedsLayout];
}

- (void)dealloc{
    Safe_Release(_detailHeader)
    Safe_Release(_detailTableView)
    
    [super dealloc];
}

- (void)layoutSubviews{
    [super layoutSubviews];
 
    /*
    _navBar.frame = CGRectMake(0, 0, self.bounds.size.width, kDressMemoDetailViewNavBarHeight);
     */
    
    _detailTableView.frame = CGRectMake(0, 0, 
                                        self.bounds.size.width, 
                                        self.bounds.size.height);
    

    
    CGSize viewSize = [_detailHeader sizeThatFits:self.bounds.size];
    _detailHeader.bounds = CGRectMake(0, 0, viewSize.width, viewSize.height);
    [_detailHeader setNeedsLayout];
    
    _detailTableView.tableHeaderView = _detailHeader;
    
    NE_LOGRECT(_detailTableView.frame);
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
#pragma mark DressMemoInfoView
@implementation DressMemoInfoView 
@synthesize userIconView = _userIconView;
@synthesize userNameLabel = _userNameLabel;
@synthesize timeLabel = _timeLabel;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _userIconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userIconView.backgroundColor = [UIColor clearColor];
        [self addSubview:_userIconView];
        
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userNameLabel.text = @"";
        _userNameLabel.font = [UIFont systemFontOfSize:12];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.textColor = [UIColor colorWithRed:194/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
        _userNameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _userNameLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:_userNameLabel];
        
        _timeIconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _timeIconView.backgroundColor = [UIColor clearColor];
        [self addSubview:_timeIconView];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.text = @"";
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor colorWithRed:194/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
        _timeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self addSubview:_timeLabel];
        
        UIImage *img;
        
        UIImageWithFileName(img, @"BG-chose&update.png");
        self.backgroundColor = [UIColor colorWithPatternImage:img];
        
        UIImageWithFileName(img, @"icon-time.png");
        _timeIconView.image = img;
    }
    
    return self;
}

- (void)dealloc{
    Safe_Release(_userNameLabel)
    Safe_Release(_userIconView)
    Safe_Release(_timeLabel)
    Safe_Release(_timeIconView)
    
    [super dealloc];
}

#define kDressMemoInfoViewInnerPadding 5
#define kDressMemoInfoViewUserIconLeftPadding 9
#define kDressMemoInfoViewUserIconWidth 25
#define kDressMemoInfoViewUserIconHeight 25
#define kDressMemoInfoViewBetweenViewsPadding 5

#define kDressMemoInfoViewNameLabelWidth 100
#define kDressMemoInfoViewTimeIconWidth 11
#define kDressMemoInfoViewTimeIconHeight 11
- (void)layoutSubviews{
    [super layoutSubviews];
    
    _userIconView.frame = CGRectMake(kDressMemoInfoViewUserIconLeftPadding, 
                                     (self.bounds.size.height-kDressMemoInfoViewUserIconHeight)/2, 
                                     kDressMemoInfoViewUserIconWidth,
                                     kDressMemoInfoViewUserIconHeight);
    
    CGFloat viewHeight = [NTESMBUtility getHeightForText:_userNameLabel.text font:_userNameLabel.font];
    if (viewHeight>self.bounds.size.height) {
        viewHeight = self.bounds.size.height;
    }
    _userNameLabel.frame = CGRectMake(_userIconView.frame.origin.x+_userIconView.frame.size.width+kDressMemoInfoViewBetweenViewsPadding, 
                                      (self.bounds.size.height-viewHeight)/2, 
                                      kDressMemoInfoViewNameLabelWidth, viewHeight);
    
    viewHeight = [NTESMBUtility getHeightForText:_timeLabel.text font:_timeLabel.font];
    if (viewHeight>self.bounds.size.height) 
        viewHeight = self.bounds.size.height;
    CGFloat viewWidth = [NTESMBUtility getWidthForText:_timeLabel.text font:_timeLabel.font];
    if (viewWidth>self.bounds.size.width) 
        viewWidth = self.bounds.size.width;
    _timeLabel.frame = CGRectMake(self.bounds.size.width-kDressMemoInfoViewInnerPadding-viewWidth, 
                                  (self.bounds.size.height-viewHeight)/2, 
                                  viewWidth, viewHeight);
    
    _timeIconView.frame = CGRectMake(_timeLabel.frame.origin.x-kDressMemoInfoViewTimeIconWidth-kDressMemoInfoViewBetweenViewsPadding, 
                                     (self.bounds.size.height-kDressMemoInfoViewTimeIconHeight)/2, 
                                     kDressMemoInfoViewTimeIconWidth, 
                                     kDressMemoInfoViewTimeIconHeight);
    
    
}

#define kDressMemoInfoViewHeight (82/2)
- (CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake(size.width, kDressMemoInfoViewHeight);
}

@end

#pragma mark -
#pragma mark DressMemoTagCell
@implementation DressMemoTagCell 

@synthesize drawDashLine = _drawDashLine;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _tagView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _tagView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tagView];
        
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tagLabel.text = @"H&M 36M 的鞋子";
        _tagLabel.textColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0];
        _tagLabel.backgroundColor = [UIColor clearColor];
        _tagLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_tagLabel];
        
        UIImage *img = nil;
        UIImageWithFileName(img, @"icon-tagS.png");
        _tagView.image = img;
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)reloadData:(DressMemoTagModel *)tag{
    if ([tag isKindOfClass:[DressMemoTagModel class]]) {
        _tagLabel.text = [NSString stringWithFormat:@"%@ 的 %@", tag.brandName, tag.catName];
    }
}

- (void)setDrawDashLine:(BOOL)drawDashLine{
    _drawDashLine = drawDashLine;
    
    [self setNeedsDisplay];
}

#define kDressMemoTagViewIconWidth 23
#define kDressMemoTagViewIconHeight 23
#define kDressMemoTagViewIconLeftPadding 24

#define kDressMemoTagViewBetweenViewsPadding 20
- (void)layoutSubviews{
    [super layoutSubviews];
    
    _tagView.frame = CGRectMake(kDressMemoTagViewIconLeftPadding, 
                                (self.bounds.size.height-kDressMemoTagViewIconHeight)/2, 
                                kDressMemoTagViewIconWidth, kDressMemoTagViewIconHeight);
    
    CGFloat viewHeight = [NTESMBUtility getHeightForText:_tagLabel.text font:_tagLabel.font];
    if (viewHeight>self.bounds.size.height) 
        viewHeight = self.bounds.size.height;
    CGFloat viewWidth = [NTESMBUtility getWidthForText:_tagLabel.text font:_tagLabel.font];
    if (viewWidth>self.bounds.size.width) 
        viewWidth = self.bounds.size.width;
    _tagLabel.frame = CGRectMake(_tagView.frame.origin.x+_tagView.frame.size.width+kDressMemoTagViewBetweenViewsPadding, 
                                 (self.bounds.size.height-viewHeight)/2, 
                                 viewWidth, viewHeight);
    
}

- (void)dealloc{
    Safe_Release(_tagView)
    Safe_Release(_tagLabel)
    
    [super dealloc];
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
        
        [self drawDashLine:CGPointMake(_tagLabel.frame.origin.x, self.bounds.size.height)
                   toPoint:CGPointMake(self.bounds.size.width-kDressMemoTagViewIconLeftPadding, self.bounds.size.height)
                   context:context];
    }
}

@end

#pragma mark -
#pragma mark DressMemoDetailTagsView
@implementation DressMemoDetailTagsView 

@synthesize datasource = _datasource;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _tagCellViews = [[NSMutableArray alloc] initWithCapacity:0];
//        self.backgroundColor = [UIColor redColor];
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)dealloc{
    Safe_Release(_tagCellViews)
    
    [super dealloc];
}

- (void)reloadData{
    NSInteger count = 0;
    
    for (DressMemoTagCell *cell in _tagCellViews) {
        [cell removeFromSuperview];
    }
    
    [_tagCellViews removeAllObjects];
    
    if ([self.datasource respondsToSelector:@selector(countOfTagInTagsView:)]) {
        count = [self.datasource countOfTagInTagsView:self];
    }
    
    for (int i=0; i<count; i++) {
        DressMemoTagCell *cell = nil;
        
        if ([self.datasource respondsToSelector:@selector(tagsView:cellWithIndex:)]) {
            cell = [self.datasource tagsView:self cellWithIndex:i];
        }
        
        if ([cell isKindOfClass:[DressMemoTagCell class]]) {
            [_tagCellViews addObject:cell];
        }
        
        if (i!=count-1) {
            cell.drawDashLine = YES;
        }
    }
    
    [self setNeedsLayout];
}

#define kDressMemoTagCellHeight 38
#define kDressMemoDetailTagsViewBottom 12
- (void)layoutSubviews{
    CGFloat viewHeight = kDressMemoTagCellHeight;
    
    for (DressMemoTagCell *cell in _tagCellViews) {
        cell.frame = CGRectMake(0, ceilf(viewHeight*[_tagCellViews indexOfObject:cell]),
                                ceilf(self.bounds.size.width), ceilf(viewHeight));
        [self addSubview:cell];
    }
    

    UIImage *img = nil;
    UIImageWithFileName(img, @"BG-taginfo.png");
    self.backgroundColor = [UIColor colorWithPatternImage:img];

}

- (CGSize)sizeThatFits:(CGSize)size{
//    [self reloadData];
    
    CGFloat height = [_tagCellViews count]>0?kDressMemoTagCellHeight*[_tagCellViews count]+kDressMemoDetailTagsViewBottom:0;
    
    return CGSizeMake(size.width, height);
}

@end


