//
//  PhotoPickTool.m
//  NetEaseBlogIphone
//
//  Created by cszhan on 8/30/10.
//  Copyright 2010 NetEase Corp. All rights reserved.
//

#import "PhotoPickTool.h"
//#import "ZCSNotficationMgr.h"
static PhotoPickTool *sharedInstance = nil;
static UIImagePickerController *picker = nil;
@interface PhotoPickTool()
@property(nonatomic,assign)BOOL isImageEdit;
@end
@implementation PhotoPickTool
@synthesize delegate;
@synthesize controllerDelegate;
@synthesize isImageEdit;
+(id)getSingleTone
{
    @synchronized(self)
	{
        if(sharedInstance == nil)
            sharedInstance = [[self alloc]initWithViewControler:nil];
        return sharedInstance;
    }
    
}
-(id)initWithViewControler:(id)controller
{
	if(self = [super init])
    {
		controllerDelegate = controller;
		delegate = nil;
        [self registerObserver];
		picker = [[UIImagePickerController alloc] init];
	}
	return self;
}
-(void)registerObserver
{
    [ZCSNotficationMgr removeObserver:self msgName:kUploadPhotoPickChooseMSG];
    [ZCSNotficationMgr addObserver:self call:@selector(pickPhoto:) msgName:kUploadPhotoPickChooseMSG];
    [ZCSNotficationMgr addObserver:self call:@selector(pickPhotoEdit:) msgName:kUploadPhotoPickChooseEditMSG];
}
#pragma mark pick phto from action sheet msg
-(void)pickPhoto:(NSNotification*)ntf
{
    id sender = [ntf object];
    int type = -1;
    if([sender respondsToSelector:@selector(intValue)]){
        type = [sender intValue];
    }
    else if([sender respondsToSelector:@selector(tag)]){
        type = [sender tag];
    }
	switch (type) 
	{
		case 0:
		{
			
			[self  pickPhotoFromCamara];
		}
			break;
		case 1:
			[self  pickPhotoFromLib];
			break;
			
		default:
			break;
	}

}
-(void)pickPhotoEdit:(NSNotification*)ntf
{
    isImageEdit = YES;
    [self pickPhoto:ntf];
}
#pragma mark  UIImagePickerController 
- (BOOL)pickPhotoFromCamara{
	//NE_LOGFUN;
	BOOL hasCamera = NO;
	hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
	if(!hasCamera)
    {
		return NO;
	}
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	//picker.postViewController = self;
	picker.delegate = self;
    if(isImageEdit)
    {
        picker.allowsEditing = YES;
    }
	[controllerDelegate presentModalViewController:picker animated:YES];
    return YES;
}
-(BOOL)pickPhotoFromLib
{
	//UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.navigationBar.tintColor = [UIColor redColor];
	picker.delegate = self;
    if(isImageEdit)
    {
        picker.allowsEditing = YES;
    }
	[controllerDelegate presentModalViewController:picker animated:YES];
    return YES;
}
 - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
        NE_LOG(@"%@",[info description]);
   
    [controllerDelegate dismissModalViewControllerAnimated:YES];
    UIImage *data  = nil;
    if(isImageEdit)
    {
        data = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    }
    else 
    {
        data = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    
    if([delegate respondsToSelector:@selector(didGetImageData:)]&&delegate)
    {
        [delegate didGetImageData:data];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo 
{
	[controllerDelegate dismissModalViewControllerAnimated:YES];
#if 0
	[controllerDelegate performSelector:@selector(didFinishPickingImage:) withObject:image afterDelay:0.5];
#endif
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    

}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{

}
#if 0

-(void)didFinishPickingImage:(UIImage*)image
{
    
	PostPhotoViewController *postphotoviewcontroller = [[PostPhotoViewController alloc] initWithNibName:nil bundle:nil];
	postphotoviewcontroller.isDisplayAlbumList = YES;
	postphotoviewcontroller.delegate = self;
	[postphotoviewcontroller setPostPhotoImage:image];
	[postphotoviewcontroller setHidesBottomBarWhenPushed:YES];
	[controllerDelegate.navigationController pushViewController:postphotoviewcontroller animated:YES];
	//[self presentModalViewController:postphotoviewcontroller animated:NO];
	[postphotoviewcontroller release];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[controllerDelegate dismissModalViewControllerAnimated:YES];
	if(delegate && [delegate respondsToSelector:@selector(cancelPost:)]){
		[delegate cancelPost:NO];
	}
}
-(void)didPostPhoto:(id)dict withStatus:(BOOL)status
{
	//NE_LOGFUN;
	if(delegate && [delegate respondsToSelector:@selector(didPostPhoto:withStatus:)])
	{	
		[delegate didPostPhoto:dict withStatus:YES];
	}
}
#endif
-(void)dealloc
{
    [picker release];
	[super dealloc];
}
@end
