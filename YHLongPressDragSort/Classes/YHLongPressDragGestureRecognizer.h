//
//  YHLongPressDragGestureRecognizer.h
//  UIKitPreviewNote
//
//  Created by chenyehong on 2022/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^YHIsDragBeginBlock)(NSIndexPath *indexPath);
typedef BOOL (^YHIsDragMoveItemBlock)(NSIndexPath *from, NSIndexPath *to);

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
