//
//  ZHBlurtView.h
//  BlurtViewTest
//
//  Created by XT on 15/11/27.
//  Copyright © 2015年 XT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHBlurtView : UIView

@property (nonatomic,assign)CGFloat headerImgHeight;
@property (nonatomic,assign)CGFloat iconHeight;
/**
 *  icon图片url
 */
@property (nonatomic,copy)NSString *imgUrl;

/** bg图片 */
@property (nonatomic, copy) UIImage *bgImage;
/** icon图片 */
@property (nonatomic, copy) UIImage *iconImage;

@property (nonatomic,copy)NSString *name;

/**
 *  自定义添加的view
 */
@property (nonatomic,weak)UIView *oterView;





- (instancetype)initWithFrame:(CGRect)frame WithHeaderImgHeight:(CGFloat)headerImgHeight iconHeight:(CGFloat)iconHeight;

@end
