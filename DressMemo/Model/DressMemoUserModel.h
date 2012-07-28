//
//  NTESMBUserModel+DressMemoUserModel_h.h
//  DressMemo
//
//  Created by  on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NTESMBUserModel.h"

@interface DressMemoUserModel:NTESMBUserModel 
@property(nonatomic,retain)NSString *postMemosNumStr;
@property(nonatomic,retain)NSString *favMemosNumStr;
@property(nonatomic,retain)NSString *followNumStr;
@property(nonatomic,retain)NSString *followedNumStr;
@property(nonatomic,retain)NSString *registerTimeStr;
@property(nonatomic,retain)NSString *lastLoginTimeStr;
@end
