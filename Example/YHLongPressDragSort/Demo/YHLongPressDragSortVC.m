//
//  YHLongPressDragSortVC.m
//  YHLongPressDragSort_Example
//
//  Created by chenyehong on 2022/4/20.
//  Copyright © 2022 ye_linux@126.com. All rights reserved.
//

#import "YHLongPressDragSortVC.h"
#import "MovItemView.h"

@interface YHLongPressDragSortVC ()

@end

@implementation YHLongPressDragSortVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"长按拖动排序";
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
    
    YHDragSortGridView *view = [[YHDragSortGridView alloc] init];
    [stackView addArrangedSubview:view];
    
    [view setViews:[self createSubItemViews] colNum:5 itemSpacing:8 itemHeight:50 lineSpacing:8 edgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}

- (NSArray<UIView *> *)createSubItemViews{
    NSMutableArray *models = NSMutableArray.new;
    [models addObject:@"0不可排"];
    [models addObject:@"1"];
    [models addObject:@"2"];
    [models addObject:@"3"];
    [models addObject:@"4"];
    [models addObject:@"5"];
    [models addObject:@"6"];
    [models addObject:@"7"];
    [models addObject:@"8"];
    NSMutableArray *views = NSMutableArray.new;
    [models enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        MovItemView *itemView = [[MovItemView alloc] init];
        itemView.lb.text = str;
        itemView.yh_longPressDragDisable = (idx == 0);//可以设置某view不能排序
        [views addObject:itemView];
    }];
    return views;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
