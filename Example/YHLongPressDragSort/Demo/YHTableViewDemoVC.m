//
//  YHTableViewDemoVC.m
//  YHLongPressDragSort_Example
//
//  Created by chenyehong on 2022/4/20.
//  Copyright © 2022 ye_linux@126.com. All rights reserved.
//

#import "YHTableViewDemoVC.h"
#import "YHTableViewDemoCell.h"

@interface YHTableViewDemoVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation YHTableViewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"UITableView长按排序";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 120;
    [tableView registerClass:[YHTableViewDemoCell class] forCellReuseIdentifier:NSStringFromClass([YHTableViewDemoCell class])];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    _tableView = tableView;
    
    __weak typeof(self)weakSelf = self;
    [self.tableView yh_enableLongPressDrag:^BOOL(NSIndexPath * _Nonnull indexPath) {
        return indexPath.row != 0;
    } isDragMoveItem:^BOOL(NSIndexPath * _Nonnull from, NSIndexPath * _Nonnull to) {
        if (to.row != 0) {
            //更新数据源
            id obj = [weakSelf.models objectAtIndex:from.row];
            [weakSelf.models removeObject:obj];
            [weakSelf.models insertObject:obj atIndex:to.row];
            return YES;//允许交换位置
        }
        return NO;
    }];
}

// Mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHTableViewDemoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YHTableViewDemoCell class]) forIndexPath:indexPath];
    cell.lb.text = [self.models objectAtIndex:indexPath.row];
    return cell;
}

// Mark - Getter
- (NSMutableArray *)models{
    if (_models == nil) {
        _models = NSMutableArray.new;
        [_models addObject:@"此cell不可排"];
        for(int i = 0 ; i < 99 ; i++){
            [_models addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _models;
}

@end
