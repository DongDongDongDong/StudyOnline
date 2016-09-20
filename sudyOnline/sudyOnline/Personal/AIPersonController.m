//
//  AIPersonController.m
//  sudyOnline
//
//  Created by andylau on 16/3/1.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AIPersonController.h"
#import "ZHBlurtView.h"
#import "UIImage+Extension.h"
#import "DXAlertView.h"
#import "UIColorExtension.h"
#import "AIDownloadController.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+Show.h"
#import "AILoginViewController.h"
#import "AIFavoriteController.h"
@interface AIPersonController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *settingArray;


@property (nonatomic, strong) UITableView *personTable;

@property (nonatomic, strong) UIButton *logOutBtn;

@property (nonatomic, strong) ZHBlurtView *head;

@end

@implementation AIPersonController

- (NSArray *)settingArray{
    if (_settingArray == nil) {
        NSArray *one = [NSArray arrayWithObjects:@"检测更新+ico_my_update", nil];
        // ,@"播放记录+ico_my_history"
        NSArray *two = [NSArray arrayWithObjects:@"我的收藏+ico_my_favorites",@"我的下载+ico_my_download",@"允许3G/4G观看视频+ico_my_set.png",@"允许3G/4G观看下载+ico_my_set.png",nil];
//        NSArray *thr = [NSArray arrayWithObjects:@"允许3G/4G观看视频+ico_my_set.png",@"允许3G/4G观看下载+ico_my_set.png", nil];
        _settingArray = [NSArray arrayWithObjects:one,two, nil];
    }
    return _settingArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ZHBlurtView *head = [[ZHBlurtView alloc] initWithFrame:self.view.frame WithHeaderImgHeight:200 iconHeight:70];
    
    UIButton *login = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
    [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
//    login.backgroundColor = [];
    [head addSubview:login];
    
    head.iconImage = [UIImage imageNamed:@"head"];
    head.bgImage = [UIImage imageNamed:@"person_top_bg.png"];
    head.name = nil;
    self.head = head;
    [self.view addSubview:head];
    
    UITableView *personTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)style:UITableViewStyleGrouped];
    personTable.delegate = self;
    personTable.dataSource = self;
    
    personTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [head.oterView addSubview:personTable];
    self.personTable = personTable;
    
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;

}


- (void)login{
    __weak typeof(self) weakSelf = self;
    AILoginViewController *loginVC = [[AILoginViewController alloc] initWithNibName:@"AILoginViewController" bundle:nil];
    [loginVC changeValueText:^(NSString *changeUerName) {
         weakSelf.head.name = changeUerName;
         weakSelf.logOutBtn.enabled = YES;
         weakSelf.logOutBtn.alpha = 1;
        weakSelf.head.iconImage = [UIImage imageNamed:@"tou"];

    }];
    
    [self presentViewController:loginVC animated:YES completion:nil];

}

- (void)userLogOut{
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"退出账号" contentText:@"退出后，使用不同账号登录，将会清除之前下载内容" leftButtonTitle:@"点错了" rightButtonTitle:@"退出登录"];
    [alert show];
    __weak typeof(self) weakSelf = self;
    alert.rightBlock = ^{
        [MBProgressHUD showMessage:@"退出中"];
        [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
        weakSelf.logOutBtn.alpha = 0;
        weakSelf.logOutBtn.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            weakSelf.head.name = nil;
        });
    };
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavBarImg:self.navigationController.navigationBar image:[UIImage imageNamed:@"touming"]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:CONSTANT_THEME_COLOR_HDEX]] forBarMetrics:UIBarMetricsDefault];
    [AIDownloadController shareDownloadManager].hidesBottomBarWhenPushed = NO;
}

#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.settingArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.settingArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"SETTING_CELL";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSArray *array = [(NSString *)self.settingArray[indexPath.section][indexPath.row] componentsSeparatedByString:@"+"];
    cell.textLabel.text = array[0];
    cell.imageView.image = [UIImage imageNamed:array[1]];
    if (indexPath.section == 1 && (indexPath.row == 3 || indexPath.row == 2)) {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchView.tag = indexPath.row;
        [switchView addTarget:self action:@selector(didClickSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    }
    return cell;
}

- (void)didClickSwitch:(UISwitch *)switchView{
    NSLog(@"%ld",switchView.tag);
    if (switchView.tag == 3) {
        //  视频观看
    } else{
        //  允许下载
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *key = @"CFBundleShortVersionString";
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"当前已是最新版本！" contentText:[NSString stringWithFormat:@"当前版本:%@",version] leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            // collection
            AIFavoriteController *favoriteVc = [[AIFavoriteController alloc] initWithNibName:@"AIFavoriteController" bundle:nil];
            favoriteVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:favoriteVc animated:YES];
        }else if (indexPath.row == 1){
            // download
            AIDownloadController *download = [AIDownloadController shareDownloadManager];
            NSLog(@"3---%@",download);
            download.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:download animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView;
    if (section == 1) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
        UIButton *logOut = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, SCREENWIDTH - 20, 40)];
        logOut.backgroundColor = [UIColor redColor];
        logOut.enabled = NO;
        logOut.alpha = 0;
        [logOut setTitle:@"退出登录" forState:UIControlStateNormal];
        [logOut addTarget:self action:@selector(userLogOut) forControlEvents:UIControlEventTouchUpInside];
        [logOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [footerView addSubview:logOut];
        self.logOutBtn = logOut;
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height;
    if (section == 1) {
        height = 80;
    }
    return height;
}


#pragma mark - setNav

- (void) setNavBarImg:(UINavigationBar *)navBar image:(UIImage *)image
{
#define kSCNavBarImageTag 10
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        //if iOS 5.0 and later
        [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[navBar  viewWithTag:kSCNavBarImageTag];
        [imageView setBackgroundColor:[UIColor clearColor]];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithImage:
                         image];
            [imageView setTag:kSCNavBarImageTag];
            [navBar insertSubview:imageView atIndex:0];
        }
    }
    [self removeBlackLine];
}

- (void)removeBlackLine{
    [self.navigationController.navigationBar setTranslucent:YES];
    //    为什么要加这个呢，shadowImage 是在ios6.0以后才可用的。但是发现5.0也可以用。不过如果你不判断有没有这个方法，
    //    而直接去调用可能会crash，所以判断下。作用：如果你设置了上面那句话，你会发现是透明了。但是会有一个阴影在，下面的方法就是去阴影
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    //    以上面4句是必须的,但是习惯还是加了下面这句话
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];

}



@end
