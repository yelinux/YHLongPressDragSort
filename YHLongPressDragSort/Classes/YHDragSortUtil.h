//
//  YHDragSortUtil.h
//  YHLongPressDragSort
//
//  Created by chenyehong on 2022/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHDragSortUtil : NSObject

/// 创建拖动动画
+ (CAKeyframeAnimation *)createDragAnim;
/// 生成截图
+ (UIImage*)snapshot: (UIView*)view;

@end

NS_ASSUME_NONNULL_END
