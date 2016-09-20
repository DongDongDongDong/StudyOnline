//
//  CommonBussinessManager.h
//  sudyOnline
//
//  Created by andylau on 16/3/4.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "ReponseObject.h"
@interface CommonBussinessManager : NSObject

+ (instancetype)sharedManager;

/** 首页 */
- (void)getHomePageInfoWithcallback:(void(^)(BOOL success, ReponseObject *reponseObject))callback;

/** 获取视频详情*/
- (void)getMovieDetailInfo:(NSString *)Url Withcallback:(void(^)(BOOL success, ReponseObject *reponseObject))callback;

/** 获取全部课程页面 */
- (void)getCourseInfoWithId:(NSString *)courseId page:(NSString *)page callback:(void(^)(BOOL success, ReponseObject *reponseObject))callback;

/** 某一项课程 */
- (void)getOneCourseInfoWithId:(NSString *)courseId callback:(void(^)(BOOL success, ReponseObject *reponseObject))callback;


@end
