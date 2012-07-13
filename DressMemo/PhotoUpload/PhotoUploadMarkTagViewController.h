//
//  PhotoUploadMarkTagViewController.h
//  DressMemo
//
//  Created by  on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoUploadStartViewController.h"
#import "PeekPagedScrollViewController.h"
//@class PhotoUploadStartViewController;
@interface PhotoUploadMarkTagViewController :PhotoUploadStartViewController
@property(nonatomic,retain) PeekPagedScrollViewController *newScrollerView;
@end
