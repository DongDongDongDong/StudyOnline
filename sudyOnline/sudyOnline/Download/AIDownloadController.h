//
//  AIDownloadController.h
//  sudyOnline
//
//  Created by andylau on 16/3/1.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIDownloadController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *obdListTable;


/** 下载中NO  已下载YES */
@property (nonatomic, assign) BOOL isDownloaded;


/** 下载中列表数据 */
@property (nonatomic, strong) NSMutableArray *downListArray;


/** 已下载列表数据 */
@property (nonatomic, strong) NSMutableArray *downloadedListArray;


+ (AIDownloadController *)shareDownloadManager;

- (void)downloadAllTask;
@end
