//
//  AIDetailTwoController.m
//  sudyOnline
//
//  Created by andylau on 16/3/6.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AIDetailTwoController.h"
#import "AIDetailCollectionCell.h"
#import "AIPlayerController.h"
#import "UIColorExtension.h"
static NSString *COURSE_CELL_REUSE = @"COURSE_CELL_REUSE";
@interface AIDetailTwoController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *courseCollectionView;

@end

@implementation AIDetailTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.courseCollectionView.delegate = self;
    self.courseCollectionView.dataSource = self;
    [self.courseCollectionView registerNib:[UINib nibWithNibName:@"AIDetailCollectionCell" bundle:nil] forCellWithReuseIdentifier:COURSE_CELL_REUSE];

}

#pragma mark -CollectionView datasource
//section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.courseArray.count;    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    AIDetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:COURSE_CELL_REUSE forIndexPath:indexPath];
    NSDictionary *dict = self.courseArray[indexPath.row];
    cell.videoList = dict;
    cell.labelNum.text = [NSString stringWithFormat:@"[第%ld集]",indexPath.row + 1];
    
    if ([self.fromType isEqualToString:@"home"]) {
        cell.labelTitle.text = dict[@"title"];
    }else if([self.fromType isEqualToString:@"course"]){
        cell.labelTitle.text = dict[@"short_name"];
    }
    return cell;
    
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREENWIDTH - 30), 40);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 5, 15);//分别为上、左、下、右
}

//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={[UIScreen mainScreen].bounds.size.width,40};
    return size;
}


//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AIDetailCollectionCell *cell = (AIDetailCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.labelNum.textColor = [UIColor colorWithHex:CONSTANT_THEME_COLOR_HDEX];
    cell.labelTitle.textColor = [UIColor colorWithHex:CONSTANT_THEME_COLOR_HDEX];
//    NSLog(@"%@",cell.videoList[@"repovideourlmp4"]);
    
    id next = [self nextResponder];
    while (next != nil) {
        next = [next nextResponder];
        if ([next isKindOfClass:[AIPlayerController class]]) {
            AIPlayerController *playVC = (AIPlayerController *)next;
            playVC.currentNum = indexPath.row;
            [playVC beginPlay];
            return;
        }
    }
    

}

/** 取消选择CELL */
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    AIDetailCollectionCell *cell = (AIDetailCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.labelNum.textColor = [UIColor blackColor];
    cell.labelTitle.textColor = [UIColor blackColor];

}


@end
