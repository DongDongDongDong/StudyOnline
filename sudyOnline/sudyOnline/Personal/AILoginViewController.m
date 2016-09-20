//
//  AILoginViewController.m
//  sudyOnline
//
//  Created by andylau on 16/3/7.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AILoginViewController.h"
#import "MBProgressHUD+Show.h"
#import <ShareSDK/ShareSDK.h>
#import "MyTextField.h"
@interface AILoginViewController ()
@property (weak, nonatomic) IBOutlet MyTextField *userTextField;
@property (weak, nonatomic) IBOutlet MyTextField *pwdTextField;

@end

@implementation AILoginViewController
- (void)changeValueText:(loginBlock)myblock{
    self.myBlock = myblock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTextFieldImage];
}

- (void)addTextFieldImage{
    UIImageView *userImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Login_user2"]];
    userImg.frame = CGRectMake(0, 0, 25, 25);
    UIImageView *pwdImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Login_pwd2"]];
    pwdImg.frame = CGRectMake(0, 0, 25, 25);
    self.userTextField.leftView = userImg;
    self.pwdTextField.leftView = pwdImg;
    self.pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.userTextField.leftViewMode = UITextFieldViewModeAlways;
}


- (IBAction)sinaLogin:(id)sender {
    [self commonLoginWith:SSDKPlatformTypeSinaWeibo];
}
- (IBAction)wechatLogin:(id)sender {
    [self commonLoginWith:SSDKPlatformTypeWechat];
}
- (IBAction)qqLogin:(id)sender {
    [self commonLoginWith:SSDKPlatformTypeQQ];
}
- (IBAction)userIDLogin:(id)sender {
}

- (void)commonLoginWith:(SSDKPlatformType)fromType{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@"登录中"];
    [ShareSDK getUserInfo:fromType
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUD];
                 [MBProgressHUD showSuccessWithText:@"登录成功"];
                 if (self.myBlock) {
                     self.myBlock(user.nickname);
                 }
                 NSLog(@"uid=%@",user.uid);
                 NSLog(@"%@",user.credential);
                 NSLog(@"token=%@",user.credential.token);
                 NSLog(@"nickname=%@",user.nickname);
                 [self dismissViewControllerAnimated:YES completion:nil];
             });
         }
         else
         {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showErrorWithText:@"登录失败"];
             NSLog(@"%@",error);
         }
         
     }];
}
@end
