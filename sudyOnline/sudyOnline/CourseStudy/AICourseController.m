//
//  AICourseController.m
//  sudyOnline
//
//  Created by andylau on 16/3/1.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AICourseController.h"
#import "CourseHeaderView.h"
#import "CourseCollectionCell.h"
#import "TencentNewsViewController.h"
#import "AIcourseDetailVC.h"
static NSString *kcellIdentifier = @"courseCollectionCellID";
static NSString *kheaderIdentifier = @"courseHeaderIdentifier";
static NSString *kheaderIdentifierUP = @"courseHeaderIdentifierUP";

@interface AICourseController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *courseCollection;
@property (nonatomic, strong) NSMutableArray *kindArray;

@property (nonatomic, strong) NSArray *titleArray;


@end

@implementation AICourseController

- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = [NSArray arrayWithObjects:@"IT互联网+IT & INTERNET",@"兴趣爱好+LIFESTYLES & HOBBIES",@"职场技能+OCCUPATIONAL SKILLS",@"语言学习+LANGUAGES",@"更多分类+MORE...", nil];
    }
    return _titleArray;
}

- (NSMutableArray *)kindArray{
    if (_kindArray == nil) {
        NSArray *one = [NSArray arrayWithObjects:@"编程语言",@"移动开发",@"数据库",@"网页设计",@"市推广场",@"网络维护",@"产品运营",@"产品设计",@"营销策划",@"自动化",@"其它",nil];
        NSArray *two = [NSArray arrayWithObjects:@"书法绘画",@"美食烹饪",@"手工制作",@"生活心得",@"旅游攻略",@"时尚美妆",@"健康养身",@"摄影摄像",@"声音乐器",@"户外活动",@"其它",nil];
        NSArray *thr = [NSArray arrayWithObjects:@"办公技能",@"商务礼仪",@"人力资源",@"职业考试",@"营销推广",@"财税投资",@"职业规划",@"管理能力",@"职业考试",@"谈判技巧",@"其它",nil];
        NSArray *four = [NSArray arrayWithObjects:@"实用口语",@"应试英语",@"韩语入门",@"日语初级",@"GRE",@"其它",nil];
        NSArray *five = [NSArray arrayWithObjects:@"装修建筑",@"亲子育儿",@"工程技术",@"哲学历史",@"经管法学",@"人生百态",@"农林医药",@"宠物喂养",@"基础医学",@"自媒体",@"其它",nil];
        _kindArray = [NSMutableArray arrayWithObjects:one,two,thr,four,five, nil];

    }
    return _kindArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.courseCollection.delegate = self;
    self.courseCollection.dataSource = self;
    self.courseCollection.backgroundColor = [UIColor whiteColor];
    [self.courseCollection registerNib:[UINib nibWithNibName:@"CourseHeaderView2" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifierUP];
    [self.courseCollection registerNib:[UINib nibWithNibName:@"CourseCollectionCell" bundle:nil]forCellWithReuseIdentifier:kcellIdentifier];
    [self.courseCollection registerNib:[UINib nibWithNibName:@"CourseHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];

}


#pragma mark UITableViewDelegate
#pragma mark -CollectionView datasource
//section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.kindArray.count;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.kindArray[section] count];
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    CourseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:33333];
    label.text = self.kindArray[indexPath.section][indexPath.row];
    return cell;
    
}
// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier;
    CourseHeaderView *view ;
    reuseIdentifier = kheaderIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        view = [[CourseHeaderView alloc] init];
    }else{
        
        if (indexPath.section == 0) {
            view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:kheaderIdentifierUP   forIndexPath:indexPath];
        }else{
            view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
            UILabel *label1 = (UILabel *)[view viewWithTag:11111];
            UILabel *label2 = (UILabel *)[view viewWithTag:22222];
            //赋值
            NSArray *tempArray = [ (NSString *)self.titleArray[indexPath.section] componentsSeparatedByString:@"+"];
            label1.text = tempArray[0];
            label2.text = tempArray[1];

        }
    }
    
    
    
    return view;
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(100, 20);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 20, 5, 15);//分别为上、左、下、右
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    CGSize  size;
    if (section == 0) {
        size = CGSizeMake(SCREENWIDTH, 200);
    }else{
        size = CGSizeMake(320, 45);
    }    return size;
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
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor greenColor]];
    AIcourseDetailVC *detailVc = [[AIcourseDetailVC alloc] initWithNibName:@"AIcourseDetailVC" bundle:nil];
    detailVc.courseID = [NSString stringWithFormat:@"%ld",indexPath.row + 2];
    [self.navigationController pushViewController:detailVc animated:YES];
}
//取消选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor redColor]];
}

#pragma mark ButtonClick
- (IBAction)didPushToNews:(id)sender {
    TencentNewsViewController *news = [[TencentNewsViewController alloc] init];
    [self.navigationController pushViewController:news animated:YES];
    
}

@end
