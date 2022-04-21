//
//  YHNestLongPressDragSortVC.m
//  YHLongPressDragSort_Example
//
//  Created by chenyehong on 2022/4/20.
//  Copyright © 2022 ye_linux@126.com. All rights reserved.
//

#import "YHNestLongPressDragSortVC.h"
#import "MovItemView.h"

@interface YHNestLongPressDragSortVC ()

@end

@implementation YHNestLongPressDragSortVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"嵌套自定义View长按拖动排序";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 10;
    [scrollView addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
        make.width.mas_equalTo(scrollView.mas_width);
    }];
    
    YHDragSortGridView *(^createSubGridViewBlock)(void) = ^{
        YHDragSortGridView *view = [[YHDragSortGridView alloc] init];
        view.yh_enableDragAnim = YES;
        view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];;
        [view setViews:[self createSubItemViews2] colNum:2 itemSpacing:2 itemHeight:50 lineSpacing:2 edgeInsets:UIEdgeInsetsZero];
        return view;
    };
    
    void(^addStackSubBlock)(void) = ^{
        YHDragSortGridView *view = [[YHDragSortGridView alloc] init];
        view.yh_enableDragAnim = YES;
        [stackView addArrangedSubview:view];
        [view setViews:@[createSubGridViewBlock(), createSubGridViewBlock(),createSubGridViewBlock(), createSubGridViewBlock(), createSubGridViewBlock()] colNum:3 itemSpacing:8 itemHeight:102 lineSpacing:8 edgeInsets:UIEdgeInsetsZero];
    };
    
    addStackSubBlock();
}

- (NSArray<UIView *> *)createSubItemViews2{
    NSMutableArray *models = NSMutableArray.new;
    [models addObject:@"0"];
    [models addObject:@"1"];
    [models addObject:@"2"];
    NSMutableArray *views = NSMutableArray.new;
    [models enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        MovItemView *itemView = [[MovItemView alloc] init];
        itemView.lb.text = str;
        [views addObject:itemView];
    }];
    return views;
}

@end
