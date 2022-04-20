//
//  YHDragSortBaseView.h
//  UIKitPreviewNote
//
//  Created by chenyehong on 2022/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHDragSortBaseView : UIView
/// 子控件集合
@property (nonatomic, strong) NSArray <UIView*>*subItemViews;
/// 拖动时是否有抖动动画
@property (nonatomic, assign) BOOL yh_enableDragAnim;
/// 排序更新回调，用于更新数据源
@property (nonatomic, copy) void (^updateSortedBlock)(NSArray <UIView*>*subItemViews);
/// 初始化ui和子控件集合发生变化时调用，由继承类实现
-(void)refreshSubItemPosition;

@end

NS_ASSUME_NONNULL_END
