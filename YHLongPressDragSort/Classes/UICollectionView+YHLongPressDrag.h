//
//  UICollectionView+YHLongPressDrag.h
//  YHLongPressDragSort
//
//  Created by chenyehong on 2022/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^YHIsDragBeginBlock)(NSIndexPath *indexPath);
typedef BOOL (^YHIsDragMoveItemBlock)(NSIndexPath *from, NSIndexPath *to);

@interface UICollectionView (YHLongPressDrag)

- (void)yh_enableLongPressDrag: (YHIsDragBeginBlock)isDragBeginBlock
                isDragMoveItem: (YHIsDragMoveItemBlock)isDragMoveItemBlock;

@end

NS_ASSUME_NONNULL_END
