//
//  UIIconImageNetViewController.h
//  DressMemo
//
//  Created by cszhan on 12-8-6.
//
//

#import "UIImageNetBaseViewController.h"
@protocol UIIconImageNetViewControllerDataSource<NSObject>
@required
-(NSString*)userIconNameForIndexPath:(NSIndexPath*)indexPath;
@end
@protocol UIIconImageNetViewControllerDeleage <NSObject>
@optional
-(void)setCellUserIcon:(UIImage*)iconImage withIndexPath:(NSIndexPath*)indexPath;
-(void)setCell:(id)cell withImageData:(UIImage*)imageData withIndexPath:(NSIndexPath*)indexPath;
@end
@interface UIIconImageNetViewController : UIImageNetBaseViewController<UIIconImageNetViewControllerDataSource,
UIIconImageNetViewControllerDeleage>
@property(nonatomic,assign)id<UIIconImageNetViewControllerDataSource>   iconDataSouce;
@property(nonatomic,assign)id<UIIconImageNetViewControllerDeleage>      iconDelegate;
//for 
- (void)startloadInitCell:(id)cell withIndexPath:(NSIndexPath*)indexPath;
@end
