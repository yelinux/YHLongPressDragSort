//
//  UITableView+YHLongPressDrag.m
//  YHLongPressDragSort
//
//  Created by chenyehong on 2022/4/20.
//

#import "UITableView+YHLongPressDrag.h"
#import <objc/runtime.h>

@interface YHTableViewDragDelegateObject : NSObject<YHLongPressDragGestureDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIImageView *ivDrag;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint startCenter;
@property (nonatomic, strong) NSIndexPath *dragingIndexPath;
@property (nonatomic, strong) NSIndexPath *targetIndexPath;

@property (nonatomic, copy) YHIsDragBeginBlock isDragBeginBlock;
@property (nonatomic, copy) YHIsDragMoveItemBlock isDragMoveItemBlock;

@end

@interface UITableView()

@property (nonatomic, strong) YHTableViewDragDelegateObject *delegateObject;

@end

@implementation UITableView (YHLongPressDrag)

/// 启用拖动排序
- (void)yh_enableLongPressDrag: (YHIsDragBeginBlock)isDragBeginBlock
                isDragMoveItem: (YHIsDragMoveItemBlock)isDragMoveItemBlock{
    self.delegateObject = [[YHTableViewDragDelegateObject alloc] init];
    self.delegateObject.tableView = self;
    self.delegateObject.isDragBeginBlock = isDragBeginBlock;
    self.delegateObject.isDragMoveItemBlock = isDragMoveItemBlock;
    
    YHLongPressDragGestureRecognizer *longPress = [[YHLongPressDragGestureRecognizer alloc] init];
    longPress.dragDelegate = self.delegateObject;
    [self addGestureRecognizer:longPress];
}

- (void)setDelegateObject:(YHTableViewDragDelegateObject *)delegateObject{
    objc_setAssociatedObject(self, @selector(delegateObject), delegateObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YHTableViewDragDelegateObject *)delegateObject{
    return objc_getAssociatedObject(self, _cmd);
}

@end

@implementation YHTableViewDragDelegateObject

// Mark - YHLongPressDragGestureDelegate
-(BOOL)yh_LongPressDragGestureRecognize: (CGPoint)point{
    self.dragingIndexPath = nil;
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
        if (CGRectContainsPoint([self.tableView cellForRowAtIndexPath:indexPath].frame, point)) {
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
        [self.tableView addSubview:self.ivDrag];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.dragingIndexPath];
        self.ivDrag.frame = cell.frame;
        self.startPoint = point;
        self.startCenter = self.ivDrag.center;
        
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
    CGPoint offset = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    self.ivDrag.center = CGPointMake(self.startCenter.x + offset.x, self.startCenter.y + offset.y);
    
    self.targetIndexPath = nil;
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
        //如果是自己不需要排序
        if ([indexPath isEqual:self.dragingIndexPath]) {continue;}
        //在第一组中找出将被替换位置的Item
        if (CGRectContainsPoint([self.tableView cellForRowAtIndexPath:indexPath].frame, point)) {
            self.targetIndexPath = indexPath;
        }
    }
    if (self.targetIndexPath) {
        //交换位置 如果没有找到self.targetIndexPath则不交换位置
        if (self.dragingIndexPath && self.targetIndexPath) {
            //isDragMoveItemBlock用于更新数据源并返回YES
            if (self.isDragMoveItemBlock && self.isDragMoveItemBlock(self.dragingIndexPath, self.targetIndexPath)) {
                //更新item位置
                [self.tableView moveRowAtIndexPath:self.dragingIndexPath toIndexPath:self.targetIndexPath];
                self.dragingIndexPath = self.targetIndexPath;
                
                [self.tableView bringSubviewToFront:self.ivDrag];
            }
        }
    }
}

-(void)yh_LongPressDragGestureEnd{
    if (!self.dragingIndexPath) {return;}
    [self.tableView cellForRowAtIndexPath:self.dragingIndexPath].contentView.alpha = 1;
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
