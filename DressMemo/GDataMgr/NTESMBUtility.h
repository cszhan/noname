//
//  Utility.h
//  网易微博iPhone客户端
//
//  Created by Xu Han Jie on 10-5-18.
//  Copyright 2010 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NTESMBUtility : NSObject {

}

+ (CGFloat) getHeightForText:(NSString *) string maxWidth:(CGFloat) width maxHeight:(CGFloat) height font:(UIFont *) font;
+(CGFloat) getWidthForText:(NSString *)string font:(UIFont *)font;
+(CGFloat)getHeightForText:(NSString *)string font:(UIFont *)font;
+(CGSize)getSizeForText:(NSString *)string font:(UIFont *)font;

+ (NSNumber *) objectToNSNumber:(id) aObject;
+ (UIImage *)roundCornersOfImage:(UIImage *)source;
+ (UIImage*)rotateImage:(UIImage*)img scaledToSize:(CGSize)newSize;
+(UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
+ (NSString *) currentScreenName;
+ (NSString *) currentName;

+ (void) prepareImageDirectoryWithName:(NSString *) dirName;
+ (NSString *) filePathInDocumentsDirectoryForFileName:(NSString *)filename;
+ (void) clearPhotoCache;
+ (void) removeImageDirectoryWithName:(NSString *) dirName;
+ (void) showCommonAlertViewWithMessage:(NSString *) message;
@end
