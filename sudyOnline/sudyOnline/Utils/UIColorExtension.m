//
//  UIColorExtension.m
//  ROVI
//
//  Created by LiYun Qiao on 12-4-9.
//  Copyright (c) 2012 Toshiba. All rights reserved.
//

#import "UIColorExtension.h"

@implementation UIColor (UIColorExtension)

+ (UIColor *) colorWithHex:(UInt64)hex
{
    // Scan values
    unsigned int r = (hex >> 16) & 0XFF;
    unsigned int g = (hex >> 8) & 0XFF;
    unsigned int b = (hex >> 0) & 0XFF;
    if (r == 0 && g == 0 && b == 0)
    {
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:0.0f];
    }
    else
    {
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
    }
}

+ (UIColor *) colorWithHex2:(UInt64)hex
{
    // Scan values
    unsigned int r = (hex >> 16) & 0XFF;
    unsigned int g = (hex >> 8) & 0XFF;
    unsigned int b = (hex >> 0) & 0XFF;
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
    
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    if(nil == stringToConvert || [stringToConvert length] == 0)
    {
        return [UIColor blackColor];
    }
    
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor blackColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    
    if ([cString length] != 6)
    {
        return [UIColor blackColor];
    }
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (r == 0 && g == 0 && b == 0)
    {
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:0.0f];
    }
    else
    {
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:1.0f];
    }
}

@end
