//
//  ResetPasswordViewController.m
//  DressMemo
//
//  Created by  on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ResetPasswordViewController.h"
@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView{
    [super loadView];
    //
    [self setNavgationBarTitle:NSLocalizedString(@"Reset Password", @"")];
    
    [self setRightTextContent:NSLocalizedString(@"Send", @"")];
    //change the background
	//self.view = mainView;
    //mainView.backgroundColor = kLoginAndSignupCellImageBGColor;

}
- (void)viewDidLoad
{
    //[super viewDidLoad];
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

@end
