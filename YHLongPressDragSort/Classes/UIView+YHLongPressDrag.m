//
//  UIView+YHLongPressDrag.m
//  UIKitPreviewNote
//
//  Created by chenyehong on 2022/4/20.
//

#import "UIView+YHLongPressDrag.h"
#import <objc/runtime.h>

@implementation UIView (YHLongPressDrag)

- (BOOL)yh_longPressDragDisable{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setYh_longPressDragDisable:(BOOL)yh_longPressDragDisable{
    objc_setAssociatedObject(self, @selector(yh_longPressDragDisable), @(yh_longPressDragDisable), OBJC_ASSOCIATION_ASSIGN);
}

@end
