//
//  AIFileDownloaderManager.m
//  obdDownloader
//
//  Created by andylau on 16/1/18.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AIFileDownloaderManager.h"
#import "AIFileDownloader.h"

@interface AIFileDownloaderManager()
/** 下载操作缓冲池 */
@property (nonatomic, strong) NSMutableDictionary *downloaderCache;

/** 失败的回调属性 */
@property (nonatomic, copy) void (^failedBlock) (NSString *);
@end

@implementation AIFileDownloaderManager

+ (instancetype)sharedDownloaderManager {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSMutableDictionary *)downloaderCache {
    if (_downloaderCache == nil) {
        _downloaderCache = [[NSMutableDictionary alloc] init];
    }
    return _downloaderCache;
}

- (void)downloadWithURL:(NSURL *)url progress:(void (^)(float))progress completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed {
    
    self.failedBlock = failed;
    AIFileDownloader *downloader = self.downloaderCache[url.path];
    if (downloader != nil) {
        if (failed) {
            failed(@"下载操作已经存在，正在下载中....");
        }
        return;
    }
    
    downloader = [[AIFileDownloader alloc] init];
    if (url.path) {
        [self.downloaderCache setObject:downloader forKey:url.path];        
    }
    [downloader downloadWithURL:url progress:progress completion:^(NSString *filePath) {
        if (url.path) {
            [self.downloaderCache removeObjectForKey:url.path];
        }
        if (completion) {
            completion(filePath);
        }
    } failed:failed];
}

- (void)pauseWithURL:(NSURL *)url {
    AIFileDownloader *download = self.downloaderCache[url.path];
    
    if (download == nil) {
        if (self.failedBlock) {
            self.failedBlock(@"操作不存在，无需暂停");
        }
        return;
    }
    [download pause];
    
    if (url.path) {
        [self.downloaderCache removeObjectForKey:url.path];
    }
}

@end