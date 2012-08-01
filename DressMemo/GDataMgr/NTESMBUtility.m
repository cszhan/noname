//
//  Utility.m
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-18.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import "NTESMBUtility.h"
#import "NEDebugTool.h"

@implementation NTESMBUtility

+ (CGFloat) getHeightForText:(NSString *) string maxWidth:(CGFloat) width maxHeight:(CGFloat) height font:(UIFont *) font
{
	CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, height) lineBreakMode:UILineBreakModeTailTruncation];
	return size.height;
}
+(CGFloat)getWidthForText:(NSString *)string font:(UIFont *)font
{
	return [string sizeWithFont:font].width; 
}
+(CGSize)getSizeForText:(NSString *)string font:(UIFont *)font
{
	return [string sizeWithFont:font forWidth:320.f lineBreakMode:UILineBreakModeTailTruncation];
}

+(CGFloat)getHeightForText:(NSString *)string font:(UIFont *)font{
	return [string sizeWithFont:font].height; 
}

+ (NSNumber *) objectToNSNumber:(id) aObject
{
	if ([aObject isKindOfClass:[NSString class]])
	{
		return [NSNumber numberWithLongLong:[aObject longLongValue]];
	}
	else if ([aObject isKindOfClass:[NSNumber class]])
	{
		return aObject;
	}
	return [NSNumber numberWithLongLong:0];
}

#pragma mark -
#pragma mark image utility

+ (UIImage *) roundCornersOfImage:(UIImage *)source {
    int w = source.size.width;
    int h = source.size.height;
	CGFloat roundSize=5;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);

	//画圆角
	CGContextBeginPath(context);
	CGContextSaveGState(context);
    CGContextTranslateCTM (context, 0, 0);
    CGContextMoveToPoint(context, w, h/2);
    CGContextAddArcToPoint(context, w, h, w/2, h, roundSize);
    CGContextAddArcToPoint(context, 0, h, 0, h/2, roundSize);
    CGContextAddArcToPoint(context, 0, 0, w/2, 0, roundSize);
    CGContextAddArcToPoint(context, w, 0, w, h/2, roundSize);
    CGContextRestoreGState(context);
	CGContextClosePath(context);
	
    CGContextClip(context);
	
    //画图像
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), source.CGImage);
	
	
    //画边
	CGContextTranslateCTM (context, 0, 0);
	//border width
	CGContextSetLineWidth(context, 2.0f);
	//border color
	CGContextSetRGBStrokeColor(context, 0.3f, 0.3f, 0.3f, 0.5f);
	CGContextBeginPath (context);
	
    CGContextMoveToPoint(context, w, h/2);
    CGContextAddArcToPoint(context, w, h, w/2, h, roundSize);
    CGContextAddArcToPoint(context, 0, h, 0, w/2, roundSize);
	CGContextAddArcToPoint(context, 0, 0, w/2, 0, roundSize);
    CGContextAddArcToPoint(context, w, 0, w, h/2, roundSize);
	CGContextClosePath(context);
	CGContextStrokePath(context);
	
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
	UIImage *newImage = [[UIImage imageWithCGImage:imageMasked] retain];

	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	CGImageRelease(imageMasked);
	
    return [newImage autorelease];    
}

+ (UIImage*)rotateImage:(UIImage*)img scaledToSize:(CGSize)newSize
{
	//CGSize newSize = CGSizeMake(img.size.width, img.size.height);
	// Create a graphics image context
    UIGraphicsBeginImageContext(newSize);

	// Tell the old image to draw in this new context, with the desired
    // new size
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];

	// Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the context
    UIGraphicsEndImageContext();
	
	// Return the new image.
    return newImage;
	
	

	
	/*CGImageRef          imgRef = img.CGImage;
	CGFloat             width = ;
	CGFloat             height = CGImageGetHeight(imgRef);
	CGAffineTransform   transform = CGAffineTransformIdentity;
	CGRect              bounds = CGRectMake(0, 0, width, height);
    CGSize              imageSize = bounds.size;
	CGFloat             boundHeight;
	switch(orient) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		default:
            // image is not auto-rotated by the photo picker, so whatever the user
            // sees is what they expect to get. No modification necessary
            transform = CGAffineTransformIdentity;
            break;
			
	}
	UIGraphicsBeginImageContext(bounds.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    if ((orient == UIImageOrientationDown) ||(orient == UIImageOrientationRight) || (orient == UIImageOrientationUp)){
        // flip the coordinate space upside down
        CGContextScaleCTM(context, 1, -1);
		CGContextTranslateCTM(context, 0, -bounds.size.height);
        
    }
	
	CGContextConcatCTM(context, transform);
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;*/
}
+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
	CGFloat height = imageToCrop.size.height;
	CGFloat width = imageToCrop.size.height;
	//create a context to do our clipping in
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
	//create a rect with the size we want to crop the image to
	//the X and Y here are zero so we start at the beginning of our
	//newly created context
	CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
	CGContextClipToRect( currentContext, clippedRect);
	
	//create a rect equivalent to the full size of the image
	//offset the rect by the X and Y we want to start the crop
	//from in order to cut off anything before them
	CGFloat startx = (rect.size.width-imageToCrop.size.width)/2;
	CGFloat starty = (rect.size.height-imageToCrop.size.height)/2;
	
	CGRect drawRect = CGRectMake(startx,
								 starty,
								 imageToCrop.size.width,
								 imageToCrop.size.height);
	
	NE_LOGRECT(drawRect);
	//draw the image to our clipped context using our offset rect
	CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
	
	//pull the image from our cropped context
	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	
	//Note: this is autoreleased
	return cropped;
}



#pragma mark -
#pragma mark 缓存文件相关

+ (void) prepareImageDirectoryWithName:(NSString *) dirName
{
	NSString *imageDir = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), dirName];
	BOOL isDir = NO;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
	if ( !(isDir == YES && existed == YES) )
	{
		[fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
	}
}
+ (void) removeImageDirectoryWithName:(NSString *) dirName
{
	NSString *imageDir = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), dirName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:imageDir error:nil];
}
+ (BOOL)removeImageDataByfullName:(NSString*)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager removeItemAtPath:fileName error:nil];
}
+ (NSString *) filePathInDocumentsDirectoryForFileName:(NSString *)filename
{
    NSString *newFileName = filename;
    if(![filename hasSuffix:@".jpg"])
    {
        newFileName = [NSString stringWithFormat:@"%@.jpg",filename];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex: 0]; 
	NSString *pathName = [documentsDirectory stringByAppendingPathComponent:newFileName];
	return pathName;
}
+ (NSString*)filePathInDocumentsDirectoryForFileNameWithSubFix:(NSString*)filename{

    return nil;

}
+ (void) clearPhotoCache
{
	[NTESMBUtility removeImageDirectoryWithName:@"small_image"];
	[NTESMBUtility removeImageDirectoryWithName:@"original_image"];
	[NTESMBUtility removeImageDirectoryWithName:@"camera_image"];
	
	[NTESMBUtility prepareImageDirectoryWithName:@"small_image"];
	[NTESMBUtility prepareImageDirectoryWithName:@"original_image"];
	[NTESMBUtility prepareImageDirectoryWithName:@"camera_image"];
}

+ (void) showCommonAlertViewWithMessage:(NSString *) message
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

@end
