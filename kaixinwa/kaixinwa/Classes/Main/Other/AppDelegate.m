//
//  AppDelegate.m
//  kaixinwa
//
//  Created by 郭庆宇 on 15/6/28.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "AppDelegate.h"
#import "QKTabBarController.h"
#import "QKLoginViewController.h"
#import "QKAccount.h"
#import "QKAccountTool.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "QKControllerTool.h"
#import <AVFoundation/AVFoundation.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "QKGetHappyPeaTool.h"
#import "QKDataBaseTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    [self.window makeKeyAndVisible];
    QKAccount* account = [QKAccountTool readAccount];
    if (account) {
        [QKControllerTool chooseRootViewController];
    }else{
        QKLoginViewController* loginVc = [[QKLoginViewController alloc]init];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
        self.window.rootViewController = nav;
    }
    
    
    //监控网络
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 当网络状态改变了，就会调用
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                DCLog(@"没有网络(断网)");
                [MBProgressHUD showError:@"无法连接网络"];
                self.isExistenceNetwork = NO;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                DCLog(@"手机自带网络");
                self.isExistenceNetwork = YES;
                if(account){
                    [QKGetHappyPeaTool getHappyPeaNum];
                }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                DCLog(@"WIFI");
                self.isExistenceNetwork =YES;
                if (account) {
                    [QKGetHappyPeaTool getHappyPeaNum];
                }
                
                break;
        }
    }];
    // 开始监控
    [mgr startMonitoring];
    
    [UMSocialData setAppKey:@"55b58b3367e58ea9200010f9"];
    //集成微信
    [UMSocialWechatHandler setWXAppId:@"wx1f4a73928cf283f1" appSecret:@"448685e2583a9f970683e7f7919035c2" url:@"http://android.myapp.com/myapp/detail.htm?apkName=com.qkhl.kaixinwa_android"];
    //集成qq
    [UMSocialQQHandler setQQWithAppId:@"1104787690" appKey:@"HCOFtkTKgMUz7uPo" url:@"http://android.myapp.com/myapp/detail.htm?apkName=com.qkhl.kaixinwa_android"];
    
    //未安装隐藏
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    //建表
    [QKDataBaseTool creatTableForShare];
    [QKDataBaseTool creatTableForTask];
    return YES;
}
//QQ41D9B8EA
//tencent1104787690
//设置回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}




//为webview播放视频准备的
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_isFull) {
        return UIInterfaceOrientationMaskAll;
        
    }
    return UIInterfaceOrientationMaskPortrait;
}


@end
