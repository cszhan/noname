//
//  UserInforEditViewController.h
//  DressMemo
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

@interface UserInforEditViewController : LoginViewController<UITextViewDelegate>
@property(nonatomic,retain)NSDictionary *userData;
@end
