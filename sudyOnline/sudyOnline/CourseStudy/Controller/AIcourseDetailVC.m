//
//  AIcourseDetailVC.m
//  studyOnline
//
//  Created by andylau on 16/3/8.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AIcourseDetailVC.h"
#import "CommonBussinessManager.h"
#import "AICourseCell.h"
#import "MJExtension.h"
#import "AICourseModel.h"
#import "AIPlayerController.h"
@interface AIcourseDetailVC ()

@property (nonatomic, strong) NSArray *courseArray;

@property (nonatomic, assign) NSInteger page;

@end

@implementation AIcourseDetailVC

- (NSArray *)courseArray{
    if (_courseArray == nil) {
        _courseArray = [NSArray array];
    }
    return  _courseArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    CommonBussinessManager *mgr = [CommonBussinessManager sharedManager];
    [mgr getCourseInfoWithId:self.courseID page:[NSString stringWithFormat:@"%ld",self.page] callback:^(BOOL success, ReponseObject *reponseObject) {
        if (success) {
            NSLog(@"%@",reponseObject);
            NSDictionary *responseDict = (NSDictionary *)reponseObject;
            NSDictionary *resultDict = responseDict[@"result"];
            if ([resultDict[@"data"] objectForKey:@"total"] > 0) {
                self.courseArray = [AICourseModel objectArrayWithKeyValuesArray:[resultDict[@"data"] objectForKey:@"courses"]];
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"COURCE_CELL_ID";
    AICourseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"AICourseCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    cell.model = self.courseArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AICourseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    AIPlayerController *playController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AIPlayerController_ID"];
    __block NSDictionary *detailDict;
    [[CommonBussinessManager sharedManager] getOneCourseInfoWithId:cell.model.id callback:^(BOOL success, ReponseObject *reponseObject) {
        if (success) {
            NSLog(@"%@",reponseObject);
            NSDictionary *responseDict = (NSDictionary *)reponseObject;
            NSDictionary *resultDict = responseDict[@"result"];
            if (resultDict[@"data"]) {
                detailDict = resultDict[@"data"];
            }
            
            if (detailDict) {
                playController.allDict = detailDict;
            }
            playController.hidesBottomBarWhenPushed = YES;
            playController.fromType = @"course";
            [self.navigationController pushViewController:playController animated:YES];
        }
    }];
}
@end
