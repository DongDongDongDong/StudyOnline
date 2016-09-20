//
//  AILoginViewController.h
//  sudyOnline
//
//  Created by andylau on 16/3/7.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AILoginViewController : UIViewController

typedef void(^loginBlock)(NSString *changeUerName);
@property (nonatomic, copy) loginBlock myBlock;
- (void)changeValueText:(loginBlock)myblock;

@end
