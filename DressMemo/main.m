//
//  main.m
//  DressMemo
//
//  Created by  on 12-6-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
#ifdef ARC
	@autoreleasepool
#else
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
#endif
	{
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
#ifdef ARC
#else
    [pool release];
#endif
}
