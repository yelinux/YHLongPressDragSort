//
//  YHLongPressDragGestureRecognizer.h
//  UIKitPreviewNote
//
//  Created by chenyehong on 2022/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 该cell是否允许拖动，pressPoint-长按cell所在的位置
typedef BOOL (^YHIsDragRecognizeBlock)(NSIndexPath *indexPath, CGPoint pressPoint);
/// 开始拖动
typedef void (^YHDragBeginBlock)(NSIndexPath *indexPath);
/// 两cell是否允许交换位置，如果允许，更新数据源并返回YES
typedef BOOL (^YHIsDragMoveItemBlock)(NSIndexPath *from, NSIndexPath *to);
/// 拖动结束
typedef void (^YHDragEndBlock)(void);

@protocol YHLongPressDragGestureDelegate <NSObject>

-(BOOL)yh_LongPressDragGestureRecognize: (CGPoint)point;
-(void)yh_LongPressDragGestureBegin: (CGPoint)point;
-(void)yh_LongPressDragGestureMove: (CGPoint)point;
-(void)yh_LongPressDragGestureEnd;

@end

@interface YHLongPressDragGestureRecognizer : UILongPressGestureRecognizer

@property (nonatomic, weak) id<YHLongPressDragGestureDelegate> dragDelegate;

@end

NS_ASSUME_NONNULL_END
