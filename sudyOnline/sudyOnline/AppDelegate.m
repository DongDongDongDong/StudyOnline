//
//  AppDelegate.m
//  sudyOnline
//
//  Created by andylau on 16/2/29.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColorExtension.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /** 分享 */
    
    [ShareSDK registerApp:SHARESDK_APPKEY activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                                                            @(SSDKPlatformTypeWechat),
                                                            @(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
                                                                switch (platformType) {
                                                                    case SSDKPlatformTypeWechat:
                                                                        [ShareSDKConnector connectWeChat:[WXApi class]];
                                                                        break;
                                                                    case SSDKPlatformTypeQQ:
                                                                        [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                                                        break;
                                                                    case SSDKPlatformTypeSinaWeibo:
                                                                        [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                                                        break;
                                                                    default:
                                                                        break;
                                                                }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType)
        {
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:SINA_APPKEY
                                          appSecret:SINA_APPSECRET
                                        redirectUri:@"http://open.weibo.com/apps/2805097691/privilege/oauth"
                                           authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                      appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:QQ_APPID
                                     appKey:QQ_APPKEY
                                   authType:SSDKAuthTypeBoth];
                break;
                
            default:
                break;
        }

    }];
//    
//    [ShareSDK registerApp:SHARESDK_APPKEY activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
//                                                            @(SSDKPlatformTypeWechat),
//                                                            @(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
//                                                                switch (platformType)
//                                                                {
//                                                                    case SSDKPlatformTypeWechat:
//                                                                        [ShareSDKConnector connectWeChat:[WXApi class]];
//                                                                        break;
//                                                                    case SSDKPlatformTypeQQ:
//                                                                        [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                                                                        break;
//                                                                    case SSDKPlatformTypeSinaWeibo:
//                                                                        [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                                                                        break;
//                                                                    default:
//                                                                        break;
//                                                                }
//                                                                
//                                                            } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
//                                                                switch (platformType)
//                                                                {
//                                                                    case SSDKPlatformTypeSinaWeibo:
//                                                                        //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                                                                        [appInfo SSDKSetupSinaWeiboByAppKey:SINA_APPKEY
//                                                                                                  appSecret:SINA_APPSECRET
//                                                                                                redirectUri:@"http://open.weibo.com/apps/2805097691/privilege/oauth"
//                                                                                                   authType:SSDKAuthTypeBoth];
//                                                                        break;
//                                                                    case SSDKPlatformTypeWechat:
//                                                                        [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
//                                                                                              appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
//                                                                        break;
//                                                                    case SSDKPlatformTypeQQ:
//                                                                        [appInfo SSDKSetupQQByAppId:QQ_APPID
//                                                                                             appKey:QQ_APPKEY
//                                                                                           authType:SSDKAuthTypeBoth];
//                                                                        break;
//                                                              
//                                                                    default:
//                                                                        break;
//                                                                }
//                                                            }];
    
    /* 修改navigationbar的背景颜色 */
    [UINavigationBar appearance].barTintColor = [UIColor colorWithHex:CONSTANT_THEME_COLOR_HDEX];
    
    /* navigationbar 文字颜色 */
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [UINavigationBar appearance].titleTextAttributes = attributes;

    return YES;
}



        

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
