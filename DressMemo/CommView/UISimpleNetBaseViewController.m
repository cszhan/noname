//
//  UISimpleNetBaseViewController.m
//  DressMemo
//
//  Created by  on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UISimpleNetBaseViewController.h"

@interface UISimpleNetBaseViewController ()

@end

@implementation UISimpleNetBaseViewController
@synthesize request;
@synthesize isVisitOther;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}
- (void)addObservers{
    [ZCSNotficationMgr addObserver:self call:@selector(didNetWorkOK:) msgName:kZCSNetWorkOK];
    [ZCSNotficationMgr addObserver:self call:@selector(didNetWorkFailed:) msgName:
     kZCSNetWorkRespondFailed];
    [ZCSNotficationMgr addObserver:self call:@selector(didNetWorkFailed:) msgName:kZCSNetWorkRequestFailed];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark net work respond failed

-(void)didNetDataOK:(NSNotification*)ntf
{
    //kNetEnd(self.view);
    NE_LOG(@"warning not implemetation net respond");
    //self.view.userInteractionEnabled = YES;
}
-(void)didNetDataFailed:(NSNotification*)ntf
{
    NE_LOG(@"warning not implemetation net respond");
}

-(void)didNetWorkOK:(NSNotification*)ntf
{
    [self performSelectorOnMainThread:@selector(didNetDataOK:) withObject:ntf waitUntilDone:NO];
    
}
-(void)didNetWorkFailed:(NSNotification*)ntf
{
    [self performSelectorOnMainThread:@selector(didNetDataFailed:) withObject:ntf waitUntilDone:NO];
}
-(void)didReloadRequest:(NSNotification*)ntf
{
    @synchronized(self)
    {
        //we should renew the request 
        self.request = [ntf object];
        
    }
}
@end
