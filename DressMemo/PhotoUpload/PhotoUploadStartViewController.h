//
//  PhotoUploadStartViewController.h
//  DressMemo
//
//  Created by  on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIBaseViewController.h"
#import "BSPreviewScrollView.h"
@interface PhotoUploadStartViewController : UIBaseViewController<BSPreviewScrollViewDelegate,UIActionSheetDelegate>
@property(nonatomic,assign)BOOL isNeedToScroller;
@property(nonatomic,retain) BSPreviewScrollView *scrollViewPreview;
@property(nonatomic,retain) NSMutableArray *scrollPages;
@property(nonatomic,assign) NSMutableArray *fileNameArr;
@property(nonatomic,assign) int  chooseImageIndex;
-(void)replaceScrollerImageViewAtIndex:(NSInteger)num withImageData:(UIImage*)data;
-(void)replaceScrollerImageViewAtIndex:(NSInteger)num withImageDataFileName:(NSString*)fileName;
@end
