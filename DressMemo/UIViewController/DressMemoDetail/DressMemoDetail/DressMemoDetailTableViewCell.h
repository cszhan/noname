//
//  DressMemoDetailTableViewCell.h
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DressMemoDetailDataModel.h"
#import "NTESMBRequest.h"

#pragma mark -
#pragma mark UIAppendInfoDetailView
@interface UIAppendInfoDetailView : UIView{
    UIImageView *_thumbImageView;
    UILabel     *_infoLabel;
    
    BOOL        _drawDashLine;
}

@property (nonatomic, assign)BOOL drawDashLine;

#define kAppendInfoTypeKey @"kAppendInfoTypeKey"
#define kAppendInfoTextKey @"kAppendInfoTextKey"

+ (CGFloat)viewHeight:(NSDictionary *)dataDic withViewWidth:(CGFloat)width;

- (void)reloadData:(NSDictionary *)dataDic;



@end

#pragma mark -
#pragma mark UIAppendInfoCell
@interface UIAppendInfoCell : UITableViewCell{
    NSMutableArray *_infoViews;
}

+ (CGFloat)cellHeight:(NSArray *)datas withCellWidth:(CGFloat)width;

- (void)reloadData:(NSArray *)datas;

@end

#pragma mark -
#pragma mark UILoadPicImageView
@interface UILoadPicImageView : UIImageView <RequestDelegate>{
    NTESMBRequest *_downloader;
}

- (void)loadPicWithPath:(NSString *)path;

@end

#pragma mark -
#pragma mark UICollectedUserCell
@interface UICollectedUserCell : UITableViewCell{
    NSMutableArray *_userIcons;
    
    //UIView
    UIImageView *_likeImageView;
    UILabel     *_collectCount;
    UIButton    *_moreBtn;
}

+ (CGFloat)cellHeight;

- (void)reloadData:(NSArray *)datas;

@end

#pragma mark -
#pragma mark UICommentCell
@protocol UICommentCellDelegate;

@interface UICommentCell : UITableViewCell{
    UIImageView *_userIcon;
    UIButton     *_commentCreator;
    UILabel     *_commentLabel;
    UIButton     *_commentedUser;
    
    UILabel     *_time;
    UIImageView *_timeImageView;
    
    UIButton    *_commentBtn;
    
    UILabel     *_commentText;
    
    id<UICommentCellDelegate> _delegate;

}

@property (nonatomic, assign)id<UICommentCellDelegate> delegate;

+ (CGFloat)cellHeight:(DressMemoCommentModel *)data withCellWidth:(CGFloat)width;

- (void)reloadData:(DressMemoCommentModel *)data;

@end

@protocol UICommentCellDelegate  <NSObject>

- (void)commentBtnPressedOnCommentCell:(UICommentCell *)cell;
- (void)commentCreatorUserPressedOnCommentCell:(UICommentCell *)cell;
- (void)commentedUserPressedOnCommentCell:(UICommentCell *)cell;

@end
