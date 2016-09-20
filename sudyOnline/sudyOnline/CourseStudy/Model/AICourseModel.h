//
//  AICourseModel.h
//  studyOnline
//
//  Created by andylau on 16/3/8.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AICourseModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
/** 介绍 */
@property (nonatomic, copy) NSString *brief;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *school_name;
@property (nonatomic, copy) NSString *is_chinese;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *picture_vertical;
@property (nonatomic, copy) NSString *picture_big;
@property (nonatomic, copy) NSString *picture_banner;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *datetime_created;
@property (nonatomic, copy) NSString *datetime_updated;
@property (nonatomic, copy) NSString *weibo_keywords;
@property (nonatomic, copy) NSString *discipline_name;


@end
