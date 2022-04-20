//
//  YHTableViewDemoCell.m
//  YHLongPressDragSort_Example
//
//  Created by chenyehong on 2022/4/20.
//  Copyright © 2022 ye_linux@126.com. All rights reserved.
//

#import "YHTableViewDemoCell.h"
#import "MovItemView.h"

@implementation YHTableViewDemoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        
        YHDragSortGridView *view = [[YHDragSortGridView alloc] init];
        view.yh_enableDragAnim = YES;
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero);
        }];
        
        [view setViews:[self createSubItemViews] colNum:5 itemSpacing:1 itemHeight:50 lineSpacing:1 edgeInsets:UIEdgeInsetsZero];
        
        UILabel *lb = UILabel.new;
        lb.textColor = UIColor.blackColor;
        [self.contentView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.offset(0);
        }];
        _lb = lb;
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
    [models addObject:@"5"];
    [models addObject:@"6"];
    NSMutableArray *views = NSMutableArray.new;
    [models enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        MovItemView *itemView = [[MovItemView alloc] init];
        itemView.lb.text = str;
        [views addObject:itemView];
    }];
    return views;
}

@end
