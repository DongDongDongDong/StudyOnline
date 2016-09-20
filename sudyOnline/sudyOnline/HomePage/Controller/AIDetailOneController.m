//
//  AIDetailOneController.m
//  sudyOnline
//
//  Created by andylau on 16/3/6.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AIDetailOneController.h"

@interface AIDetailOneController ()
@property (weak, nonatomic) IBOutlet UILabel *courseTitle;

@property (weak, nonatomic) IBOutlet UILabel *courseType;
@property (weak, nonatomic) IBOutlet UILabel *courseSchool;
@property (weak, nonatomic) IBOutlet UILabel *courseTeacher;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *courseDetail;
@end

@implementation AIDetailOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.fromType isEqualToString:@"home"]) {
        self.courseTitle.text = self.detailDict[@"title"];
        self.courseType.text = [NSString stringWithFormat:@"类型:%@",self.detailDict[@"director"]];
        self.courseSchool.text = [NSString stringWithFormat:@"学校:%@",self.detailDict[@"school"]];
        self.courseTeacher.text = [NSString stringWithFormat:@"讲师:%@",self.detailDict[@"director"]];
        self.courseDetail.text = [NSString stringWithFormat:@"简介:%@",self.detailDict[@"description"]];
        [self.courseDetail layoutIfNeeded];
        self.scrollViewHeight.constant = CGRectGetMaxY(self.courseDetail.frame) + 100;
    }else if ([self.fromType isEqualToString:@"course"]){
        self.courseTitle.text = self.detailDict[@"name"];
        self.courseType.text = [NSString stringWithFormat:@"类型:%@",self.detailDict[@"short_name"]];
        self.courseSchool.text = [NSString stringWithFormat:@"学校:%@",self.detailDict[@"school_name"]];
        NSDictionary *dictTecther = self.detailDict[@"teachers"][0];
        self.courseTeacher.text = [NSString stringWithFormat:@"讲师:%@",dictTecther[@"name"]];
        self.courseDetail.text = [NSString stringWithFormat:@"简介:%@",self.detailDict[@"brief"]];
        [self.courseDetail layoutIfNeeded];
        self.scrollViewHeight.constant = CGRectGetMaxY(self.courseDetail.frame) + 100;

    }
    
}


//-(void)setDetailDict:(NSDictionary *)detailDict{
//    _detailDict = detailDict;
//    self.courseTitle.text = detailDict[@"title"];
//    self.courseType.text = [NSString stringWithFormat:@"类型:%@",detailDict[@"director"]];
//    self.courseSchool.text = [NSString stringWithFormat:@"学校:%@",detailDict[@"school"]];
//    self.courseTeacher.text = [NSString stringWithFormat:@"讲师:%@",detailDict[@"director"]];
//    self.courseDetail.text = [NSString stringWithFormat:@"简介:%@",detailDict[@"description"]];
//    [self.courseDetail layoutIfNeeded];
//    self.scrollViewHeight.constant = CGRectGetMaxY(self.courseDetail.frame) + 100;
//
//}

@end
