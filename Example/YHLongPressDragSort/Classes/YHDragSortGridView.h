//
//  StackMov1View.h
//  UIKitPreviewNote
//
//  Created by chenyehong on 2022/4/19.
//

#import "YHDragSortBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHDragSortGridView : YHDragSortBaseView

/// 初始化子控件，固定横向间距，宽度自适应
/// @param views 子控件集合
/// @param colNum 列数
/// @param itemSpacing 横向间距
/// @param itemHeight 子控件统一高度
/// @param lineSpacing 纵向间距
/// @param edgeInsets 内边距
-(void)setViews: (NSArray<UIView*>*)views
         colNum: (NSInteger)colNum
    itemSpacing: (CGFloat)itemSpacing
     itemHeight: (CGFloat)itemHeight
    lineSpacing: (CGFloat)lineSpacing
     edgeInsets: (UIEdgeInsets)edgeInsets;

/// 初始化子控件，统一宽高，横向间距自适应
/// @param views 子控件集合
/// @param colNum 列数
/// @param itemWidth 子控件统一宽度
/// @param itemHeight 子控件统一高度
/// @param lineSpacing 纵向间距
/// @param edgeInsets 内边距
-(void)setViews: (NSArray<UIView*>*)views
         colNum: (NSInteger)colNum
      itemWidth: (CGFloat)itemWidth
     itemHeight: (CGFloat)itemHeight
    lineSpacing: (CGFloat)lineSpacing
     edgeInsets: (UIEdgeInsets)edgeInsets;

@end

NS_ASSUME_NONNULL_END
