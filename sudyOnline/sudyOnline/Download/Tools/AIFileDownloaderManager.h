//
//  AIFileDownloaderManager.h
//  obdDownloader
//
//  Created by andylau on 16/1/18.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIFileDownloaderManager : NSObject

+ (instancetype)sharedDownloaderManager;

- (void)downloadWithURL:(NSURL *)url progress:(void (^)(float progress))progress completion:(void (^)(NSString *filePath))completion failed:(void (^)(NSString *errorMessage))failed;

- (void)pauseWithURL:(NSURL *)url;
@end
