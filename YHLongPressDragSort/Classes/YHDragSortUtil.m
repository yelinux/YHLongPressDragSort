//
//  YHDragSortUtil.m
//  YHLongPressDragSort
//
//  Created by chenyehong on 2022/4/21.
//

#import "YHDragSortUtil.h"

@implementation YHDragSortUtil

+ (CAKeyframeAnimation *)createDragAnim{
    CGFloat (^angle2radian)(int x) = ^(int x){
        return ((x)/180.0*M_PI);
    };
    CAKeyframeAnimation *dragAnim = [CAKeyframeAnimation animation];
    dragAnim.keyPath = @"transform.rotation";
    dragAnim.values = @[@(angle2radian(-5)),@(angle2radian(5)),@(angle2radian(-5))];
    dragAnim.repeatCount = MAXFLOAT;
    dragAnim.duration = 0.5;
    return dragAnim;
}

@end
