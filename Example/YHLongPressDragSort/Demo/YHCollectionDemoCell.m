//
//  YHCollectionDemoCell.m
//  YHLongPressDragSort_Example
//
//  Created by chenyehong on 2022/4/20.
//  Copyright © 2022 ye_linux@126.com. All rights reserved.
//

#import "YHCollectionDemoCell.h"
#import "MovItemView.h"

@implementation YHCollectionDemoCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        
        YHDragSortGridView *view = [[YHDragSortGridView alloc] init];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero);
        }];
        
        [view setViews:[self createSubItemViews] colNum:2 itemSpacing:1 itemHeight:50 lineSpacing:1 edgeInsets:UIEdgeInsetsZero];
    }
    return self;
}

- (NSArray<UIView *> *)createSubItemViews{
    NSMutableArray *models = NSMutableArray.new;
    [models addObject:@"0"];
    [models addObject:@"1"];
    [models addObject:@"2"];
    [models addObject:@"3"];
    [models addObject:@"4"];
    NSMutableArray *views = NSMutableArray.new;
    [models enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        MovItemView *itemView = [[MovItemView alloc] init];
        itemView.lb.text = str;
        [views addObject:itemView];
    }];
    return views;
}

@end
