//
//  DressMemoRetweetController.m
//  DressMemo
//
//  Created by Fengfeng Pan on 12-8-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DressMemoRetweetController.h"
#import "UIRetweetView.h"
#import "SharePlatformCenter.h"

@interface DressMemoRetweetController ()

@end

@implementation DressMemoRetweetController

- (void)loadView{
    [super loadView];
    
    _retweetView = [[UIRetweetView alloc] initWithFrame:CGRectMake(0, 44, 320, 460-44-50)];
    [self.view addSubview:_retweetView];
    _retweetView.tableView.delegate = self;
    _retweetView.tableView.dataSource = self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) 
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDisappear:) 
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    Safe_Release(_retweetView)
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    Safe_Release(_retweetView)
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_retweetView.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
     
#pragma mark -
#pragma mark Public API
-(void)didSelectorTopNavItem:(id)navObj
{
	NE_LOG(@"select item:%d",[navObj tag]);
    
	switch ([navObj tag])
	{
		case 0:
        {
            [super didSelectorTopNavItem:navObj];
        }
			break;
		case 1: //发送按钮
		{
            NSString *string = [[(UIRetweetInputCell *)[_retweetView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] inputView] text];
            [[SharePlatformCenter defaultCenter] sendStatus:string ImageData:nil];
			break;
		}
	}
    
}

#pragma mark -
#pragma mark Private API
- (void)keyboardAppear:(NSNotification *)n{
    _retweetView.tableView.contentOffset = CGPointZero;
    _retweetView.tableView.scrollEnabled = NO;
}

- (void)keyboardDisappear:(NSNotification *)n{
    _retweetView.tableView.scrollEnabled = YES;
}

#pragma mark -
#pragma mark UITableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        static NSString *retweetCell = @"retweetCell";
        UIRetweetInputCell *cell = [tableView dequeueReusableCellWithIdentifier:retweetCell];
        
        if(![cell isKindOfClass:[UIRetweetInputCell class]]) {
            cell = [[[UIRetweetInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:retweetCell] autorelease];
        }
        
        return cell;
        
    }else {
        static NSString *bindCell = @"bindCell";
        UIRetweetBindCell *cell = [tableView dequeueReusableCellWithIdentifier:bindCell];
        
        if (![cell isKindOfClass:[UIRetweetBindCell class]]) {
            cell = [[[UIRetweetBindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bindCell] autorelease];
        }

        NSString *type = nil;
        NSString *platformName = nil;
        if (indexPath.row == 1) {
            type = K_PLATFORM_Sina;
            platformName = @"新浪微博";
        }else {
            type = K_PLATFORM_Tencent;
            platformName = @"腾讯微波";
        }
        
        NSDictionary *data = [[SharePlatformCenter defaultCenter] modelDataWithType:type];
        cell.weiboType = type;

        [cell reloadData:data withWeiBo:platformName];

        
        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0) {
        return [UIRetweetInputCell cellHeight];
    }else {
        return [UIRetweetBindCell cellHeight];
    }

    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *type;
    
    switch (indexPath.row) {
        case 1:
            type = K_PLATFORM_Sina;
            break;
        case 2:
            type = K_PLATFORM_Tencent;
            break;
        default:
            type = nil;
            break;
    }
    
    [[SharePlatformCenter defaultCenter] bindPlatformWithKey:type WithController:self];
}


@end
