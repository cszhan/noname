//
//  UIImage+Extend.m
//  DressMemo
//
//  Created by  on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Extend.h"
#import "UIImage+ProportionalFill.h"

@implementation UIImage_Extend
+(UIImage *)imageCroppedToFitSize:(CGSize)size withData:(UIImage*)srcData; // uses MGImageResizeCrop
{
    return [srcData imageCroppedToFitSize:size];
}
+(UIImage*)imageCroppedToFitSize:(CGSize)size withFileName:(NSString*)fileName{
    UIImage *data = nil;
    
    UIImageWithFullPathName(data, fileName);
    assert(data);
    UIImage *cropImageData = [UIImage_Extend imageCroppedToFitSize:size  
                                                            withData:data];
    return cropImageData;
}
+(UIImage*)imageCroppedToFitSizeII:(CGSize)size withData:(UIImage*)srcData
{
    return [srcData imageByScalingAndCroppingForSize:size];
}
+(UIImage*)imageCroppedToFitSizeII:(CGSize)size withFileName:(NSString*)fileName
{
    UIImage *data = nil;
   
    UIImageWithFullPathName(data, fileName);
    assert(data);
    UIImage *cropImageData = [UIImage_Extend imageCroppedToFitSizeII:size  
                                                            withData:data];
    return cropImageData;
}

+(UIImage*)imageScaleToFitSize:(CGSize)size withData:(UIImage*)srcData{
    return [srcData imageScaledToFitSize:size];
}
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
                                 //, bool leftup,bool leftbottom,bool rightup bool rightBottom)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);

    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+(UIImage *)makeRoundCornerImage : (UIImage*) img : (int) cornerWidth : (int) cornerHeight 
                       withLeftUp:(BOOL)leftUp withLeftButtom:(BOOL)leftBtm withRightUp:(BOOL)rightUp withRightButtom:(BOOL)rightBtm
{
	UIImage * newImage = nil;
	
	if( nil != img)
	{
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		int w = img.size.width;
		int h = img.size.height;
        
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
        
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
		addRoundedRectToPath(context, rect, cornerWidth, cornerHeight);
		CGContextClosePath(context);
		CGContextClip(context);
        
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
        
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		[img release];
        
        
		newImage = [[UIImage imageWithCGImage:imageMasked] retain];
		CGImageRelease(imageMasked);
		
		[pool release];
	}
	
    return newImage;
}
UIImage* MTDContextCreateRoundedMask(UIImage *srcImage, CGRect rect, CGFloat radius_tl, CGFloat radius_tr, CGFloat radius_bl, CGFloat radius_br ) {  
    
    CGContextRef context;
#if 0
    CGColorSpaceRef colorSpace;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a bitmap graphics context the size of the image
    context = CGBitmapContextCreate( NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast );
    
    // free the rgb colorspace
    CGColorSpaceRelease(colorSpace);    
    
    if ( context == NULL ) {
        return NULL;
    }
#else
    context = UIGraphicsGetCurrentContext();
#endif
    // cerate mask
    
    CGFloat minx = CGRectGetMinX( rect ), midx = CGRectGetMidX( rect ), maxx = CGRectGetMaxX( rect );
    CGFloat miny = CGRectGetMinY( rect ), midy = CGRectGetMidY( rect ), maxy = CGRectGetMaxY( rect );
    
    CGContextBeginPath( context );
    CGContextSetGrayFillColor( context, 1.0, 0.0 );
    CGContextAddRect( context, rect );
    CGContextClosePath( context );
    CGContextDrawPath( context, kCGPathFill );
    
    CGContextSetGrayFillColor( context, 1.0, 1.0 );
    CGContextBeginPath( context );
    CGContextMoveToPoint( context, minx, midy );
    CGContextAddArcToPoint( context, minx, miny, midx, miny, radius_bl );
    CGContextAddArcToPoint( context, maxx, miny, maxx, midy, radius_br );
    CGContextAddArcToPoint( context, maxx, maxy, midx, maxy, radius_tr );
    CGContextAddArcToPoint( context, minx, maxy, minx, midy, radius_tl );
    CGContextClosePath( context );
    CGContextDrawPath( context, kCGPathFill );
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    /*
    CGImageRef bitmapContext = CGBitmapContextCreateImage( context );
    CGContextRelease( context );
    */
    // convert the finished resized image to a UIImage (
    UIGraphicsBeginImageContext(srcImage.size);
    UIImage *theImage = [UIImage imageWithCGImage:srcImage.CGImage];
    // image is retained by the property setting above, so we can 
    // release the original
    //CGImageRelease(bitmapContext);
    UIGraphicsEndImageContext();
    // return the image
    return theImage;
} 
+(UIImage *)imageWithColor:(UIColor *)color  withSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width,size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end



