//
//  ZHBlurtView.m
//  BlurtViewTest
//
//  Created by XT on 15/11/27.
//  Copyright © 2015年 XT. All rights reserved.
//

#import "ZHBlurtView.h"
#import "UIImageView+LBBlurredImage.h"
#import "UIImageView+WebCache.h"
#define changeRate  (self.frame.size.width / self.frame.size.height)


@interface ZHBlurtView ()<UIScrollViewDelegate>
/**
 *  图片
 */
@property (nonatomic,weak)UIImageView *imageView;
@property (nonatomic,weak)UIImageView *icon;

@property (nonatomic,weak)UIScrollView *scrollView;
/**
 *  放大比例
 */
@property (nonatomic,assign)CGFloat scale;
/**
 *  名字label
 */
@property (nonatomic,weak)UILabel *label;
@end

@implementation ZHBlurtView

- (instancetype)initWithFrame:(CGRect)frame WithHeaderImgHeight:(CGFloat)headerImgHeight iconHeight:(CGFloat)iconHeight {
    if (self = [super initWithFrame:frame]) {
        self.headerImgHeight = (headerImgHeight == 0  ? self.frame.size.height * 0.382 : headerImgHeight);
        self.iconHeight = (iconHeight == 0  ? self.frame.size.height * 0.382  : iconHeight);
        [self setupContentView];
    }
    return self;

}


- (void)setupContentView {
    
    NSAssert(self.headerImgHeight >= self.iconHeight && self.iconHeight > 0, @"图片高度应当大于头像高度，头像高度应当大于零");
    

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    NSLog(@"%@",NSStringFromCGRect(self.frame));

    // 不能有背景颜色
    //   scrollView.backgroundColor = [UIColor blueColor];
    
    scrollView.delegate = self;
    self.scrollView = scrollView;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.decelerationRate = 2;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.headerImgHeight)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView = imageView;
    self.scale =  self.imageView.frame.size.width / self.imageView.frame.size.height;
    //    self.changeRate = self.frame.size.height / self.frame.size.width;
    
    
//    imageView.image = [UIImage imageNamed:@"tou"];
    
    // 20 左右 R  模糊图片
 //   [imageView setImageToBlur:imageView.image blurRadius:21 completionBlock:nil];
    
    
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - self.iconHeight) / 2, (self.headerImgHeight - self.iconHeight) / 2, self.iconHeight, self.iconHeight)];
    
    icon.backgroundColor = [UIColor whiteColor];
//    NSLog(@"%@",NSStringFromCGRect(icon.frame));
    
//    icon.image = [UIImage imageNamed:@"tou"];
    icon.layer.cornerRadius = self.iconHeight * 0.5;
    icon.clipsToBounds = YES;
    self.icon = icon;
    
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"tou"]];
    
//    [imageView sd_setImageWithURL:[NSURL URLWithString:self.bgImgUrl] placeholderImage:[UIImage imageNamed:@"person_top_bg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 20 左右 R  模糊图片
//        [imageView setImageToBlur:imageView.image blurRadius:21 completionBlock:nil];
//    }];

    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(icon.frame) + 10, self.frame.size.width, 20)];
    self.label = name;
    name.text = (self.name ? self.name : @"请点击登录");
    name.textAlignment = NSTextAlignmentCenter;
    name.textColor = [UIColor whiteColor];
    
    
    UIView *otherVIew = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerImgHeight, self.frame.size.width, self.frame.size.height - self.headerImgHeight)];
    
    otherVIew.backgroundColor = [UIColor redColor];
    self.oterView = otherVIew;
 
    // 注意添加顺序
    [scrollView addSubview:otherVIew];
    [self addSubview:imageView];
    [self addSubview:scrollView];
    [scrollView addSubview:icon];
    [scrollView addSubview:name];

}

- (void)setIconImage:(UIImage *)iconImage{
    self.icon.image = iconImage;
}

- (void)setBgImage:(UIImage *)bgImage{
    self.imageView.image = bgImage;
}

- (void)setName:(NSString *)name{
    if (name) {
        self.label.text = name;
    }else{
        self.label.text = @"请点击登录";
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (scrollView.contentOffset.y < 0) {
        // 高度宽度同时拉伸 从中心放大
        CGFloat imgH = self.headerImgHeight - scrollView.contentOffset.y * 2;
        CGFloat imgW = imgH * self.scale;
        self.imageView.frame = CGRectMake(scrollView.contentOffset.y * self.scale,0, imgW,imgH);
        
        CGFloat iconOriginalX = (self.frame.size.width - self.iconHeight) / 2;
        CGFloat iconOriginalY = (self.headerImgHeight - self.iconHeight) / 2;
        
        self.icon.frame = CGRectMake(iconOriginalX + offsetY * changeRate, iconOriginalY + offsetY * changeRate * 2, self.iconHeight - changeRate * offsetY * 2, self.iconHeight - changeRate * offsetY * 2);
        self.icon.layer.cornerRadius = self.icon.frame.size.width * 0.5;
        self.icon.clipsToBounds = YES;
        
        self.label.frame = CGRectMake(self.label.frame.origin.x, CGRectGetMaxY(self.icon.frame) + 10, self.label.frame.size.width, self.label.frame.size.height);
        
    } else {
        // 只拉伸高度
        self.imageView.frame = CGRectMake(0, 0, self.imageView.frame.size.width, 200 - scrollView.contentOffset.y);
    }

//    NSLog(@"%0.0f",scrollView.contentOffset.y);
}


@end
