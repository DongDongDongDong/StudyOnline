//
//  DownListCell.m
//  obdDownloader
//
//  Created by andylau on 16/1/25.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "DownListCell.h"
#import "AIFileDownloaderManager.h"
#import "DownLoadMission.h"
#import "DownloadMissionList.h"
#import "AIFileDownloaderManager.h"

@interface DownListCell ()
@property (weak, nonatomic) IBOutlet UILabel *brandTitle;
@property (weak, nonatomic) IBOutlet UILabel *brandSize;

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@end


@implementation DownListCell

- (void)awakeFromNib{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadAllTask:) name:@"NOTIFICATION_DOWNLOAD_ALL_TASK" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTaskStatus) name:@"NOTIFICATION_DOWNLOAD_ALL_TASK_CHANGESTATUS" object:nil];

}


- (void)downloadAllTask:(NSNotification *)note{
    if ([note.userInfo[@"uid"] isEqualToString:self.downModal.uniqueMark]) {
        CGFloat progress = ((NSNumber *)note.userInfo[@"progress"]).floatValue;
//        [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"下载中"] forState:UIControlStateNormal];
        self.downloadProgress.progress = progress;
        self.brandSize.text = [NSString stringWithFormat:@"正在下载%.1fM/100.9M",progress * 100.9];
        self.brandSize.textColor = [UIColor blueColor];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",progress] forKey:self.downModal.brandName];
        [self layoutIfNeeded];
    }
}

- (void)changeTaskStatus{
    NSArray *allDownloadArray = [DownloadMissionList shareDownload].allTasks;
    for (DownLoadMission *task in allDownloadArray) {
        if ([self.downModal.uniqueMark isEqualToString:task.UID]) {
            [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"下载中"] forState:UIControlStateNormal];
            [self.downloadBtn setTitle:@"暂停" forState:UIControlStateNormal];
            self.brandSize.text = [NSString stringWithFormat:@"等待下载%.1fM/100.9M",self.downloadProgress.progress * 100.9];
            self.brandSize.textColor = [UIColor blueColor];
            [self layoutIfNeeded];
//            NSLog(@"更新状态成功---------");
            break;
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setDownModal:(DownListModel *)downModal{
    _downModal = downModal;
    self.brandTitle.text = downModal.brandName;
    self.brandSize.text = downModal.brandSize;
    self.downloadProgress.progress = [downModal.brandProgress floatValue];
    if ([downModal.brandProgress floatValue] > 0) {
        self.downloadBtn.tag = 33333;
    }
    if(self.downloadBtn.tag == 11111){
        /** 默认 */
        [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"未下载"] forState:UIControlStateNormal];
        self.brandSize.text = @"";
        self.brandSize.textColor = [UIColor blackColor];
    }else if (self.downloadBtn.tag == 22222){
        /** 下载 */
        [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"下载中"] forState:UIControlStateNormal];
        self.brandSize.text = [NSString stringWithFormat:@"等待下载%.1fM/100.9M",self.downloadProgress.progress * 100.9];
        self.brandSize.textColor = [UIColor blueColor];
    }else if (self.downloadBtn.tag == 33333){
        /** 暂停 */
        [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"暂停中"] forState:UIControlStateNormal];
        self.brandSize.text = [NSString stringWithFormat:@"已暂停%.1fM/100.9M",self.downloadProgress.progress * 100.9];
        self.brandSize.textColor = [UIColor redColor];
    }
    NSMutableArray *allTasks = [DownloadMissionList shareDownload].allTasks;
    
    /** 全部下载时修改状态 */
    for (DownLoadMission *task in allTasks) {
        if ([task.UID isEqualToString:downModal.uniqueMark]) {
            [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"下载中"] forState:UIControlStateNormal];
            [self.downloadBtn setTitle:@"暂停" forState:UIControlStateNormal];
            self.brandSize.text = [NSString stringWithFormat:@"等待下载%.1fM/100.9M",self.downloadProgress.progress * 100.9];
            self.brandSize.textColor = [UIColor blueColor];
            break;
        }
    }
    
}


- (IBAction)btnDidClick:(UIButton *)button {
    
    NSLog(@"点击了下载按钮－%@",self.downModal.brandName);
    if ([button.titleLabel.text isEqualToString:@"下载"]) {
        [button setTitle:@"暂停" forState:UIControlStateNormal];
        button.tag = 22222;
        [button setBackgroundImage:[UIImage imageNamed:@"下载中"] forState:UIControlStateNormal];
        DownLoadMission *mission = [[DownLoadMission alloc]initWithUID:self.downModal.uniqueMark];
        mission.model = self.downModal;
        
        [[DownloadMissionList shareDownload] addMission:mission];
        __block typeof(self)weakSelf = self;
        
        
        self.brandSize.text = [NSString stringWithFormat:@"等待下载%.1fM/100.9M",self.downloadProgress.progress * 100.9];
        self.brandSize.textColor = [UIColor blueColor];
        
        [mission changeValueText:^(CGFloat progressValue, DownListModel *model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.downloadProgress.progress = progressValue;
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",progressValue] forKey:weakSelf.downModal.brandName];
                weakSelf.brandSize.text = [NSString stringWithFormat:@"正在下载%.1fM/100.9M",progressValue * 100.9];
                weakSelf.brandSize.textColor = [UIColor blueColor];
            });
        }];
        
        
        [mission didFinishDownload:^(DownListModel *finishModal) {
            NSLog(@"下载完毕 %@-%@",finishModal.brandName,finishModal.brandSize);
            [weakSelf dataDidFinishDownload:finishModal];
        }];
    }else if ([button.titleLabel.text isEqualToString:@"暂停"]) {
        button.tag = 33333;
         NSMutableArray *allTasks = [DownloadMissionList shareDownload].allTasks;
        for (DownLoadMission *task in allTasks) {
            if ([task.UID isEqualToString:self.downModal.uniqueMark]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_PAUSE_UPLOAD_TASK" object:nil userInfo:@{@"uid":self.downModal.uniqueMark}];
                break;
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [button setTitle:@"下载" forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"暂停中"] forState:UIControlStateNormal];
                self.brandSize.text = [NSString stringWithFormat:@"已暂停%.1fM/100.9M",self.downloadProgress.progress * 100.9];
                self.brandSize.textColor = [UIColor redColor];
                
            });
        });
    }


}


- (void)dataDidFinishDownload:(DownListModel *)model{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_DELETE_UPLOAD_CELL" object:nil userInfo:@{@"model":self.downModal}];

}



@end
