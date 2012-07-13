//
//  UIAlertViewMgr.m
//  DressMemo
//
//  Created by  on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIAlertViewMgr.h"
#import "ZCSNotficationMgr.h"
#import "AppMSGDef.h"
static UIAlertViewMgr *sharedInstance = nil;
@implementation UIAlertViewMgr
+(id)getSigleTone{
    @synchronized(self){
        if(sharedInstance == nil){
            sharedInstance = [[self alloc]init];
        }
    }
    return sharedInstance;
}
-(id)init{
    if(self = [super init])
    {
    
        [self registorObserver];
    }
    return  self;
}
-(void)registorObserver
{

    [ZCSNotficationMgr addObserver:self call:@selector(shouldActionSheetChoose:) msgName:kUploadActionSheetViewAlertMSG];
}
-(void)shouldActionSheetChoose:(NSNotification*)ntf
{
    id obj = [ntf object];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" 
                                                            delegate:self 
                                                   cancelButtonTitle:nil
                                              destructiveButtonTitle:nil otherButtonTitles:nil,nil];
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:NSLocalizedString(@"From Camera",@"")];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"From Album" ,@"")];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel",@"")];
    [actionSheet showInView:obj];
    [actionSheet autorelease];
    
}
#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) 
        return;
    [ZCSNotficationMgr postMSG:kUploadPhotoPickChooseMSG obj:[NSNumber numberWithInt:buttonIndex]];
}
@end
