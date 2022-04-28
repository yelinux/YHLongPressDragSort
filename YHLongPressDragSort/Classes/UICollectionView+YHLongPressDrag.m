//
//  UICollectionView+YHLongPressDrag.m
//  YHLongPressDragSort
//
//  Created by chenyehong on 2022/4/20.
//

#import "UICollectionView+YHLongPressDrag.h"
#import <objc/runtime.h>
#import "YHDragSortUtil.h"

@interface YHCollectionDragDelegateObject : NSObject<YHLongPressDragGestureDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *ivDrag;
@property (nonatomic, assign) CGFloat tempAlpha;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint startCenter;
@property (nonatomic, strong) NSIndexPath *dragingIndexPath;
@property (nonatomic, strong) NSIndexPath *targetIndexPath;

@property (nonatomic, copy) YHIsDragRecognizeBlock isDragRecognizeBlock;
@property (nonatomic, copy) YHDragBeginBlock dragBeginBlock;
@property (nonatomic, copy) YHIsDragMoveItemBlock isDragMoveItemBlock;
@property (nonatomic, copy) YHDragEndBlock dragEndBlock;

@end

@interface UICollectionView()

@property (strong, nonatomic) YHCollectionDragDelegateObject *delegateObject;

@end

@implementation UICollectionView (YHLongPressDrag)

- (void)yh_enableLongPressDrag: (YHIsDragRecognizeBlock)isDragRecognizeBlock
                isDragMoveItem: (YHIsDragMoveItemBlock)isDragMoveItemBlock{
    [self yh_enableLongPressDrag:isDragRecognizeBlock isDragBeginBlock:nil isDragMoveItem:isDragMoveItemBlock dragEndBlock:nil];
}

- (void)yh_enableLongPressDrag: (YHIsDragRecognizeBlock)isDragRecognizeBlock
              isDragBeginBlock: (nullable YHDragBeginBlock)dragBeginBlock
                isDragMoveItem: (YHIsDragMoveItemBlock)isDragMoveItemBlock
                  dragEndBlock: (nullable YHDragEndBlock)dragEndBlock{
    self.delegateObject = [[YHCollectionDragDelegateObject alloc] init];
    self.delegateObject.collectionView = self;
    self.delegateObject.isDragRecognizeBlock = isDragRecognizeBlock;
    self.delegateObject.dragBeginBlock = dragBeginBlock;
    self.delegateObject.isDragMoveItemBlock = isDragMoveItemBlock;
    self.delegateObject.dragEndBlock = dragEndBlock;
    
    YHLongPressDragGestureRecognizer *longPress = [[YHLongPressDragGestureRecognizer alloc] init];
    longPress.dragDelegate = self.delegateObject;
    [self addGestureRecognizer:longPress];
}

- (void)setDelegateObject:(YHCollectionDragDelegateObject *)delegateObject{
    objc_setAssociatedObject(self, @selector(delegateObject), delegateObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YHCollectionDragDelegateObject *)delegateObject{
    return objc_getAssociatedObject(self, _cmd);
}

@end

@implementation YHCollectionDragDelegateObject

// Mark - YHLongPressDragGestureDelegate
-(BOOL)yh_LongPressDragGestureRecognize: (CGPoint)point{
    self.dragingIndexPath = nil;
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        CGRect cellFrame = [self.collectionView cellForItemAtIndexPath:indexPath].frame;
        if (CGRectContainsPoint(cellFrame, point)) {
            if (self.isDragRecognizeBlock && self.isDragRecognizeBlock(indexPath, CGPointMake(point.x - cellFrame.origin.x, point.y - cellFrame.origin.y))) {
                self.dragingIndexPath = indexPath;
            }
            break;
        }
    }
    return self.dragingIndexPath != nil;
}

-(void)yh_LongPressDragGestureBegin: (CGPoint)point{
    if (self.dragingIndexPath) {
        [self.collectionView addSubview:self.ivDrag];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.dragingIndexPath];
        self.ivDrag.frame = cell.frame;
        self.startPoint = point;
        self.startCenter = self.ivDrag.center;
        
        self.ivDrag.image = [YHDragSortUtil snapshot:cell];
        self.ivDrag.transform = CGAffineTransformMakeScale(1.1, 1.1);
        
        self.tempAlpha = cell.contentView.alpha;
        cell.contentView.alpha = 0;
        
        self.dragBeginBlock ? self.dragBeginBlock(self.dragingIndexPath) : nil;
    }
}

-(void)yh_LongPressDragGestureMove: (CGPoint)point{
    if (!self.dragingIndexPath) {return;}
    CGPoint offset = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    self.ivDrag.center = CGPointMake(self.startCenter.x + offset.x, self.startCenter.y + offset.y);
    
    self.targetIndexPath = nil;
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        //如果是自己不需要排序
        if ([indexPath isEqual:self.dragingIndexPath]) {continue;}
        //在第一组中找出将被替换位置的Item
        if (CGRectContainsPoint([self.collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            self.targetIndexPath = indexPath;
        }
    }
    if (self.targetIndexPath) {
        //交换位置 如果没有找到self.targetIndexPath则不交换位置
        if (self.dragingIndexPath && self.targetIndexPath) {
            //isDragMoveItemBlock用于更新数据源并返回YES
            if (self.isDragMoveItemBlock && self.isDragMoveItemBlock(self.dragingIndexPath, self.targetIndexPath)) {
                //更新item位置
                [self.collectionView moveItemAtIndexPath:self.dragingIndexPath toIndexPath:self.targetIndexPath];
                self.dragingIndexPath = self.targetIndexPath;
                
                [self.collectionView bringSubviewToFront:self.ivDrag];
            }
        }
    }
}

-(void)yh_LongPressDragGestureEnd{
    if (!self.dragingIndexPath) {return;}
    CGRect endFrame = [self.collectionView cellForItemAtIndexPath:self.dragingIndexPath].frame;
    [UIView animateWithDuration:0.2 animations:^{
        self.ivDrag.transform = CGAffineTransformIdentity;
        self.ivDrag.frame = endFrame;
    } completion:^(BOOL finished) {
        [self.ivDrag removeFromSuperview];
        [self.collectionView cellForItemAtIndexPath:self.dragingIndexPath].contentView.alpha = self.tempAlpha;
    }];
    if (self.dragEndBlock) {
        self.dragEndBlock();
    }
}

// Mark - Getter
- (UIImageView *)ivDrag{
    if (_ivDrag == nil) {
        _ivDrag = [[UIImageView alloc] init];
    }
    return _ivDrag;
}
@end
