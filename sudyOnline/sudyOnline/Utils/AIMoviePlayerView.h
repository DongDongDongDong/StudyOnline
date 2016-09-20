//
//  AIMoviePlayerView.h
//  sudyOnline
//
//  Created by andylau on 16/3/5.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIMoviePlayerView : UIView
/** 播放指定URL的视频 */
- (void)playWithURL:(NSURL *)url;

/** 停止播放 */
- (void)stopPlayback;

/** 截取指定时间点的图像 */
- (void)caputreImageAtTime:(double)time completion:(void (^)(UIImage *image))completion;

@end
