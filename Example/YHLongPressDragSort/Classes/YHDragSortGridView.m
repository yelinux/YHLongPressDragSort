//
//  YHDragSortGridView.m
//  UIKitPreviewNote
//
//  Created by chenyehong on 2022/4/19.
//

#import "YHDragSortGridView.h"

@interface YHDragSortGridView()

@property (nonatomic, assign) NSInteger colNum;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

@implementation YHDragSortGridView

-(void)setViews: (NSArray<UIView*>*)views
         colNum: (NSInteger)colNum
    itemSpacing: (CGFloat)itemSpacing
     itemHeight: (CGFloat)itemHeight
    lineSpacing: (CGFloat)lineSpacing
     edgeInsets: (UIEdgeInsets)edgeInsets{
    [self setViews:views colNum:colNum itemWidth:0 itemSpacing:itemSpacing itemHeight:itemHeight lineSpacing:lineSpacing edgeInsets:edgeInsets];
}

-(void)setViews: (NSArray<UIView*>*)views
         colNum: (NSInteger)colNum
      itemWidth: (CGFloat)itemWidth
     itemHeight: (CGFloat)itemHeight
    lineSpacing: (CGFloat)lineSpacing
     edgeInsets: (UIEdgeInsets)edgeInsets{
    [self setViews:views colNum:colNum itemWidth:itemWidth itemSpacing:0 itemHeight:itemHeight lineSpacing:lineSpacing edgeInsets:edgeInsets];
}

-(void)setViews: (NSArray<UIView*>*)views
         colNum: (NSInteger)colNum
      itemWidth: (CGFloat)itemWidth
    itemSpacing: (CGFloat)itemSpacing
     itemHeight: (CGFloat)itemHeight
    lineSpacing: (CGFloat)lineSpacing
     edgeInsets: (UIEdgeInsets)edgeInsets{
    [self.subItemViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *subItemViews = [NSMutableArray arrayWithArray:views];
    if (subItemViews.count % colNum > 0) {
        NSInteger count = colNum - (subItemViews.count % colNum);
        for(int i = 0 ; i < count; i++){
            UIView *itemView = [[UIView alloc] init];
            itemView.alpha = 0;
            [subItemViews addObject:itemView];
        }
    }
    self.subItemViews = subItemViews;
    
    _colNum = colNum;
    _itemWidth = itemWidth;
    _itemSpacing = itemSpacing;
    _itemHeight = itemHeight;
    _lineSpacing = lineSpacing;
    _edgeInsets = edgeInsets;
    
    [self.subItemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:view];
    }];
    
    [self refreshSubItemPosition];
}

-(void)refreshSubItemPosition{
    [self.subItemViews mas_remakeConstraints:^(MASConstraintMaker *make) {
            
    }];
    NSMutableArray *arrayOfArrays = [NSMutableArray array];
    NSUInteger count = self.subItemViews.count;
    int j = 0;
    while(count) {
        NSRange range = NSMakeRange(j, MIN(_colNum, count));
        NSArray *subArr = [self.subItemViews subarrayWithRange:range];
        [arrayOfArrays addObject:subArr];
        count -= range.length;
        j += range.length;
    }
    __block UIView *perView = nil;
    [arrayOfArrays enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.itemWidth > 0) {
            [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:self.itemWidth leadSpacing:self.edgeInsets.left tailSpacing:self.edgeInsets.right];
        } else {
            [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:self.itemSpacing leadSpacing:self.edgeInsets.left tailSpacing:self.edgeInsets.right];
        }
        [array mas_makeConstraints:^(MASConstraintMaker *make) {
            perView?make.top.mas_equalTo(perView.mas_bottom).offset(self.lineSpacing):make.top.offset(self.edgeInsets.top);
            make.height.mas_equalTo(self.itemHeight);
        }];
        perView = array.lastObject;
    }];
    [self.subItemViews.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-self.edgeInsets.bottom);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}


@end
