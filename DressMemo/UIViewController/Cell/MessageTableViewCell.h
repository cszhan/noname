//
//  MessageTableViewCell.h
//  DressMemo
//
//  Created by cszhan on 12-7-30.
//
//

#import <UIKit/UIKit.h>
#import "FriendItemCell.h"
typedef enum MessageCell_Type{
    MessageCell_Like = -1,
	MessageCell_Follow = 0,
	MessageCell_Comment,
    MessageCell_ReComment,
	//TimelineCell_ReTweet,
}MessageCell_Type;

@interface MessageTableViewCell : FriendItemCell
@property(nonatomic,retain)UIButton *nickNameBtn;
//@property(nonatomic,retain)UIImageView *userIconView;
@property(nonatomic,assign)MessageCell_Type cellType;
@property(nonatomic,retain)UILabel *timeLabel;
@property(nonatomic,retain)UILabel *commentLabel;
@property(nonatomic,retain)UILabel *reCommentLabel;
@property(nonatomic,retain)NSDictionary *msgData;
@end
