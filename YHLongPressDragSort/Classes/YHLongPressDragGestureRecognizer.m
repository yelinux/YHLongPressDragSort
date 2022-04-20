//
//  MovLongPressGestureRecognizer.m
//  UIKitPreviewNote
//
//  Created by chenyehong on 2022/4/19.
//

#import "YHLongPressDragGestureRecognizer.h"
#import "YHDragSortBaseView.h"

@interface YHLongPressDragGestureRecognizer()

@property (nonatomic, assign) CGPoint touchBeginPoint;

@end

@implementation YHLongPressDragGestureRecognizer

-(instancetype)init{
    if (self = [super initWithTarget:self action:@selector(longPress:)]) {

    }
    return self;
}

- (void)longPress: (UILongPressGestureRecognizer*)sender{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            [self.movDelegate yh_LongPressDragGestureBegin:self.touchBeginPoint];
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint point = [sender locationInView:self.view];
            [self.movDelegate yh_LongPressDragGestureMove:point];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            if (!CGPointEqualToPoint(self.touchBeginPoint, CGPointZero)) {
                [self.movDelegate yh_LongPressDragGestureEnd];
            }
            break;
        default:
            break;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    
    self.touchBeginPoint = point;
    if ([self.movDelegate yh_LongPressDragGestureRecognize:point]) {
        [super touchesBegan:touches withEvent:event];
    }
}

@end
