//
//  DressMemoDetailView.h
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DressMemoDetailDataModel.h"
#import "NTESMBTweetieTableView.h"
#import "NTESMBRequest.h"

@class DressMemoInfoView;
@class DressMemoDetailTagsView;
@class DressMemoUserIconDownloader;
@protocol DressMemoTagsViewDataSource;

#pragma mark -
#pragma mark DressMemoDetailTableHeader
@interface DressMemoDetailTableHeader : UIView <DressMemoTagsViewDataSource, RequestDelegate>{
    DressMemoInfoView *_infoView;
    UIView *_gallery;
    
    DressMemoDetailTagsView *_tagsView;
    
    DressMemoUserIconDownloader *_downloader;
}

@property (nonatomic, readonly)DressMemoDetailTagsView *tagsView;

- (void)reloadData:(DressMemoDetailDataModel *)dataModel;

@end

#pragma mark -
#pragma mark DressMemoDetailView
@interface DressMemoDetailView : UIView{
    DressMemoDetailTableHeader *_detailHeader;
    NTESMBTweetieTableView     *_detailTableView;
}

@property (nonatomic, readonly)NTESMBTweetieTableView     *tableView;
@property (nonatomic, readonly)DressMemoDetailTableHeader *detailHeader;

- (void)reloadData:(DressMemoDetailDataModel *)dataModel;

@end


#pragma mark -
#pragma mark DressMemoInfoView
@interface DressMemoInfoView : UIView{
    UIImageView *_userIconView;
    UILabel     *_userNameLabel;
    UIImageView *_timeIconView;
    UILabel     *_timeLabel;
}

@property (nonatomic, readonly)UIImageView *userIconView;
@property (nonatomic, readonly)UILabel     *userNameLabel;
@property (nonatomic, readonly)UILabel     *timeLabel;

@end

#pragma mark -
#pragma mark DressMemoTagCell
@interface DressMemoTagCell : UIView{
    UIImageView *_tagView;
    UILabel     *_tagLabel;
    
    BOOL        _drawDashLine;
}

@property (nonatomic, assign)BOOL drawDashLine;

- (void)reloadData:(DressMemoTagModel *)tag;

@end

#pragma mark -
#pragma mark DressMemoDetailTagsView
@interface DressMemoDetailTagsView : UIView {
    id <DressMemoTagsViewDataSource> _datasource;
    
    NSMutableArray *_tagCellViews;
    
}

@property (nonatomic, assign)id <DressMemoTagsViewDataSource> datasource;

- (void)reloadData;

@end

@protocol DressMemoTagsViewDataSource  <NSObject>

- (NSInteger)countOfTagInTagsView:(DressMemoDetailTagsView *)tagsView;
- (DressMemoTagCell *)tagsView:(DressMemoDetailTagsView *)tagsView cellWithIndex:(NSInteger)index;

@end