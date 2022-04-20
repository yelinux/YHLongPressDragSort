//
//  UICollectionView+YHLongPressDrag.m
//  YHLongPressDragSort
//
//  Created by chenyehong on 2022/4/20.
//

#import "UICollectionView+YHLongPressDrag.h"
#import "YHLongPressDragGestureRecognizer.h"
#import <objc/runtime.h>

@interface YHCollectionDragDelegateObject : NSObject<YHLongPressDragGestureDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *ivDrag;
@property (nonatomic, strong) NSIndexPath *dragingIndexPath;
@property (nonatomic, strong) NSIndexPath *targetIndexPath;

@property (nonatomic, copy) YHIsDragBeginBlock isDragBeginBlock;
@property (nonatomic, copy) YHIsDragMoveItemBlock isDragMoveItemBlock;

@end

@interface UICollectionView()

@property (strong, nonatomic) YHCollectionDragDelegateObject *delegateObject;

@end

@implementation UICollectionView (YHLongPressDrag)

- (void)yh_enableLongPressDrag: (YHIsDragBeginBlock)isDragBeginBlock
                isDragMoveItem: (YHIsDragMoveItemBlock)isDragMoveItemBlock{
    self.delegateObject = [[YHCollectionDragDelegateObject alloc] init];
    self.delegateObject.collectionView = self;
    self.delegateObject.isDragBeginBlock = isDragBeginBlock;
    self.delegateObject.isDragMoveItemBlock = isDragMoveItemBlock;
    
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
        if (CGRectContainsPoint([self.collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (self.isDragBeginBlock && self.isDragBeginBlock(indexPath)) {
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
        
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, YES, cell.window.screen.scale);
        [cell drawViewHierarchyInRect:cell.bounds afterScreenUpdates:NO];
        self.ivDrag.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.ivDrag.transform = CGAffineTransformMakeScale(1.1, 1.1);
        
        cell.contentView.alpha = 0;
    }
}

-(void)yh_LongPressDragGestureMove: (CGPoint)point{
    if (!self.dragingIndexPath) {return;}
    self.ivDrag.center = point;
    
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
    [self.collectionView cellForItemAtIndexPath:self.dragingIndexPath].contentView.alpha = 1;
    self.ivDrag.transform = CGAffineTransformIdentity;
    [self.ivDrag removeFromSuperview];
}

// Mark - Getter
- (UIImageView *)ivDrag{
    if (_ivDrag == nil) {
        _ivDrag = [[UIImageView alloc] init];
    }
    return _ivDrag;
}
@end
