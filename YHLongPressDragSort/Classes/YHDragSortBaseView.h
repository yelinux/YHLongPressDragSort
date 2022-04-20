//
//  YHDragSortBaseView.h
//  UIKitPreviewNote
//
//  Created by chenyehong on 2022/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHDragSortBaseView : UIView

@property (nonatomic, strong) NSArray <UIView*>*subItemViews;
@property (nonatomic, assign) BOOL enableDragAnim;
@property (nonatomic, copy) void (^updateSortedBlock)(NSArray <UIView*>*subItemViews);
-(void)refreshSubItemPosition;

@end

NS_ASSUME_NONNULL_END
