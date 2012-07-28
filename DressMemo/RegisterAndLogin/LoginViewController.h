//
//  LoginViewController.h
//  DressMemo
//
//  Created by  on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIBaseViewController.h"

@interface LoginViewController : UIBaseViewController<UITableViewDelegate>
{

    UIImageView *cloudView;
    
    UIButton *loginButton;
    UIButton *regButton;
    
    UITableView *logInfo;
    UINavigationController *gnv;
}
@property(nonatomic,retain)UITableViewCell *reSetPwdcell;
@end
