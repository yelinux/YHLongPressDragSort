//
//  YHDragSortCollectionBaseView.h
//  YHLongPressDragSort
//
//  Created by chenyehong on 2022/4/20.
//

#import <UIKit/UIKit.h>
#import "YHLongPressDragGestureRecognizer.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHDragSortCollectionBaseView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource, YHLongPressDragGestureDelegate>

@end

NS_ASSUME_NONNULL_END
