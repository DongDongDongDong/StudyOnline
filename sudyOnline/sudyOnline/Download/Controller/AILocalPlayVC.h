//
//  AILocalPlayVC.h
//  studyOnline
//
//  Created by andylau on 16/3/11.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AILocalPlayVC : UIViewController

/** 视频URL */
@property (nonatomic, copy) NSString *movieUrl;



/** 停止播放 */
- (void)stopPlayback;


@end
