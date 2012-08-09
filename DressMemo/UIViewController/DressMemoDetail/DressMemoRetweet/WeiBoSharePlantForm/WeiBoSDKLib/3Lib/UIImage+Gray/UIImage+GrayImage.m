//
//  UIImage+GrayImage.m
//  UMSNSDemo
//
//  Created by Fengfeng Pan on 11-12-14.
//  Copyright (c) 2011年 Realcent. All rights reserved.
//

#import "UIImage+GrayImage.h"

@implementation UIImage (GrayImage)

-(UIImage *)createGrayCopy{  
    int width = self.size.width;  
    int height = self.size.height;  
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();  
    
    CGContextRef context = CGBitmapContextCreate (nil,  
                                                  width,  
                                                  height,  
                                                  8,      // bits per component  
                                                  0,  
                                                  colorSpace,  
                                                  kCGImageAlphaNone);  
    
    CGColorSpaceRelease(colorSpace);  
    
    if (context == NULL) {  
        return nil;  
    }  
    
    CGContextDrawImage(context,  
                       CGRectMake(0, 0, width, height), self.CGImage);  
    CGImageRef image = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:image];  
    CFRelease(image);
    CGContextRelease(context);  
    
    return grayImage;  
} 

@end
