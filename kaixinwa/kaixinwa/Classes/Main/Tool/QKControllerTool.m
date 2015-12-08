//
//  QKControllerTool.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/1.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKControllerTool.h"
#import "QKTabBarController.h"
#import "NewfeatureViewController.h"

@implementation QKControllerTool

+ (void)chooseRootViewController
{
    // 如何知道第一次使用这个版本？比较上次的使用情况
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    
    // 从沙盒中取出上次存储的软件版本号(取出用户上次的使用记录)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    // 获得当前打开软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([currentVersion isEqualToString:lastVersion]) {
        // 当前版本号 == 上次使用的版本：显示HMTabBarViewController
        [UIApplication sharedApplication].statusBarHidden = NO;
        QKTabBarController * tabBarController = [[QKTabBarController alloc] init];
        window.rootViewController = tabBarController;
    } else { // 当前版本号 != 上次使用的版本：显示版本新特性
        window.rootViewController = [[NewfeatureViewController alloc] init];
        
        // 存储这次使用的软件版本
        [defaults setObject:currentVersion forKey:versionKey];
        [defaults synchronize];
    }

}

+ (void)chooseRootViewControllerWithIndex:(NSUInteger)index
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIApplication sharedApplication].statusBarHidden = NO;
    QKTabBarController * tabBarController = [[QKTabBarController alloc] init];
    tabBarController.selectedIndex = index;
    window.rootViewController = tabBarController;
    
}

@end
