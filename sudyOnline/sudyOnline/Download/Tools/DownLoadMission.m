//
//  DownLoadTask.m
//  obdDownloader
//
//  Created by andylau on 16/1/25.
//  Copyright © 2016年 andylau. All rights reserved.
//

typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_2G= 1,
    NETWORK_TYPE_3G= 2,
    NETWORK_TYPE_4G= 3,
    NETWORK_TYPE_5G= 4,//  5G目前为猜测结果
    NETWORK_TYPE_WIFI= 5,
}NETWORK_TYPE;


#import "DownLoadMission.h"
#import "AIFileDownloaderManager.h"
#import "DownListModel.h"
#import <AVFoundation/AVFoundation.h>

@interface DownLoadMission ()<AVAudioPlayerDelegate>
@property (nonatomic, strong)AVAudioPlayer *audioPlayer;
@end

@implementation DownLoadMission

- (void)changeValueText:(downloadProgressBlock)progressBlock{
    self.progressBlock = progressBlock;
}
- (void)didFinishDownload:(downloadFinishBlock)finishBlock{
    self.finishBlock = finishBlock;
}


- (instancetype)initWithUID:(NSString *)uid
{
    self = [super init];
    
    if (self) {
        self.UID = uid;        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSLog(@"Only Once Init");
        });
    }
    
    return self;
}



- (void)download{
    [self beginDownload:self.model.downloadUrl];
}

- (void)pause{
    [self pauseWithUrl:self.model.downloadUrl];
}


- (void)pauseWithUrl:(NSString *)url{
    AIFileDownloaderManager *manager = [AIFileDownloaderManager sharedDownloaderManager];
    [manager pauseWithURL:[NSURL URLWithString:url]];
}

- (void)beginDownload:(NSString *)url{
    AIFileDownloaderManager *manager = [AIFileDownloaderManager sharedDownloaderManager];
    NSLog(@"开始下载 %@",url);
    __block typeof(self) weakSelf = self;
    [manager downloadWithURL:[NSURL URLWithString:url] progress:^(float progress) {
        
//        NSLog(@"下载中%@－－－> %f",weakSelf.model.brandName,progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.progressBlock) {
                self.progressBlock(progress,weakSelf.model);
            }
        });
        
    } completion:^(NSString *filePath) {
        NSLog(@"下载完成 %@",weakSelf.model.downloadUrl);
        weakSelf.model.destinationUrl = filePath;
        if (self.finishBlock) {
            self.finishBlock(weakSelf.model);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_FINISH_UPLOAD_TASK" object:self userInfo:@{@"uid":weakSelf.UID}];

    } failed:^(NSString *errorMessage) {
        NSLog(@"下载错误 %@",self.model.downloadUrl);
    }];
}

#pragma mark fakeAudio


- (void)fakeAudio
{
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^(void) {
        NSError *audioSessionError = nil;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession setCategory:AVAudioSessionCategoryPlayback error:&audioSessionError]){
            NSLog(@"Successfully set the audio session.");
        } else {
            NSLog(@"Could not set the audio session");
        }
        
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *filePath = [mainBundle pathForResource:@"mySong" ofType:@"mp3"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
        if (self.audioPlayer != nil){
            self.audioPlayer.delegate = self;
            [self.audioPlayer setNumberOfLoops:-1];
            if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]){
                NSLog(@"Successfully started playing...");
            } else {
                NSLog(@"Failed to play.");
            }
        } else {
            NSLog(@"Player is nil.");
        }
    });
    
}

#pragma mark -netWorkType

-(NETWORK_TYPE)getNetworkTypeFromStatusBar {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])     {
            dataNetworkItemView = subview;
            break;
        }
    }
    NETWORK_TYPE nettype = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    nettype = [num intValue];
    return nettype;
}

@end
