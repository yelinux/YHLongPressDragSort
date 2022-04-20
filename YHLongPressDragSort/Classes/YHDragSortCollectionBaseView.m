//
//  YHDragSortCollectionBaseView.m
//  YHLongPressDragSort
//
//  Created by chenyehong on 2022/4/20.
//

#import "YHDragSortCollectionBaseView.h"

@interface YHDragSortCollectionBaseView()

@property (nonatomic, strong) UIImageView *ivDrag;
@property (nonatomic, strong) NSIndexPath *dragingIndexPath;
@property (nonatomic, strong) NSIndexPath *targetIndexPath;

@end

@implementation YHDragSortCollectionBaseView


// Mark - Getter
- (UIImageView *)ivDrag{
    if (_ivDrag == nil) {
        _ivDrag = [[UIImageView alloc] init];
    }
    return _ivDrag;
}

@end
