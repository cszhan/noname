//
//  FavDressMemoViewController.m
//  DressMemo
//
//  Created by  on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FavDressMemoViewController.h"
#import "ZCSNetClientDataMgr.h"
@interface FavDressMemoViewController ()

@end

@implementation FavDressMemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *bgImage = nil;
    UIImageWithFileName(bgImage,@"BG.png");
    //assert(bgImage);
    mainView.bgImage = bgImage;
    if(!self.isVisitOther)
        [self setNavgationBarTitle:NSLocalizedString(@"My Favarator", @""
                                                     )];
    else 
    {
        [self setNavgationBarTitle:NSLocalizedString(@"Favarator", @""
                                                     )];
    }
    
    [self getMyFavMemos];
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


#pragma mark start get data
- (void) shouldLoadNewerData:(NTESMBTweetieTableView *) tweetieTableView
{
    NSLog(@"loader new data");
    //    if(isRefreshing)
    //        return;
}

- (void)shouldLoadOlderData:(NTESMBTweetieTableView *) tweetieTableView
{
#if 0 
    if(isRefreshing)
        return;
#endif  
    NSLog(@"loader old data");
    [self startShowLoadingView];
    [self getMyFavMemos];
    //[memoTimelineDataSource getOldData];
}
/*
 *Pageno
 pagesize
 */

-(void)getMyFavMemos
{
    ZCSNetClientDataMgr *netMgr = [ZCSNetClientDataMgr getSingleTone];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           @"1"         ,@"pageno",
                           @"100",@"pagesize",
                           nil];
    if(self.isVisitOther)
    {
        
        [param setValue:self.userId forKey:@"uid"];
    }
    [netMgr getFavMemos:param];
}
@end
