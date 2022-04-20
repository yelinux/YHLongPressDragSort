//
//  YHDragSortBaseView.m
//  UIKitPreviewNote
//
//  Created by chenyehong on 2022/4/19.
//

#import "YHDragSortBaseView.h"
#import "YHLongPressDragGestureRecognizer.h"
#import "UIView+YHLongPressDrag.h"

@interface YHDragSortBaseView()<YHLongPressDragGestureDelegate>

@property (nonatomic, strong) YHLongPressDragGestureRecognizer *longPressDragGest;

@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, assign) CGFloat tempAlpha;
@property (nonatomic, strong) UIImageView *ivDrag;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint startCenter;
@property (nonatomic, strong) CAKeyframeAnimation *sortingAnim;

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
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.window.screen.scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    self.ivDrag.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.ivDrag.transform = CGAffineTransformMakeScale(1.1, 1.1);
    
    [self addSubview:self.ivDrag];
    self.tempAlpha = self.dragView.alpha;
    self.dragView.alpha = 0;
    
    if (self.yh_enableDragAnim) {
        [self.ivDrag.layer addAnimation:self.sortingAnim forKey:NSStringFromSelector(@selector(sortingAnim))];
        [self.subItemViews enumerateObjectsUsingBlock:^(UIView * view, NSUInteger idx, BOOL * _Nonnull stop) {
            (!view.yh_longPressDragDisable) ? [view.layer addAnimation:self.sortingAnim forKey:NSStringFromSelector(@selector(sortingAnim))] : nil;
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
    [self.ivDrag removeFromSuperview];
    self.ivDrag.transform = CGAffineTransformIdentity;
    self.dragView.alpha = self.tempAlpha;
    
    if (self.yh_enableDragAnim) {
        [self.ivDrag.layer removeAnimationForKey:NSStringFromSelector(@selector(sortingAnim))];
        [self.subItemViews enumerateObjectsUsingBlock:^(UIView * view, NSUInteger idx, BOOL * _Nonnull stop) {
            (!view.yh_longPressDragDisable) ? [view.layer removeAnimationForKey:NSStringFromSelector(@selector(sortingAnim))] : nil;
        }];
    }
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

- (CAKeyframeAnimation *)sortingAnim{
    if (_sortingAnim == nil) {
        CGFloat (^angle2radian)(int x) = ^(int x){
            return ((x)/180.0*M_PI);
        };
        _sortingAnim = [CAKeyframeAnimation animation];
        _sortingAnim.keyPath = @"transform.rotation";
        _sortingAnim.values = @[@(angle2radian(-5)),@(angle2radian(5)),@(angle2radian(-5))];
        _sortingAnim.repeatCount = MAXFLOAT;
        _sortingAnim.duration = 0.5;
    }
    return _sortingAnim;
}

@end
