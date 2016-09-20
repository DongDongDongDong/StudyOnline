//
//  AIPlayerController.m
//  sudyOnline
//
//  Created by andylau on 16/3/6.
//  Copyright © 2016年 andylau. All rights reserved.
//
#define BOTTOM_LINE_X_MARGIN 5
#define BOTTOM_LINE_Y_MARGIN 39 + CGRectGetMaxY(self.playerView.frame)
#define BOTTOM_LINE_WIDTH [UIScreen mainScreen].bounds.size.width / 3 - 10
#define BOTTOM_LINE_HEIGHT 3
#import "AIPlayerController.h"
#import "AIMoviePlayerView.h"
#import "UIImageView+WebCache.h"
#import "UIColorExtension.h"
#import "HHHorizontalPagingView.h"
#import "UIImage+Extension.h"
#import "AIHomeLabel.h"
#import "AIDetailOneController.h"
#import "AIDetailTwoController.h"
#import "AIDetailThreeController.h"
#import "AIFavoriteController.h"
#import "MBProgressHUD+Show.h"
#import <ShareSDK/ShareSDK.h>
#import "UIView+EXtension.h"
#import "AIDownloadController.h"
#import "DownListModel.h"
@interface AIPlayerController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet AIMoviePlayerView *playerView;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;


/** 存放顶部所有标题的scrollView */
@property (weak, nonatomic) IBOutlet UIScrollView *titlesScrollView;
/** 存放顶部所有内容的scrollView */
@property (weak, nonatomic) IBOutlet UIScrollView *contentsScrollView;
/** 底部横线 */
@property (nonatomic, strong) UIView *bottomLine;
/** 分享下载View */
@property (nonatomic, strong) UIView *shareDownloadView;

/** 当前视频URL */
@property (nonatomic, copy) NSString *movieUrl;
/** 当前视频名字 */
@property (nonatomic, copy) NSString *movieName;


@end

@implementation AIPlayerController

-(UIView *)shareDownloadView{
    if (_shareDownloadView == nil) {
        _shareDownloadView = [[[NSBundle mainBundle] loadNibNamed:@"AICourseInteract" owner:self options:nil] lastObject];
        _shareDownloadView.frame = CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH, 50);
    }
    return _shareDownloadView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildVces];
    [self setupTitles];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"详细课程";
    if ([self.fromType isEqualToString:@"home"]) {
        if (self.allDict) {
            [self.playerImage sd_setImageWithURL:[NSURL URLWithString:self.allDict[@"largeimgurl"]] placeholderImage:[UIImage imageNamed:@"pic_default1"] options:(SDWebImageRetryFailed | SDWebImageLowPriority)];
        }
    }else if([self.fromType isEqualToString:@"course"]){
        if (self.allDict) {
            [self.playerImage sd_setImageWithURL:[NSURL URLWithString:self.allDict[@"picture"]] placeholderImage:[UIImage imageNamed:@"pic_default1"] options:(SDWebImageRetryFailed | SDWebImageLowPriority)];
        }
    }
    
    [self setUpMovieInfo];
    [self preLoadPresentingController];
}

- (void)preLoadPresentingController{
    AIDetailOneController *firstVc = [self.childViewControllers firstObject];
    firstVc.view.frame = self.contentsScrollView.bounds;
    [self.contentsScrollView addSubview:firstVc.view];
    AIHomeLabel *firstLabel = [self.titlesScrollView.subviews firstObject];
    firstLabel.scale = 1.0;
    firstLabel.textColor = [UIColor colorWithHex:CONSTANT_THEME_COLOR_HDEX];
}

/** 更改当前播放视频信息 */
- (void)setUpMovieInfo{
    
    if ([self.fromType isEqualToString:@"home"]) {
        NSDictionary *mp4Url = self.allDict[@"videoList"][self.currentNum];
        self.movieUrl = mp4Url[@"repovideourlmp4"];
        self.movieName = mp4Url[@"title"];
    }else if ([self.fromType isEqualToString:@"course"]){
        NSArray *lesson = self.allDict[@"lessons"];
        NSDictionary *mp4Url = lesson[self.currentNum];
        self.movieUrl = mp4Url[@"ipad_url"];
        self.movieName = mp4Url[@"short_name"];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication].keyWindow addSubview:self.shareDownloadView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.shareDownloadView removeFromSuperview];
}

- (void)setupChildVces
{
    AIDetailOneController *vc01 = [[AIDetailOneController alloc] initWithNibName:@"AIDetailOneController" bundle:nil];
    vc01.title = @"0";
    if ([self.fromType isEqualToString:@"home"]) {
        vc01.fromType = @"home";
    }else if ([self.fromType isEqualToString:@"course"]){
        vc01.fromType = @"course";
    }
    vc01.detailDict = self.allDict;
    [self addChildViewController:vc01];
    
    AIDetailTwoController *vc02 = [[AIDetailTwoController alloc] initWithNibName:@"AIDetailTwoController" bundle:nil];
    if ([self.fromType isEqualToString:@"home"]) {
        vc02.courseArray = self.allDict[@"videoList"];
        vc02.fromType = @"home";
    }else if ([self.fromType isEqualToString:@"course"]){
        vc02.courseArray = self.allDict[@"lessons"];
        vc02.fromType = @"course";
    }

    vc02.view.backgroundColor = [UIColor orangeColor];

    vc02.title = @"1";
    [self addChildViewController:vc02];
    
    AIDetailThreeController *vc03 = [[AIDetailThreeController alloc] initWithNibName:@"AIDetailThreeController" bundle:nil];

    vc03.title = @"2";
    [self addChildViewController:vc03];
    
    // 设置内容size
    CGFloat contentsContentW = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.contentsScrollView.contentSize = CGSizeMake(contentsContentW, 0);
}

/**
 *  添加顶部的所有标题
 */
- (void)setupTitles
{
    // 初始化标题
    NSArray *labelArray = [NSArray arrayWithObjects:@"课程介绍",@"课程目录",@"课程推荐", nil];
    NSUInteger count = self.childViewControllers.count;
    CGFloat labelW = [UIScreen mainScreen].bounds.size.width / 3;
    CGFloat labelH = 30;
    CGFloat labelY = 7;
    for (NSUInteger i = 0; i < count; ++i) {
        // 创建label
        AIHomeLabel *label = [[AIHomeLabel alloc] init];
        label.font = [UIFont systemFontOfSize:17];
        label.tag = i;
        [self.titlesScrollView addSubview:label];
        
        CGFloat labelX = i * labelW;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        label.text = labelArray[i];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    }
    
    // 设置scrollView的内容大小
    CGFloat titlesContentW = count * labelW;
    self.titlesScrollView.contentSize = CGSizeMake(titlesContentW, 0);
    

    //初始化横线
    self.bottomLine = [[UIView alloc]initWithFrame:CGRectMake(BOTTOM_LINE_X_MARGIN, BOTTOM_LINE_Y_MARGIN + 10, BOTTOM_LINE_WIDTH, BOTTOM_LINE_HEIGHT)];
    self.bottomLine.layer.cornerRadius = 2.0f;
    self.bottomLine.layer.masksToBounds = YES;
    self.bottomLine.backgroundColor = [UIColor colorWithHex:CONSTANT_THEME_COLOR_HDEX];
    [self.view addSubview:self.bottomLine];
    
}

#pragma mark - <UIScrollViewDelegate>
/**
 *  在scrollView动画结束时调用(添加子控制器的view到self.contentsScrollView)
 *  self.contentsScrollView == scrollView
 *  用户手动触发的动画结束，不会调用这个方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得当前需要显示的子控制器的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 滚动标题栏（self.titlesScrollView）
    AIHomeLabel *label = self.titlesScrollView.subviews[index];
    CGFloat titlesW = self.titlesScrollView.frame.size.width;
    CGFloat offsetX = label.center.x - titlesW * 0.5;
    // 最大的偏移量
    CGFloat maxOffsetX = self.titlesScrollView.contentSize.width - titlesW;
    if (offsetX < 0) {
        offsetX = 0;
    } else if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    CGPoint offset = CGPointMake(offsetX, self.titlesScrollView.contentOffset.y);
    [self.titlesScrollView setContentOffset:offset animated:YES];
    
    label.textColor = [UIColor colorWithHex:CONSTANT_THEME_COLOR_HDEX];
    // 让其它label
    [self.titlesScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            if ([[self.titlesScrollView.subviews[idx] class] isSubclassOfClass:[AIHomeLabel class]]) {
                AIHomeLabel *otherLabel = self.titlesScrollView.subviews[idx];
                otherLabel.scale = 0.0;
                otherLabel.textColor = [UIColor blackColor];
            }
        }
    }];
    
    UIViewController *vc = self.childViewControllers[index];
    // 如果子控制器的view已经在上面，就直接返回
    if (vc.view.superview) return;
    
    // 添加
    CGFloat vcW = scrollView.frame.size.width;
    CGFloat vcH = scrollView.frame.size.height;
    CGFloat vcX = index * vcW;
    CGFloat vcY = 0;
    vc.view.frame = CGRectMake(vcX, vcY, vcW, vcH);
    
    [scrollView addSubview:vc.view];
}

/**
 *  当scrollView停止滚动时调用这个方法（用户手动触发的动画停止，会调用这个方法）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 获得当前需要显示的子控制器的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 滚动标题栏（self.titlesScrollView）
    AIHomeLabel *label = self.titlesScrollView.subviews[index];
    label.textColor = [UIColor colorWithHex:CONSTANT_THEME_COLOR_HDEX];

    CGFloat offsetLabX = label.tag *  [UIScreen mainScreen].bounds.size.width / 3;
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionOverrideInheritedDuration animations:^{
        self.bottomLine.frame = CGRectMake(offsetLabX + BOTTOM_LINE_X_MARGIN, BOTTOM_LINE_Y_MARGIN, BOTTOM_LINE_WIDTH, BOTTOM_LINE_HEIGHT);

    } completion:nil];
    
    //    [self didChangedataSource:label.tag];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

#warning 这里最好取绝对值（保证计算出来的比例是非负数）
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    // 左边文字的索引
    NSUInteger leftIndex = (NSUInteger)(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger rightIndex = leftIndex + 1;
    
    CGFloat rightScale = value - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    
    
    // 取出label设置大小和颜色
    AIHomeLabel *leftLabel = self.titlesScrollView.subviews[leftIndex];
    leftLabel.textColor = [UIColor colorWithHex:CONSTANT_THEME_COLOR_HDEX];
    leftLabel.scale = leftScale;
    if (rightIndex < self.titlesScrollView.subviews.count) {
        if([[self.titlesScrollView.subviews[rightIndex] class] isSubclassOfClass:[AIHomeLabel class]]){
            AIHomeLabel *rightLabel = self.titlesScrollView.subviews[rightIndex];
            rightLabel.textColor = [UIColor blackColor];
            rightLabel.scale = rightScale;
        }
    }
}


- (void)labelClick:(UITapGestureRecognizer *)recognizer
{
    AIHomeLabel *label = (AIHomeLabel *)recognizer.view;
    // 计算x方向上的偏移量
    CGFloat offsetX = label.tag * self.contentsScrollView.frame.size.width;
    label.textColor = [UIColor colorWithHex:CONSTANT_THEME_COLOR_HDEX];

    // 设置偏移量
    CGPoint offset = CGPointMake(offsetX, self.contentsScrollView.contentOffset.y);
    [self.contentsScrollView setContentOffset:offset animated:YES];
    CGFloat offsetLabX = label.tag *  [UIScreen mainScreen].bounds.size.width / 3;
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.bottomLine.frame = CGRectMake(offsetLabX + BOTTOM_LINE_X_MARGIN, BOTTOM_LINE_Y_MARGIN, BOTTOM_LINE_WIDTH, BOTTOM_LINE_HEIGHT);
        
    } completion:nil];
    
}

#pragma mark clickMethod
- (void)beginPlay{
    [self play:nil];
}

- (IBAction)play:(id)sender {
    
    [self setUpMovieInfo];
    if (self.movieUrl){
        [self.playerView playWithURL:[NSURL URLWithString:self.movieUrl]];
    }
}

- (void)dealloc {
    // 走之前停止播放
    [self.playerView stopPlayback];
}

#pragma  mark share&Download

- (IBAction)downloadVideo:(id)sender {
    AIDownloadController *downLoadVC = [AIDownloadController shareDownloadManager];
    NSLog(@"1---%@",downLoadVC);
    DownListModel *model = [[DownListModel alloc] init];
    model.brandName = self.movieName;
    model.downloadUrl = self.movieUrl;
    model.uniqueMark = [self generateUniqueID];
    [downLoadVC.downListArray addObject:model];
    [MBProgressHUD showSuccessWithText:@"已添加到下载队列"];
    [downLoadVC downloadAllTask];
}

- (IBAction)favoriteVideo:(UIButton *)sender {
    [MBProgressHUD showSuccessWithText:@"收藏成功"];
    sender.titleLabel.textColor = [UIColor yellowColor];
    sender.enabled = NO;
}

- (IBAction)shareVideo:(id)sender {
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"tou.png"]];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        
        [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        }];
    }
}
- (NSString *)generateUniqueID{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddHHmmssSSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
    return timeLocal;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//    NSLog(@"touchbegin");
//    if (self.view.width < self.view.height) {
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
//    } else {
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
//    }
//}

@end
