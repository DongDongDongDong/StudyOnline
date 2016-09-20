//
//  AIFileDownloader.m
//  obdDownloader
//
//  Created by andylau on 16/1/17.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AIFileDownloader.h"



// 网络访问超时时长
#define kTimeOut    20.0


@interface AIFileDownloader() <NSURLConnectionDataDelegate>

/** 下载文件的 URL */
@property (nonatomic, strong) NSURL *downloadURL;
/** 下载的连接 */
@property (nonatomic, strong) NSURLConnection *downloadConnection;

/** 文件总大小 */
@property (nonatomic, assign) long long expectedContentLength;
/** 本地文件当前大小 */
@property (nonatomic, assign) long long currentLength;

/** 文件保存在本地的路径 */
@property (nonatomic, copy) NSString *filePath;

/** 文件输出流 */
@property (nonatomic, strong) NSOutputStream *fileStrem;

/** 下载的运行循环 */
@property (nonatomic, assign) CFRunLoopRef downloadRunloop;

@property (nonatomic, copy) void (^progressBlock)(float);
@property (nonatomic, copy) void (^completionBlock)(NSString *);
@property (nonatomic, copy) void (^failedBlock)(NSString *);

@end

@implementation AIFileDownloader


- (void)downloadWithURL:(NSURL *)url progress:(void (^)(float))progress completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed {
    
    self.downloadURL = url;
    self.progressBlock = progress;
    self.completionBlock = completion;
    self.failedBlock = failed;
    
    [self serverFileInfoWithURL:url];
    
    NSLog(@"%lld %@", self.expectedContentLength, self.filePath);
    
    if (![self checkLocalFileInfo]) {
        if (completion) {
            completion(self.filePath);
        }
        return;
    };
    
    NSLog(@"需要下载文件，从 %lld开始继续下载", self.currentLength);
    [self downloadFile];
}

- (void)pause {
    // 取消当前的连接
    [self.downloadConnection cancel];
}

#pragma mark - 下载文件
- (void)downloadFile {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.downloadURL cachePolicy:1 timeoutInterval:kTimeOut];
        NSString *rangeStr = [NSString stringWithFormat:@"bytes=%lld-", self.currentLength];
        [request setValue:rangeStr forHTTPHeaderField:@"Range"];
        
        self.downloadConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        [self.downloadConnection start];
        
        self.downloadRunloop = CFRunLoopGetCurrent();
        CFRunLoopRun();
    });
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//   BOOL iscreat = [[NSFileManager defaultManager] createFileAtPath:self.filePath
//                                            contents:@"" attributes:nil];
//    NSLog(@"是否创建成功%d",iscreat);
    self.fileStrem = [[NSOutputStream alloc] initToFileAtPath:self.filePath append:YES];
    [self.fileStrem open];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.fileStrem write:data.bytes maxLength:data.length];
    
    self.currentLength += data.length;
    float progress = (float)self.currentLength / self.expectedContentLength;
    
    if (self.progressBlock) {
        self.progressBlock(progress);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.fileStrem close];
    
    CFRunLoopStop(self.downloadRunloop);
    
    if (self.completionBlock) {
        dispatch_async(dispatch_get_main_queue(), ^ {
            self.completionBlock(self.filePath);
        });
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.fileStrem close];
    CFRunLoopStop(self.downloadRunloop);
    
    NSLog(@"出现错误%@", error.localizedDescription);
    
    if (self.failedBlock) {
        self.failedBlock(error.localizedDescription);
    }
}

#pragma mark - 私有方法

- (BOOL)checkLocalFileInfo {
    
    long long fileSize = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.filePath error:NULL];
        fileSize = [attributes fileSize];
    }
    

    if (fileSize > self.expectedContentLength) {
        [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:NULL];
        fileSize = 0;
    }
    
    self.currentLength = fileSize;
    if (fileSize == self.expectedContentLength) {
        return NO;
    }
    return YES;
}

- (void)serverFileInfoWithURL:(NSURL *)url {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:kTimeOut];
    request.HTTPMethod = @"HEAD";
    
    NSURLResponse *response = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    self.expectedContentLength = response.expectedContentLength;
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    self.filePath = [filePath stringByAppendingPathComponent:response.suggestedFilename];
    
    return;
}

@end
