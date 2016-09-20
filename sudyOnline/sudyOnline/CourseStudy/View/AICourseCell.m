//
//  AICourseCell.m
//  studyOnline
//
//  Created by andylau on 16/3/8.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AICourseCell.h"
#import "UIImageView+WebCache.h"
@interface AICourseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *courseImage;
@property (weak, nonatomic) IBOutlet UILabel *courseTitle;
@property (weak, nonatomic) IBOutlet UILabel *courseTime;

@end

@implementation AICourseCell

- (void)setModel:(AICourseModel *)model{
    _model = model;
    [self.courseImage sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"picture"] options:(SDWebImageRetryFailed | SDWebImageLowPriority)];
    self.courseTitle.text = model.name;
    self.courseTime.text = model.datetime_updated;
}
@end
