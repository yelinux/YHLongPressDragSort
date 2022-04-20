//
//  YHCollectionDemoVC.m
//  YHLongPressDragSort_Example
//
//  Created by chenyehong on 2022/4/20.
//  Copyright © 2022 ye_linux@126.com. All rights reserved.
//

#import "YHCollectionDemoVC.h"
#import "YHCollectionDemoCell.h"

@interface YHCollectionDemoVC ()<UICollectionViewDelegate, UICollectionViewDataSource, YHLongPressDragGestureDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIImageView *ivDrag;

@property (nonatomic, strong) NSIndexPath *dragingIndexPath;

@property (nonatomic, strong) NSIndexPath *targetIndexPath;

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
    
    YHLongPressDragGestureRecognizer *longPress = [[YHLongPressDragGestureRecognizer alloc] init];
    longPress.dragDelegate = self;
    [self.collectionView addGestureRecognizer:longPress];
}

// Mark - YHLongPressDragGestureDelegate
-(BOOL)yh_LongPressDragGestureRecognize: (CGPoint)point{
    self.dragingIndexPath = nil;
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        if (CGRectContainsPoint([self.collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            self.dragingIndexPath = indexPath;
            break;
        }
    }
    return self.dragingIndexPath != nil;
}

-(void)yh_LongPressDragGestureBegin: (CGPoint)point{
    if (self.dragingIndexPath) {
        [self.collectionView addSubview:self.ivDrag];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.dragingIndexPath];
        self.ivDrag.frame = cell.frame;
        
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
    self.ivDrag.center = point;
    
    self.targetIndexPath = nil;
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        //如果是自己不需要排序
        if ([indexPath isEqual:self.dragingIndexPath]) {continue;}
        //在第一组中找出将被替换位置的Item
        if (CGRectContainsPoint([self.collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            self.targetIndexPath = indexPath;
        }
    }
    if (self.targetIndexPath) {
        //交换位置 如果没有找到self.targetIndexPath则不交换位置
        if (self.dragingIndexPath && self.targetIndexPath) {
            //更新数据源
    //        [self rearrangeInUseTitles];
            //更新item位置
            [self.collectionView moveItemAtIndexPath:self.dragingIndexPath toIndexPath:self.targetIndexPath];
            self.dragingIndexPath = self.targetIndexPath;
            
            [self.collectionView bringSubviewToFront:self.ivDrag];
        }
    }
}

-(void)yh_LongPressDragGestureEnd{
    if (!self.dragingIndexPath) {return;}
    [self.collectionView cellForItemAtIndexPath:self.dragingIndexPath].contentView.alpha = 1;
    self.ivDrag.transform = CGAffineTransformIdentity;
    [self.ivDrag removeFromSuperview];
}

// Mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YHCollectionDemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YHCollectionDemoCell class]) forIndexPath:indexPath];
    return cell;
}

// Mark - Getter
- (UIImageView *)ivDrag{
    if (_ivDrag == nil) {
        _ivDrag = [[UIImageView alloc] init];
    }
    return _ivDrag;
}

@end
