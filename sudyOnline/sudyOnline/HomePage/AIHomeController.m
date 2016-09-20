//
//  AIHomeController.m
//  sudyOnline
//
//  Created by andylau on 16/3/1.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AIHomeController.h"
#import "AICollectionView.h"
#import <UIKit/UIKit.h>
#import "UIView+EXtension.h"
#import "CommonBussinessManager.h"
#import "MJExtension.h"
#import "AIHomeModel.h"
#import "SQCollectionCell.h"
#import "AIPlayerController.h"
#import "MJRefresh.h"
static NSString *kcellIdentifier = @"collectionCellID";
static NSString *kheaderIdentifier = @"headerIdentifier";
static NSString *kheaderIdentifier2 = @"headerIdentifier2";
static NSString *kfooterIdentifier = @"footerIdentifier";

@interface AIHomeController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) AICollectionView *AIHeaderVC;

@property (nonatomic, strong) NSArray *homeArray;



@end

@implementation AIHomeController

- (NSArray *)homeArray{
    if (_homeArray == nil) {
        _homeArray = [NSArray array];
    }
    
    return _homeArray;
}

- (AICollectionView *)AIHeaderVC{
    if (_AIHeaderVC == nil) {
        _AIHeaderVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AICollectionView_ID"];
        _AIHeaderVC.view.frame = CGRectMake(0, 0, SCREENWIDTH, 210);
        
//        UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 160, SCREENWIDTH, 20)];
//        bottom.backgroundColor = [UIColor orangeColor];
        [_AIHeaderVC.view addSubview:_AIHeaderVC.pageControl];

        UIView *sectionHeader = [[[NSBundle mainBundle] loadNibNamed:@"headView" owner:self options:nil] lastObject];
        sectionHeader.frame = CGRectMake(0, 180, SCREENWIDTH, 30);
        [_AIHeaderVC.view addSubview:sectionHeader];
        [self addChildViewController:_AIHeaderVC];
    }
    return _AIHeaderVC;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 设置容器视图高度
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = 400.0 / 640.0 * w;
//    self.containerView.bounds = CGRectMake(0, 0, SCREENWIDTH, h);
    [self loadNewData];
}


- (void) loadNewData{
    CommonBussinessManager *mgr = [CommonBussinessManager sharedManager];
    __weak typeof(self) weakSelf = self;
    [mgr getHomePageInfoWithcallback:^(BOOL success, ReponseObject *reponseObject) {
        _homeArray = [AIHomeModel objectArrayWithKeyValuesArray:reponseObject];
        AIHomeModel *model = _homeArray[0];
        weakSelf.AIHeaderVC.imageURLs = model.vos;
        [self collectionInitSetting];
        NSMutableArray *changeHomeArray = [NSMutableArray array];
        for (NSArray *arr in _homeArray) {
            [changeHomeArray addObject:arr
             ];
        }
        _homeArray = [changeHomeArray copy];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewData];
    [self.collectionView reloadData];
}

- (void)collectionInitSetting{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    //通过Nib生成cell，然后注册 Nib的view需要继承 UICollectionViewCell
    [self.collectionView registerNib:[UINib nibWithNibName:@"SQCollectionCell" bundle:nil] forCellWithReuseIdentifier:kcellIdentifier];
    
    //注册headerView Nib的view需要继承UICollectionReusableView
    [self.collectionView registerNib:[UINib nibWithNibName:@"headView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier2];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];

    //注册footerView Nib的view需要继承UICollectionReusableView
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kfooterIdentifier];

}



#pragma mark -CollectionView datasource
//section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.homeArray.count - 1;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    AIHomeModel *model = self.homeArray[section + 1];
    return [model.vos count];
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    SQCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    AIHomeModel *model = self.homeArray[indexPath.section + 1];
    cell.cellDict = model.vos[indexPath.row];
    return cell;
    
}
// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier;
    UICollectionReusableView *view ;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = kfooterIdentifier;
        view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    }else{
        if(indexPath.section == 0){
            reuseIdentifier = kheaderIdentifier;
            view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
            [view addSubview:self.AIHeaderVC.view];
        }else{
            reuseIdentifier = kheaderIdentifier2;
            view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
            UILabel *label = (UILabel *)[view viewWithTag:10001];
            if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
                AIHomeModel *model = self.homeArray[indexPath.section + 1];
                label.text = [NSString stringWithFormat:@"%@",model.name];
            }
        }
    }
    
    return view;
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width;
    CGFloat height;
//    if (indexPath.section == 0) {
//        width = ([UIScreen mainScreen].bounds.size.width - 40) * 0.5;
//        height = 0.8 *width;
//    }else if(indexPath.section == 1){
//        width = ([UIScreen mainScreen].bounds.size.width - 40);
//        height = 0.6 * width;
//    }else if(indexPath.section == 2){
//        width = ([UIScreen mainScreen].bounds.size.width - 40) * 0.5;
//        height = 0.8 * width;
//    }else
    
        if (indexPath.section % 2 == 0) {
            width = ([UIScreen mainScreen].bounds.size.width - 40) * 0.5;
            height = 0.8 *width;
        }else{
            width = ([UIScreen mainScreen].bounds.size.width - 40);
            height = 0.6 * width;
        }
        
        
        
    return CGSizeMake(width, height);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 15, 5, 15);//分别为上、左、下、右
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size;
    if (section == 0) {
        size =  CGSizeMake([UIScreen mainScreen].bounds.size.width,210);
    }else{
        size = CGSizeMake(320, 45);
    }
    return size;
}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={[UIScreen mainScreen].bounds.size.width,10};
    return size;
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SQCollectionCell *cell = (SQCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"%@",cell.cellDict[@"contentId"]);
    
    CommonBussinessManager *mgr = [CommonBussinessManager sharedManager];
    // [NSString stringWithFormat:@"http://so.open.163.com/movie/%@/getMovies4Ipad.htm",cell.cellDict[@"contentId"]]
    [mgr getMovieDetailInfo:DETAIL_MOVIE_URL(cell.cellDict[@"contentId"]) Withcallback:^(BOOL success, ReponseObject *reponseObject) {
        NSDictionary *movieDict;
        if (success) {
             movieDict = (NSDictionary *)[reponseObject copy];
        }
        AIPlayerController *playController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AIPlayerController_ID"];
        playController.allDict = movieDict;
        playController.fromType = @"home";
        playController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playController animated:YES];
    }];
//    [cell setBackgroundColor:[UIColor greenColor]];
}
//取消选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor redColor]];
}

@end
