//
//  DownListModel.h
//  obdDownloader
//
//  Created by andylau on 16/1/25.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DownListModel : NSObject

/** 车牌名 */
@property (nonatomic, copy) NSString *brandName;

/** 包大小 */
@property (nonatomic, copy) NSString *brandSize;

/** 包路径 */
@property (nonatomic, copy) NSString *downloadUrl;

/** 存放路径 */
@property (nonatomic, copy) NSString *destinationUrl;

/** 每组数据唯一标识 */
@property (nonatomic, copy) NSString *uniqueMark;

/** 当前下载进度 */
@property (nonatomic, assign) NSString *brandProgress;


@end
