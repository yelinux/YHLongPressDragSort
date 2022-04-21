//
//  YHCollectionDemoCell.h
//  YHLongPressDragSort_Example
//
//  Created by chenyehong on 2022/4/20.
//  Copyright © 2022 ye_linux@126.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHCollectionDemoCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *lb;
@property (nonatomic, strong) YHDragSortGridView *gridView;

@end

NS_ASSUME_NONNULL_END
