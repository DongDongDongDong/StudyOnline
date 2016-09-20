//
//  AIDetailCollectionCell.h
//  sudyOnline
//
//  Created by andylau on 16/3/6.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIDetailCollectionCell : UICollectionViewCell
@property (nonatomic, strong)IBOutlet  UILabel *labelNum;
@property (nonatomic, strong)IBOutlet  UILabel *labelTitle;

/** 单个视频相关资料 */
@property (nonatomic, strong) NSDictionary *videoList;

@end
