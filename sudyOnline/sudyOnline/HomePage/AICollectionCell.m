//
//  AICollectionCell.m
//  sudyOnline
//
//  Created by andylau on 16/3/1.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AICollectionCell.h"
#import "UIImageView+WebCache.h"
@interface AICollectionCell()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
@implementation AICollectionCell

- (void)setCellDict:(NSDictionary *)cellDict{
    _cellDict = cellDict;
//    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    
//    self.imageView.image = [UIImage imageWithData:data];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:cellDict[@"picUrl"]] placeholderImage:[UIImage imageNamed:@"pic_default1"] options:(SDWebImageRetryFailed | SDWebImageLowPriority)];
    self.title.text = cellDict[@"title"];
}

@end