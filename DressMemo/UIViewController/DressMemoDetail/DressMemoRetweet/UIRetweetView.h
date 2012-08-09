//
//  UIRetweetView.h
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark UIRetweetView
@interface UIRetweetView : UIView{
    UITableView *_tableView;
}

@property (nonatomic, readonly)UITableView *tableView;

@end

#pragma mark -
#pragma mark UIRetweetInputCell
@interface UIRetweetInputCell : UITableViewCell <UITextViewDelegate>{
    UITextView  *_inputView;
    UIImageView *_image;
    UILabel     *_countLabel;
}

@property (nonatomic, readonly) UITextView  *inputView;

+ (CGFloat)cellHeight;

@end

#pragma mark -
#pragma mark UIRetweetBindCell
@interface UIRetweetBindCell : UITableViewCell {
    UIButton    *_checkBtn;
    UILabel     *_weiboName;
    UILabel     *_bindName;
    
    NSString    *_weiboType;
}

@property (nonatomic, retain)NSString *weiboType;

+ (CGFloat)cellHeight;

- (void)reloadData:(NSDictionary *)data withWeiBo:(NSString *)weiboName;

@end