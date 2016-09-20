//
//  ReponseObject.h
//  PengPai
//
//  Created by Chris on 15/3/30.
//  Copyright (c) 2015年 UXIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReponseObject : NSObject

@property (nonatomic, strong) id reponseData;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *errorDescription;

@end
