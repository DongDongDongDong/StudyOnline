//
//  AIFileDownloader.h
//  obdDownloader
//
//  Created by andylau on 16/1/17.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIFileDownloader : NSObject

- (void)downloadWithURL:(NSURL *)url progress:(void (^)(float progress))progress completion:(void (^)(NSString *filePath))completion failed:(void (^)(NSString *errorMessage))failed;

- (void)pause;
@end
