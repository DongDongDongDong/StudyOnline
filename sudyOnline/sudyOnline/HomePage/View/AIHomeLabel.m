//
//  AIHomeLabel.m
//  MarkMan_New
//
//  Created by andylau on 16/1/15.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AIHomeLabel.h"

@implementation AIHomeLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:16];
        self.userInteractionEnabled = YES;
        self.scale = 0.0;
    }
    return self;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    // scale == 0.0 == blue == 0.0 0.0 1.0
    // scale == 1.0 == yellow == 1.0 1.0 0.0
    //                   red  == 1.0 0.0 0.0
    //                  black == 0.0 0.0 .0
    // 颜色渐变
//    self.textColor = [UIColor colorWithRed:1 - scale green:0.3 - scale blue:0.3 - scale alpha:1.0];
    
    // 大小渐变
    CGFloat minWhScale = 0.9; // [0.7, 1.0]
    CGFloat whScale = minWhScale + scale * (1 - minWhScale);
    self.transform = CGAffineTransformMakeScale(whScale, whScale);
}
@end
