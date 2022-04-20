//
//  StackMov1View.h
//  UIKitPreviewNote
//
//  Created by chenyehong on 2022/4/19.
//

#import "YHDragSortBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHDragSortGridView : YHDragSortBaseView

-(void)setViews: (NSArray<UIView*>*)views
         colNum: (NSInteger)colNum
    itemSpacing: (CGFloat)itemSpacing
     itemHeight: (CGFloat)itemHeight
    lineSpacing: (CGFloat)lineSpacing
     edgeInsets: (UIEdgeInsets)edgeInsets;

-(void)setViews: (NSArray<UIView*>*)views
         colNum: (NSInteger)colNum
      itemWidth: (CGFloat)itemWidth
     itemHeight: (CGFloat)itemHeight
    lineSpacing: (CGFloat)lineSpacing
     edgeInsets: (UIEdgeInsets)edgeInsets;

@end

NS_ASSUME_NONNULL_END
