//
//  MessageTableViewCell.m
//  DressMemo
//
//  Created by cszhan on 12-7-30.
//
//

#import "MessageTableViewCell.h"

#define kUserImageIconPendingX      18.f/2.f
#define kUserImageIconPendingY      18.f/2.f
#define kUserImageIconW             (80.f+10.f)/2.f

#define kCellNickNameFontSize       16
#define kCellTimeFontSize           14


#define kCellContentStartX          (18.f+90.f+24.f)/2.f
#define kFollowText                 @"关注了你"
#define kReCommentText              @"回复"

@interface MessageTableViewCell()
@property(nonatomic,retain)UILabel *cellTypeIndicator;
@end
@implementation MessageTableViewCell
@synthesize nickNameBtn;
@synthesize cellType;
@synthesize cellTypeIndicator;
@synthesize timeLabel;
@synthesize commentLabel;
@synthesize reCommentLabel;
//@synthesize userIconView;
-(void)dealloc{
    self.nickNameBtn = nil;
    self.cellTypeIndicator = nil;
    self.timeLabel = nil;
    self.commentLabel = nil;
    self.reCommentLabel = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.nickNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //self.nickNameBtn.backgroundColor = [UIColor clearColor];
        self.nickNameBtn.userInteractionEnabled = YES;
        //self.nickNameBtn.titleLabel.textColor = [UIColor redColor];
        [self.nickNameBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.nickNameBtn.titleLabel.font = kAppTextSystemFont(kCellNickNameFontSize);
        self.nickNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:nickNameBtn];
        UIImageView *_userIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kUserImageIconPendingX,kUserImageIconPendingY, kUserImageIconW, kUserImageIconW)];
        [self addSubview:_userIconImageView];
        [_userIconImageView release];
        self.userIconImageView  = _userIconImageView;
        
        UILabel *_cellTypeIndictor = [[UILabel alloc]initWithFrame:CGRectZero];
        _cellTypeIndictor.numberOfLines = 1;
        _cellTypeIndictor.backgroundColor = [UIColor clearColor];
        _cellTypeIndictor.font = kAppTextBoldSystemFont(kCellNickNameFontSize);
        [self addSubview:_cellTypeIndictor];
        self.cellTypeIndicator = _cellTypeIndictor;
        
        UILabel *_commentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _commentLabel.numberOfLines = 0;
        [self addSubview:_commentLabel];
        self.commentLabel = _commentLabel;
        [_commentLabel release];
        
        UILabel *_reCommentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _reCommentLabel.numberOfLines = 0;
        [self addSubview:_reCommentLabel];
        self.reCommentLabel = _reCommentLabel;
        [_reCommentLabel release];
        
        UILabel *_timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLabel.numberOfLines = 1;
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_timeLabel];
        self.timeLabel = _timeLabel;
        [_timeLabel release];
        
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    NSString *nickName = @"";//[self.msgData objectForKey:@"fname"];//self.nickNameBtn.titleLabel.text;
    switch (self.cellType)
    {
        case MessageCell_Like:
        {
             nickName = [self.msgData objectForKey:@"uname"];
            self.cellTypeIndicator.hidden = YES;
            CGFloat width = 0.f;
            CGSize size = [NTESMBUtility getSizeForText:nickName font:kAppTextSystemFont(kCellNickNameFontSize)];
            CGSize sizeIndictor = [NTESMBUtility getSizeForText:kFollowText font:kAppTextSystemFont(kCellNickNameFontSize)];
            width = size.width;
            if(kUserImageIconPendingX*2+size.width +sizeIndictor.width>kDeviceScreenWidth)
            {
                width = kDeviceScreenWidth-kUserImageIconPendingX*2-sizeIndictor.width;
            }
            [self.nickNameBtn setTitle:nickName forState:UIControlStateNormal];
            self.nickNameBtn.frame = CGRectMake(kCellContentStartX,kUserImageIconPendingY,width,size.height);
            
            self.timeLabel.frame = CGRectMake(kCellContentStartX,kUserImageIconPendingY+kUserImageIconW-kCellTimeFontSize,250.f,kCellTimeFontSize);
            break;
        }
        case MessageCell_Follow:
        {
            nickName = [self.msgData objectForKey:@"fname"];
            
            CGFloat width = 0.f;
            CGSize size = [NTESMBUtility getSizeForText:nickName font:kAppTextSystemFont(kCellNickNameFontSize)];
            CGSize sizeIndictor = [NTESMBUtility getSizeForText:kFollowText font:kAppTextSystemFont(kCellNickNameFontSize)];
            width = size.width;
            if(kUserImageIconPendingX*2+size.width +sizeIndictor.width>kDeviceScreenWidth)
            {
                width = kDeviceScreenWidth-kUserImageIconPendingX*2-sizeIndictor.width;
            }
            [self.nickNameBtn setTitle:nickName forState:UIControlStateNormal];
            self.nickNameBtn.frame = CGRectMake(kCellContentStartX,kUserImageIconPendingY,width,size.height);
            self.cellTypeIndicator.text = kFollowText;
            self.cellTypeIndicator.frame = CGRectMake(self.nickNameBtn.frame.origin.x+width+2.f,kUserImageIconPendingY,sizeIndictor.width,sizeIndictor.height);
            
            self.timeLabel.frame = CGRectMake(kCellContentStartX,kUserImageIconPendingY+kUserImageIconW-kCellTimeFontSize,250.f,kCellTimeFontSize);
            
        }
            break;
        case MessageCell_ReComment:
        {
            //NSString *nickName = [self.msgData objectForKey:@"fname"];
            CGFloat width = 0.f;
            CGSize size = [NTESMBUtility getSizeForText:nickName font:kAppTextSystemFont(kCellNickNameFontSize)];
            CGSize sizeIndictor = [NTESMBUtility getSizeForText:kReCommentText font:kAppTextSystemFont(kCellNickNameFontSize)];
            width = size.width;
            if(kUserImageIconPendingX*2+size.width +sizeIndictor.width>kDeviceScreenWidth)
            {
                width = kDeviceScreenWidth-kUserImageIconPendingX*2-sizeIndictor.width;
            }
            self.nickNameBtn.frame = CGRectMake(kCellContentStartX,kUserImageIconPendingY,width,size.height);
            self.cellTypeIndicator.text = kReCommentText;
            self.cellTypeIndicator.frame = CGRectMake(self.nickNameBtn.frame.origin.x+width+2.f,kUserImageIconPendingY,sizeIndictor.width,sizeIndictor.height);
            
        }
        default:
            break;
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
