//
//  AICollectionView.m
//  sudyOnline
//
//  Created by andylau on 16/3/1.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AICollectionCell.h"
#import "AICollectionView.h"

@interface AICollectionView()
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

/** 当前页面索引 */
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AICollectionView

- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,160, SCREENWIDTH, 20)];
//        _pageControl.numberOfPages = 3;
    }
    return _pageControl;
}

- (NSMutableArray *)imageURLs{
    if (_imageURLs == nil) {
        
            _imageURLs = [NSMutableArray array];
            
//            for (int i = 1; i <= 10; i++) {
//                NSString *fileName = [NSString stringWithFormat:@"00%d.jpg", i];
//                NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
//                
//                [_imageURLs addObject:url];
//            }
//  

    }
    return _imageURLs;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 设置界面布局
//    self.layout.itemSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT - 64);
    self.layout.itemSize = self.view.bounds.size;
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    
    
    // 当前页面索引 = 0
    self.currentIndex = 0;
    // 滚动到第一张图片
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    // 开启时钟
    [self startTimer];
}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.pageControl.numberOfPages = self.imageURLs.count;
    return self.imageURLs.count;
}

- (NSUInteger)indexWithOffset:(NSUInteger)offset {
    return (self.currentIndex + offset - 1 + self.imageURLs.count) % self.imageURLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AICollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.cellDict = self.imageURLs[[self indexWithOffset:indexPath.item]];
//    NSLog(@"%@ %tu", cell.imageURL.lastPathComponent, indexPath.item);
//    cell.pageControl.numberOfPages = self.imageURLs. count;
    return cell;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger offset = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    self.currentIndex = [self indexWithOffset:offset];
    
    // 滚动到第一张图片
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    [UIView setAnimationsEnabled:NO];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [UIView setAnimationsEnabled:YES];
    
    self.pageControl.currentPage = self.currentIndex;

//    NSLog(@"重设位置");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

#pragma mark - 时钟方法
- (void)startTimer {
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(fire) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/** 时钟触发方法 */
- (void)fire {
    // 取出当前显示cell
    NSIndexPath *indexPath = [self.collectionView indexPathsForVisibleItems].lastObject;
//        NSLog(@"%ld", self.currentIndex);
//    AICollectionCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    self.pageControl.currentPage = self.currentIndex;
    // 显示下一张
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(indexPath.item + 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollViewDidEndDecelerating:self.collectionView];
    });
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

@end