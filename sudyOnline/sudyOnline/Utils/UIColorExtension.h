//
//  UIColorExtension.h
//  ROVI
//
//  Created by LiYun Qiao on 12-4-9.
//  Copyright (c) 2012 Toshiba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (UIColorExtension)

/**
 * Constuctor color from HEX.
 * 
 * @param stringToConvert  the HEX to parse
 *
 * @return the UIColor after being parsed
 */
+ (UIColor *) colorWithHex:(UInt64)hex;

+ (UIColor *) colorWithHex2:(UInt64)hex;

/**
 * Constuctor color from HEX string.
 * 
 * @param stringToConvert  the string to parse
 *
 * @return the UIColor after being parsed
 */
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

@end
