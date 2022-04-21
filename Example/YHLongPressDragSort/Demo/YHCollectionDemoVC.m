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

@property (nonatomic, strong) CAKeyframeAnimation *dragAnim;

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
    
    __weak typeof(self)weakSelf = self;
    // 启用长按拖动排序
    [self.collectionView yh_enableLongPressDrag:^BOOL(NSIndexPath * _Nonnull indexPath, CGPoint pressPoint) {
        // 哪些cell可以长按拖动排序
        return indexPath.row != 0;
    } isDragBeginBlock:^(NSIndexPath * _Nonnull indexPath) {
        // 开始拖动，启用自定义动画
        for (NSIndexPath *ixPath in [weakSelf.collectionView indexPathsForVisibleItems]){
            if (ixPath.row != 0) {
                UICollectionViewCell *cell = [weakSelf.collectionView cellForItemAtIndexPath:ixPath];
                [cell.contentView.layer addAnimation:weakSelf.dragAnim forKey:nil];
            }
        }
    } isDragMoveItem:^BOOL(NSIndexPath * _Nonnull from, NSIndexPath * _Nonnull to) {
        // 拖动到某位置是否确定插入排序
        if (to.row != 0) {
            //更新数据源
            id obj = [weakSelf.models objectAtIndex:from.row];
            [weakSelf.models removeObject:obj];
            [weakSelf.models insertObject:obj atIndex:to.row];
            return YES;//允许插入排序
        }
        return NO;//不允许插入排序
    } dragEndBlock:^{
        // 拖动结束，关闭自定义动画
        for (NSIndexPath *ixPath in [weakSelf.collectionView indexPathsForVisibleItems]){
            if (ixPath.row != 0) {
                UICollectionViewCell *cell = [weakSelf.collectionView cellForItemAtIndexPath:ixPath];
                [cell.contentView.layer removeAllAnimations];
            }
        }
    }];
}

// Mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YHCollectionDemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YHCollectionDemoCell class]) forIndexPath:indexPath];
    cell.lb.text = [self.models objectAtIndex:indexPath.row];
    if (!self.nested) {
        cell.gridView.hidden = YES;
        cell.contentView.backgroundColor = [UIColor colorWithHue:( arc4random() % 256 / 256.0 ) saturation:( arc4random() % 128 / 256.0 ) + 0.5 brightness:( arc4random() % 128 / 256.0 ) + 0.5 alpha:1];
    }
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

- (CAKeyframeAnimation *)dragAnim{
    if (_dragAnim == nil) {
        _dragAnim = [YHDragSortUtil createDragAnim];
    }
    return _dragAnim;
}

@end
