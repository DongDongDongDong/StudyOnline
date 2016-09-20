//
//  CommonBussinessManager.m
//  sudyOnline
//
//  Created by andylau on 16/3/4.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "CommonBussinessManager.h"

@implementation CommonBussinessManager

+ (instancetype)sharedManager
{
    static CommonBussinessManager *sharedManagerInstance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[self alloc] init];
    });
    
    return sharedManagerInstance;
}


- (void)getHomePageInfoWithcallback:(void (^)(BOOL, ReponseObject *))callback{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",nil]; //添加content type，默认情况下是不支持text／html的。
    
    [manager GET:HOME_PAGE_DATA parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject count]){
            if (callback) {
                callback(YES,responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.description);
        callback(NO,nil);

    }];
}

- (void)getMovieDetailInfo:(NSString *)Url Withcallback:(void(^)(BOOL success, ReponseObject *reponseObject))callback{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",nil]; //添加content type，默认情况下是不支持text／html的。
    [manager GET:Url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (callback) {
                callback(YES,responseObject);
            }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.description);
        callback(NO,nil);
        
    }];

}

- (void)getCourseInfoWithId:(NSString *)courseId page:(NSString *)page callback:(void(^)(BOOL success, ReponseObject *reponseObject))callback;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",nil]; //添加content type，默认情况下是不支持text／html的。
    
    NSString *url = [NSString stringWithFormat:@"http://platform.sina.com.cn/opencourse/get_courses?discipline_id=%@&order_by=modified_at%%20DESC&app_key=1919446470&page=%@&count_per_page=20",courseId,page];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (callback) {
            callback(YES,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.description);
        callback(NO,nil);
        
    }];
}

- (void)getOneCourseInfoWithId:(NSString *)courseId callback:(void(^)(BOOL success, ReponseObject *reponseObject))callback{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",nil]; //添加content type，默认情况下是不支持text／html的。
    
    NSString *url = [NSString stringWithFormat:@"http://platform.sina.com.cn/opencourse/get_course?id=%@&with_lessons=1&app_key=1919446470",courseId];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (callback) {
            callback(YES,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.description);
        callback(NO,nil);
    }];

}

@end
