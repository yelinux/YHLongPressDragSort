//
//  UICollectionView+YHLongPressDrag.h
//  YHLongPressDragSort
//
//  Created by chenyehong on 2022/4/20.
//

#import <UIKit/UIKit.h>
#import "YHLongPressDragGestureRecognizer.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (YHLongPressDrag)

/// 启用拖动排序
/// @param isDragRecognizeBlock 该cell是否允许拖动
/// @param dragBeginBlock 开始拖动
/// @param isDragMoveItemBlock 两cell是否允许交换位置，如果允许，更新数据源并返回YES
/// @param dragEndBlock 拖动结束
- (void)yh_enableLongPressDrag: (YHIsDragRecognizeBlock)isDragRecognizeBlock
              isDragBeginBlock: (YHDragBeginBlock)dragBeginBlock
                isDragMoveItem: (YHIsDragMoveItemBlock)isDragMoveItemBlock
                  dragEndBlock: (YHDragEndBlock)dragEndBlock;

@end

NS_ASSUME_NONNULL_END
