//
//  MyTextField.m
//  CheckAuto3-0
//
//  Created by 魏瑞东 on 15/6/15.
//  Copyright (c) 2015年 youxinpai. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;// 右偏10
    return iconRect;
}
@end
