//
//  AIMoviePlayerView.m
//  sudyOnline
//
//  Created by andylau on 16/3/5.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AIMoviePlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
@interface AIMoviePlayerView()
/** 视频播放器 */
@property (nonatomic, strong) MPMoviePlayerController *player;
/** 播放完成后显示的图像 */
@property (nonatomic, weak) UIImageView *imageView;

/** 截图完成块代码 */
@property (nonatomic, copy) void (^captureCompletion) (UIImage *);
@end

@implementation AIMoviePlayerView

- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:self.bounds];
        
        // 把图像视图插入到最底层
        [self insertSubview:iv atIndex:0];
        
        _imageView = iv;
    }
    return _imageView;
}

- (MPMoviePlayerController *)player {
    if (_player == nil) {
        _player = [[MPMoviePlayerController alloc] init];
    }
    return _player;
}

#pragma mark - 播放相关控制代码
/** 添加监听 */
- (void)setupNotification {
    // 监听播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    // 监听屏幕截图通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
}

- (void)captureFinished:(NSNotification *)notification {
    NSLog(@"截图完成 %@", notification);
    
    UIImage *image = notification.userInfo[MPMoviePlayerThumbnailImageKey];
    
    if (self.captureCompletion) {
        self.captureCompletion(image);
    }
    
    self.imageView.image = image;
}

- (void)playbackFinished {
    NSLog(@"播放完成");
    
    // 如果是全屏播放完成，退回全屏
    if (self.player.isFullscreen) {
        [self.player setFullscreen:NO animated:YES];
    }
    
    // 把播放器的视图从屏幕上删除
    [self.player.view removeFromSuperview];
    
    // 删除通知中心
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 公共方法
- (void)playWithURL:(NSURL *)url {
    self.player.contentURL = url;
    
    // 将播放器的视图添加到movieView中
    self.player.view.frame = self.bounds;
    [self addSubview:self.player.view];
    
    // 设置通知
    [self setupNotification];
    
    // 播放
    [self.player play];
}


- (void)stopPlayback {
    [self.player stop];
}

- (void)caputreImageAtTime:(double)time completion:(void (^)(UIImage *image))completion {
    // 在此方法中，completion不需要执行
    // 需要定义一个属性，记录住completion的块代码，然后在需要的时候执行
    self.captureCompletion = completion;
    
    [self.player requestThumbnailImagesAtTimes:@[@(time)] timeOption:MPMovieTimeOptionNearestKeyFrame];
}

@end
