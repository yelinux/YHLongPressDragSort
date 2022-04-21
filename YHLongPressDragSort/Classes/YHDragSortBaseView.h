//
//  YHDragSortBaseView.h
//  UIKitPreviewNote
//
//  Created by chenyehong on 2022/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 长按拖动排序自定义基类
@interface YHDragSortBaseView : UIView
/// 子控件集合
@property (nonatomic, strong) NSArray <UIView*>*subItemViews;
/// 拖动时是否有抖动动画
@property (nonatomic, assign) BOOL yh_enableDragAnim;
/// 开始拖动，可由继承类启用自定义动画
-(void)longPressDragBegin;
/// 必须由继承类实现：初始化ui和子控件集合subItemViews顺序发生变化时调用，根据subItemViews顺序更新子控件布局
-(void)refreshSubItemPosition;
/// 排序更新回调，用于更新数据源
@property (nonatomic, copy) void (^updateSortedBlock)(NSArray <UIView*>*subItemViews);
/// 拖动结束，可由继承类结束自定义动画
-(void)longPressDragEnd;

@end

NS_ASSUME_NONNULL_END
