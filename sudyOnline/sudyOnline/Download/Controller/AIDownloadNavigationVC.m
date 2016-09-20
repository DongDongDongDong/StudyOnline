//
//  AIDownloadNavigationVC.m
//  studyOnline
//
//  Created by andylau on 16/3/10.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AIDownloadNavigationVC.h"
#import "AIDownloadController.h"
@interface AIDownloadNavigationVC ()

@end

@implementation AIDownloadNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"NAV add---");
    AIDownloadController *downVC = [AIDownloadController shareDownloadManager];
    self.viewControllers = @[downVC];
    

//    [self.tabBarItem initWithTitle:@"下载" image:[UIImage imageNamed:@"tabbar_download"] selectedImage:[UIImage imageNamed:@"tabbar_download_s"]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"NAV add---WILL-APPEAR");

    AIDownloadController *downVC = [AIDownloadController shareDownloadManager];
    self.viewControllers = @[downVC];
}

@end
