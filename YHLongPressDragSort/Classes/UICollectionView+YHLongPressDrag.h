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
- (void)yh_enableLongPressDrag: (YHIsDragRecognizeBlock)isDragRecognizeBlock
              isDragBeginBlock: (YHDragBeginBlock)dragBeginBlock
                isDragMoveItem: (YHIsDragMoveItemBlock)isDragMoveItemBlock
                  dragEndBlock: (YHDragEndBlock)dragEndBlock;

@end

NS_ASSUME_NONNULL_END
