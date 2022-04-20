//
//  YHCollectionDemoVC.m
//  YHLongPressDragSort_Example
//
//  Created by chenyehong on 2022/4/20.
//  Copyright © 2022 ye_linux@126.com. All rights reserved.
//

#import "YHCollectionDemoVC.h"
#import "YHCollectionDemoCell.h"

@interface YHCollectionDemoVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation YHCollectionDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"CollectionView长按排序";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(160, 160);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.minimumLineSpacing = 8;
    flowLayout.minimumInteritemSpacing = 8;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[YHCollectionDemoCell class] forCellWithReuseIdentifier:NSStringFromClass([YHCollectionDemoCell class])];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    [self.collectionView yh_enableLongPressDrag:^BOOL(NSIndexPath * _Nonnull indexPath) {
        return indexPath.row != 0;
    } isDragMoveItem:^BOOL(NSIndexPath * _Nonnull from, NSIndexPath * _Nonnull to) {
        if (to.row != 0) {
            //更新数据源
            id obj = [self.models objectAtIndex:from.row];
            [self.models removeObject:obj];
            [self.models insertObject:obj atIndex:to.row];
            return YES;
        }
        return NO;
    }];
}

// Mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YHCollectionDemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YHCollectionDemoCell class]) forIndexPath:indexPath];
    cell.lb.text = [self.models objectAtIndex:indexPath.row];
    return cell;
}

// Mark - Getter
- (NSMutableArray *)models{
    if (_models == nil) {
        _models = NSMutableArray.new;
        for(int i = 0 ; i < 100 ; i++){
            [_models addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _models;
}

@end
