//
//  YHDragSortBaseView.m
//  UIKitPreviewNote
//
//  Created by chenyehong on 2022/4/19.
//

#import "YHDragSortBaseView.h"
#import "YHLongPressDragGestureRecognizer.h"
#import "UIView+YHLongPressDrag.h"
#import "YHDragSortUtil.h"

@interface YHDragSortBaseView()<YHLongPressDragGestureDelegate>

@property (nonatomic, strong) YHLongPressDragGestureRecognizer *longPressDragGest;

@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, assign) CGFloat tempAlpha;
@property (nonatomic, strong) UIImageView *ivDrag;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint startCenter;
@property (nonatomic, strong) CAKeyframeAnimation *dragAnim;

@end

@implementation YHDragSortBaseView

- (instancetype)init{
    if (self = [super init]) {
        [self addGestureRecognizer:self.longPressDragGest];
    }
    return self;
}

// MARK - ui
-(void)refreshSubItemPosition{

}

// Mark - MovLongPressGestureRecognizerDelegate
-(BOOL)yh_LongPressDragGestureRecognize: (CGPoint)point{
    __block UIView *targetView = nil;
    [self.subItemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        if (view.alpha > 0 && !view.yh_longPressDragDisable) {
            CGRect rect = [self convertRect:view.frame fromView:view.superview];
            if (CGRectContainsPoint(rect, point)) {
                targetView = view;
                *stop = YES;
            }
        }
    }];
    self.dragView = targetView;
    return targetView?YES:NO;
}

-(void)yh_LongPressDragGestureBegin: (CGPoint)point{
    UIView *view = self.dragView;
    CGRect rect = [self convertRect:view.frame fromView:view.superview];
    self.ivDrag.frame = rect;
    self.startPoint = point;
    self.startCenter = self.ivDrag.center;
    
    self.ivDrag.image = [YHDragSortUtil snapshot:view];
    self.ivDrag.transform = CGAffineTransformMakeScale(1.1, 1.1);
    
    [self addSubview:self.ivDrag];
    self.tempAlpha = view.alpha;
    view.alpha = 0;
    
    if (self.yh_enableDragAnim) {
        [self.subItemViews enumerateObjectsUsingBlock:^(UIView * view, NSUInteger idx, BOOL * _Nonnull stop) {
            (!view.yh_longPressDragDisable) ? [view.layer addAnimation:self.dragAnim forKey:NSStringFromSelector(@selector(dragAnim))] : nil;
        }];
    }
}

-(void)yh_LongPressDragGestureMove: (CGPoint)point{
    CGPoint offset = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    self.ivDrag.center = CGPointMake(self.startCenter.x + offset.x, self.startCenter.y + offset.y);

    __block UIView *targetView = nil;
    [self.subItemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        if (view.alpha > 0 && !view.yh_longPressDragDisable) {
            CGRect rect = [self convertRect:view.frame fromView:view.superview];
            if (CGRectContainsPoint(rect, point)) {
                targetView = view;
                *stop = YES;
            }
        }
    }];
    
    if (targetView) {
        NSMutableArray *subItemViews = [NSMutableArray arrayWithArray:self.subItemViews];
        NSInteger targetIndex = [subItemViews indexOfObject:targetView];
        [subItemViews removeObject:self.dragView];
        [subItemViews insertObject:self.dragView atIndex:targetIndex];
//        [subItemViews exchangeObjectAtIndex:[self.subItemViews indexOfObject:targetView] withObjectAtIndex:[self.subItemViews indexOfObject:self.dragView]];
        self.subItemViews = subItemViews;
        [self refreshSubItemPosition];
        [self bringSubviewToFront:self.ivDrag];
        if (self.updateSortedBlock) {
            self.updateSortedBlock(self.subItemViews);
        }
    }
}

-(void)yh_LongPressDragGestureEnd{
    if (self.yh_enableDragAnim) {
        [self.subItemViews enumerateObjectsUsingBlock:^(UIView * view, NSUInteger idx, BOOL * _Nonnull stop) {
            (!view.yh_longPressDragDisable) ? [view.layer removeAnimationForKey:NSStringFromSelector(@selector(dragAnim))] : nil;
        }];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.ivDrag.transform = CGAffineTransformIdentity;
        self.ivDrag.frame = self.dragView.frame;
    } completion:^(BOOL finished) {
        self.dragView.alpha = self.tempAlpha;
        [self.ivDrag removeFromSuperview];
    }];
}

// MARK - Getter
- (YHLongPressDragGestureRecognizer *)longPressDragGest{
    if (_longPressDragGest == nil) {
        _longPressDragGest = [[YHLongPressDragGestureRecognizer alloc] init];
        _longPressDragGest.dragDelegate = self;
    }
    return _longPressDragGest;
}

- (UIImageView *)ivDrag{
    if (_ivDrag == nil) {
        _ivDrag = [[UIImageView alloc] init];
    }
    return _ivDrag;
}

- (CAKeyframeAnimation *)dragAnim{
    if (_dragAnim == nil) {
        _dragAnim = [YHDragSortUtil createDragAnim];
    }
    return _dragAnim;
}

@end
