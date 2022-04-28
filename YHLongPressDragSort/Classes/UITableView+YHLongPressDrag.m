//
//  UITableView+YHLongPressDrag.m
//  YHLongPressDragSort
//
//  Created by chenyehong on 2022/4/20.
//

#import "UITableView+YHLongPressDrag.h"
#import <objc/runtime.h>
#import "YHDragSortUtil.h"

@interface YHTableViewDragDelegateObject : NSObject<YHLongPressDragGestureDelegate>

@property (nonatomic, weak) UITableView *tableView;
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

@interface UITableView()

@property (nonatomic, strong) YHTableViewDragDelegateObject *delegateObject;

@end

@implementation UITableView (YHLongPressDrag)

- (void)yh_enableLongPressDrag: (YHIsDragRecognizeBlock)isDragRecognizeBlock
                isDragMoveItem: (YHIsDragMoveItemBlock)isDragMoveItemBlock{
    [self yh_enableLongPressDrag:isDragRecognizeBlock dragBeginBlock:nil isDragMoveItem:isDragMoveItemBlock dragEndBlock:nil];
}

- (void)yh_enableLongPressDrag: (YHIsDragRecognizeBlock)isDragRecognizeBlock
                dragBeginBlock: (nullable YHDragBeginBlock)dragBeginBlock
                isDragMoveItem: (YHIsDragMoveItemBlock)isDragMoveItemBlock
                  dragEndBlock: (nullable YHDragEndBlock)dragEndBlock{
    self.delegateObject = [[YHTableViewDragDelegateObject alloc] init];
    self.delegateObject.tableView = self;
    self.delegateObject.isDragRecognizeBlock = isDragRecognizeBlock;
    self.delegateObject.dragBeginBlock = dragBeginBlock;
    self.delegateObject.isDragMoveItemBlock = isDragMoveItemBlock;
    self.delegateObject.dragEndBlock = dragEndBlock;
    
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
        CGRect cellFrame = [self.tableView cellForRowAtIndexPath:indexPath].frame;
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
        [self.tableView addSubview:self.ivDrag];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.dragingIndexPath];
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
    CGRect endFrame = [self.tableView cellForRowAtIndexPath:self.dragingIndexPath].frame;
    [UIView animateWithDuration:0.2 animations:^{
        self.ivDrag.transform = CGAffineTransformIdentity;
        self.ivDrag.frame = endFrame;
    } completion:^(BOOL finished) {
        [self.ivDrag removeFromSuperview];
        [self.tableView cellForRowAtIndexPath:self.dragingIndexPath].contentView.alpha = self.tempAlpha;
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
