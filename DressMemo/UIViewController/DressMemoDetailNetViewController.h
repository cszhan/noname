//
//  DressMemoDetailViewController.h
//  DressMemo
//
//  Created by cszhan on 12-8-1.
//
//

#import "UIIconImageNetViewController.h"
#import "DressMemoDetailDataModel.h"

@interface DressMemoDetailNetViewController : UIIconImageNetViewController<UIIconImageNetViewControllerDataSource,
UIIconImageNetViewControllerDeleage>
//for DressMemoCommentData dataArray;
//for DressMemoDetailDataModel
@property(nonatomic,retain)DressMemoDetailDataModel *memoDetailData;
@end
