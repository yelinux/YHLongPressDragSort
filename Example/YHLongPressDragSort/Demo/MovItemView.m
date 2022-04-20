//
//  MovItemView.m
//  UIKitPreviewNote
//
//  Created by chenyehong on 2022/4/19.
//

#import "MovItemView.h"

@interface MovItemView()

@end

@implementation MovItemView

- (instancetype)init{
    if (self = [super init]) {
        UILabel *lb = UILabel.new;
        lb.backgroundColor = [UIColor colorWithHue:( arc4random() % 256 / 256.0 ) saturation:( arc4random() % 128 / 256.0 ) + 0.5 brightness:( arc4random() % 128 / 256.0 ) + 0.5 alpha:1];
        lb.text = [NSString stringWithFormat:@"%u", arc4random() % 256];
        lb.numberOfLines = 0;
        [self addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero);
        }];
        _lb = lb;
    }
    return self;
}

@end
