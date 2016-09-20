//
//  AIPlayerController.h
//  sudyOnline
//
//  Created by andylau on 16/3/6.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIPlayerController : UIViewController


@property (nonatomic, strong) NSDictionary *allDict;

/** course 或 home */
@property (nonatomic, copy) NSString *fromType;


/** 播放第几集 */
@property (nonatomic, assign) NSInteger currentNum;


- (void)beginPlay;


@end
