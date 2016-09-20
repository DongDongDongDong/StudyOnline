//
//  AIDownloadController.m
//  sudyOnline
//
//  Created by andylau on 16/3/1.
//  Copyright © 2016年 andylau. All rights reserved.
//

#define downloadURL @"http://192.168.1.21/test1.zip"
#import "AIDownloadController.h"
#import "AILocalPlayVC.h"
#import "DownListCell.h"
#import "DownListModel.h"
#import "DownLoadMission.h"
#import "DownloadMissionList.h"
#import "DownloadedCell.h"
@interface AIDownloadController ()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UISegmentedControl *brandSegment;

/** cell */
@property (nonatomic, strong) NSMutableDictionary *downloadCellDict;

@end

@implementation AIDownloadController
static AIDownloadController *instance;
+ (AIDownloadController *)shareDownloadManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AIDOWNLOAD_ID"];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


- (NSMutableDictionary *)downloadCellDict{
    if (_downloadCellDict == nil) {
        _downloadCellDict = [NSMutableDictionary dictionary];
    }
    return _downloadCellDict;
}

- (NSMutableArray *)downListArray{
    if (_downListArray == nil) {
        _downListArray = [NSMutableArray array];
//        for (int i = 0; i < 1; i++) {
//            DownListModel *model = [[DownListModel alloc]init];
//            model.brandName = [NSString stringWithFormat:@"[第%d集]开宗明义",i + 1];
//            model.uniqueMark = [self generateUniqueIDWith:[NSString stringWithFormat:@"%d",i]];
//            model.brandSize = @"138M";
//            model.brandProgress = [[NSUserDefaults standardUserDefaults] objectForKey:model.brandName];
//            model.downloadUrl = [NSString stringWithFormat:@"http://192.168.56.111/test%d.zip",i+1];
//            [_downListArray addObject:model];
//        }
    }else{
        for (DownListModel *model in _downListArray) {
            model.brandProgress = [[NSUserDefaults standardUserDefaults] objectForKey:model.brandName];
        }
    }
    return _downListArray;
}

- (void)findLocalMovie{
    NSString *movieFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];

    NSBundle *movieBundle=[NSBundle bundleWithPath:movieFilePath];
    NSString *bundlePath=[movieBundle resourcePath];
    
    NSArray *arrMovie=[NSBundle pathsForResourcesOfType:@"mp4" inDirectory:bundlePath];
    for (NSString *filePath in arrMovie) {
        NSLog(@"local---movie---%@",filePath);
        DownListModel *model = [[DownListModel alloc]init];
        model.brandName = [filePath substringFromIndex:85];
        model.destinationUrl = filePath;
        [self.downloadedListArray addObject:model];
    }
}

- (NSString *)generateUniqueIDWith:(NSString *)i{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddHHmmssSSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@%@", date,i];
    return timeLocal;
}


- (NSMutableArray *)downloadedListArray{
    if (_downloadedListArray == nil) {
        _downloadedListArray = [NSMutableArray array];
//        for (int i = 0; i < 3; i++) {
//            DownListModel *model = [[DownListModel alloc]init];
//            model.brandName = [NSString stringWithFormat:@"swift入门%d",i];
//            model.brandSize = @"109.3M";
//            [_downloadedListArray addObject:model];
//        }
    }
    return _downloadedListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addRightBarButton];
    //    [self arrayTest];
    self.obdListTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.obdListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.brandSegment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFinishCell:) name:@"NOTIFICATION_DELETE_UPLOAD_CELL" object:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self findLocalMovie];
    [self.obdListTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"self=---%p",self);
//    NSLog(@"tableFrameDidAppear---%@－%p",NSStringFromCGRect(self.obdListTable.frame),self.obdListTable);
//    [self.obdListTable reloadData];
}



- (void)addRightBarButton{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    [rightBtn setTitle:@"全部下载" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //    rightBtn.backgroundColor = [UIColor blueColor];
    //    [rightBtn setBackgroundImage:[UIImage imageNamed:@"全部下载"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(downloadAllTask) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *RightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = RightItem;
}

- (void)deleteFinishCell:(NSNotification *)note{
    DownListModel *model = note.userInfo[@"model"];
    NSInteger row = [self.downListArray indexOfObject:model];
    [self.downListArray removeObject:model];
    NSIndexPath *tmpIndexpath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.obdListTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:tmpIndexpath, nil] withRowAnimation:UITableViewRowAnimationTop];
    
    [self.downloadedListArray addObject:model];
}


- (IBAction)segmentClick:(UISegmentedControl *)segment {

    switch (segment.selectedSegmentIndex) {
        case 0:{
            self.isDownloaded = NO;
            [self.obdListTable reloadData];
        }
            break;
        case 1:{
            self.isDownloaded = YES;
            [self.obdListTable reloadData];
        }
            break;
            
    }
}

- (void)downloadAllTask{
    NSLog(@"添加所有任务");
    
    
    NSMutableArray *unAddTaskArray = [NSMutableArray arrayWithArray:self.downListArray];
    for (DownLoadMission *tasked in [DownloadMissionList shareDownload].allTasks) {
        [unAddTaskArray removeObject:tasked.model];
        NSLog(@"删除了任务%@",tasked.model.brandName);
    }
    
    NSLog(@"新数组任务长度%ld",unAddTaskArray.count);
    for (DownListModel *model in unAddTaskArray) {
        NSLog(@"本次添加了任务%@",model.brandName);
        
        DownLoadMission *mission = [[DownLoadMission alloc]initWithUID:model.uniqueMark];
        mission.model = model;
        [[DownloadMissionList shareDownload] addMission:mission];
        
        [mission changeValueText:^(CGFloat progressValue, DownListModel *model) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_DOWNLOAD_ALL_TASK" object:nil userInfo:@{@"uid":model.uniqueMark, @"progress":@(progressValue)} ];
        }];
        
        [mission didFinishDownload:^(DownListModel *finishModal) {
            NSLog(@"下载完毕 %@-%@",finishModal.brandName,finishModal.brandSize);
            [self.downListArray removeObject:finishModal];
            [self.downloadedListArray addObject:finishModal];
            [self.obdListTable reloadData];
        }];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_DOWNLOAD_ALL_TASK_CHANGESTATUS" object:nil userInfo:nil ];
    
    
}

- (void)dealloc{
    NSLog(@"Download走了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.isDownloaded){
        // 已下载
        return self.downloadedListArray.count;
    }else{
        NSLog(@"%ld", self.downListArray.count);
        return self.downListArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    if (self.isDownloaded) {
        static NSString *reUseInentifier2 = @"OBDLISTCELL2";
        DownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:reUseInentifier2];
        if (cell == nil) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reUseInentifier2];
            [tableView registerNib:[UINib nibWithNibName:@"DownloadedCell" bundle:nil] forCellReuseIdentifier:reUseInentifier2];
            cell = [tableView dequeueReusableCellWithIdentifier:reUseInentifier2];
        }
        DownListModel *model = self.downloadedListArray[indexPath.row];
        cell.model = model;
//        cell.detailTextLabel.text = model.brandSize;
//        cell.textLabel.text = model.brandName;
//        UIView *bottom_line = [[UIView alloc]initWithFrame:CGRectMake(5, 48, [UIScreen mainScreen].bounds.size.width - 10, 1)];
//        bottom_line.backgroundColor = [UIColor lightGrayColor];
//        [cell addSubview:bottom_line];
//        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        cell.layer.borderWidth = 1.0f;
        return cell;
    }else{
        /*
         DownListModel *model = self.downListArray[indexPath.row];
         NSString *reUseIdentifier1 = [NSString stringWithFormat:@"Cell%ld%ld%@",indexPath.section,indexPath.row,model.brandName];
         DownListCell *cell = [tableView dequeueReusableCellWithIdentifier:reUseIdentifier1];
         if (cell == nil) {
         [tableView registerNib:[UINib nibWithNibName:@"DownListCell" bundle:nil] forCellReuseIdentifier:reUseIdentifier1] ;
         cell = [tableView dequeueReusableCellWithIdentifier:reUseIdentifier1];
         }
         
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.downModal = self.downListArray[indexPath.row];
         */
        DownListModel *model = self.downListArray[indexPath.row];
        NSString *reUseIdentifier1 = [NSString stringWithFormat:@"Cell%@",model.brandName];
        DownListCell *cell;
        
        if (self.downloadCellDict[reUseIdentifier1]) {
            cell = self.downloadCellDict[reUseIdentifier1];
            //            NSLog(@"重用CELL%@",reUseIdentifier1);
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DownListCell" owner:self options:nil] lastObject];
            //            NSLog(@"创建CELL%@",reUseIdentifier1);
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.downModal = self.downListArray[indexPath.row];
        
        
        [self.downloadCellDict setObject:cell forKey:reUseIdentifier1];
        return cell;
    }
    
}



#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isDownloaded){
        return  UITableViewCellEditingStyleDelete;
    }else{
        return  UITableViewCellEditingStyleNone;
    }
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.downloadedListArray removeObjectAtIndex:indexPath.row];
        NSIndexPath *tmpIndexpath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        [self.obdListTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:tmpIndexpath, nil] withRowAnimation:UITableViewRowAnimationTop];
    }
}


@end