//
//  DressMemoDetailViewController.h
//  DressMemo
//
//  Created by cszhan on 12-8-1.
//
//

#import "UIBaseViewController.h"
#import "DressMemoDetailNetViewController.h"
#import "DressMemoDetailView.h"
#import "DressMemoDetailTableViewCell.h"

@class DressMemoDetailView;

@interface DressMemoDetailViewController : DressMemoDetailNetViewController <UITableViewDelegate, UITableViewDataSource, DressMemoTagsViewDataSource, UICommentCellDelegate>{
    DressMemoDetailView *_detailView;
    
    
    UIButton       *_likeBtn;
    UIButton       *_retweetBtn;
    UIButton       *_commentBtn;
    
}

-(void)setHiddenRightBtn:(BOOL)hidden;

@end
