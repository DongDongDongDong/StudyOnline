//
//  SQCollectionCell.m
//  sudyOnline
//
//  Created by andylau on 16/3/4.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "SQCollectionCell.h"
#import "UIImageView+WebCache.h"
@interface SQCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageTop;
@property (weak, nonatomic) IBOutlet UILabel *firstLAbel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@end

@implementation SQCollectionCell

- (void)setCellDict:(NSDictionary *)cellDict{
    _cellDict = cellDict;
    [self.imageTop sd_setImageWithURL:[NSURL URLWithString:cellDict[@"picUrl"]] placeholderImage:[UIImage imageNamed:@"pic_default1"] options:(SDWebImageRetryFailed | SDWebImageLowPriority)];
    self.firstLAbel.text = cellDict[@"subtitle"];
    self.secondLabel.text = cellDict[@"title"];
    self.thirdLabel.text = cellDict[@"description"];
}

@end
